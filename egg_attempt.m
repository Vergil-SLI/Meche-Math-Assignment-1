function egg_attempt
    x0 = 5;
    y0 = 5;
    theta = pi/6;
    egg_params = struct();
    egg_params.a = 3;
    egg_params.b = 2;
    egg_params.c = 0.15;
    s_perimeter = linspace(0, 1, 100);

    [V_vals, G_vals] = egg_func(s_perimeter, x0, y0, theta, egg_params);

    % hold on; axis equal; axis square
    % axis([0,10,0,10])

    % plot(V_vals(1, :), V_vals(2, :));
    plot(s_perimeter, V_vals(1, :)) % root find this function to find the left and right bounding box?
    % plot(s_perimeter, G_vals(2, :)) % root find this function to find the up and down bounding box?
end