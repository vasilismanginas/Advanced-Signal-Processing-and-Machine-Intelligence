clear; clc;
load('../../font_sizes.mat');
pca_pcr = load('../../data/PCAPCR/PCAPCR.mat');

X = pca_pcr.X;
X_noise = pca_pcr.Xnoise;
X_test = pca_pcr.Xtest;
Y = pca_pcr.Y;
Y_test = pca_pcr.Ytest;
rank_X = rank(X);
[U_X_noise, S_X_noise, V_X_noise] = svd(X_noise);


B_OLS = inv(transpose(X_noise) * X_noise) * transpose(X_noise) * Y;
B_PCR = V_X_noise(:, 1: rank_X) * inv(S_X_noise(1: rank_X, 1: rank_X)) * transpose(U_X_noise(:, 1: rank_X)) * Y;

Y_OLS = X_noise * B_OLS;
Y_PCR = X_noise * B_PCR;

estimation_error_OLS = vecnorm(Y - Y_OLS) .^ 2;
estimation_error_PCR = vecnorm(Y - Y_PCR) .^ 2;


Y_OLS_test = X_test * B_OLS;
Y_PCR_test = X_test * B_PCR;

estimation_error_OLS_test = vecnorm(Y_test - Y_OLS_test) .^ 2;
estimation_error_PCR_test = vecnorm(Y_test - Y_PCR_test) .^ 2;

figure;
subplot(1, 2, 1);
hold on;
stem(estimation_error_OLS, '-x', 'DisplayName', 'OLS', 'LineWidth', 3, 'MarkerSize', 14);
stem(estimation_error_PCR, '--o', 'DisplayName', 'PCR', 'LineWidth', 3, 'MarkerSize', 10);
title('OLS vs PCR (training)', 'FontSize', title_font);
xlabel('Column');
ylabel('Squared Error');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

subplot(1, 2, 2);
hold on;
stem(estimation_error_OLS_test, '-x', 'DisplayName', 'OLS', 'LineWidth', 3, 'MarkerSize', 14);
stem(estimation_error_PCR_test, '--o', 'DisplayName', 'PCR', 'LineWidth', 3, 'MarkerSize', 10);
title('OLS vs PCR (test)', 'FontSize', title_font);
xlabel('Column');
ylabel('Squared Error');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

total_error_OLS_train = sum(estimation_error_OLS);
total_error_PCR_train = sum(estimation_error_PCR);
total_error_OLS_test = sum(estimation_error_OLS_test);
total_error_PCR_test = sum(estimation_error_PCR_test);