clc; clear; close all;

% 1 Load far-field data
load('converted_data.mat');  

% 2 Extract data
phi = data(:,1);  
theta = data(:,2);
Re_Etheta = data(:,3);
Im_Etheta = data(:,4);
Re_Ephi = data(:,5);
Im_Ephi = data(:,6);

% 3 Compute E-field magnitudes
E_theta = sqrt(Re_Etheta.^2 + Im_Etheta.^2);  
E_phi = sqrt(Re_Ephi.^2 + Im_Ephi.^2);  
E_total = sqrt(E_theta.^2 + E_phi.^2); % Total E-field magnitude

% 4 Apply Time Modulation (PAM - Pulse Amplitude Modulation)
T = 4;  % Define pulse repetition period
num_samples = length(E_total); % Number of data points
time_modulation = mod((1:num_samples), T) > 1; % ON/OFF pattern (simple PAM)
E_total_modulated = E_total .* time_modulation'; % Apply modulation to E-field

% 5 Compute Radiation Intensity U (modulated)
eta = 377;  % Free space impedance
U_modulated = (E_total_modulated.^2) / (2 * eta);

% 6 Numerical Integration for Total Radiated Power
dTheta = deg2rad(5);  % Step size for integration
dPhi = deg2rad(5);
P_total_modulated = sum(U_modulated .* sin(deg2rad(theta)) * dTheta * dPhi);

% 7 Compute Directivity (D) for time-modulated pattern
D_modulated = (4 * pi * U_modulated) / P_total_modulated;
D_modulated_dB = 10 * log10(D_modulated / max(D_modulated)); % Convert to dB

% 8 Plot the Normal vs. Time-Modulated Radiation Pattern
figure;
plot(theta, 10 * log10(E_total / max(E_total)), 'b', 'LineWidth', 2); hold on;
plot(theta, D_modulated_dB, 'r--', 'LineWidth', 2);
xlabel('Theta (Degrees)');
ylabel('Radiation Pattern (dB)');
legend('Original Radiation Pattern', 'Time-Modulated Radiation');
title('Effect of Time Modulation (PAM) on Radiation Pattern');
grid on;
ylim([-40 0]);
