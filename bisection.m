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
    
            if input_func(x_root) / abs(input_func(x_root)) == input_func(x1) / abs(input_func(x1))
                guess_list = [guess_list, x1];
                x1 = x_root;
            else
                guess_list = [guess_list, x2];
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
