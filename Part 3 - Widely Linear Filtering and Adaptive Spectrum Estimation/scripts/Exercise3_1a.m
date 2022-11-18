clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
num_trials = 100;

b1 = 1.5 + 1i;
b2 = 2.5 - 0.5i;
circular_wgn = 1 / sqrt(2) * (randn(num_trials, signal_length) + 1i * randn(num_trials, signal_length));
term1 = b1 * [zeros(num_trials, 1), circular_wgn(:, 1 : end-1)];
term2 = b2 * [zeros(num_trials, 1), conj(circular_wgn(:, 1 : end-1))];
WLMA = circular_wgn + term1 + term2;

[wgn_coeff, wgn_quot] = circularity(circular_wgn);
[WLMA_coeff, WLMA_quot] = circularity(WLMA);

figure;
subplot(2, 2, 1)
scatter(real(circular_wgn(:)), imag(circular_wgn(:)), 1);
title(sprintf('WGN, circularity coefficient = %.2f', wgn_coeff), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
grid on; grid minor;

subplot(2, 2, 2)
scatter(real(WLMA(:)), imag(WLMA(:)), 1);
title(sprintf('WLMA, circularity coefficient = %.2f', WLMA_coeff), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
grid on; grid minor;


order = 2;
step_size = 0.01;
all_trial_errors_CLMS = zeros(num_trials, signal_length);
all_trial_errors_ACLMS = zeros(num_trials, signal_length);

for trial = 1: num_trials
    noise_signal = circular_wgn(trial, :);
    input_signal = WLMA(trial, :);
    [~, errors_CLMS, ~] = CLMS(noise_signal, input_signal, order, step_size);
    [~, errors_ACLMS, ~, ~] = ACLMS(noise_signal, input_signal, order, step_size);
    all_trial_errors_CLMS(trial, :) = abs(errors_CLMS) .^ 2;
    all_trial_errors_ACLMS(trial, :) = abs(errors_ACLMS) .^ 2;
end


MSE_CLMS = pow2db(mean(all_trial_errors_CLMS, 1));
MSE_ACLMS = pow2db(mean(all_trial_errors_ACLMS, 1));

subplot(2, 2, [3, 4]);
hold on;
plot(MSE_CLMS, 'LineWidth', 2, 'DisplayName', 'CLMS output');
plot(MSE_ACLMS, 'LineWidth', 2, 'DisplayName', 'ACLMS output');
title('Learning Curves of CLMS and ACLMS', 'FontSize', title_font);
xlabel('Sample');
ylabel('MSE (dB)');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;


