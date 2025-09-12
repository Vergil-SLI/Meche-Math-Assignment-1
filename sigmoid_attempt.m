function fzero_sigmoid()
    global input_list;

    x_init = linspace(0, 50, 100);
    success_x = [];
    success_y = [];
    fail_x = [];
    fail_y = [];
    
    for i = 1:length(x_init)
        [~, ~, exitflag] = fzero(@sigmoid_func, x_init(i));
        [y_val, ~] = sigmoid_func(x_init(i));
        
        if exitflag == 1
            success_x(end+1) = x_init(i);
            success_y(end+1) = y_val;
        else
            fail_x(end+1) = x_init(i);
            fail_y(end+1) = y_val;
        end
    end

    %plot starting value as green if exit is fine
    x_range = linspace(0, 50, 100);
    [y_vals, ~] = sigmoid_func(x_range);
    plot(x_range, y_vals, "b-")
    hold on
    plot(success_x, success_y, 'go', "MarkerFaceColor", "g");
    plot(fail_x, fail_y, 'ro', "MarkerFaceColor", "r");
end


% function secant_sigmoid()
%     x1_init = linspace(0, 50, 200);
%     x2_init = linspace(0, 50, 200); 
%     dx_tol = 1e-14;
%     y_tol = 1e-14;
% 
%     hold on
% 
%     x0_success = [];
%     x1_success = [];
% 
%     x0_fail = [];
%     x1_fail = [];
% 
%     for i = 1:length(x1_init)
%         for j = 1:length(x2_init)
%             [~, exit, ~] = secant(@sigmoid_func, x1_init(i), x2_init(j), 200, dx_tol, y_tol);
% 
%             if exit == 0
%                 % green when solved fully
%                 x0_success(end+1) = x1_init(i);
%                 x1_success(end+1) = x2_init(j);
%             else
%                 % red when not solved fully
%                 x0_fail(end+1) = x1_init(i);
%                 x1_fail(end+1) = x2_init(j);
%             end
%         end
%     end
% 
%     plot(x0_success, x1_success, 'go', "MarkerFaceColor", "g", "MarkerSize",2);
%     plot(x0_fail, x1_fail, 'ro', "MarkerFaceColor", "r", "MarkerSize",2);
% end


% function newton_sigmoid()
%     x_init = linspace(0, 50, 100);
%     dx_tol = 1e-14;
%     y_tol = 1e-14;
%     success_x = [];
%     success_y = [];
%     fail_x = [];
%     fail_y = [];
% 
%     for i = 1:length(x_init)
%         [~, exit, ~] = newton(@sigmoid_func, x_init(i), 200, dx_tol, y_tol);
%         [y_val, ~] = sigmoid_func(x_init(i));
% 
%         if exit == 0
%             % green when solved fully
%             success_x(end+1) = x_init(i);
%             success_y(end+1) = y_val;
%         else
%             % red when not solved fully
%             fail_x(end+1) = x_init(i);
%             fail_y(end+1) = y_val;
%         end
%     end
% 
%     % plot starting value as green if exit is fine
%     x_range = linspace(0, 50, 100);
%     [y_vals, ~] = sigmoid_func(x_range);
%     plot(x_range, y_vals, "b-")
%     hold on
%     plot(success_x, success_y, 'go', "MarkerFaceColor", "g");
%     plot(fail_x, fail_y, 'ro', "MarkerFaceColor", "r");
% end

function [f_val, dfdx] = sigmoid_func(x)
    global input_list;

    if length(x) == 1
        input_list(:,end+1) = x;
    end

    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end