clc; clear; close all;

% 1 Load far-field data
load('converted_data.mat');  

% 2️ Extract data
phi = data(:,1);  
theta = data(:,2);
Re_Etheta = data(:,3);
Im_Etheta = data(:,4);
Re_Ephi = data(:,5);
Im_Ephi = data(:,6);

% 3️ Compute E-field magnitudes
E_theta = sqrt(Re_Etheta.^2 + Im_Etheta.^2);  
E_phi = sqrt(Re_Ephi.^2 + Im_Ephi.^2);  
E_total = sqrt(E_theta.^2 + E_phi.^2); % Total E-field magnitude

% 4️ Compute Radiation Intensity U
eta = 377;  % Free space impedance
U = (E_theta.^2 + E_phi.^2) / (2*eta);  

% 5️ Numerical Integration for Total Radiated Power
dTheta = deg2rad(5);  % Step size for integration
dPhi = deg2rad(5);
P_total = sum(U .* sin(deg2rad(theta)) * dTheta * dPhi); 

% 6️ Compute Directivity (D)
D = (4 * pi * U) / P_total;

% 🔹 Fix: Ensure Directivity is always positive
D(D <= 0) = eps; % Replace any zero/negative values with a very small number

% 7 Convert Directivity to dB scale
D_dB = 10 * log10(D / max(D)); % Normalize to max value

% 🔹 Alternative normalization using max(U) (Uncomment if needed)
% D_dB = 10 * log10(U / max(U)); 

% 8 Select data for a specific Phi cut (e.g., Phi = 0°)
phi_cut = 0; 
indices = find(phi == phi_cut);
theta_selected = theta(indices);
D_dB_selected = D_dB(indices);

% 9 Plot the 2D Radiation Pattern
figure;
plot(theta_selected, D_dB_selected, 'r', 'LineWidth', 2); % Red line

% Labels and Title
xlabel('Angle (Degrees)');
ylabel('Directivity (dB)');
title(['2D Radiation Pattern (Phi = ' num2str(phi_cut) '°)']);
grid on;
xlim([min(theta_selected) max(theta_selected)]); % Angle range
ylim([-40 0]); % Set dB range for better visualization

% 10 Find Peaks (Sidelobes) and Nulls
[pks, locs] = findpeaks(D_dB_selected); % Find sidelobes
nulls = islocalmin(D_dB_selected); % Find nulls

% 11 Annotate Main Beam, Sidelobes, and Nulls
hold on;
plot(theta_selected(locs), pks, 'ko', 'MarkerFaceColor', 'k'); % Sidelobe peaks (black circles)
plot(theta_selected(nulls), D_dB_selected(nulls), 'bo', 'MarkerFaceColor', 'b'); % Nulls (blue circles)

% Add text labels
text(theta_selected(locs), pks, '  Side Lobe', 'VerticalAlignment', 'bottom');
text(theta_selected(nulls), D_dB_selected(nulls), ' Null', 'VerticalAlignment', 'top');
text(theta_selected(D_dB_selected == max(D_dB_selected)), max(D_dB_selected), ' Main Beam', 'HorizontalAlignment', 'center');

hold off;
