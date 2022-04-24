clear; clc;
load('../../font_sizes.mat');
pca_pcr = load('../../data/PCAPCR/PCAPCR.mat');

X = pca_pcr.X;
X_noise = pca_pcr.Xnoise;
difference_before = X - X_noise;

[U_X, S_X, V_X] = svd(X);
[U_X_noise, S_X_noise, V_X_noise] = svd(X_noise);
rank_X = rank(X);


X_denoised = U_X_noise(:, 1: rank_X) * S_X_noise(1: rank_X, 1: rank_X) * V_X_noise(:, 1: rank_X)';
squared_error_noise = vecnorm(X - X_noise) .^ 2;
squared_error_denoised = vecnorm(X - X_denoised) .^ 2;


figure;
hold on;
stem(squared_error_noise, '-x', 'DisplayName', 'Difference with Noisy Signal', 'LineWidth', 3, 'MarkerSize', 14);
stem(squared_error_denoised, '--o', 'DisplayName', 'Difference with Denoised Signal', 'LineWidth', 3, 'MarkerSize', 10);
title('Difference between Input and Noisy/Denoised Input', 'FontSize', title_font);
xlabel('Column');
ylabel('Squared Error');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;
