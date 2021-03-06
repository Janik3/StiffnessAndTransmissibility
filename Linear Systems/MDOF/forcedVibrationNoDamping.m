function X = forcedVibrationNoDamping(K,M,f,omega)

% obtained from https://www.brown.edu/Departments/Engineering/Courses/En4/Notes/vibrations_mdof/vibrations_mdof.htm

% Function to calculate steady state amplitude of
% a forced linear system.
% K is nxn the stiffness matrix
% M is the nxn mass matrix
% f is the n dimensional force vector
% omega is the forcing frequency, in radians/sec.
% The function computes a vector X, giving the amplitude of
% each degree of freedom
%

X = (K-M*omega^2)\f;

end