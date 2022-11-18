clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;

sampling_frequency = 1;
sine_frequency = 0.005;
t = (0: signal_length-1) / sampling_frequency;
clean_signal = sin(2 * pi * sine_frequency * t);

model_orders = [5, 10, 15, 20];
step_size = 0.01;
delays = 3 : 25;
num_delays = length(delays);
num_trials = 1000;
MSPE = zeros(num_delays, num_trials);

figure;
hold on;
for order = model_orders
    for i = 1: num_delays
        for j = 1: num_trials
            white_noise = randn(1, signal_length);
            numerator = [1 0 0.5];
            denominator = 1;
            noise_signal = filter(numerator, denominator , white_noise);
            noisy_sine = clean_signal + noise_signal;
    
            [output_estimates, errors, weights] = LMS_ALE(noisy_sine, noisy_sine, order, step_size, delays(i));
            MSPE(i, j) = mean((clean_signal - output_estimates) .^ 2);
        end
    end 
    MSPE_averages = mean(MSPE, 2);
    plot(delays, MSPE_averages, 'LineWidth', 3, 'DisplayName', sprintf('Model order = %i', order));
    title('MSPE for different model orders and delays', 'FontSize', title_font);
    xlabel('Delay');
    ylabel('MSPE');
    xlim([3, 25])
    ylim([0.3 0.65])
    set(gca,'FontSize', axes_font);
    legend('FontSize', legend_font);
    grid on; grid minor;
end