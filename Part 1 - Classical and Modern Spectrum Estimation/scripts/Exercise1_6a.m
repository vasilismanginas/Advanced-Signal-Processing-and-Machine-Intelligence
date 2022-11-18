clear; clc;
load('../../font_sizes.mat');
pca_pcr = load('../../data/PCAPCR/PCAPCR.mat');

X = pca_pcr.X;
X_noise = pca_pcr.Xnoise;

svd_X = svd(X);
svd_X_noise = svd(X_noise);
squared_error = (svd_X - svd_X_noise) .^ 2;

figure;

subplot(1, 2, 1);
hold on;
stem(svd_X, '-x', 'DisplayName', 'Clean Input', 'LineWidth', 3, 'MarkerSize', 14);
stem(svd_X_noise, '--o', 'DisplayName', 'Noisy Input', 'LineWidth', 3, 'MarkerSize', 10);
title('Singular Values of Clean and Noisy Inputs', 'FontSize', title_font);
xlabel('Singular Value Number');
ylabel('Singular Value');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

subplot(1, 2, 2);
stem(squared_error, '-x', 'LineWidth', 3, 'MarkerSize', 10);
title('Squared Error between Clean and Noisy Singular Values', 'FontSize', title_font);
xlabel('Singular Value Number');
ylabel('Squared Error');
set(gca,'FontSize', axes_font);
grid on; grid minor;
