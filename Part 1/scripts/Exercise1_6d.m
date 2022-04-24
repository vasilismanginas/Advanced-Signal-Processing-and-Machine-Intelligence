clear; clc;
load('../../font_sizes.mat');
pca_pcr = load('../../data/PCAPCR/PCAPCR.mat');
addpath("../../data/PCAPCR");

X = pca_pcr.X;
X_noise = pca_pcr.Xnoise;
Y = pca_pcr.Y;
rank_X = rank(X);
[U_X_noise, S_X_noise, V_X_noise] = svd(X_noise);

B_OLS = inv(transpose(X_noise) * X_noise) * transpose(X_noise) * Y;
B_PCR = V_X_noise(:, 1: rank_X) * inv(S_X_noise(1: rank_X, 1: rank_X)) * transpose(U_X_noise(:, 1: rank_X)) * Y;

num_of_trials = 1000;
OLS_SE = cell(num_of_trials, 1);
PCR_SE = cell(num_of_trials, 1);

for trial_index = 1: num_of_trials
    [Y_test, Y_OLS_test] = regval(B_OLS);
    OLS_SE{trial_index} = vecnorm(Y_test - Y_OLS_test) .^ 2;
    [Y_test, Y_PCR_test] = regval(B_PCR);
    PCR_SE{trial_index} = vecnorm(Y_test - Y_PCR_test) .^ 2;
end

OLS_MSE_array = mean(cell2mat(OLS_SE));
PCR_MSE_array = mean(cell2mat(PCR_SE));

OLS_MSE = sum(OLS_MSE_array);
PCR_MSE = sum(PCR_MSE_array);


figure;
hold on;
stem(OLS_MSE_array, '-x', 'DisplayName', 'OLS', 'LineWidth', 3, 'MarkerSize', 14);
stem(PCR_MSE_array, '--o', 'DisplayName', 'PCR', 'LineWidth', 3, 'MarkerSize', 10);
title('MSE of OLS vs PCR', 'FontSize', title_font);
xlabel('Column');
ylabel('MSE');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;