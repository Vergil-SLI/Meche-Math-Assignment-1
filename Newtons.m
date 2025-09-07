function Newtons()
    x_range = linspace(-10, 35, 100);

    [y_vals, ~] = test_func(x_range);

    x_init = -2;
    max_iter = 200;
    dx_tol = 1e-7;
    y_tol = 1e-7;

    [x_root1, ~] = newton(@test_func, x_init, max_iter, dx_tol, y_tol);
    [f_root1, ~] = test_func(x_root1);

    x1 = -5;
    x2 = 5;

    [x_rootb, ~] = bisection_method(@test_func, x1, x2, y_tol, max_iter);
    [f_rootb, ~] = test_func(x_rootb);
    
    
    [x_roots, ~] = secant(@test_func, x1, x2, max_iter, dx_tol, y_tol);
    [f_roots, ~] = test_func(x_roots);

    hold on;
    plot(x_range, y_vals, "k");
    plot(x_range, x_range * 0, "r--");
    plot(x_roots, f_roots, "bo")
    disp([x_roots, f_roots])
    disp([x_rootb, f_rootb])
    disp([x_root1, f_root1])
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

function [result, exit] = bisection_method(test_func01, x1, x2, tolerance, max_iter)
    current_iter = 1;
    y_val_1 = test_func01(x1);
    y_val_2 = test_func01(x2);
    min_y_val = min(abs(y_val_1), abs(y_val_2));
    
    while(abs(min_y_val) > tolerance && current_iter < max_iter)
        new_x = (x1 + x2) / 2;
        min_y_val = test_func01(new_x);
        
        if min_y_val > 0 && y_val_1 > 0
            x1 = new_x;
        elseif min_y_val < 0 && y_val_1 < 0
            x1 = new_x;
        elseif min_y_val > 0 && y_val_2 > 0
            x2 = new_x;
        elseif min_y_val < 0 && y_val_2 < 0
            x2 = new_x;
        end

        current_iter = current_iter + 1;
    end
    
    if current_iter < max_iter
        exit = 0;
    else
        exit = 1;
    end

    if current_iter == 1 && min_y_val == y_val_1
        result = x1;
    elseif current_iter == 1 && min_y_val == y_val_2
        result = x2;
    else 
        result = new_x;
    end
end

function [f_val, dfdx] = test_func(x)
    f_val = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2 + 6) - .7 - exp(x/6);
    dfdx = (3*x.^2)/100 - x/4 + 2 + 3*cos(x/2 + 6) - exp(x/6)/6;
end





%Secant Method
function [x_root, exit] = secant(input_func, x_n1, x_n2, max_iter, dx_tol, y_tol)

    
    [fval1, ~] = input_func(x_n1);
    [fval2, ~] = input_func(x_n2);

    count = 0;

    while count < max_iter && abs(fval1) > y_tol && abs(x_n1 - x_n2) > dx_tol
   
        temp_x1 = x_n1;

        x_n1 = ((x_n2*fval1) - (x_n1*fval2))/(fval1 - fval2);

        x_n2 = temp_x1;

        [fval1, ~] = input_func(x_n1);
        [fval2, ~] = input_func(x_n2);

        count = count + 1;

    end

    x_root = x_n1;
    exit = 0;

    if abs(fval1) > y_tol && abs(x_n1 - x_n2) > dx_tol
        exit = 1;
    end

end