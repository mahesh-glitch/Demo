clc; clear;

% === Step 1: Load CST Far-Field File (1_8.ffs) ===
filename = '1_8.ffs';
fid = fopen(filename, 'r');
lines = {};
while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line) || startsWith(line, '#')
        continue;
    end
    nums = sscanf(line, '%f');
    if length(nums) >= 2  % valid rows only
        lines{end+1,1} = nums.';
    end
end
fclose(fid);

% === Step 2: Convert to Numeric Matrix ===
row_lengths = cellfun(@length, lines);
max_len = mode(row_lengths);  % most common row length
valid_lines = lines(row_lengths == max_len);  % only keep consistent rows
data = cell2mat(valid_lines);

% === Step 3: Extract Angle and Gain ===
theta = data(:, 1);                % theta in degrees
gain = abs(data(:, end));          % gain (magnitude)
gain = gain / max(gain);           % normalize

% === Step 4: Define 8×8 Time Modulation Matrix ===
S = [
    1 0 0 1 0 0 1 1;
    0 1 0 0 1 0 1 0;
    0 0 1 0 0 1 0 1;
    1 1 0 0 0 0 0 1;
    0 0 1 1 1 0 0 0;
    1 0 1 0 0 1 0 0;
    0 1 0 1 0 1 1 0;
    1 0 0 0 1 1 0 1
];

% === Step 5: Simulate Time-Modulated Radiation Pattern ===
T = size(S, 1);  % number of time slots
N = size(S, 2);  % number of antennas
E_total = zeros(size(gain));

for t = 1:T
    E_t = zeros(size(gain));
    for n = 1:N
        E_t = E_t + S(t, n) * gain;
    end
    E_total = E_total + E_t;
end

E_total = E_total / max(E_total);  % normalize

% === Step 6: Polar Plot ===
figure;
polarplot(deg2rad(theta), E_total, 'LineWidth', 2);
title('TMAA Radiation Pattern (from CST Far-Field)');
rlim([0 1]);
