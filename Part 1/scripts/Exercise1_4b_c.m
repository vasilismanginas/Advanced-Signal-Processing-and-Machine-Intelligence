clear; clc;
load('../../font_sizes.mat');

sampling_frequency = 1;
signal_lengths = [1000, 10000];

figure;
for signal_length_index = 1: length(signal_lengths)
    discarded_samples = 500;
    current_signal_length = signal_lengths(signal_length_index);
    resulting_samples = current_signal_length - discarded_samples;
    
    ar_coeffs = [2.76, -3.81, 2.65, -0.92];
    variance = 1;
    model_orders = [2:14];
    
    
    ar_model = arima('Constant', 0, 'AR', ar_coeffs, 'Variance', variance);
    x = simulate(ar_model, current_signal_length);
    x = x(discarded_samples: current_signal_length);
    
    [freq_response, freq_range] = freqz(variance, [1 -ar_coeffs], resulting_samples, sampling_frequency);
    PSD_true = pow2db(abs(freq_response) .^ 2);
    
    PSD_est = cell(length(model_orders), 1);
    MSEs = zeros(length(model_orders), 1);
    
    for order = model_orders
        [coeff_est, noise_variance_est, ~] = aryule(x, order);
        freq_response_est = freqz(sqrt(noise_variance_est), coeff_est, resulting_samples);
        PSD_est{order-1} = pow2db(abs(freq_response_est) .^ 2);
        MSEs(order-1) = sum((PSD_est{order-1} - PSD_true) .^ 2) / resulting_samples;
    end
    
    [min_MSE_order, min_MSE_order_index] = min(MSEs);

    subplot(2, 2, signal_length_index);
%     for i = 1: length({PSD_est{:, 1}})
    for i = min_MSE_order_index-1 : min_MSE_order_index+2
        plot(freq_range, PSD_est{i, :}, 'LineWidth', 2, 'DisplayName', sprintf('Model order: %i', i));
        hold on;
    end
    plot(freq_range, PSD_true, 'LineWidth', 2, 'Color', 'k', 'DisplayName', 'True PSD');
    title(sprintf('PSD Estimate for Different Model Orders (%i samples)', current_signal_length), 'FontSize', title_font);
    xlabel('Normalised Frequency (\pi radians / sample)');
    ylabel('PSD Amplitude');
    set(gca,'FontSize', axes_font)
    legend('FontSize', legend_font);
    grid on; grid minor;
    
    subplot(2, 2, signal_length_index+2);
    plot(MSEs, 'LineWidth', 2);
    title(sprintf('MSE for Different Model Orders (%i samples)', current_signal_length), 'FontSize', title_font);
    xlabel('Model Order');
    ylabel('MSE');
    set(gca,'FontSize', axes_font)
    grid on; grid minor;
end