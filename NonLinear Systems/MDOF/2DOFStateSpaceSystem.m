function dydt = designedSystem(t,q,freq,multiplier,M,C,disp_range,k_plot)
    %MDOF with gound excitation
    
    %%% States %%%%%
    % first half of the states are postions
    % second half are velocities
    %%%%%%%%%%%%%%%%
    
    nDOF = length(M);
    nStates = 2*nDOF;
    
    %nonlinear stiffness (update depending on current states)
    for i = 1:nDOF
        K = zeros([1 nDOF]);
        if i = 1
            K(i) = interp1(disp_range(i),k_plot(i),q(1))
        else
            K(i) = interp1(disp_range(i),k_plot(i),q(i)-q(i-1))
        end
    end
    
    u = inputFn(t,freq,multiplier);%input

    dydt =  [q(2)+u; -k/m*q(1)-c/m*q(2)+(-c+k)/m*u];
end