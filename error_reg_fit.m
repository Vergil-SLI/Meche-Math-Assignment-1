function [p, k] = error_reg_fit(x_reg, y_reg)
    y = log(y_reg)';
    x1 = log(x_reg)';
    x2 = ones(length(x1), 1);

    coeffs = regress(y, [x1, x2]);
    p = coeffs(1);
    k = exp(coeffs(2));

end