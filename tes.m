clc;
close all;
clear all;

% Parameters
Tp = 1; % Pulse period (adjust based on your system)
ton = 0.4; % ON time of the pulse
toff = 0.6; % OFF time of the pulse (adjust based on your setup)
f0 = 1; % Fundamental frequency (adjust as needed)
m = -10:10; % Range of m values (harmonics)
k = 2*pi;  % Wave number 
d = 0.5;

% Additional parameters for array factor
N = 16; % Number of array elements
theta = linspace(-pi, pi, 360); % Angle range for AF calculation

% Calculate tau_n and Duty cycle
tau_n = (toff - ton) / Tp;  
Duty_cycle = ton / Tp;  % Duty Cycle

% Preallocate Gmn array for different m
Gmn = zeros(size(m));

% Compute Gmn for each value of m
for i = 1:length(m)
    Gmn(i) = tau_n * sinc(tau_n * m(i)) * exp(-1j * 2 * pi * m(i) * (2 * Duty_cycle + tau_n));
end

% Calculate the array factor
AF = zeros(size(theta)); % Preallocate array for AF
for k = 1:length(theta)
    for n = 0:N-1
        AF(k) = AF(k) + Gmn(n + 1) * exp(1j * k * n * d * sin(theta(k))); % Correctly indexing theta(k)
    end
end

% Normalize the array factor
AF = AF / max(abs(AF)); % Normalize for better visualization

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



% Plot the magnitude and phase of Gmn for visualization
figure;
subplot(4,1,1);
stem(m, abs(Gmn), 'LineWidth', 1);
xlabel('Harmonic Index m');
ylabel('|G_{mn}|');
title('Magnitude of G_{mn}');
grid on;

subplot(4,1,2);
stem(m, angle(Gmn), 'LineWidth', 1);
xlabel('Harmonic Index m');
ylabel('Phase of G_{mn}');
title('Phase of G_{mn}');
grid on;

% Subplot 3: Rectangular Plot of Radiation Pattern
subplot(4,1,3);  % Third subplot in 2x2 grid
plot(rad2deg(theta), pattern_normalized);
xlabel('Angle in degrees');
ylabel('Radiation Pattern');
title('Rectangular Plot of Radiation Pattern');
grid on;

% Subplot 4: Polar Plot of Radiation Pattern
subplot(4,1,4);  % Fourth subplot in 2x2 grid
polarplot((theta), pattern_normalized);
title('Polar Plot of Radiation Pattern');
grid on;

