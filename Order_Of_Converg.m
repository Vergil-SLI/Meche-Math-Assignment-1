function converg_plots()
    
    %Fzero
    subplot(2, 2, 1);
    
    [en, en1, xr, yr, p, k] = fzero_analysis();
    loglog(en, en1,'ro','markerfacecolor','r','markersize',1);
    hold on;
    loglog(xr, yr,'bo','markerfacecolor','b','markersize',1);

    fit_line_x = 10.^[-16:.01:1];
    fit_line_y = k*fit_line_x.^p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    title("FZero Method Convergence Analysis");
    xlabel("E_n")
    ylabel("E_n1")
    legend("Raw Data", "Cleaned Data", "Linear Regression Fit Line", Location="northwest")
    hold off;
    
    %Bisection
    subplot(2, 2, 2);
    
    [en, en1, xr, yr, p, k] = bisection_converg();
    loglog(en, en1,'ro','markerfacecolor','r','markersize',1);
    hold on;
    loglog(xr, yr,'bo','markerfacecolor','b','markersize',1);

    fit_line_x = 10.^[-16:.01:1];
    fit_line_y = k*fit_line_x.^p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    title("Bisection Method Convergence Analysis");
    xlabel("E_n")
    ylabel("E_n1")
    legend("Raw Data", "Cleaned Data", "Linear Regression Fit Line", Location="northwest")
    hold off;

    %Newton
    subplot(2, 2, 3);
    
    [en, en1, xr, yr, p, k] = newton_converg();
    loglog(en, en1,'ro','markerfacecolor','r','markersize',1);
    hold on;
    loglog(xr, yr,'bo','markerfacecolor','b','markersize',1);

    fit_line_x = 10.^[-16:.01:1];
    fit_line_y = k*fit_line_x.^p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    title("Newton's Method Convergence Analysis");
    xlabel("E_n")
    ylabel("E_n1")
    legend("Raw Data", "Cleaned Data", "Linear Regression Fit Line", Location="northwest")
    hold off;

    %Secant
    subplot(2, 2, 4);
    
    [en, en1, xr, yr, p, k] = secant_converg();
    loglog(en, en1,'ro','markerfacecolor','r','markersize',1);
    hold on;
    loglog(xr, yr,'bo','markerfacecolor','b','markersize',1);

    fit_line_x = 10.^[-16:.01:1];
    fit_line_y = k*fit_line_x.^p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    title("Secant Method Convergence Analysis");
    xlabel("E_n")
    ylabel("E_n1")
    legend("Raw Data", "Cleaned Data", "Linear Regression Fit Line", Location="northwest")
    hold off;


end
function [error_n, error_n1, x_regression, y_regression, p, k] = bisection_converg()

    error_n = [];
    error_n1 = [];
    [x_root_init, ~, ~] = bisection(@test_func, -5, 5, 1e-14, 200);

    for i = 1:500
        [x_root, ~, guess] = bisection(@test_func, x_root_init - .1 - rand(), x_root_init + .1 + rand(), 1e-14, 200);

        for j = 1:(length(guess)-1)
            % error_n(end + 1) = guess(j) - 0.7174;
            % error_n1(end + 1) = guess(j+1) - 0.7174; 
            error_n = [error_n, abs(guess(j) - x_root)];
            error_n1 = [error_n1, abs(guess(j+1) - x_root)];
        end
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

function [error_n, error_n1, x_regression, y_regression, p, k] = newton_converg()

    error_n = [];
    error_n1 = [];

    x_init = -2;
    dx_tol = 1e-14;
    y_tol = 1e-14;
    [x_root_init, ~, ~] = newton(@test_func, x_init, 200, dx_tol, y_tol);

    for i = 1:1000
        [x_root, ~, guess] = newton(@test_func, x_root_init + 5*(rand()-.5), 200, dx_tol, y_tol);

        for j = 1:(length(guess)-1)
            % error_n(end + 1) = guess(j) - 0.7174;
            % error_n1(end + 1) = guess(j+1) - 0.7174; 
            error_n = [error_n, abs(guess(j) - x_root)];
            error_n1 = [error_n1, abs(guess(j+1) - x_root)];
        end
    end
    % data points to be used in the regression
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

function [error_n, error_n1, x_regression, y_regression, p, k] = secant_converg()

    error_n = [];
    error_n1 = [];

    x_n1 = -5;
    x_n2 = 5;
    dx_tol = 1e-14;
    y_tol = 1e-14;
    [x_root_init, ~, ~] = secant(@test_func, x_n1, x_n2, 200, dx_tol, y_tol);

    for i = 1:1000
        % [x_root, ~, guess] = secant(@test_func, x_root_init - .1-rand(), x_root_init + .1+rand(), 200, dx_tol, y_tol);
        [x_root, ~, guess] = secant(@test_func, x_root_init + 6*(rand()-.5), x_root_init + 6*(rand()-.5), 200, dx_tol, y_tol);

        for j = 1:(length(guess)-1)
            % error_n(end + 1) = guess(j) - 0.7174;
            % error_n1(end + 1) = guess(j+1) - 0.7174; 
            error_n = [error_n, abs(guess(j) - x_root)];
            error_n1 = [error_n1, abs(guess(j+1) - x_root)];
        end
    end
    % data points to be used in the regression
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