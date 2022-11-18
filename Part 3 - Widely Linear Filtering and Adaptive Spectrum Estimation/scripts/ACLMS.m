function [output_estimates, errors, h, g] = ACLMS(input_signal, desired_signal, model_order, step_size)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    h = zeros(signal_length, model_order);
    g = zeros(signal_length, model_order);

    for i = model_order + 1 : length(input_signal)
        input_signal_slice = input_signal(i - model_order : i - 1);
        output_estimates(i) = conj(h(i, :)) * transpose(input_signal_slice) + conj(g(i, :)) * transpose(conj(input_signal_slice));
        errors(i) = desired_signal(i) - output_estimates(i);
        h(i + 1, :) = h(i, :) + step_size * conj(errors(i)) * input_signal_slice;
        g(i + 1, :) = g(i, :) + step_size * conj(errors(i)) * conj(input_signal_slice);
    end
end