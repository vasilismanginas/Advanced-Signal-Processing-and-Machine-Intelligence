clear; clc;
load('../../font_sizes.mat');

signal_length = 1500;
sampling_frequency = 1000;
freq_range = (0: signal_length-1) * sampling_frequency / signal_length;
variance = 0.05;
circular_wgn = variance * (randn(1, signal_length) + 1i * randn(1, signal_length));

frequency = zeros(1, signal_length);
frequency(1:500) = 100;
frequency(501:1000) = 100 + ((501:1000) - 500) / 2;
frequency(1001:1500) = 100 + (((1001:1500) - 1000) / 25) .^ 2;
phase = cumsum(frequency);

FM_signal = exp(1i * (2*pi/sampling_frequency .* phase));
noisy_FM_signal = FM_signal + circular_wgn;

CLMS_step = 1;
CLMS_leakages = [0, 0.01, 0.1];
num_leakages = length(CLMS_leakages);
CLMS_input = (1/signal_length) * exp(1i * 2*pi/signal_length * (0:signal_length-1)' * (0:signal_length-1));

figure;
for i = 1: num_leakages
    [~, ~, CLMS_weights] = DFT_CLMS(CLMS_input, noisy_FM_signal, CLMS_step, CLMS_leakages(i));
    PSD = abs(transpose(CLMS_weights)) .^ 2;
    median_psd = 50 * median(PSD, 'all');
    PSD(PSD > median_psd) = median_psd;
    
    subplot(num_leakages, 1, i);
    surf(1:signal_length, freq_range, PSD, "LineStyle", "none");
    view(2);
    cbar = colorbar;
    cbar.Label.String = 'PSD (dB)';
    title(sprintf('Time frequency diagram of FM signal with DFT-CLMS, step size = 1, leakage = %.3f', CLMS_leakages(i)), 'FontSize', title_font);
    xlabel('Sample');
    ylabel('Frequency (Hz)');
    ylim([0 600])
    set(gca,'FontSize', axes_font)  
    grid on; grid minor;
end
