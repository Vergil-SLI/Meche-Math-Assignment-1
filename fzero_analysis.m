function [error_n, error_n1, x_regression, y_regression, p, k] = fzero_analysis()
    %declare input_list as a global variable
    global input_list;
    x0 = 2.7;
    error_n = [];
    error_n1 = [];
    
    for i = 1:1000
        % run fzero, which calls and populates input list through
        % fzero test func
        x_root = fzero(@fzero_test_func, x0 + 10*(rand()-.5));
    
        for j = 1:length(input_list)-1
            error_n(end + 1) = abs(input_list(j) - x_root);
            error_n1(end + 1) = abs(input_list(j+1) - x_root); 
        end
        input_list = [];
    end
    %data points to be used in the regression
    x_regression = []; % e_n
    y_regression = []; % e_{n+1}
    %iterate through the collected data
    for n=1:length(error_n)
        %if the error is not too big or too small
        %and it was enough iterations into the trial...
        if error_n(n)>1e-15 && error_n(n)<1e-1 && ...
            error_n1(n)>1e-14 && error_n1(n)<1e-1
            %then add it to the set of points for regression
            x_regression(end+1) = error_n(n);
            y_regression(end+1) = error_n1(n);
        end
    end
    [p, k] = error_reg_fit(x_regression, y_regression);
    disp([p, k]);
 
end

