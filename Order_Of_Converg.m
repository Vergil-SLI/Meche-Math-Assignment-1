function [error_n, error_n1] = bisection_converg()

    input1 = linspace(-1, 0, 500);
    input2 = linspace(1, 2, 500);

    error_n = [];
    error_n1 = [];

    for i = 1:length(input1)
        [~, ~, guess] = bisection(@test_func, input1(i), input2(i), 1e-14, 200);

        for j = 1:(length(guess)-1)
            % error_n(end + 1) = guess(j) - 0.7174;
            % error_n1(end + 1) = guess(j+1) - 0.7174; 
            error_n = [error_n, abs(guess(j) - 0.7174)];
            error_n1 = [error_n1, abs(guess(j+1) - 0.7174)];
        end
    end

    loglog(error_n, error_n1,'ro','markerfacecolor','r','markersize',1);
end