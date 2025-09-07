%Bisection Method
function [x_root, exit, guess_list] = bisection(input_func, x1, x2, tol, max_iter)

    if abs(input_func(x1)) < abs(input_func(x2))
        x_root = x1;
    else
        x_root = x2;
    end

    guess_list = x_root;
    
    if input_func(x1) / abs(input_func(x1)) ~= input_func(x2) / abs(input_func(x2))
        current_iter = 1;
        while(abs(input_func(x_root)) > tol && current_iter < max_iter)
            x_root = (x1 + x2) / 2;
            current_iter = current_iter + 1;
            guess_list = [guess_list, x_root];
    
            if input_func(x_root) / abs(input_func(x_root)) == input_func(x1) / abs(input_func(x1))
                x1 = x_root;
            else
                x2 = x_root;
            end
        end
    else
        current_iter = max_iter;
    end
    
    if current_iter < max_iter
        exit = 0;
    else
        exit = 1;
    end
end

%Newton's Method
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

    exit = 0;

    if abs(x_curr - x_prev) > dx_tol && abs(f_val) > y_tol
        exit = 1;

    end

end
