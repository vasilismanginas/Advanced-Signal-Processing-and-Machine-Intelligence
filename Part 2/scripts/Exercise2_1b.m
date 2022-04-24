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

figure;
% subplot(1, 2, 1)
hold on;
for step_size = step_sizes
    all_trial_errors = zeros(num_trials, signal_length);
    for trial = 1: num_trials
        input_signal = transpose(simulate(ar_model, signal_length));
        [output_estimates, errors, weights] = LMS(input_signal, input_signal, weights_size, step_size);
        all_trial_errors(trial, :) = errors .^ 2;
    end
    MSE = pow2db(mean(all_trial_errors, 1));
    plot(MSE, 'LineWidth', 2, 'DisplayName', sprintf('Step size: %.2f', step_size));
end
title('LMS Learning Curve', 'FontSize', title_font);
xlabel('Sample');
ylabel('MSE (dB)');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

% 
% subplot(1, 2, 2)
% plot(weights, 'LineWidth', 3);
% title('Learnt weight estimates of AR coefficients', 'FontSize', title_font);
% xlabel('Sample');
% ylabel('Weights');
% xlim([0 1000])
% set(gca,'FontSize', axes_font);
% grid on; grid minor;