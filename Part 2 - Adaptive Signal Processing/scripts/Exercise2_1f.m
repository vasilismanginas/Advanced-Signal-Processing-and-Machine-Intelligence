clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
ar_coeffs = [0.1, 0.8];
weights_size = length(ar_coeffs);
variance = 0.25;

ar_model = arima('Constant', 0, 'AR', ar_coeffs, 'Variance', variance);
step_sizes = [0.01, 0.05];
num_steps = length(step_sizes);
leakages = [0.1, 0.5, 0.9];
num_leakages = length(leakages);
num_trials = 100;

figure;
for step_size = step_sizes
    for leakage_index = 1: num_leakages
        for trial = 1: num_trials
            input_signal = transpose(simulate(ar_model, signal_length));
            [output_estimates, errors, weights] = Leaky_LMS(input_signal, input_signal, weights_size, step_size, leakages(leakage_index));
            something = weights;
            all_trial_weights{trial} = weights;
        end
    
        averaged_weights = mean(cat(3, all_trial_weights{:}), 3);
        subplot(1, 3, leakage_index);
        hold on;
        plot(averaged_weights(:, 2), 'LineWidth', 3, 'DisplayName', sprintf('a1, step size = %.2f', step_size));
        plot(averaged_weights(:, 1), 'LineWidth', 3, 'DisplayName', sprintf('a2, step size = %.2f', step_size));
        title(sprintf('Leakage coefficient = %.1f', leakages(leakage_index)), 'FontSize', title_font);
        xlabel('Sample');
        ylabel('Averaged Weights');
        xlim([0 1000])
        ylim([0 1])
        set(gca,'FontSize', axes_font);
        legend('FontSize', legend_font);
        grid on; grid minor;
    end
end