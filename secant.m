function [x_root, exit, guess_list] = secant(input_func, x_n1, x_n2, max_iter, dx_tol, y_tol)

    
    [fval1, ~] = input_func(x_n1);
    [fval2, ~] = input_func(x_n2);

    count = 0;

    while count < max_iter && abs(fval1) > y_tol && abs(x_n1 - x_n2) > dx_tol && abs(fval1 - fval2) > dx_tol
   
        temp_x1 = x_n1;

        x_n1 = ((x_n2*fval1) - (x_n1*fval2))/(fval1 - fval2);
        x_n2 = temp_x1;
        [fval1, ~] = input_func(x_n1);
        [fval2, ~] = input_func(x_n2);
        
        guess_list = [guess_list, x_n1];
        count = count + 1;

    end

    x_root = x_n1;
    exit = 0;

    if abs(fval1) > y_tol && abs(x_n1 - x_n2) > dx_tol
        exit = 1;
    end

end