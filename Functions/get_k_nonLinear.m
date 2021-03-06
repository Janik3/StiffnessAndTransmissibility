function k_nonLinear = get_k_nonLinear(x_in, h_0, L_0, L_min, K_h, preload_dist, M_above)
    %% Define the non-linear F and K based on their equations
    % The equations
    syms 'x' 
    syms 'F_tot'
    
    F = F_horzSpring_y(x, K_h, L_0, L_min, h_0);
    k = diff(F);

    K_v = -vpa(subs(k,x,h_0)); %vertical spring stiffness that provides zero stiffness
    
    % The total force in the vertical direction is the sum of the force
    % from the vertical and horizonatal springs
    F_tot = F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_dist);
    
    %determine the operating location due to the mass
    eqn1 = M_above*9.81 == F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_dist);
    massDisplacement = solve(eqn1,x);

    %K is the derivative of the force
    k_tot = diff(F_tot);
   
    x_in;
    %Convert to numbers
    x_nums = x_in + massDisplacement(1); %include an offset to work in the zero stiffness area of the system
    
    %Convert to numbers
    % x_nums = [0:h_0*2/1000:h_0*2];
    F_tot_nums = vpa(subs(F_tot,x,x_nums));
    F_actualZero = vpa(subs(F_tot,x,massDisplacement(1)));
    F_desiredZero = vpa(subs(F_tot,x,h_0));
    correctOffset = (F_actualZero - F_desiredZero)/K_v

    
%     %Plots
%     figure
%     hold on;
%     plot(x_in,F_tot_nums, 'color', 'k', 'linewidth', 2)
%     set(gca,'FontSize',15)
%     title('Stiffness of QZS System with Offset')
%     xlabel('Position (shifted) [m]');
%     ylabel('Force [N]');
%     x0=100;
%     y0=100;
%     width=800;
%     height=500;
%     set(gcf,'position',[x0,y0,width,height]);
%     hold off;
    
    % F_nums = vpa(subs(F_tot,x,x_nums));
    k_nonLinear = double(vpa(subs(k_tot,x,x_nums)));
end