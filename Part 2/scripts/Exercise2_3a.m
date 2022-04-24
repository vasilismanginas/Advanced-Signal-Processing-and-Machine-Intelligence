clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;

sampling_frequency = 1;
sine_frequency = 0.005;
t = (0: signal_length-1) / sampling_frequency;
clean_signal = sin(2 * pi * sine_frequency * t);

weights_length = 2;
step_size = 0.01;
% delays = [1, 2, 3, 4];
delays = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
num_delays = length(delays);
num_trials = 1000;
MSPE = zeros(num_delays, num_trials);

figure;
for i = 1: num_delays
    for j = 1: num_trials
        white_noise = randn(1, signal_length);
        numerator = [1 0 0.5];
        denominator = 1;
        noise_signal = filter(numerator, denominator , white_noise);
        noisy_sine = clean_signal + noise_signal;

        [output_estimates, errors, weights] = LMS_ALE(noisy_sine, noisy_sine, weights_length, step_size, delays(i));
        MSPE(i, j) = mean((clean_signal - output_estimates) .^ 2);
    end
    
    if i <= 4
        subplot(4, 2, 2*i-1);
        hold on;
        plot(noisy_sine, 'LineWidth', 2, 'DisplayName', 'Noisy signal', 'Color', '#4DBEEE');
        plot(output_estimates, 'LineWidth', 2, 'DisplayName', 'ALE', 'Color', 'r');
        plot(clean_signal, 'LineWidth', 3, 'DisplayName', 'Clean signal', 'Color', 'k');
        title(sprintf('Clean, noisy, and ALE output signals for delay = %i', delays(i)), 'FontSize', title_font);
        xlabel('Sample');
        ylabel('Amplitude');
        set(gca,'FontSize', axes_font);
        legend('FontSize', legend_font);
        grid on; grid minor;
    end
end


subplot(4, 2, 2 * (1:4));
MSPE_averages = mean(MSPE, 2);
plot(MSPE_averages, 'LineWidth', 3);
title('MSPE for different delays', 'FontSize', title_font);
xlabel('Delay');
ylabel('MSPE');
set(gca,'FontSize', axes_font);
grid on; grid minor;