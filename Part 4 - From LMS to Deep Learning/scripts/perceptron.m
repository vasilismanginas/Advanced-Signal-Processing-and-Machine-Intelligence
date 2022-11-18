function [output_estimates, errors, weights] = perceptron(input_signal, desired_signal, model_order, step_size, a, initial_weights)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    weights = zeros(signal_length, model_order + 1);

    if initial_weights ~= 0
        weights(model_order + 1, :) = initial_weights;
    end

    for i = model_order + 1 : length(input_signal)
        input_signal_slice = [1, input_signal(i - model_order : i - 1)];
        output_estimates(i) = a * tanh(weights(i, :) * transpose(input_signal_slice));
        errors(i) = desired_signal(i) - output_estimates(i);
        weights(i + 1, :) = weights(i, :) + step_size * errors(i) * input_signal_slice;
    end
end