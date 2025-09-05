function Newtons()
    x_range = linspace(-10, 35, 100);

    [y_vals, ~] = test_func(x_range);

    x_init = -2;
    max_iter = 200;
    dx_tol = 1e-7;
    y_tol = 1e-7;

    [x_root1, ~] = newton(@test_func, x_init, max_iter, dx_tol, y_tol);
    [f_root1, ~] = test_func(x_root1);

    hold on;
    plot(x_range, y_vals, "k");
    plot(x_range, x_range * 0, "r--");
    plot(x_root1, f_root1, "bo")
end

function [x_root, exit] = newton(input_func, x_init, max_iter, dx_tol, y_tol)
    
    x_prev = x_init - 2*dx_tol;
    x_curr = x_init;
    [f_val, dfdx_val] = input_func(x_curr);

    count = 0;

    while abs(dfdx_val) > dx_tol && abs(x_curr - x_prev) > dx_tol && count<max_iter && abs(f_val)>y_tol
        x_prev = x_curr;
        x_curr = x_curr - f_val/dfdx_val;

        [f_val, dfdx_val] = input_func(x_curr);
        count = count + 1;
    end
    x_root = x_curr;

    exit = 0;

    if abs(x_curr - x_prev) > dx_tol && abs(f_val) > y_tol
        exit = 1;

    end

end

function [f_val, dfdx] = test_func(x)
    f_val = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2 + 6) - .7 - exp(x/6);
    dfdx = (3*x.^2)/100 - x/4 + 2 + 3*cos(x/2 + 6) - exp(x/6)/6;
end