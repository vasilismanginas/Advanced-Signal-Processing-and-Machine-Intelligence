function [Vzero, Valpha, Vbeta] = clarke(Va, Vb, Vc)
    clarke_matrix = sqrt(2/3) * [sqrt(1/2) sqrt(1/2) sqrt(1/2); 1 -1/2 -1/2; 0 sqrt(3/4) -sqrt(3/4)];
    original_voltages = [Va; Vb; Vc];
    alpha_beta_voltages = clarke_matrix * original_voltages;
    Vzero = alpha_beta_voltages(1, :);
    Valpha = alpha_beta_voltages(2, :);
    Vbeta = alpha_beta_voltages(3, :);
end