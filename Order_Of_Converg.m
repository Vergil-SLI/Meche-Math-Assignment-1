function [error_n, error_n1] = bisection_converg()

    error_n = [];
    error_n1 = [];
    [x_root_init, ~, ~] = bisection(@test_func, -5, 5, 1e-14, 200);

    for i = 1:1000
        [x_root, ~, guess] = bisection(@test_func, x_root_init - 1 * rand(), x_root_init + 1 * rand(), 1e-14, 200);

        for j = 1:(length(guess)-1)
            % error_n(end + 1) = guess(j) - 0.7174;
            % error_n1(end + 1) = guess(j+1) - 0.7174; 
            error_n = [error_n, abs(guess(j) - x_root)];
            error_n1 = [error_n1, abs(guess(j+1) - x_root)];
        end
    end

    loglog(error_n, error_n1,'ro','markerfacecolor','r','markersize',1);
end