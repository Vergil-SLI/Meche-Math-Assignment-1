function [f_val, dfdx] = test_func(x)
    f_val = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2 + 6) - .7 - exp(x/6);
    dfdx = (3*x.^2)/100 - x/4 + 2 + 3*cos(x/2 + 6) - exp(x/6)/6;
end