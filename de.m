% Differential Evolution (DE) for Time Modulated 1x8 Linear Array
clear all; close all; clc;

%% Parameters
N = 8; % Number of antenna elements
T = 10; % Number of time steps (time slots per modulation period)
pop_size = 50; % Population size
gen = 100; % Number of generations
F = 0.8; % Mutation factor
CR = 0.9; % Crossover probability

%% Initialize Population (Random 0/1 switching)
pop = randi([0 1], pop_size, N*T);

%% Fitness Function: Minimize Side Lobe Level (SLL)
fitness = zeros(pop_size, 1);

for g = 1:gen
    for i = 1:pop_size
        % Mutation
        idxs = randperm(pop_size,3);
        mutant = pop(idxs(1),:) + F*(pop(idxs(2),:) - pop(idxs(3),:));
        mutant = mod(round(mutant),2); % Ensure 0/1 only
        
        % Crossover
        cross_points = rand(1, N*T) < CR;
        trial = pop(i,:);
        trial(cross_points) = mutant(cross_points);
        
        % Selection
        fit_trial = fitness_function(trial, N, T);
        fit_target = fitness_function(pop(i,:), N, T);
        
        if fit_trial < fit_target
            pop(i,:) = trial;
            fitness(i) = fit_trial;
        else
            fitness(i) = fit_target;
        end
    end
    
    % Optional: Display best fitness in each generation
    disp(['Generation ', num2str(g), ': Best SLL = ', num2str(min(fitness))]);
end

%% Output Best Solution
[~, best_idx] = min(fitness);
best_solution = pop(best_idx,:);

% Reshape into (Elements x Time Steps) matrix
best_sequence = reshape(best_solution, [T, N])';

disp('Best ON/OFF switching matrix:');
disp(best_sequence);

%% --- FITNESS FUNCTION ---
function SLL = fitness_function(switching_seq, N, T)
    % Reshape to (Elements x Time Steps)
    seq = reshape(switching_seq, [T, N])';
    
    % Time-averaged excitation for each element
    weights = sum(seq, 2)/T;
    
    % Calculate Array Factor (normalized)
    theta = linspace(-pi/2, pi/2, 500);
    AF = zeros(size(theta));
    
    for n = 1:N
        AF = AF + weights(n) * exp(1j*(n-1)*pi*sin(theta));
    end
    
    AF_norm = abs(AF) / max(abs(AF));
    
    % Exclude main lobe
    AF_norm(theta >= -pi/6 & theta <= pi/6) = -inf;
    
    % Find maximum sidelobe level
    SLL = max(AF_norm);
end
