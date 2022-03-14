clear; clc;
sampling_frequency = 1;
sampling_period = 1 / sampling_frequency;
signal_length = 1000;
t = (0: signal_length) * sampling_period;


% impulse signal
impulse = t==0;
[impulse_direct, ~] = direct_psd(impulse, sampling_frequency);
[impulse_acf, impulse_lags, impulse_indirect, ~] = indirect_psd(impulse, sampling_frequency);

% combination of two sinusoidal signal
sine_frequencies = [0.15, 0.48];
sines_signal = sin(2 * pi * sine_frequencies(1) * t) + sin(2 * pi * sine_frequencies(2) * t);
[sines_direct, direct_frequency_range] = direct_psd(sines_signal, sampling_frequency);
[sines_acf, sines_lags, sines_indirect, indirect_frequency_range] = indirect_psd(sines_signal, sampling_frequency);

% % random signal
% random_signal = 5 * rand(1, signal_length+1) - 2.5;
% random_direct = direct_psd(random_signal);
% [random_acf, random_lags, randon_indirect] = indirect_psd(random_signal);


% direct_frequency_range = (-signal_length/2 : signal_length/2) * sampling_frequency / signal_length;
% indirect_frequency_range = (-signal_length : signal_length) ./ 2 * sampling_frequency / signal_length;

title_font = 17;
axes_font = 15;
legend_font = 15;

figure;
subplot(2, 2, 1);
plot(impulse_lags, impulse_acf, 'LineWidth', 3);
title('ACF of impulse function', 'FontSize', title_font)
xlabel('Lag (samples)')
ylabel('ACF Amplitude')
set(gca,'FontSize', axes_font)
grid on; grid minor;


subplot(2, 2, 2);
plot(sines_lags, sines_acf, 'LineWidth', 2);
title('Direct and indirect methods of PSD estimation', 'FontSize', title_font)
title('ACF of sum of sinusoidal functions', 'FontSize', 13)
xlabel('Lag (samples)')
ylabel('ACF Amplitude')
set(gca,'FontSize', axes_font)
grid on; grid minor;

subplot(2, 2, 3);
hold on;
plot(indirect_frequency_range, impulse_indirect, 'LineWidth', 4, 'DisplayName', 'Indirect Method');
plot(direct_frequency_range, impulse_direct, '--', 'LineWidth', 4, 'DisplayName', 'Direct Method');
ylim([0.00099, 0.00101]);
title('Direct and indirect methods of PSD estimation', 'FontSize', title_font)
xlabel('Normalised Frequency (\pi radians / sample)')
ylabel('PSD Amplitude')
legend('FontSize', legend_font);
set(gca,'FontSize', axes_font)
grid on; grid minor;

subplot(2, 2, 4);
hold on;
plot(indirect_frequency_range, sines_indirect, 'LineWidth', 4, 'DisplayName', 'Indirect Method');
plot(direct_frequency_range, sines_direct, 'LineWidth', 4, 'DisplayName', 'Direct Method');
title('Direct and indirect methods of PSD estimation', 'FontSize', title_font)
xlabel('Normalised Frequency (\pi radians / sample)')
ylabel('PSD Amplitude')
legend('FontSize', legend_font);
set(gca,'FontSize', axes_font)
grid on; grid minor;


function [direct_psd, direct_frequency_range] = direct_psd(signal, sampling_frequency)
    signal_length = length(signal) - 1;
    centered_signal_fft = fftshift(fft(signal));
    centerd_magnitude = abs(centered_signal_fft);
    direct_psd = centerd_magnitude .^ 2 / length(signal);
    direct_frequency_range = (-signal_length/2 : signal_length/2) * sampling_frequency / signal_length;
end

function [signal_acf, signal_lags, indirect_psd, indirect_frequency_range] = indirect_psd(signal, sampling_frequency)
    signal_length = length(signal) - 1;
    [signal_acf, signal_lags] = xcorr(signal, 'biased');
    centered_signal_fft = fftshift(fft(signal_acf));
    indirect_psd = abs(centered_signal_fft);
    indirect_frequency_range = (-signal_length : signal_length) ./ 2 * sampling_frequency / signal_length;
end