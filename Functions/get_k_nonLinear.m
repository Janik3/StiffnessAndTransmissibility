function k_nonLinear = get_k_nonLinear(x_in, h_0, L_0, L_min, K_h)
    %% Define the non-linear F and K based on their equations
    % The equations
    syms 'x' 
    
    F = F_horzSpring_y(x, K_h, L_0, L_min, h_0);
    k = diff(F);

    K_v = -vpa(subs(k,x,h_0)); %vertical spring stiffness that provides zero stiffness

    % The total force in the vertical direction is the sum of the force
    % from the vertical and horizonatal springs
    F_tot = F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, h_0);
    
    %K is the derivative of the force
    k_tot = diff(F_tot);

    %Convert to numbers
    x_nums = x_in+h_0; %include an offset to work in the zero stiffness area of the system
    F_nums = vpa(subs(F_tot,x,x_nums));
    k_nonLinear = double(vpa(subs(k_tot,x,x_nums)));
end