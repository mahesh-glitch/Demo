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




