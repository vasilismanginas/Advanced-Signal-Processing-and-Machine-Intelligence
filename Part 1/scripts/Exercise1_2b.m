clear; clc;
eeg_data = load('../../data/EEG_data/EEG_Data_Assignment1.mat');

eeg = eeg_data.POz;
num_samples = length(eeg_data.POz);
sampling_frequency = eeg_data.fs;
freq_resolution = 1 / 5;
nfft = sampling_frequency / freq_resolution;
overlap_samples = 0;
window_length_seconds = [1, 5, 10];
window_length_samples = window_length_seconds * sampling_frequency;


[standard_psd, frequency_range] = periodogram(eeg, rectwin(num_samples), nfft, sampling_frequency);
averaging_psd_1 = pwelch(eeg, rectwin(window_length_samples(1)), overlap_samples, nfft);
averaging_psd_5 = pwelch(eeg, rectwin(window_length_samples(2)), overlap_samples, nfft);
averaging_psd_10 = pwelch(eeg, rectwin(window_length_samples(3)), overlap_samples, nfft);


title_font = 17;
axes_font = 15;
legend_font = 15;


figure;
subplot(1, 2, 1);
plot(frequency_range, pow2db(standard_psd), 'LineWidth', 2);
title('Standard Periodogram', 'FontSize', title_font);
xlabel('Frequency (Hz)');
ylabel('PSD Amplitude (dB)');
xlim([0 60]);
set(gca,'FontSize', axes_font)
grid on; grid minor;

subplot(1, 2, 2);
hold on;
plot(frequency_range, pow2db(averaging_psd_10), 'LineWidth', 2, 'DisplayName', 'window length: 10s');
plot(frequency_range, pow2db(averaging_psd_5), 'LineWidth', 2, 'DisplayName', 'window length: 5s');
plot(frequency_range, pow2db(averaging_psd_1), 'LineWidth', 2, 'DisplayName', 'window length: 1s');
title('Variable Window Averaged Periodograms', 'FontSize', title_font);
xlabel('Frequency (Hz)');
ylabel('PSD Amplitude (dB)');
xlim([0 60]);
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;