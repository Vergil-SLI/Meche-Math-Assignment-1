function f_val = fzero_test_func(x)
    global input_list;

    % append the current input to input_list
    % formatted so this works even if x is a column vector instead of a scalar
    input_list(:,end+1) = x;
    f_val = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2 + 6) - .7 - exp(x/6);
end