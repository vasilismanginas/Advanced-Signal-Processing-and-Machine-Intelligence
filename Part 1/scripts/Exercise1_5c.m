clear; clc;
load('../../font_sizes.mat');
ecg_data = load('../../data/ECG_data/RRI-DATA.mat');

RRI_trials = {ecg_data.xRRI1, ecg_data.xRRI2, ecg_data.xRRI3};
sampling_frequency = 4;
window_length_samples = [50, 150];
overlap_samples = 0;
nfft = 2048;
model_orders = [5, 10, 15, 20, 25, 30];
RRI_orders = [5, 15, 20];

figure;
for trial_index = 1: length(RRI_trials)
    current_trial = RRI_trials{trial_index};
    current_trial = detrend(current_trial - mean(current_trial));
    current_length = length(current_trial);
    [standard_psd, frequency_range] = periodogram(current_trial, hamming(length(current_trial)), nfft, sampling_frequency);

    subplot(1, 3, trial_index);
%     figure;
    hold on;
    plot(frequency_range, pow2db(standard_psd), 'LineWidth', 2, 'DisplayName', 'Standard periodogram');

    [coeff_est, noise_variance_est, ~] = aryule(current_trial, RRI_orders(trial_index));
    [freq_response_est, freq_range] = freqz(sqrt(noise_variance_est), coeff_est, current_length, sampling_frequency);
    PSD_estimate = abs(freq_response_est) .^ 2;
    plot(freq_range, pow2db(PSD_estimate), 'LineWidth', 3, 'DisplayName', sprintf('AR(%i)', RRI_orders(trial_index)));

%     for order = model_orders
%         [coeff_est, noise_variance_est, ~] = aryule(current_trial, order);
%         [freq_response_est, freq_range] = freqz(sqrt(noise_variance_est), coeff_est, current_length, sampling_frequency);
%         PSD_estimate = abs(freq_response_est) .^ 2;
%         plot(freq_range, pow2db(PSD_estimate), 'LineWidth', 2, 'DisplayName', sprintf('Model order: %i', order));
%     end



    title(sprintf('Periodograms of RRI trial %i', trial_index), 'FontSize', title_font);
    xlabel('Normalised Frequency (\pi radians / sample)');
    ylabel('PSD Amplitude');
    xlim([0 1]);
    set(gca,'FontSize', axes_font)
    legend('FontSize', legend_font);
    grid on; grid minor;
end

