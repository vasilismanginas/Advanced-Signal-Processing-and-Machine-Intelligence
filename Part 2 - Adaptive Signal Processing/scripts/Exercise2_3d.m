clear; clc;
load('../../font_sizes.mat');
eeg_data = load('../../data/EEG_data/EEG_Data_Assignment2.mat');
sampling_frequency = eeg_data.fs;
POz_signal = transpose(detrend(eeg_data.POz));

signal_length = length(POz_signal);
sine_frequency = 50;
t = (0: signal_length-1) / sampling_frequency;
mains_noise = sin(2 * pi * sine_frequency * t);
synthetic_reference_noise = mains_noise + 0.01 * randn(1, signal_length);

model_orders = [5, 10, 15, 20];
% model_orders = [5, 10];
num_orders = length(model_orders);
step_sizes = [0.01, 0.001, 0.0001];
% step_sizes = [0.01, 0.001];
num_steps = length(step_sizes);


order = 10;
step_size = 0.001;


window_length = 2 ^ 12;
overlap_length = 0.75 * window_length;
nfft = 2 ^ 13;



% figure;
% ctr = 0;
% for i = 1: num_orders
%     for j = 1: num_steps
%         [noise_estimates_ANC, errors_ANC, weights_ANC] = LMS(synthetic_reference_noise, POz_signal, model_orders(i), step_sizes(j));
%         output_estimates_ANC = POz_signal - noise_estimates_ANC;
%     
%         ctr = ctr + 1;
%         subplot(num_orders, num_steps, ctr);
%         spectrogram(output_estimates_ANC, window_length, overlap_length, nfft, sampling_frequency, 'yaxis')
%         ylim([0 60])
%         title(sprintf('Order = %i, Step Size = %.4f', [model_orders(i), step_sizes(j)]), 'FontSize', title_font);
%         set(gca,'FontSize', axes_font);
%     end
% end





figure;
subplot(2, 2, 1);
spectrogram(POz_signal, window_length, overlap_length, nfft, sampling_frequency, 'yaxis');
ylim([0 60])
title('Spectrogram of original POz signal', 'FontSize', title_font);
set(gca,'FontSize', axes_font);


optimal_order = 10;
optimal_step_size = 0.001;

[noise_estimates_ANC, errors_ANC, weights_ANC] = LMS(synthetic_reference_noise, POz_signal, optimal_order, optimal_step_size);
output_estimates_ANC = POz_signal - noise_estimates_ANC;
subplot(2, 2, 2);
spectrogram(output_estimates_ANC, window_length, overlap_length, nfft, sampling_frequency, 'yaxis');
ylim([0 60])
title('Spectrogram of optimal denoised POz signal', 'FontSize', title_font);
set(gca,'FontSize', axes_font);

subplot(2, 2, [3, 4]);
hold on;
[original_periodogram, frequency_range] = periodogram(POz_signal, hamming(signal_length), nfft, sampling_frequency);
denoised_periodogram = periodogram(output_estimates_ANC, hamming(signal_length), nfft, sampling_frequency);
plot(frequency_range, pow2db(original_periodogram), 'LineWidth', 3, 'DisplayName', 'Original');
plot(frequency_range, pow2db(denoised_periodogram), 'LineWidth', 3, 'DisplayName', 'Denoised');
title('Periodograms of original and denoised signals', 'FontSize', title_font);
xlabel('Frequency (Hz)');
ylabel('PSD Amplitude (dB)');
xlim([0 60]);
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;