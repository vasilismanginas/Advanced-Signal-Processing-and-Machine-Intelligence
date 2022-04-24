clear; clc;
load('../../font_sizes.mat');

time_series_data = load('../../data/part_4_time_series/time-series.mat');
time_series = transpose(time_series_data.y);

time_series_mean = mean(time_series);
removed_mean_signal = time_series - time_series_mean;

LMS_step = 1 * 10^(-5);
LMS_order = 4;
a = 51;
pretrain_samples = 20;
pretrain_epochs = 100;

for i = 1: pretrain_epochs
    if i == 1
        [output_estimates, errors, weights] = perceptron(time_series, time_series, LMS_order, LMS_step, 51, 0);
    else
        starting_weights = weights(end, :);
        [output_estimates, errors, weights] = perceptron(time_series, time_series, LMS_order, LMS_step, 51, starting_weights);
    end
end

pretrained_weights = weights(end, :);
[pretrained_output_estimates, pretrained_errors, weights] = perceptron(time_series, time_series, LMS_order, LMS_step, 51, pretrained_weights);
MSE_pretrained = pow2db(mean(pretrained_errors .^ 2));
output_variance = var(pretrained_output_estimates);
error_variance = var(pretrained_errors);
prediction_gain_pretrained = 10 * log10(output_variance / error_variance);

figure;
hold on;
plot(time_series, 'LineWidth', 2, 'DisplayName', 'Original time series');
plot(pretrained_output_estimates, 'LineWidth', 2, 'DisplayName', 'Perceptron tanh output');
title('Dynamical perceptron output with optimised scaling and pretrained weights', 'FontSize', title_font);
xlabel('Sample');
ylabel('Amplitude');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;
