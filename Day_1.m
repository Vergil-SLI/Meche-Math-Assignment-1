clear;

% Initial Test Func
syms x
test_func01 = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

% Plot Base Graph
hold off
fplot(test_func01,[-15 40]);
ylim([-40, 80]);
hold on
yline(0, '--');


% Bisection Method 
% (Start with an x value that has a neg y and another with a pos y)
function [result, exit] = bisection_method(x1, x2, tolerance, max_iter)
    current_iter = 1;
    y_val_1 = subs(test_func01, x, x1);
    y_val_2 = subs(test_func01, x, x2); 
    min_y_val = min(abs(y_val_1), abs(y_val_2));
    
    while(abs(min_y_val) > tolerance && current_iter < max_iter)
        new_x = (x1 + x2) / 2;
        min_y_val = subs(test_func01, x, new_x);
        
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