function [fvals, dfdx] = test_func2(x)
    fvals = (x-37.879).^2;
    dfdx = 2* (x-37.879);
end