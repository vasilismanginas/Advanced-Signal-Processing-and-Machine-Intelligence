function [output_estimates, errors, weights] = Leaky_LMS(input_signal, desired_signal, weights_length, step_size, leakage)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    weights = zeros(signal_length, weights_length);

    for i = weights_length+1 : length(input_signal)
        input_signal_slice = input_signal(i - weights_length : i - 1);
        output_estimates(i) = weights(i, :) * transpose(input_signal_slice);
        errors(i) = desired_signal(i) - output_estimates(i);
        weights(i + 1, :) = (1 - leakage * step_size) * weights(i, :) + step_size * errors(i) * input_signal_slice;
    end
end