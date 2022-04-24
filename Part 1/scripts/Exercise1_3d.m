clear; clc;
load('../../font_sizes.mat');

sampling_frequency = 1;
overlap_samples = 0;
signal_lengths = [30, 50, 100];
signal_colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];

figure;
for i = 1: length(signal_lengths)
    subplot(3, 2, [1 3 5])
    current_signal_length = signal_lengths(i);
    n = (0: current_signal_length-1);
%     f = n ./ (2*current_signal_length) .* sampling_frequency;
    noise = 0.2/sqrt(2)*(randn(size(n))+1j*randn(size(n)));
    x = exp(1j*2*pi*0.3*n)+exp(1j*2*pi*0.32*n)+ noise;
    [psd, f] = periodogram(x, rectwin(current_signal_length), current_signal_length, sampling_frequency);
    psd_dB = pow2db(psd);
    plot(f, psd, 'LineWidth', 3, 'DisplayName', sprintf('Number of samples: %i', current_signal_length));
    hold on;
end

title('Periodogram of Noisy Complex Exponentials', 'FontSize', title_font);
xlabel('Frequency (Hz)');
ylabel('PSD Amplitude');
xlim([0.1 0.6])
set(gca,'FontSize', axes_font);
legend('FontSize', legend_font);
grid on; grid minor;


for i = 1: length(signal_lengths)
    subplot(3, 2, 2*i)
    current_signal_length = signal_lengths(i);
    n = (0: current_signal_length-1);
    f = n ./ (2*current_signal_length) .* sampling_frequency;
    noise = 0.2/sqrt(2)*(randn(size(n))+1j*randn(size(n)));
    x = exp(1j*2*pi*0.3*n)+exp(1j*2*pi*0.32*n)+ noise;
    plot(n, x, 'LineWidth', 3, 'Color', signal_colors(i,:));
    title(sprintf('Noisy Complex Exponential (%i samples)', current_signal_length), 'FontSize', title_font);
    xlabel('Sample');
    ylabel('Signal Amplitude');
    set(gca,'FontSize', axes_font);
    grid on; grid minor;
end
