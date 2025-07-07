clc;
clear all;
close all;
% Load far-field data (before time modulation)
load('converted_data.mat');  
% Extract fields
phi = data(:,1);  
theta = data(:,2);
Re_Etheta = data(:,3);
Im_Etheta = data(:,4);
Re_Ephi = data(:,5);
Im_Ephi = data(:,6);

% Compute E-field magnitude
Etheta_abs = sqrt(Re_Etheta.^2 + Im_Etheta.^2);
Ephi_abs = sqrt(Re_Ephi.^2 + Im_Ephi.^2);
E_total = sqrt(Etheta_abs.^2 + Ephi_abs.^2);

% Compute radiation intensity
U = E_total.^2;

% Compute total radiated power
dtheta = pi/180; 
dphi = pi/180;
P_rad = sum(U .* sin(deg2rad(theta)) * dtheta * dphi);  

% Compute directivity
D = 4 * pi * U / P_rad;  

% Assume efficiency η = 1 (ideal case)
G = D;  
disp(D);
% Plot Directivity
figure;
polarplot(deg2rad(theta), D, 'b', 'LineWidth', 1.5);
title('Directivity');
grid on;
