function animated_egg()

    s = linspace(0, 1, 100);
    x0 = 5;
    y0 = 5;
    theta = pi/6;
    
    egg_parms = struct();
    egg_parms.a = 3;
    egg_parms.b = 2;
    egg_parms.c = .15;

    x_wall = 30;
    y_ground = 1;


    [V, G] = egg_func(s, x0, y0, theta, egg_parms);
    
    og = plot(V(1, :), V(2, :), "k");
    hold on;
    xline(x_wall, "b-");
    yline(y_ground, "b-");
    axis equal
    axis square
    axis([0, 31, 0, 31])

    [t_ground, t_wall] = collision_func(@egg_trajectory, egg_parms, y_ground, x_wall)

    t = 0;
    
    while t < t_wall && t < t_ground
        [newx, newy, newtheta] = egg_trajectory(t);
        
        [newv, ~] = egg_func(s, newx, newy, newtheta, egg_parms);

        set(og, "xdata", newv(1, :), "ydata", newv(2, :));

        drawnow;

        t = t + 0.001;
    end

    if t_wall < t_ground
        [x0, y0, theta] = egg_trajectory(t_wall);
        egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_parms);
        [x1_s, x2_s, ~, ~] = bound_box(x0, y0, theta, egg_parms);
        [~, x1_bound] = egg_wrapper2x(x1_s);
        [~, x2_bound] = egg_wrapper2x(x2_s);

        if x1_bound > x2_bound
            [finalv, ~] = egg_func(x1_s, x0, y0, theta, egg_parms);
        else
            [finalv, ~] = egg_func(x2_s, x0, y0, theta, egg_parms);
        end
    else
        [x0, y0, theta] = egg_trajectory(t_ground);
        egg_wrapper2y = @(s) egg_wrapper1y(s,x0,y0,theta,egg_parms);
        [~, ~, y1_s, y2_s] = bound_box(x0, y0, theta, egg_parms);
        [~, y1_bound] = egg_wrapper2y(y1_s);
        [~, y2_bound] = egg_wrapper2y(y2_s);

        if y1_bound > y2_bound
            [finalv, ~] = egg_func(y2_s, x0, y0, theta, egg_parms);
        else
            [finalv, ~] = egg_func(y1_s, x0, y0, theta, egg_parms);
        end
    end

    plot(finalv(1), finalv(2), "ro", "MarkerSize",6, "MarkerFaceColor","r");

end


% function eggxample01()
%     %set the oval hyper-parameters
%     egg_params = struct();
%     egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
%     %specify the position and orientation of the egg
%     x0 = 5; y0 = 5; theta = pi/6;    
% 
%     %set up the axis
%     hold on; axis equal; axis square
%     axis([0,10,0,10])
% 
%     %plot the origin of the egg frame
%     plot(x0,y0,'ro','markerfacecolor','r');
% 
%     %compute the perimeter of the egg
%     Vx = [];
%     Vy = [];
%     Gx = [];
%     Gy = [];
%     egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_params);
%     egg_wrapper2y = @(s) egg_wrapper1y(s,x0,y0,theta,egg_params);
% 
%     for s= 0:0.02:1
%         [Gx1, Vx1] = egg_wrapper2x(s);
%         Vx(end+1) = Vx1;
%         Gx(end+1) = Gx1;
%         [Gy1, Vy1] = egg_wrapper2y(s);
%         Vy(end+1) = Vy1;
%         Gy(end+1) = Gy1;
%     end
% 
%     %plot the perimeter of the egg
%     plot(Vx,Vy,'k');
% 
%     %find and plot boundaries
%     [x1_bound, x2_bound, y1_bound, y2_bound] = bound_box(x0, y0, theta, egg_params);
% 
%     line([x1_bound,x2_bound], [y1_bound, y1_bound], 'Color', 'r', 'LineWidth', 2);
%     line([x1_bound,x2_bound], [y2_bound, y2_bound], 'Color', 'r', 'LineWidth', 2);
%     line([x1_bound,x1_bound], [y1_bound, y2_bound], 'Color', 'r', 'LineWidth', 2);
%     line([x2_bound,x2_bound], [y1_bound, y2_bound], 'Color', 'r', 'LineWidth', 2);
% 
%     % calculate time of collision
%     y_ground = 1;
%     x_wall = 30;
% 
%     [t_ground,t_wall] = collision_func(@egg_trajectory, egg_params, y_ground, x_wall)
% end

