clear; clc;
load('../../font_sizes.mat');
load sunspot.dat

% divide data into the years and the sunspots and define useful parameters
years = transpose(sunspot(:, 1));
sunspots = transpose(sunspot(:, 2));
num_samples = length(sunspots);
sampling_frequency = 1;


% PSD of sunspot data
[sunspot_psd, ~] = periodogram(sunspots, hamming(num_samples), num_samples, sampling_frequency);


% remove the mean
sunspot_mean = mean(sunspots);
removed_mean = sunspots - sunspot_mean;
[sunspot_mean_psd, ~] = periodogram(removed_mean, hamming(num_samples), num_samples, sampling_frequency);


% remove the trend
removed_trend = detrend(sunspots);
[sunspot_detrend_psd, ~] = periodogram(removed_trend, hamming(num_samples), num_samples, sampling_frequency);


% remove the mean and detrend
removed_mean_detrend = detrend(removed_mean);
[sunspot_mean_detrend_psd, ~] = periodogram(removed_mean_detrend, hamming(num_samples), num_samples, sampling_frequency);


% logarithmic and removed mean
log_sunspots = log10(sunspots + eps);
log_mean = mean(log_sunspots);
log_removed_mean = log_sunspots - log_mean;
[log_sunspot_psd, frequency_range] = periodogram(log_removed_mean, hamming(num_samples), num_samples, sampling_frequency);


figure;
subplot(2, 2, 1);
hold on;
plot(years, sunspots, 'LineWidth', 3, 'DisplayName', 'Unprocessed');
plot(years, removed_mean_detrend, 'LineWidth', 3, 'DisplayName', 'Removed Mean and Trend');
title('Sunspot time series', 'FontSize', title_font)
xlabel('Year')
ylabel('Number of occurrences')
xlim([1700 1987])
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;

subplot(2, 2, 3);
hold on;
plot(frequency_range, pow2db(sunspot_psd), 'LineWidth', 3, 'DisplayName', 'Unprocessed');
plot(frequency_range, pow2db(sunspot_mean_detrend_psd), '--', 'LineWidth', 3, 'DisplayName', 'Removed Mean and Trend');
title('Periodogram of sunspot time series', 'FontSize', title_font)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude (dB)')
ylim([-20 60])
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;

subplot(2, 2, 2);
hold on;
plot(years, sunspots, 'LineWidth', 3, 'DisplayName', 'Unprocessed');
plot(years, log_sunspots, 'LineWidth', 3, 'DisplayName', 'Log Removed Mean');
title('Sunspot time series and logarithm', 'FontSize', title_font)
xlabel('Year')
ylabel('Number of occurrences')
xlim([1700 1987])
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;

subplot(2, 2, 4);
plot(frequency_range, pow2db(log_sunspot_psd), 'LineWidth', 3, 'DisplayName', 'Log Removed Mean');
title('Periodogram of logarithmic sunspot time series', 'FontSize', title_font)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude (dB)')
% ylim([-20 60])
set(gca,'FontSize', axes_font)
legend('FontSize', legend_font);
grid on; grid minor;



% figure;
% subplot(2, 4, 1);
% plot(years, sunspots, 'LineWidth', 1);
% title('Sunspots over the years', 'FontSize', 13)
% xlabel('Year')
% ylabel('Number of occurrences')
% grid on; grid minor;
% subplot(2, 4, 5);
% plot(frequency_range, sunspot_psd, 'LineWidth', 1);
% title('PSD of sunspots', 'FontSize', 13)
% xlabel('Normalised Frequency')
% ylabel('PSD Amplitude')
% grid on; grid minor;
% 
% 
% subplot(2, 4, 2);
% plot(years, removed_mean, 'LineWidth', 1);
% title('Sunspots over the years (removed mean)', 'FontSize', 13)
% xlabel('Year')
% ylabel('Number of occurrences')
% grid on; grid minor;
% subplot(2, 4, 6);
% plot(frequency_range, sunspot_mean_psd, 'LineWidth', 1);
% title('PSD of sunspots', 'FontSize', 13)
% xlabel('Normalised Frequency')
% ylabel('PSD Amplitude')
% grid on; grid minor;
% 
% 
% subplot(2, 4, 3);
% plot(years, removed_trend, 'LineWidth', 1);
% title('Sunspots over the years (detrend)', 'FontSize', 13)
% xlabel('Year')
% ylabel('Number of occurrences')
% grid on; grid minor;
% subplot(2, 4, 7);
% plot(frequency_range, sunspot_detrend_psd, 'LineWidth', 1);
% title('PSD of sunspots', 'FontSize', 13)
% xlabel('Normalised Frequency')
% ylabel('PSD Amplitude')
% grid on; grid minor;
% 
% 
% subplot(2, 4, 4);
% plot(years, log_sunspots, 'LineWidth', 1);
% title('Sunspots over the years (log & removed mean)', 'FontSize', 13)
% xlabel('Year')
% ylabel('Number of occurrences')
% grid on; grid minor;
% subplot(2, 4, 8);
% plot(frequency_range, log_sunspot_psd, 'LineWidth', 1);
% title('PSD of sunspots', 'FontSize', 13)
% xlabel('Normalised Frequency')
% ylabel('PSD Amplitude')
% grid on; grid minor;