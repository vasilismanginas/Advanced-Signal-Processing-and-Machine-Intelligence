function [output_estimates, errors, weights] = LMS_ALE(input_signal, desired_signal, weights_length, step_size, delay)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    weights = zeros(signal_length, weights_length);

    for i = weights_length + delay + 1 : length(input_signal)
        input_signal_slice = input_signal(i - weights_length - delay : i - delay - 1);
        output_estimates(i) = weights(i, :) * transpose(input_signal_slice);
        errors(i) = desired_signal(i) - output_estimates(i);
        weights(i + 1, :) = weights(i, :) + step_size * errors(i) * input_signal_slice;
    end
end