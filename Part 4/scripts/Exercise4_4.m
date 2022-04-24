clear; clc;
load('../../font_sizes.mat');

time_series_data = load('../../data/part_4_time_series/time-series.mat');
time_series = transpose(time_series_data.y);

time_series_mean = mean(time_series);
removed_mean_signal = time_series - time_series_mean;

LMS_step = 1 * 10^(-5);
LMS_order = 4;
[output_estimates, errors, weights] = perceptron(time_series, time_series, LMS_order, LMS_step, 52, 0);
MSE_optimal = pow2db(mean(errors .^ 2));
output_variance = var(output_estimates);
error_variance = var(errors);
prediction_gain_optimal = 10 * log10(output_variance / error_variance);

figure;
hold on;
plot(time_series, 'LineWidth', 2, 'DisplayName', 'Original time series');
plot(output_estimates, 'LineWidth', 2, 'DisplayName', 'Perceptron tanh output');
title('Dynamical perceptron output with optimised scaling and learnt bias', 'FontSize', title_font);
xlabel('Sample');
ylabel('Amplitude');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

% figure;
% plot(weights, 'LineWidth', 3);
% title('Weight progression of dynamical perceptron with optimised scaling', 'FontSize', title_font);
% xlabel('Sample');
% ylabel('Weights');
% xlim([0 length(time_series)])
% set(gca,'FontSize', axes_font);
% grid on; grid minor;