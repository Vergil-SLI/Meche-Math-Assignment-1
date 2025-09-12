function [x_root, exit, guess_list] = newton(input_func, x_init, max_iter, dx_tol, y_tol)
    
    x_prev = x_init - 2*dx_tol;
    x_curr = x_init;
    [f_val, dfdx_val] = input_func(x_curr);

    count = 0;
    guess_list = x_curr;

    while abs(dfdx_val) > dx_tol && abs(x_curr - x_prev) > dx_tol && count<max_iter && abs(f_val)>y_tol
        x_prev = x_curr;
        x_curr = x_curr - f_val/dfdx_val;

        [f_val, dfdx_val] = input_func(x_curr);
        count = count + 1;
        guess_list = [guess_list, x_curr];
    end

    x_root = x_curr;

    exit = 1;

    if count < max_iter && abs(dfdx_val) > dx_tol && abs(x_curr - x_prev)
        exit = 0;
    end

end