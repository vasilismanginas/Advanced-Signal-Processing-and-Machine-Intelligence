clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
variance = 0.5;
num_trials = 100;
noise = sqrt(variance) * randn(num_trials, signal_length);
numerator = [1 0.9];
denominator = 1;
w0 = 0.9;
weights_length = 1;
rho = 0.001;
alpha = 0.8;
xlimit = 1000;
initial_step_size = 0;

weight_error_LMS1 = zeros(num_trials, signal_length+1);
weight_error_LMS2 = zeros(num_trials, signal_length+1);
weight_error_banveniste = zeros(num_trials, signal_length+1);
weight_error_fahrang = zeros(num_trials, signal_length+1);
weight_error_matthews = zeros(num_trials, signal_length+1);
adaptive_step_banveniste = zeros(num_trials, signal_length+1);
adaptive_step_fahrang = zeros(num_trials, signal_length+1);
adaptive_step_matthews = zeros(num_trials, signal_length+1);

for trial = 1: num_trials
    noise_signal = noise(trial, :);
    input_signal = filter(numerator, denominator , noise_signal);
    [output_estimates_LSM1, errors_LSM1, weights_LSM1] = LMS(noise_signal, input_signal, weights_length, 0.01);
    [output_estimates_LSM2, errors_LSM2, weights_LSM2] = LMS(noise_signal, input_signal, weights_length, 0.1);
    [output_estimates_benveniste, errors_benveniste, weights_benveniste, adaptive_step_sizes_benveniste] = GASS_LMS(noise_signal, input_signal, weights_length, 'benveniste', initial_step_size, rho, alpha);
    [output_estimates_fahrang, errors_fahrang, weights_fahrang, adaptive_step_sizes_fahrang] = GASS_LMS(noise_signal, input_signal, weights_length, 'fahrang', initial_step_size, rho, alpha);
    [output_estimates_matthews, errors_matthews, weights_matthews, adaptive_step_sizes_matthews] = GASS_LMS(noise_signal, input_signal, weights_length, 'matthews', initial_step_size, rho, alpha);
    

    weight_error_LMS1(trial, :) = w0 - weights_LSM1;
    weight_error_LMS2(trial, :) = w0 - weights_LSM2;
    weight_error_banveniste(trial, :) = w0 - weights_benveniste;
    weight_error_fahrang(trial, :) = w0 - weights_fahrang;
    weight_error_matthews(trial, :) = w0 - weights_matthews;
    adaptive_step_banveniste(trial, :) = adaptive_step_sizes_benveniste;
    adaptive_step_fahrang(trial, :) = adaptive_step_sizes_fahrang;
    adaptive_step_matthews(trial, :) = adaptive_step_sizes_matthews;
end

averaged_weight_error_LMS1 = mean(weight_error_LMS1, 1);
averaged_weight_error_LMS2 = mean(weight_error_LMS2, 1);
averaged_weight_error_benveniste = mean(weight_error_banveniste, 1);
averaged_weight_error_fahrang = mean(weight_error_fahrang, 1);
averaged_weight_error_matthews = mean(weight_error_matthews, 1);
averaged_adaptive_step_benveniste = mean(adaptive_step_sizes_benveniste, 1);
averaged_adaptive_step_fahrang = mean(adaptive_step_sizes_fahrang, 1);
averaged_adaptive_step_matthews = mean(adaptive_step_sizes_matthews, 1);

fig = figure;
fig.WindowState = 'maximized';
subplot(1, 2, 1);
hold on;
plot(averaged_weight_error_LMS1(1:xlimit), 'LineWidth', 3, 'DisplayName', 'LMS: step size = 0.01');
plot(averaged_weight_error_LMS2(1:xlimit), 'LineWidth', 3, 'DisplayName', 'LMS: step size = 0.1');
plot(averaged_weight_error_benveniste(1:xlimit), 'LineWidth', 3, 'DisplayName', 'GASS LSM: Benveniste');
plot(averaged_weight_error_fahrang(1:xlimit), 'LineWidth', 3, 'DisplayName', 'GASS LSM: Fahrang');
plot(averaged_weight_error_matthews(1:xlimit), 'LineWidth', 3, 'DisplayName', 'GASS LSM: Matthews');
title('Weight error of standard LMS and GASS LMS', 'FontSize', title_font);
xlabel('Sample');
ylabel('Weight error');
xlim([0 xlimit])
ylim([-0.1 1])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

subplot(1, 2, 2);
hold on;
plot(averaged_adaptive_step_benveniste, 'LineWidth', 3, 'DisplayName', 'GASS LSM: Benveniste');
plot(averaged_adaptive_step_fahrang, 'LineWidth', 3, 'DisplayName', 'GASS LSM: Fahrang');
plot(averaged_adaptive_step_matthews, 'LineWidth', 3, 'DisplayName', 'GASS LSM: Matthews');
title('Evolution of step size of GASS LMS', 'FontSize', title_font);
xlabel('Sample');
ylabel('Step size');
xlim([0 xlimit])
ylim([-0.05 0.4])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;