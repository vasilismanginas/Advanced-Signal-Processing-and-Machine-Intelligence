clear; clc;
load('../../font_sizes.mat');

sampling_frequency = 1;
signal_length = 100;
t = (0: signal_length-1);
f = t ./ (2*signal_length) .* sampling_frequency;
sine_frequencies = [0.1 0.35];
sum_of_sines = 2 * sin(2 * pi * sine_frequencies(1) * t) + sin(2 * pi * sine_frequencies(2) * t);
num_of_trials = 100;

PSD_matrix = zeros(num_of_trials, signal_length);
dB_PSD_matrix = zeros(num_of_trials, signal_length);

for j = 1: num_of_trials
    noise_signal = randn(1, signal_length);
    noisy_sine = sum_of_sines + noise_signal;
    biased_acf = xcorr(noisy_sine, 'biased');
    biased_psd = fftshift(fft(ifftshift(biased_acf)));
    halved_biased_psd = biased_psd(signal_length: (2*signal_length)-1);
    halved_biased_psd_dB = pow2db(halved_biased_psd);
    PSD_matrix(j, :) = halved_biased_psd;
    dB_PSD_matrix(j, :) = halved_biased_psd_dB;
end


figure;
subplot(2, 2, 1);
for j = 1: num_of_trials
    if j == 1
        plot(f, PSD_matrix(j, :), 'Color',	'#4DBEEE', 'DisplayName', 'Individual Realisations');
    else
        plot(f, PSD_matrix(j, :), 'Color', '#4DBEEE', 'HandleVisibility', 'off');
    end
    hold on;
end
PSDs_sum = sum(PSD_matrix);
mean_PSD = PSDs_sum ./ num_of_trials;
plot(f, mean_PSD, 'LineWidth', 2, 'Color', 'k', 'DisplayName', 'Realisations Mean');
hold on;
clean_sine_biased_acf = xcorr(sum_of_sines, 'biased');
clean_sine_biased_psd = fftshift(fft(ifftshift(clean_sine_biased_acf)));
clean_sine_halved_biased_psd = clean_sine_biased_psd(signal_length: (2*signal_length)-1);
plot(f, clean_sine_halved_biased_psd, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Sine without noise');
title('Different PSD Realisations, Mean, and Clean PSD', 'FontSize', title_font);
xlabel('Normalised Frequency (\pi radians / sample)');
ylabel('PSD Amplitude');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;


subplot(2, 2, 3);
PSDs_std = std(PSD_matrix);
plot(f, PSDs_std, 'LineWidth', 3);
title('Standard Deviation PSD Realisations', 'FontSize', title_font);
xlabel('Normalised Frequency (\pi radians / sample)');
ylabel('PSD Standard Deviation');
set(gca,'FontSize', axes_font);
grid on; grid minor;


subplot(2, 2, 2);
for j = 1: num_of_trials
    if j == 1
        plot(f, dB_PSD_matrix(j, :), 'Color',	'#4DBEEE', 'DisplayName', 'Individual Realisations');
    else
        plot(f, dB_PSD_matrix(j, :), 'Color', '#4DBEEE', 'HandleVisibility', 'off');
    end
    hold on;
end
dB_PSDs_sum = sum(dB_PSD_matrix);
mean_dB_PSD = dB_PSDs_sum ./ num_of_trials;
plot(f, mean_dB_PSD, 'LineWidth', 2, 'Color', 'k', 'DisplayName', 'Realisations Mean');
hold on;
clean_sine_halved_biased_dB_psd = pow2db(clean_sine_halved_biased_psd);
plot(f, clean_sine_halved_biased_dB_psd, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Sine without noise');
title('Different PSD Realisations, Mean, and Clean PSD (dB)', 'FontSize', title_font);
xlabel('Normalised Frequency (\pi radians / sample)');
ylabel('PSD Amplitude (dB)');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;
ylim([-80 30])


subplot(2, 2, 4);
dB_PSDs_std = std(dB_PSD_matrix);
plot(f, dB_PSDs_std, 'LineWidth', 3);
title('Standard Deviation of PSD Realisations (dB)', 'FontSize', title_font);
xlabel('Normalised Frequency (\pi radians / sample)');
ylabel('PSD Standard Deviation (dB)');
set(gca,'FontSize', axes_font);
grid on; grid minor;