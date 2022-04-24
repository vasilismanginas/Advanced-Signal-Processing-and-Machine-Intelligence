clear; clc;
load('../../font_sizes.mat');

sampling_frequency = 1;
signal_length = 100;
t = (0: signal_length-1);
f = t ./ (2*signal_length) .* sampling_frequency;
sine_frequencies = [0.15 0.35];


noise_signal = randn(1, signal_length);
filtered_noise_signal = filter([1 1], 1, noise_signal);
sines = 2*sin(2 * pi * sine_frequencies(1) * t) + sin(2 * pi * sine_frequencies(2) * t);
noisy_sine = sines + noise_signal;

signals = {noise_signal, filtered_noise_signal, noisy_sine};
signal_labels = ["Noise Signal", "Filtered Noise Signal", "Noisy Sine Signal"];
num_signals = length(signals);


for i = 1: num_signals
    biased_acfs{i} = xcorr(signals{i}, 'biased');
    biased_psds{i} = fftshift(fft(ifftshift(biased_acfs{i})));
    unbiased_acfs{i} = xcorr(signals{i}, 'unbiased');
    unbiased_psds{i} = fftshift(fft(ifftshift(unbiased_acfs{i})));

    halved_biased_acfs{i} = biased_acfs{i}(signal_length: (2*signal_length)-1);
    halved_biased_psds{i} = biased_psds{i}(signal_length: (2*signal_length)-1);
    halved_unbiased_acfs{i} = unbiased_acfs{i}(signal_length: (2*signal_length)-1);
    halved_unbiased_psds{i} = unbiased_psds{i}(signal_length: (2*signal_length)-1);
end


figure;
for i = 1 : num_signals
    subplot(num_signals, 2, (i*2)-1);
    plot(t, halved_unbiased_acfs{i}, 'LineWidth', 3, 'DisplayName', 'Unbiased');
    hold on;
    plot(t, halved_biased_acfs{i}, 'LineWidth', 3, 'DisplayName', 'Biased');
    title(sprintf('Correlogram of %s', signal_labels(i)), 'FontSize', title_font);
    xlabel('Lag (samples)');
    ylabel('ACF Amplitude');
    set(gca,'FontSize', axes_font)
    legend('FontSize', legend_font);
    grid on; grid minor;
end

for i = 1 : num_signals
    subplot(num_signals, 2, i*2);
    plot(f, halved_unbiased_psds{i}, 'LineWidth', 3, 'DisplayName', 'Unbiased');
    hold on;
    plot(f, halved_biased_psds{i}, 'LineWidth', 3, 'DisplayName', 'Biased');
    title(sprintf('PSD of %s', signal_labels(i)), 'FontSize', title_font);
    xlabel('Normalised Frequency (\pi radians / sample)');
    ylabel('PSD Amplitude');
    set(gca,'FontSize', axes_font)
    legend('FontSize', legend_font);
    grid on; grid minor;
end
