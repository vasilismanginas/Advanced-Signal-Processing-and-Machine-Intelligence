clear; clc;
load sunspot.dat

% divide data into the years and the sunspots and define useful parameters
years = transpose(sunspot(:, 1));
sunspots = transpose(sunspot(:, 2));
num_samples = length(sunspots);
sampling_frequency = 1;


% PSD of sunspot data
[sunspot_psd, ~] = periodogram(sunspots);


% remove the mean
sunspot_mean = mean(sunspots);
removed_mean = sunspots - sunspot_mean;
[sunspot_mean_psd, ~] = periodogram(removed_mean);


% remove the trend
removed_trend = detrend(sunspots);
[sunspot_detrend_psd, ~] = periodogram(removed_trend);


% logarithmic and removed mean
log_sunspots = log10(sunspots + eps);
log_mean = mean(log_sunspots);
log_removed_mean = log_sunspots - log_mean;
[log_sunspot_psd, frequency_range] = periodogram(log_removed_mean);


figure;
subplot(2, 4, 1);
plot(years, sunspots, 'LineWidth', 1);
title('Sunspots over the years', 'FontSize', 13)
xlabel('Year')
ylabel('Number of occurrences')
grid on; grid minor;
subplot(2, 4, 5);
plot(frequency_range, sunspot_psd, 'LineWidth', 1);
title('PSD of sunspots', 'FontSize', 13)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude')
grid on; grid minor;


subplot(2, 4, 2);
plot(years, removed_mean, 'LineWidth', 1);
title('Sunspots over the years (removed mean)', 'FontSize', 13)
xlabel('Year')
ylabel('Number of occurrences')
grid on; grid minor;
subplot(2, 4, 6);
plot(frequency_range, sunspot_mean_psd, 'LineWidth', 1);
title('PSD of sunspots', 'FontSize', 13)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude')
grid on; grid minor;


subplot(2, 4, 3);
plot(years, removed_trend, 'LineWidth', 1);
title('Sunspots over the years (detrend)', 'FontSize', 13)
xlabel('Year')
ylabel('Number of occurrences')
grid on; grid minor;
subplot(2, 4, 7);
plot(frequency_range, sunspot_detrend_psd, 'LineWidth', 1);
title('PSD of sunspots', 'FontSize', 13)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude')
grid on; grid minor;


subplot(2, 4, 4);
plot(years, log_sunspots, 'LineWidth', 1);
title('Sunspots over the years (log & removed mean)', 'FontSize', 13)
xlabel('Year')
ylabel('Number of occurrences')
grid on; grid minor;
subplot(2, 4, 8);
plot(frequency_range, log_sunspot_psd, 'LineWidth', 1);
title('PSD of sunspots', 'FontSize', 13)
xlabel('Normalised Frequency')
ylabel('PSD Amplitude')
grid on; grid minor;