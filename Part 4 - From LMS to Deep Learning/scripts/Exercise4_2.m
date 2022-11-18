clear; clc;
load('../../font_sizes.mat');

time_series_data = load('../../data/part_4_time_series/time-series.mat');
time_series = transpose(time_series_data.y);

time_series_mean = mean(time_series);
removed_mean_signal = time_series - time_series_mean;

LMS_step = 1 * 10^(-5);
LMS_order = 4;
[output_estimates, errors, weights] = perceptron(removed_mean_signal, removed_mean_signal, LMS_order, LMS_step, 1, 0);
MSE = pow2db(mean(errors .^ 2));
output_variance = var(output_estimates);
error_variance = var(errors);
prediction_gain = 10 * log10(output_variance / error_variance);

figure;
hold on;
plot(removed_mean_signal, 'LineWidth', 2, 'DisplayName', 'Original time series');
plot(output_estimates, 'LineWidth', 2, 'DisplayName', 'Perceptron tanh output');
title('One-step ahed prediction of time series using dynamical perceptron with tanh activation', 'FontSize', title_font);
xlabel('Sample');
ylabel('Amplitude');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;