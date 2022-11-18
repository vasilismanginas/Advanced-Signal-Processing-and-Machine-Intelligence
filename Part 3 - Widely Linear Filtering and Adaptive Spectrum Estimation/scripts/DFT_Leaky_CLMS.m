function [output_estimates, errors, h] = DFT_Leaky_CLMS(input_signal, desired_signal, step_size, leakage)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    h = zeros(signal_length, signal_length);
    
    for i = 1 : length(input_signal)
        output_estimates(i) = conj(h(i, :)) * transpose(input_signal);
        errors(i) = desired_signal(i) - output_estimates(i);
        h(i + 1, :) = (1 - leakage * step_size) * h(i, :) + step_size * conj(errors(i)) * input_signal;
    end
end