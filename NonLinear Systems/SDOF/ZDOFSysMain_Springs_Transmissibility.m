% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

%% Define the system variables
h_0 = 3/12*.3048; % initial height from horizontal to top (converting inches to m)
L_0 = 4/12*.3048; %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 17513.38; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_dist = 2/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)

%% Create F and K plots for the designed Zero Stiffness System

% The horizontal (negative stifness portions)
syms 'x' 
F = F_horzSpring_y(x, K_h, L_0, L_min, h_0);
k = diff(F);

%Convert to numbers
x_nums = [0:h_0*2/1000:h_0*2];
F_nums = vpa(subs(F,x,x_nums));
K_nums = vpa(subs(k,x,x_nums));

%Plots for the negative stiffness system
figure
subplot(2,1,1);
hold on; 
plot(x_nums, F_nums);
ylabel('F [N]')
xlabel('Displacement from top [m]')
title('Overall force of negative stiffness system')
subplot(2,1,2)
plot(x_nums, K_nums);
ylabel('K [N/m]')
xlabel('Displacement from top [m]')
title('Stiffness of negative stiffness system')
hold off; 


K_v = -K_nums(h_0/(h_0*2/1000)) ; %vertical spring stiffness that provides zero stiffness
K_v = -vpa(subs(k,x,h_0));
% K_v = 17513.38
 
% F and K for the Zero Stiffness System (negative stiffness + positive
% stiffness) 
F_tot = F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_dist);
k_tot = diff(F_tot);

%Convert to numbers
x_nums = [0:h_0*2/1000:h_0*2];
F_tot_nums = vpa(subs(F_tot,x,x_nums));
K_tot_nums = vpa(subs(k_tot,x,x_nums));


%Plots for the zero stiffness system
figure
subplot(2,1,1);
hold on; 
plot(x_nums, F_tot_nums);
ylabel('F [N]')
xlabel('Displacement from top [m]')
title('Overall force of zero stiffness system')
subplot(2,1,2)
plot(x_nums, K_tot_nums);
ylabel('K [N/m]')
xlabel('Displacement from top [m]')
title('Stiffness of zero stiffness system')
hold off;



%% Time Domain analysis

trans = []; 
freq_trans = [];
% list of frequencies to simulate in time domain 
freqList = [0.05,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1,1.5,2,3,4,5,6,7,8,9,10];
freqList = 0.5:0.2:7;

multiplier = 0.01; % amplitude for input
m = 50; %in kg
zeta = 0.2; %damping ratio
k_v = double(K_v); % vertical spring stiffness 
w_n = sqrt(k_v/m); % natural frequency of positive stiffness sys
c = 2*zeta*w_n*m; % damping for system 

%get the nonlinear k
disp_range = -100:0.01:100;
k_plot = get_k_nonLinear(disp_range, h_0, L_0, L_min, K_h, preload_dist);

for i = 1:1:length(freqList)
    forceSim = 1; % used to manually force a simulation that has previously already been completed
    
    %Print to screen 
    "Simulation at a frequency of :"
    freq = freqList(i)
    
    % time variables (Change as required)
    tf = 40/freq; % Final time 

    T = 0.001; % Sampling time
    t = 0:T:tf; % time vector
    t_span = [0 tf];

    %Initial Conditions
    x = [0 0]';
    u = inputFn(t,freq,multiplier);
    
    %for saving results (speeds up runs in the future) 
    figName = strcat('Figures/','ZSS_ ', strrep(num2str(freq),'.','') ,'_',  strrep(num2str(multiplier),'.',''), '_', strrep(num2str(m),'.',''), '_', strrep(num2str(zeta),'.',''), '_' , strrep(num2str(k_v),'.',''), '.jpeg');
    fileNameTime = strcat('Files/','ZSS, ', num2str(freq) ,',',  num2str(multiplier), ',', num2str(m), ',', num2str(zeta), ',' , num2str(k_v), 'time.txt');
    fileNameVals = strcat('Files/','ZSS, ', num2str(freq) ,',',  num2str(multiplier), ',', num2str(m), ',', num2str(zeta), ',' , num2str(k_v), 'vals.txt');
    
    if exist(fileNameVals) && forceSim == 0
        % this has already been simulated. Pull the reults. Do not repeat the simulation
        t_out = readmatrix(fileNameTime);
        y_out = readmatrix(fileNameVals);
    else
        %%%%%%%%%%%%% Perform the time domain simulation %%%%%%%%%%%%%
        %
        %
        [t_out, y_out] = ode45(@(t,y) designedSystem(t,y,freq,multiplier,m,c, disp_range, k_plot), t, x);
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %calculate the transmission ratio 
    trans(i) = ampratiomeasure(u((length(u)/2):(length(u)-1)),y_out((length(y_out)/4):(length(y_out)-1)));
    freq_trans(i) = freq; 

    %plot time domain 
    figure
    hold on; 
    plot(t_out, y_out(:,1));
    plot(t, u);
    legend('Output Position[m]','Input Position (Ground Vibrations)[m]');
    ylabel('Displacement of top [m]')
    xlabel('Time [s]')
    title(strcat('Overall Displacement of Zero Stiffness System, freq = ', num2str(freq)));
    hold off; 
    saveas(gcf,figName);
    writematrix(y_out, fileNameVals);
    writematrix(t_out, fileNameTime);
    
end

%Positive Stiffness Transmissibility (closed form, may be incorreect) 
omega = [0:0.25:10]
%omega = freq/180*pi
trans_vert = @(omega) sqrt(k_v.^2 + (c.*omega).^2)./sqrt((-m.*omega.^2 + k_v).^2 + (c.*omega).^2)
trans_vert_nums = feval(trans_vert,omega*2*pi);

%Plot transmissibility 
figure()
hold on;
plot(freq_trans,trans);
plot(omega,trans_vert_nums);
ylabel('Transmission Ratio')
xlabel('Frequency [Hz]')
title('Transmissibility of Zero Stiffness System')
hold off; 
