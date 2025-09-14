function quadtest()

    x_range = linspace(0, 100, 100);
    [y_vals, ~] = test_func2(x_range);

    x_init = 30;
    max_iter = 200;
    dx_tol = 1e-14;
    y_tol = 1e-14;

    [x_root1, ~] = newton(@test_func2, x_init, max_iter, dx_tol, y_tol);
    [f_root1, ~] = test_func2(x_root1);

    xn1 = 20;
    xn2 = 50;
    [x_roots, ~] = secant(@test_func2, xn1, xn2, max_iter, dx_tol, y_tol);
    [f_roots, ~] = test_func2(x_roots);

    hold on;
    plot(x_range, y_vals, "k");
    axis([10 60 -50 100])
    plot(x_range, x_range * 0, "r--");
    plot(x_roots, f_roots, "bo")
    disp([x_roots, f_roots])

    [~, ~, ~, ~, pn, kn] = newton_converg2();
    disp(["N p = ", pn, "N k = ", kn])

    [~, ~, ~, ~, ps, ks] = secant_converg2();
    disp(["S p = ", ps, "S k = ", ks])

end


function [error_n, error_n1, x_regression, y_regression, p, k] = newton_converg2()

    error_n = [];
    error_n1 = [];

    x_init = 20;
    dx_tol = 1e-14;
    y_tol = 1e-14;
    [x_root_init, ~, ~] = newton(@test_func2, x_init, 200, dx_tol, y_tol);

    for i = 1:1000
        [x_root, ~, guess] = newton(@test_func2, x_root_init + 5*(rand()-.5), 200, dx_tol, y_tol);

        for j = 1:(length(guess)-1)
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

end

function [error_n, error_n1, x_regression, y_regression, p, k] = secant_converg2()

    error_n = [];
    error_n1 = [];

    x_n1 = 20;
    x_n2 = 50;
    dx_tol = 1e-14;
    y_tol = 1e-14;
    [x_root_init, ~, ~] = secant(@test_func2, x_n1, x_n2, 200, dx_tol, y_tol);

    for i = 1:1000
        % [x_root, ~, guess] = secant(@test_func, x_root_init - .1-rand(), x_root_init + .1+rand(), 200, dx_tol, y_tol);
        [x_root, ~, guess] = secant(@test_func2, x_root_init + 6*(rand()-.5), x_root_init + 6*(rand()-.5), 200, dx_tol, y_tol);

        for j = 1:(length(guess)-1)
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

end