clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
ar_coeffs = [0.1, 0.8];
weights_size = length(ar_coeffs);
variance = 0.25;

ar_model = arima('Constant', 0, 'AR', ar_coeffs, 'Variance', variance);
step_sizes = [0.01, 0.05];
num_steps = length(step_sizes);
num_trials = 100;

all_trial_emse = zeros(num_steps, num_trials);
EMSE = zeros(1, num_steps);
misadjustments = zeros(1, num_steps);

for i = 1: num_steps
    for trial = 1: num_trials
        input_signal = transpose(simulate(ar_model, signal_length));
        [output_estimates, errors, weights] = LMS(input_signal, input_signal, weights_size, step_sizes(i));

        mean_steady_state_error = mean(errors(signal_length/2 + 1 : end) .^ 2);
        current_emse = mean_steady_state_error - variance;
        all_trial_emse(i, trial) = current_emse;
    end

    EMSE(i) = mean(all_trial_emse(i, :));
    misadjustments(i) = EMSE(i) / variance;
end