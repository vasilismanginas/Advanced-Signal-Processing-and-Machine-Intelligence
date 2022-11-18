function [output_estimates, errors, weights] = GNGD(input_signal, desired_signal, weights_length, step_size, rho)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    weights = zeros(signal_length, weights_length);
    epsilon = ones(1, signal_length);
    previous_slice = zeros(1, weights_length);

    for i = weights_length+2 : length(input_signal)
        input_signal_slice = input_signal(i - weights_length : i - 1);
        output_estimates(i) = weights(i, :) * transpose(input_signal_slice);
        errors(i) = desired_signal(i) - output_estimates(i);
        normalised_step_size = 1 / (epsilon(i) + input_signal_slice * transpose(input_signal_slice));
        weights(i + 1, :) = weights(i, :) + normalised_step_size * errors(i) * input_signal_slice;

        epsilon_update_num = errors(i) * errors(i - 1) * input_signal_slice * transpose(previous_slice);
        epsilon_update_denom = (epsilon(i - 1) + previous_slice * transpose(previous_slice));
        epsilon(i + 1) = epsilon(i) - rho * step_size * epsilon_update_num / epsilon_update_denom;

        previous_slice = input_signal_slice;
    end
end