function [t_ground,t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)
    t_ground = -1;
    t_wall = -1;
    t = 0;
    max_t = 100;
    

    while (t_ground == -1 || t_wall == -1) && t < max_t
        [x0, y0, theta] = traj_fun(t);
        egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_params);
        egg_wrapper2y = @(s) egg_wrapper1y(s,x0,y0,theta,egg_params);
        [x1_s, x2_s, y1_s, y2_s] = bound_box(x0, y0, theta, egg_params);
        %convert boundary s values to actual x-y coords
        [~, x1_bound] = egg_wrapper2x(x1_s);
        [~, x2_bound] = egg_wrapper2x(x2_s);
        [~, y1_bound] = egg_wrapper2y(y1_s);
        [~, y2_bound] = egg_wrapper2y(y2_s);
        
        % x_wall is between the 2 x_bounds
        if ((x1_bound <= x_wall && x_wall <= x2_bound) || (x2_bound <= x_wall && x_wall <= x1_bound)) && t_wall == -1
            t_wall = t;
        end

        if ((y1_bound <= y_ground && y_ground <= y2_bound) || (y2_bound <= y_ground && y_ground <= y1_bound)) && t_ground == -1
            t_ground = t;
        end

        t = t + 0.001;
    end
end


function [x1_s, x2_s, y1_s, y2_s] = bound_box(x0, y0, theta, egg_params)
    egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_params);
    egg_wrapper2y = @(s) egg_wrapper1y(s,x0,y0,theta,egg_params);
    
    [x1_s, ~, ~] = secant(egg_wrapper2x, 0, 0.1, 200, 1e-14, 1e-14);
    [y1_s, ~, ~] = secant(egg_wrapper2y, 0, 0.1, 200, 1e-14, 1e-14);

    x1_s = round(mod(x1_s, 1), 4);
    y1_s = round(mod(y1_s, 1), 4);
    x2_s = -1;
    y2_s = -1;
    
    % guess x and y "s values" using secant with increments of 0.1
    % normalize guesses to be between 0~1, and double check the 2nd value
    % isn't equal to the first
    for guess = 0:0.1:1
        x2_s_guess = secant(egg_wrapper2x, guess, guess + 0.1, 200, 1e-14, 1e-14);
        y2_s_guess = secant(egg_wrapper2y, guess, guess + 0.1, 200, 1e-14, 1e-14);
        x2_s_guess = round(mod(x2_s_guess, 1), 4);
        y2_s_guess = round(mod(y2_s_guess, 1), 4);
        
        if x1_s ~= x2_s_guess && x2_s == -1
            x2_s = x2_s_guess;
        end
        
        if y1_s ~= y2_s_guess && y2_s == -1
            y2_s = y2_s_guess;
        end
    end
end


function [gx_out, vx_out] = egg_wrapper1x(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params); % we don't care about V atm
    gx_out = G(1);
    vx_out = V(1); % holder for secant function to work
end

function [gy_out, vy_out] = egg_wrapper1y(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    gy_out = G(2);
    vy_out = V(2); % holder for secant function to work
end


function [V, G] = egg_func(s,x0,y0,theta,egg_params)
    %unpack the struct
    a=egg_params.a;
    b=egg_params.b;
    c=egg_params.c;
    %compute x (without rotation or translation)
    x = a*cos(2*pi*s);
    %useful intermediate variable
    f = exp(-c*x/2);
    %compute y (without rotation or translation)
    y = b*sin(2*pi*s).*f;
    %compute the derivatives of x and y (without rotation or translation)
    dx = -2*pi*a*sin(2*pi*s);
    df = (-c/2)*f.*dx;
    dy = 2*pi*b*cos(2*pi*s).*f + b*sin(2*pi*s).*df;
    %rotation matrix corresponding to theta
    R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    %compute position and gradient for rotated + translated oval
    V = R*[x;y]+[x0*ones(1,length(theta));y0*ones(1,length(theta))];
    G = R*[dx;dy];
end

function [x0, y0, theta] = egg_trajectory(t)

    x0 = 7*t + 8;
    y0 = -6*t.^2 + 20*t + 6;
    theta = 5*t;

end