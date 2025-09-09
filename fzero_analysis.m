function fzero_analysis()
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
    
    loglog(error_n, error_n1,'ro','markerfacecolor','r','markersize',1);
end

