clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
variance = 0.5;
num_trials = 1000;
noise = sqrt(variance) * randn(num_trials, signal_length);
numerator = [1 0.9];
denominator = 1; 
w0 = 0.9;
weights_length = 1;
rho = 0.001;
GASS_init_step = 0.05;
GNGD_init_step = 0.05;
xlimit = 1000;

all_weights_banveniste = zeros(num_trials, signal_length+1);
all_weights_GNGD = zeros(num_trials, signal_length+1);
weight_error_banveniste = zeros(num_trials, signal_length+1);
weight_error_GNGD = zeros(num_trials, signal_length+1);
all_trial_emse_benveniste = zeros(1, num_trials);
all_trial_emse_GNGD = zeros(1, num_trials);

for trial = 1: num_trials
    noise_signal = noise(trial, :);
    input_signal = filter(numerator, denominator , noise_signal);
    [output_estimates_benveniste, errors_benveniste, weights_benveniste, adaptive_step_sizes_benveniste] = GASS_LMS(noise_signal, input_signal, weights_length, 'benveniste', GASS_init_step, rho, 0);
    [output_estimates_GNGD, errors_GNGD, weights_GNGD] = GNGD(noise_signal, input_signal, weights_length, GNGD_init_step, rho);
    
    all_weights_banveniste(trial, :) = transpose(weights_benveniste);
    weight_error_banveniste(trial, :) = w0 - weights_benveniste;
    all_weights_GNGD(trial, :) = transpose(weights_GNGD);
    weight_error_GNGD(trial, :) = w0 - weights_GNGD;

    mean_steady_state_error_benveniste = mean(errors_benveniste(signal_length/2 + 1 : end) .^ 2);
    current_emse_benveniste = mean_steady_state_error_benveniste - variance;
    all_trial_emse_benveniste(trial) = current_emse_benveniste;

    mean_steady_state_error_GNGD = mean(errors_GNGD(signal_length/2 + 1 : end) .^ 2);
    current_emse_GNGD = mean_steady_state_error_GNGD - variance;
    all_trial_emse_GNGD(trial) = current_emse_GNGD;
end

EMSE_GNGD = mean(all_trial_emse_GNGD);
EMSE_benveniste = mean(all_trial_emse_benveniste);

averaged_weight_benveniste = mean(all_weights_banveniste, 1);
averaged_weight_error_benveniste = mean(weight_error_banveniste, 1);
averaged_weight_GNGD = mean(all_weights_GNGD, 1);
averaged_weight_error_GNGD = mean(weight_error_GNGD, 1);

figure;
hold on;
plot(averaged_weight_error_benveniste(1:xlimit), 'LineWidth', 3, 'DisplayName', 'GASS LSM: Benveniste');
plot(averaged_weight_error_GNGD(1:xlimit), 'LineWidth', 3, 'DisplayName', 'GNGD');
title('Evolution of weight error of Benveniste GASS LMS and GNGD', 'FontSize', title_font);
xlabel('Sample');
ylabel('Weight error');
xlim([0 xlimit]);
% ylim([-0.1 1])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;