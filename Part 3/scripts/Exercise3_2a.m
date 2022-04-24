clear; clc;
load('../../font_sizes.mat');

signal_length = 1500;
sampling_frequency = 1000;
variance = 0.05;
circular_wgn = variance * (randn(1, signal_length) + 1i * randn(1, signal_length));

frequency = zeros(1, signal_length);
frequency(1:500) = 100;
frequency(501:1000) = 100 + ((501:1000) - 500) / 2;
frequency(1001:1500) = 100 + (((1001:1500) - 1000) / 25) .^ 2;
phase = cumsum(frequency);

FM_signal = exp(1i * (2*pi/sampling_frequency .* phase));
noisy_FM_signal = FM_signal + circular_wgn;

AR_order = 1;
coeff_estimate = aryule(noisy_FM_signal, AR_order);
[freq_response_est, freq_range] = freqz(1, coeff_estimate, signal_length, sampling_frequency);
PSD_estimate = abs(freq_response_est) .^ 2;

figure;
subplot(2, 2, 1);
plot(frequency, 'LineWidth', 3);
title('Frequency variation of FM signal', 'FontSize', title_font);
xlabel('Sample');
ylabel('Frequency (Hz)');
set(gca,'FontSize', axes_font)
grid on; grid minor;

subplot(2, 2, 3);
plot(angle(FM_signal), 'LineWidth', 1);
title('Phase of FM signal', 'FontSize', title_font);
xlabel('Sample');
ylabel('Phase (rad)');
set(gca,'FontSize', axes_font)
grid on; grid minor;

subplot(2, 2, [2, 4]);
plot(freq_range, PSD_estimate, 'LineWidth', 3);
title('AR PSD of FM signal', 'FontSize', title_font);
xlabel('Frequency (Hz)');
ylabel('PSD Amplitude');
set(gca,'FontSize', axes_font)
grid on; grid minor;