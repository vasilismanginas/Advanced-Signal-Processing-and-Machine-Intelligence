function [circularity_coeff, circularity_quot] = circularity(signal)
    covariance = mean(abs(signal) .^ 2);
    pseudo_covariance = mean(signal .^ 2);
    circularity_coeff = abs(pseudo_covariance) / covariance;
    circularity_quot = pseudo_covariance / covariance;
end