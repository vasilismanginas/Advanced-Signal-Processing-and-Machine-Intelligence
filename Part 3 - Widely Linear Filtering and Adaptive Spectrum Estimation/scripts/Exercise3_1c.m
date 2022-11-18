clear; clc;
load('../../font_sizes.mat');

signal_length = 1000;
sampling_frequency = 10000;
t = (0: signal_length - 1) / sampling_frequency;
f0 = 50;
balanced_amplitudes = [1, 1, 1];
balanced_phases = [0, - 2/3 * pi, 2/3 * pi];
balanced_delta_b = 0;
balanced_delta_c = 0;

Va_balanced = balanced_amplitudes(1) * cos(2 * pi * f0 * t + balanced_phases(1));
Vb_balanced = balanced_amplitudes(2) * cos(2 * pi * f0 * t + balanced_phases(2) + balanced_delta_b);
Vc_balanced = balanced_amplitudes(3) * cos(2 * pi * f0 * t + balanced_phases(3) + balanced_delta_c);

[Vzero_balanced, Valpha_balanced, Vbeta_balanced] = clarke(Va_balanced, Vb_balanced, Vc_balanced);
balanced_clarke_voltage = Valpha_balanced + 1i * Vbeta_balanced;
[balanced_circularity_coeff, ~] = circularity(balanced_clarke_voltage);


unbalanced_amplitudes = [0.2, 0.5, 0.8];
unbalanced_delta_b = 0.1 * pi;
unbalanced_delta_c = - 0.1 * pi;

Va_unbalanced = unbalanced_amplitudes(1) * cos(2 * pi * f0 * t + balanced_phases(1));
Vb_unbalanced = unbalanced_amplitudes(2) * cos(2 * pi * f0 * t + balanced_phases(2) + unbalanced_delta_b);
Vc_unbalanced = unbalanced_amplitudes(3) * cos(2 * pi * f0 * t + balanced_phases(3) + unbalanced_delta_c);

[Vzero_unbalanced, Valpha_unbalanced, Vbeta_unbalanced] = clarke(Va_unbalanced, Vb_unbalanced, Vc_unbalanced);
unbalanced_clarke_voltage = Valpha_unbalanced + 1i * Vbeta_unbalanced;
[unbalanced_circularity_coeff, ~] = circularity(unbalanced_clarke_voltage);

figure;
hold on;
scatter(real(balanced_clarke_voltage(:)), imag(balanced_clarke_voltage(:)), 'DisplayName', 'Balanced');
scatter(real(unbalanced_clarke_voltage(:)), imag(unbalanced_clarke_voltage(:)), 'DisplayName', 'Unbalanced');
title(sprintf('Balanced (circularity = %.2f) and unbalanced (circularity = %.2f) clarke voltages', [balanced_circularity_coeff, unbalanced_circularity_coeff]), 'FontSize', title_font);
xlabel('Real');
ylabel('Imaginary');
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;
