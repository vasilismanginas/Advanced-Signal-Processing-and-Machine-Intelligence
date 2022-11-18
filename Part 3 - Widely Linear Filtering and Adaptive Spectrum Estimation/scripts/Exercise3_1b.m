clear; clc;
load('../../font_sizes.mat');

low_wind_data = load('../../data/wind-dataset/low-wind.mat');
medium_wind_data = load('../../data/wind-dataset/medium-wind.mat');
high_wind_data = load('../../data/wind-dataset/high-wind.mat');

low_wind_complex = low_wind_data.v_east + 1i * low_wind_data.v_north;
medium_wind_complex = medium_wind_data.v_east + 1i * medium_wind_data.v_north;
high_wind_complex = high_wind_data.v_east + 1i * high_wind_data.v_north;

[low_coeff, ~] = circularity(low_wind_complex);
[medium_coeff, ~] = circularity(medium_wind_complex);
[high_coeff, ~] = circularity(high_wind_complex);

figure;
subplot(3, 2, 1)
scatter(real(low_wind_complex(:)), imag(low_wind_complex(:)), 1);
title(sprintf('Low Wind: circularity coefficient = %.2f', low_coeff), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
grid on; grid minor;

subplot(3, 2, 3)
scatter(real(medium_wind_complex(:)), imag(medium_wind_complex(:)), 1);
title(sprintf('Medium Wind: circularity coefficient = %.2f', medium_coeff), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
grid on; grid minor;

subplot(3, 2, 5)
scatter(real(high_wind_complex(:)), imag(high_wind_complex(:)), 1);
title(sprintf('High Wind: circularity coefficient = %.2f', high_coeff), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
grid on; grid minor;



all_winds = [low_wind_complex, medium_wind_complex, high_wind_complex].';
figure_titles = ["Low Wind", "Medium Wind", "High Wind"];
model_orders = 1:20;
step_sizes = [0.2, 0.02, 0.002];

CLMS_MSEs = zeros(1, length(model_orders));
ACLMS_MSEs = zeros(1, length(model_orders));

for i = 1: length(all_winds(:, 1))
    input_signal = all_winds(i, :);
    for order = model_orders
        [~, errors_CLMS, ~] = CLMS(input_signal, input_signal, order, step_sizes(i));
        [~, errors_ACLMS, ~, ~] = ACLMS(input_signal, input_signal, order, step_sizes(i));
        CLMS_MSEs(order) = mean((abs(errors_CLMS)) .^ 2);
        ACLMS_MSEs(order) = mean((abs(errors_ACLMS)) .^ 2);
    end

    subplot(3, 2, 2*i);
    hold on;
    plot(CLMS_MSEs, 'LineWidth', 3, 'DisplayName', 'CLMS');
    plot(ACLMS_MSEs, 'LineWidth', 3, 'DisplayName', 'ACLMS');
    title(strcat(figure_titles(i), ': MSE vs model order'), 'FontSize', title_font);
    xlabel('Model Order');
    ylabel('MSE');
    set(gca,'FontSize', axes_font);
    legend('FontSize', legend_font);
    grid on; grid minor;
end