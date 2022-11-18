clear; clc;
load('../../font_sizes.mat');
eeg_data = load('../../data/EEG_data/EEG_Data_Assignment2.mat');
sampling_frequency = eeg_data.fs;
signal_length = 1200;
freq_range = (0: signal_length-1) * sampling_frequency / signal_length;
starting_points = [1500, 3000];
num_starting_points = length(starting_points);

figure;
for i = 1: num_starting_points
    
    POz_signal = transpose(detrend(eeg_data.POz - mean(eeg_data.POz)));
    POz_signal = POz_signal(starting_points(i): starting_points(i) + signal_length - 1);
    
    CLMS_step = 1;
    CLMS_leakage = 0;
    CLMS_input  = 1/signal_length * exp(1i * (1: signal_length)' * pi/signal_length * (0:signal_length - 1));
    
    [~, ~, CLMS_weights] = DFT_CLMS(CLMS_input, POz_signal, CLMS_step, CLMS_leakage);
    PSD = abs(transpose(CLMS_weights)) .^ 2;
    median_psd = 400 * median(PSD, 'all');
    PSD(PSD > median_psd) = median_psd;
    
    
    
    subplot(num_starting_points, 1, i);
    surf(1:signal_length, freq_range, PSD, "LineStyle", "none");
    view(2);
    cbar = colorbar;
    cbar.Label.String = 'PSD (dB)';
    title(sprintf('Time frequency diagram of EEG POz signal with DFT-CLMS, start = %i', starting_points(i)), 'FontSize', title_font);
    xlabel('Sample');
    ylabel('Frequency (Hz)');
    ylim([0 70])
    set(gca,'FontSize', axes_font)  
    grid on; grid minor;
end