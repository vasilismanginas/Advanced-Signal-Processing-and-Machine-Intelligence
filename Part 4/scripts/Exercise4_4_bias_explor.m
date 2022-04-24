clear; clc;
load('../../font_sizes.mat');

time_series_data = load('../../data/part_4_time_series/time-series.mat');
time_series = transpose(time_series_data.y);

time_series_mean = mean(time_series);
removed_mean_signal = time_series - time_series_mean;

LMS_step = 1 * 10^(-5);
LMS_order = 4;
a = 1:1:100;
num_a = length(a);
biases = 0:0.001:0.15;
num_biases = length(biases);

MSE = zeros(num_a, num_biases);
prediction_gain = zeros(num_a, num_biases);

fig = figure;
fig.WindowState = 'maximized';
for i = 1: num_a
    for j = 1: num_biases
        [output_estimates, errors, weights] = perceptron_hard_bias(time_series, time_series, LMS_order, LMS_step, a(i), biases(j), 0);
        MSE(i, j) = pow2db(mean(errors .^ 2));
        output_variance = var(output_estimates);
        error_variance = var(errors);
        prediction_gain(i, j) = 10 * log10(output_variance / error_variance);
    end
end

colormap parula;
subplot(1, 2, 1);
surf(biases, a, MSE);
title('MSE as a function of scaling factor and bias', 'FontSize', title_font);
xlabel('Bias')
ylabel('Scaling Factor');
zlabel('MSE (dB)');
set(gca,'FontSize', axes_font);
grid on; grid minor;

subplot(1, 2, 2);
surf(biases, a, prediction_gain);
title('Prediction gain as a function of scaling factor and bias', 'FontSize', title_font);
xlabel('Bias')
ylabel('Scaling Factor');
zlabel('Prediction Gain (dB)');
set(gca,'FontSize', axes_font);
grid on; grid minor;

[min_MSE, min_MSE_index] = min(MSE(:));
[min_row, min_col] = ind2sub(size(MSE), min_MSE_index);
min_bias = biases(min_col);
min_a = a(min_row);

[max_prediction_gain, max_prediction_gain_index] = max(prediction_gain(:));
[max_row, max_col] = ind2sub(size(prediction_gain), max_prediction_gain_index);
max_bias = biases(max_col);
max_a = a(max_row);