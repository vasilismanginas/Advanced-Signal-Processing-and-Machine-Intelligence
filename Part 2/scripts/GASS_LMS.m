function [output_estimates, errors, weights, adaptive_step_sizes] = GASS_LMS(input_signal, desired_signal, weights_length, gass_type, initial_step_size, rho, alpha)
    signal_length = length(input_signal);
    output_estimates = zeros(1, signal_length);
    errors = zeros(1, signal_length);
    weights = zeros(signal_length, weights_length);
    psi = zeros(signal_length, weights_length);
    adaptive_step_sizes = zeros(1, signal_length);
    adaptive_step_sizes(weights_length + 1) = initial_step_size;
    previous_slice = zeros(1, weights_length);

    for i = weights_length+1 : length(input_signal)
        input_signal_slice = input_signal(i - weights_length : i - 1);
        output_estimates(i) = weights(i, :) * transpose(input_signal_slice);
        errors(i) = desired_signal(i) - output_estimates(i);
        weights(i + 1, :) = weights(i, :) + adaptive_step_sizes(i) * errors(i) * input_signal_slice;

        switch gass_type
            case 'benveniste'
                psi(i, :) = (eye(weights_length) - adaptive_step_sizes(i-1) * transpose(previous_slice) * previous_slice) * psi(i-1, :) + errors(i-1) * previous_slice;
            case 'fahrang'
                psi(i, :) = alpha * psi(i-1, :) + errors(i-1) * previous_slice;
            case 'matthews'
                psi(i, :) = errors(i-1) * previous_slice;
            otherwise
        end

        adaptive_step_sizes(i+1) = adaptive_step_sizes(i) + rho * errors(i) * input_signal_slice * transpose(psi(i-1, :));
        previous_slice = input_signal_slice;
    end
end