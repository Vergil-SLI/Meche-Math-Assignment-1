function eggxample01()
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;
    
    [xmax, exit, guess_list] = bound_box(x0, y0, theta, egg_params)


    %set up the axis
    hold on; axis equal; axis square
    axis([0,10,0,10])

    %plot the origin of the egg frame
    plot(x0,y0,'ro','markerfacecolor','r');

    % %compute the perimeter of the egg
    % Vx = [];
    % Vy = [];
    % egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_params);
    % egg_wrapper2y = @(s) egg_wrapper1y(s,x0,y0,theta,egg_params);
    % 
    % for s= 0:0.02:1
    %     [Vx1, Gx1] = egg_wrapper2x(s);
    %     Vx(end+1) = Vx1;
    %     [Vy1, Gy1] = egg_wrapper2y(s);
    %     Vy(end+1) = Vy1;
    % end
    % 
    % %plot the perimeter of the egg
    % plot(Vx,Vy,'k');


    % %compute a single point along the egg (s=.8)
    % %as well as the tangent vector at that point
    % vvals = [];
    % gvals = [];
    % for s = 0:.02:1
    % 
    %     [V_single, G_single] = egg_func(s,x0,y0,theta,egg_params);
    %     vvals = [vvals, V_single];
    %     gvals = [gvals, G_single];
    % end
    % %plot this single point on the egg
    % plot(vvals(1, :),vvals(2, :),'ro','markerfacecolor','r');
    % %plot this tangent vector on the egg
    % % vector_scaling = .1;
    % % tan_vec_x = [V_single(1),V_single(1)+vector_scaling*G_single(1)];
    % % tan_vec_y = [V_single(2),V_single(2)+vector_scaling*G_single(2)];
    % % plot(tan_vec_x,tan_vec_y,'g')
end

function [root, exit, guess_list] = bound_box(x0, y0, theta, egg_params)
    ymax = 0;
    ymin = 0;
    xmin = 0;

    egg_wrapper2x = @(s) egg_wrapper1x(s,x0,y0,theta,egg_params);
    [root, exit, guess_list] = secant(egg_wrapper2x, 0.2, 0.3, 200, 1e-14, 1e-14);
end


function [x_out, dxds_out] = egg_wrapper1x(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    x_out = V(1);
    dxds_out = G(1);
end

function [y_out, dyds_out] = egg_wrapper1y(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    y_out = V(2);
    dyds_out = G(2);
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

