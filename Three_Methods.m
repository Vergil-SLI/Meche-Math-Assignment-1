%Bisection Method
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

%Newton's Method
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
