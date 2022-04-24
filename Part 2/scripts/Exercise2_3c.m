clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;

sampling_frequency = 1;
sine_frequency = 0.005;
t = (0: signal_length-1) / sampling_frequency;
clean_signal = sin(2 * pi * sine_frequency * t);

model_order = 5;
step_size = 0.01;
delay = 3;
num_trials = 1000;
MSPE_ALE = zeros(1, num_trials);
MSPE_ANC = zeros(1, num_trials);
all_outputs_ALE = zeros(num_trials, signal_length);
all_outputs_ANC = zeros(num_trials, signal_length);


for i = 1: num_trials
    white_noise = randn(1, signal_length);
    numerator = [1 0 0.5];
    denominator = 1;
    noise_signal = filter(numerator, denominator , white_noise);
    noisy_sine = clean_signal + noise_signal;
    secondary_noise = 2 * noisy_sine + 0.05;

    [output_estimates_ALE, errors_ALE, weights_ALE] = LMS_ALE(noisy_sine, noisy_sine, model_order, step_size, delay);
    [noise_estimates_ANC, errors_ANC, weights_ANC] = LMS(secondary_noise, noise_signal, model_order, step_size);

    output_estimates_ANC = noisy_sine - noise_estimates_ANC;
    all_outputs_ALE(i, :) = output_estimates_ALE;
    all_outputs_ANC(i, :) = output_estimates_ANC;
    MSPE_ALE(i) = mean((clean_signal - output_estimates_ALE) .^ 2);
    MSPE_ANC(i) = mean((clean_signal - output_estimates_ANC) .^ 2);
end


average_output_ALE = mean(all_outputs_ALE, 1);
average_output_ANC = mean(all_outputs_ANC, 1);
MSPE_ALE_average = mean((clean_signal - average_output_ALE) .^ 2);
MSPE_ANC_average = mean((clean_signal - average_output_ANC) .^ 2);

figure;
hold on;

plot(noisy_sine, 'LineWidth', 2, 'DisplayName', 'Noisy signal', 'Color', '#4DBEEE');
plot(average_output_ALE, 'LineWidth', 3, 'DisplayName', 'ALE', 'Color', 'r');
plot(average_output_ANC, 'LineWidth', 3, 'DisplayName', 'ANC', 'Color', 'k');
plot(clean_signal, '--', 'LineWidth', 3, 'DisplayName', 'Clean signal', 'Color', 'y');
title('Clean, noisy, ALE output, and ANC output signals', 'FontSize', title_font);
xlabel('Sample');
ylabel('Amplitude');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;