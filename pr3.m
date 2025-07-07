clc;
clear all;
close all;

% Parameters for Time-Modulated Array
N = 16;                       % Number of elements
d = 0.5;                     % Element spacing in wavelengths (lambda/2)
theta = linspace(0, pi, 1000);  % Observation angles from 0 to pi
beta = 2*pi;                % Phase constant (wave number for lambda = 1)
t = 0;                        % Time instant
h_max = 5;                    % Number of harmonics to consider
f0 = 1e9;                     % Carrier frequency (1 GHz)
fp = 1e6;                     % Modulation frequency (1 MHz)

% Initialize Array Factor for Time Modulation
AF_TMA = zeros(size(theta));

% Loop over harmonics
for h = -h_max:h_max
    p = exp(1i * 2 * pi * (f0 + h * fp) * t);  % Time modulation term
    for n = 1:N
        if mod(n, 2) == 0
            un_h = 1;  % Assuming unity amplitude modulation for simplicity
            AF_TMA = AF_TMA + un_h * exp(1i * beta * (n-1) * d * cos(theta));
        end
    end
AF_TMA=AF_TMA*p;
end

% Calculate Power Pattern
AF_TMA_power = abs(AF_TMA).^2;

% Normalize the Array Factor
AF_TMA_power_normalized = AF_TMA_power / max(AF_TMA_power);

% Calculate Directivity (U_max * 4 * pi / P_radiation)
U_max_TMA = max(AF_TMA_power_normalized);
P_radiation_TMA = 2 * pi * trapz(theta, AF_TMA_power_normalized .* sin(theta));
D_TMA = (U_max_TMA * 4 * pi) / P_radiation_TMA;
D_TMA_dB = 10 * log10(D_TMA);


