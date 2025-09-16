function animated_egg()

    s = linspace(0, 1, 100);
    x0 = 5;
    y0 = 5;
    theta = pi/6;
    
    egg_parms = struct();
    egg_parms.a = 3;
    egg_parms.b = 2;
    egg_parms.c = .15;


    [V, G] = egg_func(s, x0, y0, theta, egg_parms);
    
    og = plot(V(1, :), V(2, :), "k");
    hold on;
    xline(30, "b-");
    yline(3, "r-");
    axis equal
    axis square
    axis([0, 50, 0, 50])
    
    for t=0:.001:10
        [newx, newy, newtheta] = egg_trajectory(t);
        
        [newv, newg] = egg_func(s, newx, newy, newtheta, egg_parms);

        set(og, "xdata", newv(1, :), "ydata", newv(2, :));

        drawnow;
    end
end
