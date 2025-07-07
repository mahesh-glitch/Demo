clc;
clear all;
close all;



% Parameters
N = 16;                       % Number of array elements
d = 0.5;                     % Element spacing in wavelengths (lambda/2)
f0 = 1e9;                    % Carrier frequency (1 GHz)
fp = 1e6;                    % Modulation frequency (1 MHz)
c = 3e8;                     % Speed of light (m/s)
lambda = c / f0;             % Wavelength
beta = 2 * pi / lambda;       % Phase constant
theta = linspace(0, pi, 1000);  % Observation angle from 0 to pi
t = 0;                       % Time (you can change or loop over time)
h_max = 5;                  % Maximum number of harmonics to consider

% Initialize the Array Factor
AF = zeros(size(theta));

% Loop over harmonics h
for h = -h_max:h_max
    % Time modulation term
    time_modulation = exp(1i * 2 * pi * (f0 + h * fp) * t);
    
    % Loop over array elements n
    for n = 1:N
        % Example modulation coefficient u_n^h (you can define differently)
        un_h = 1;  % Assume unity modulation coefficient for simplicity
        
        % Array factor component
        AF = AF + un_h * time_modulation * exp(1i * beta * (n - 1) * d * cos(theta));
    end
end

% Calculate the magnitude of AF
AF_magnitude = abs(AF);


% Plot the Array Factor in Polar Coordinates
figure;
polarplot(theta, AF_magnitude);
title('Time Modulated Array Factor');
grid on;

% Calculate the radiation pattern (power pattern)
pattern = abs(AF).^2; 

% Normalize the pattern
pattern_normalized = pattern / max(pattern); 

% Calculate Maximum Radiation Intensity
U_max = max(pattern_normalized); % Maximum intensity

% Compute Total Radiated Power (P_radiation)
P_radiation = 2*pi*trapz(theta, pattern_normalized .* sin(theta));  % Integrating radiation pattern

% Calculate Directivity using D = (U_max * 4*pi) / P_radiation
directivity = (U_max * 4 * pi) / P_radiation; % Directivity (linear scale)

disp(directivity)
