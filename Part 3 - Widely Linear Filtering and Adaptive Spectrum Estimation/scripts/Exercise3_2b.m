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

CLMS_order = 1;
CLMS_steps = [1, 0.1, 0.01, 0.001];
num_steps = length(CLMS_steps);

figure;
for i = 1: num_steps
    current_step = CLMS_steps(i);
    [~, ~, CLMS_coeff_estimate] = CLMS(noisy_FM_signal, noisy_FM_signal, CLMS_order, current_step);

    for n = 1: signal_length
        [freq_response_est, freq_range]= freqz(1 , [1; -conj(CLMS_coeff_estimate(n))], 1024);
        PSD(:, n) = abs(freq_response_est) .^ 2;
    end

    medianPSD = 50 * median(median(PSD));
    PSD(PSD > medianPSD) = medianPSD;

    subplot(num_steps, 1, i);
    surf(1:signal_length, freq_range, PSD, "LineStyle", "none");
    view(2);
    cbar = colorbar;
    cbar.Label.String = 'PSD (dB)';
    title(sprintf('Time frequency diagram of FM signal with CLMS, step size = %.3f', current_step), 'FontSize', title_font);
    xlabel('Sample');
    ylabel('Frequency (Hz)');
    set(gca,'FontSize', axes_font)  
    grid on; grid minor;
end
