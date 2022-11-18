clear; clc;
load('../../font_sizes.mat');

signal_length = 5000;
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


unbalanced_amplitudes = [0.6, 0.7, 0.8];
unbalanced_delta_b = 0.5 * pi;
unbalanced_delta_c = 0.45 * pi;

Va_unbalanced = unbalanced_amplitudes(1) * cos(2 * pi * f0 * t + balanced_phases(1));
Vb_unbalanced = unbalanced_amplitudes(2) * cos(2 * pi * f0 * t + balanced_phases(2) + unbalanced_delta_b);
Vc_unbalanced = unbalanced_amplitudes(3) * cos(2 * pi * f0 * t + balanced_phases(3) + unbalanced_delta_c);
[Vzero_unbalanced, Valpha_unbalanced, Vbeta_unbalanced] = clarke(Va_unbalanced, Vb_unbalanced, Vc_unbalanced);
unbalanced_clarke_voltage = Valpha_unbalanced + 1i * Vbeta_unbalanced;


model_order = 1;
step_size = 0.05;
[~, balanced_CLMS_error, h_balanced_CLMS] = CLMS(balanced_clarke_voltage, balanced_clarke_voltage, model_order, 0.05);
[~, balanced_ACLMS_error, h_balanced_ACLMS, g_balanced_ACLMS] = ACLMS(balanced_clarke_voltage, balanced_clarke_voltage, model_order, 0.005);
[~, unbalanced_CLMS_error, h_unbalanced_CLMS] = CLMS(unbalanced_clarke_voltage, unbalanced_clarke_voltage, model_order, 0.005);
[~, unbalanced_ACLMS_error, h_unbalanced_ACLMS, g_unbalanced_ACLMS] = ACLMS(unbalanced_clarke_voltage, unbalanced_clarke_voltage, model_order, 0.5);

frequency_balanced_CLMS = -sampling_frequency/(2*pi) * atan(imag(h_balanced_CLMS) ./ real(h_balanced_CLMS));
frequency_balanced_ACLMS = -sampling_frequency/(2*pi) * atan(imag(h_balanced_ACLMS) ./ real(h_balanced_ACLMS));

frequency_unbalanced_CLMS = -sampling_frequency/(2*pi) * atan(imag(h_unbalanced_CLMS) ./ real(h_unbalanced_CLMS));
frequency_unbalanced_ACLMS = abs(sampling_frequency/(2*pi) * atan(sqrt(imag(h_unbalanced_ACLMS) .^ 2 - abs(g_unbalanced_ACLMS) .^ 2) ./ real(h_unbalanced_ACLMS)));

figure;

subplot(2, 2, 1);
hold on;
plot(frequency_balanced_CLMS, 'LineWidth', 3, 'DisplayName', 'CLMS');
plot(frequency_balanced_ACLMS, 'LineWidth', 3, 'DisplayName', 'ACLMS');
title('Frequency estimation in balanced system', 'FontSize', title_font);
xlabel('Sample');
ylabel('Frequency (Hz)');
xlim([0 signal_length])
ylim([0 200])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

subplot(2, 2, 2);
hold on;
plot(pow2db(abs(balanced_CLMS_error)), 'LineWidth', 3, 'DisplayName', 'CLMS');
plot(pow2db(abs(balanced_ACLMS_error)), 'LineWidth', 3, 'DisplayName', 'ACLMS');
title('Learning curves in balanced system', 'FontSize', title_font);
xlabel('Sample');
ylabel('Error (dB)');
xlim([0 signal_length])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;


subplot(2, 2, 3);
hold on;
plot(frequency_unbalanced_CLMS, 'LineWidth', 3, 'DisplayName', 'CLMS');
plot(frequency_unbalanced_ACLMS, 'LineWidth', 3, 'DisplayName', 'ACLMS');
title('Frequency estimation in unbalanced system', 'FontSize', title_font);
xlabel('Sample');
ylabel('Frequency (Hz)');
xlim([0 signal_length])
ylim([0 200])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;

subplot(2, 2, 4);
hold on;
plot(pow2db(abs(unbalanced_CLMS_error)), 'LineWidth', 3, 'DisplayName', 'CLMS');
plot(pow2db(abs(unbalanced_ACLMS_error)), 'LineWidth', 3, 'DisplayName', 'ACLMS');
title('Learning curves in unbalanced system', 'FontSize', title_font);
xlabel('Sample');
ylabel('Error (dB)');
xlim([0 signal_length])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;
% 
% 
% 
% subplot(2,2,1)
% plot(f_est_clms, 'LineWidth',2)
% hold on 
% plot(f_est_aclms,'--', 'LineWidth',2)
% hold on 
% plot(real_f,':k', 'LineWidth',2)
% grid minor
% legend('CLMS','ACLMS','System Frequency')
% xlabel('Sample')
% ylabel('Frequency (Hz)')
% title('Balanced Voltage System Frequency Estimation')
% subplot(2,2,2)
% plot(pow2db(abs(e_bal_clms)),'LineWidth',2)
% hold on
% plot(pow2db(abs(e_bal_aclms)),'LineWidth',2)
% grid minor
% legend('CLMS', 'ACLMS')
% xlabel('Sample')
% ylabel('Error (dB)')
% title('Balanced Voltage System Learning Curves')
% subplot(2,2,3)
% plot(f_est_clms_,'LineWidth',2)
% hold on 
% plot(f_est_aclms_,'--', 'LineWidth',2)
% hold on 
% plot(real_f,':k', 'LineWidth',2)
% grid minor
% legend('CLMS','ACLMS', 'System Frequency')
% xlabel('Sample')
% ylabel('Frequency (Hz)')
% title('Unbalanced Voltage System Frequency Estimation')
% subplot(2,2,4)
% plot(pow2db(abs(e_unbal_clms)),'LineWidth',2)
% hold on
% plot(pow2db(abs(e_unbal_aclms)),'LineWidth',2)
% grid minor
% legend('CLMS', 'ACLMS')
% xlabel('Sample')
% ylabel('Error (dB)')
% title('Unbalanced Voltage System Learning Curves')