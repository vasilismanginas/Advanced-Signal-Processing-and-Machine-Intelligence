clear; clc;
load('../../font_sizes.mat');
ecg_data = load('../../data/ECG_data/RRI-DATA.mat');

RRI_trials = {ecg_data.xRRI1, ecg_data.xRRI2, ecg_data.xRRI3};
sampling_frequency = 4;
window_length_samples = [50, 150];
overlap_samples = 0;
nfft = 2048;


figure;
for trial_index = 1: length(RRI_trials)
    current_trial = RRI_trials{trial_index};
    current_trial = detrend(current_trial - mean(current_trial));
    [standard_psd, frequency_range] = periodogram(current_trial, hamming(length(current_trial)), nfft, sampling_frequency);
    averaging_psd_50 = pwelch(current_trial, hamming(window_length_samples(1) * sampling_frequency), overlap_samples, nfft, sampling_frequency);
    averaging_psd_150 = pwelch(current_trial, hamming(window_length_samples(2) * sampling_frequency), overlap_samples, nfft, sampling_frequency);
    
    
    
    subplot(3, 1, trial_index);
    hold on;
    plot(frequency_range, pow2db(standard_psd), 'LineWidth', 2, 'DisplayName', 'Standard periodogram');
    plot(frequency_range, pow2db(averaging_psd_50), 'LineWidth', 2, 'DisplayName', 'Averaged periodogram (w = 50)');
    plot(frequency_range, pow2db(averaging_psd_150), 'LineWidth', 2, 'DisplayName', 'Averaged periodogram (w = 150)');
    title(sprintf('Periodograms of RRI trial %i', trial_index), 'FontSize', title_font);
    xlabel('Normalised Frequency (\pi radians / sample)');
    ylabel('PSD Amplitude');
%     xlim([0 0.5]);
    set(gca,'FontSize', axes_font)
    legend('FontSize', legend_font);
    grid on; grid minor;
end
