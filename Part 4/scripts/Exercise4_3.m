clear; clc;
load('../../font_sizes.mat');

time_series_data = load('../../data/part_4_time_series/time-series.mat');
time_series = transpose(time_series_data.y);

time_series_mean = mean(time_series);
removed_mean_signal = time_series - time_series_mean;

LMS_step = 1 * 10^(-5);
LMS_order = 4;
% a = 1:100;
a = [10, 40, 70];
% a = [81];
num_a = length(a);

MSE = zeros(1, num_a);
prediction_gain = zeros(1, num_a);

figure;
for i = 1: num_a
    [output_estimates, errors, weights] = perceptron(removed_mean_signal, removed_mean_signal, LMS_order, LMS_step, a(i), 0);
    MSE(i) = pow2db(mean(errors .^ 2));
    output_variance = var(output_estimates);
    error_variance = var(errors);
    prediction_gain(i) = 10 * log10(output_variance / error_variance);
    
    subplot(num_a, 1, i);
    hold on;
    plot(removed_mean_signal, 'LineWidth', 2, 'DisplayName', 'Original time series');
    plot(output_estimates, 'LineWidth', 2, 'DisplayName', 'Perceptron tanh output');
    title(sprintf('Dynamical perceptron with tanh activation and scaling a = %i', a(i)), 'FontSize', title_font);
    xlabel('Sample');
    ylabel('Amplitude');
    ylim([-60 60])
    set(gca,'FontSize', axes_font);
    legend('FontSize', legend_font);
    grid on; grid minor;
end

% subplot(1, 2, 1);
% plot(a, MSE, 'LineWidth', 3, 'DisplayName', 'Perceptron tanh output');
% title('MSE as a function of scaling factor', 'FontSize', title_font);
% xlabel('Scaling Factor');
% ylabel('MSE (dB)');
% set(gca,'FontSize', axes_font);
% grid on; grid minor;
% 
% subplot(1, 2, 2);
% plot(a, prediction_gain, 'LineWidth', 3, 'DisplayName', 'Perceptron tanh output');
% title('Prediction gain as a function of scaling factor', 'FontSize', title_font);
% xlabel('Scaling Factor');
% ylabel('Prediction Gain (dB)');
% set(gca,'FontSize', axes_font);
% grid on; grid minor;
% 
% [min_MSE, min_MSE_index] = min(MSE);
% [max_prediction_gain, max_prediction_gain_index] = max(prediction_gain);