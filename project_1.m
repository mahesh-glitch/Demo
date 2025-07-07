clc;
clear all;
close all;

% Antenna Array Parameters
N = 16;               % Number of elements in the array
d = 0.5;             % Element spacing (to avoid grating lobes)
theta = linspace(0, pi, 1000);  % Observation angles from 0 to 2*pi

% Calculate the Array Factor (AF)
AF = zeros(size(theta));  % Initializing zeros for the array factor
k = 2*pi;                 % Wave number 
beta = 0;                 % Phase shift: 0 for broadside array, pi for end-fire array

for n = 1:N
    AF = AF + exp(1i * (n-1) * (k * d * cos(theta) + beta));  % Array factor formula
end

% Calculate the radiation pattern (power pattern)
pattern = abs(AF).^2; 

%  Normalize the pattern
pattern_normalized = pattern / max(pattern); 

% Calculate Maximum Radiation Intensity
U_max = max(pattern_normalized); % Maximum intensity

% Compute Total Radiated Power (P_radiation)
P_radiation = 2*pi*trapz(theta, pattern_normalized .* sin(theta));  % Integrating radiation pattern

% Calculate Directivity using D = (U_max * 4*pi) / P_radiation
directivity = (U_max * 4 * pi) / P_radiation; % Directivity (linear scale)

disp(directivity)

dir_dB = 10 * log10(directivity);
disp(dir_dB)



% Create a figure with 2x2 subplots
figure;

% Subplot 1: Rectangular Plot of Array Factor
subplot(2,2,1);  % First subplot in 2x2 grid
plot(rad2deg(theta), real(AF));
xlabel('Angle in degrees');
ylabel('Array Factor');
title('Rectangular Plot of Array Factor');
grid on;

% Subplot 2: Polar Plot of Array Factor
subplot(2,2,2);  % Second subplot in 2x2 grid
polarplot(theta, real(AF));
title('Polar Plot of Array Factor');
grid on;

% Subplot 3: Rectangular Plot of Radiation Pattern
subplot(2,2,3);  % Third subplot in 2x2 grid
plot(rad2deg(theta), pattern_normalized);
xlabel('Angle in degrees');
ylabel('Radiation Pattern');
title('Rectangular Plot of Radiation Pattern');
grid on;

% Subplot 4: Polar Plot of Radiation Pattern
subplot(2,2,4);  % Fourth subplot in 2x2 grid
polarplot((theta), pattern_normalized);
title('Polar Plot of Radiation Pattern');
grid on;
