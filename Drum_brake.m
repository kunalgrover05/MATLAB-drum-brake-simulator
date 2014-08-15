% Clear all memory
clear

% t2 and t3 are symbolic variables
syms t2 t3

% Fixing l1, l2, l3, l4, t4, r, rj
% r->Radius of circle
% rj->Radius of joint
r=100;
l1 = 20;
l2 = 90;
l3 = 100*sqrt(3);
l4 = r;
t4 = pi/3;
rj=4;


% Limits for movement
k_start = 0;
k_end = pi;
k_diff = 1;
k = 1;
k_step = pi/60;

% Setting up figure
figure('units','normalized','outerposition',[0 0 1 1])
axis([-1.2*r,1.2*r,-1.2*r,1.2*r]);
axis equal
axis off
hold all

% Drawing circle
[xunit , yunit] = get_circle( 0, 0, r+8 );
h = plot( xunit, yunit, 'Linewidth', 14, 'color', 'y' );

link1 = line( [0 0], [0 0], 'LineWidth', 10, 'color', 'r' );
link2 = line( [0 0], [0 0], 'LineWidth', 10, 'color', 'g' );
link4 = line( [0 0], [0 0], 'LineWidth', 10, 'color', 'r' );
link5 = line( [0 0], [0 0], 'LineWidth', 10, 'color', 'g' );

[xunit, yunit] = get_arc( [0 0], [0 0], r );
link3 = plot(xunit, yunit, 'LineWidth', 20, 'color', 'b');
link6 = plot(xunit, yunit, 'LineWidth', 20, 'color', 'b');

% Radius linkages-Not present in drum brakes
%link7 = line( [0 -l4*cos(t4)], [0 -l4*sin(t4)], 'LineWidth', 6, 'color', 'y' );
%link8 = line( [0 l4*cos(t4)], [0 l4*sin(t4)], 'LineWidth', 6, 'color', 'y' );

[xunit, yunit] = get_circle( 0, 0, rj );
joint1 = fill(xunit, yunit, 'k');
joint2 = fill(xunit, yunit, 'k');
joint3 = fill(xunit, yunit, 'k');
joint5 = fill(-xunit, -yunit, 'k');
joint6 = fill(-xunit, -yunit, 'k');

[xunit, yunit] = get_circle( -l4*cos(t4), -l4*sin(t4), rj );
joint4 = fill(xunit, yunit, 'k');
joint7 = fill(-xunit, -yunit, 'k');

% Starting point for u and w
u=degtorad(170);
w=degtorad(220);

% Find all solutions and store in array    
for t1 = k_start : k_step : k_end
    du=2;
    dw=2;
    f(t2,t3)=l1*cos(t1)+l2*cos(t2)+l3*cos(t3)+l4*cos(t4);
    g(t2,t3)=l1*sin(t1)+l2*sin(t2)+l3*sin(t3)+l4*sin(t4);
    fd2(t2)=diff(f,t2);
    fd3(t3)=diff(f,t3);
    gd2(t2)=diff(g,t2);
    gd3(t3)=diff(g,t3);

    while (du>0.0001 | dw>0.0001)
        A = [fd2(u), fd3(w) ; gd2(u), gd3(w)];
        B = -[f(u,w);g(u,w)];
        C = A \ B;
        
        du = eval(C(1));
        dw = eval(C(2));
        
        u = u+du;
        w = w+dw;
    end
    radtodeg(u);
    radtodeg(w);
    arru(k) = u;
    arrw(k) = w;
    k = k+k_diff;
end

% Start at k=1 and plot
k=1;
break_flag = 0;

while 1
    for t1 = k_start : k_step : k_end
        u = arru(k);
        w = arrw(k);
        
        % Check if point goes outside circle
        if ( ( (l1*cos(t1)+l2*cos(u))^2 + (l1*sin(t1)+l2*sin(u))^2 ) > r^2 )
           k_end = t1-k_step;
           break;
        end
        
        k = k + k_diff;
        
        x1 = -l4*cos(t4);
        y1 = -l4*sin(t4);
        x2 = l1*cos(t1)+l2*cos(u);
        y2 = l1*sin(t1)+l2*sin(u);
        [xunit, yunit] = get_arc( [x1 y1], [x2 y2], r );
        set( link3, 'XData', xunit, 'YData', yunit );
        set( link6, 'XData', -xunit, 'YData', -yunit );
        % Here are the drum pad linkages as straight lines
        %set( link3, 'XData', [l1*cos(t1)+l2*cos(u) -l4*cos(t4)], 'YData', [l1*sin(t1)+l2*sin(u) -l4*sin(t4)] );
        %set( link6, 'XData', [-l1*cos(t1)-l2*cos(u) l4*cos(t4)], 'YData', [-l1*sin(t1)-l2*sin(u) l4*sin(t4)] );
        
        set( link1, 'XData', [0 l1*cos(t1)], 'YData', [0 l1*sin(t1)] );
        set( link2, 'XData', [l1*cos(t1) l1*cos(t1)+l2*cos(u)], 'YData', [l1*sin(t1) l1*sin(t1)+l2*sin(u)] );
        set( link4, 'XData', [0 -l1*cos(t1)], 'YData', [0 -l1*sin(t1)] );
        set( link5, 'XData', [-l1*cos(t1) -l1*cos(t1)-l2*cos(u)], 'YData', [-l1*sin(t1) -l1*sin(t1)-l2*sin(u)] );
        
        [xunit, yunit] = get_circle( l1*cos( t1 ), l1*sin(t1), rj );
        set( joint2, 'XData', xunit, 'YData', yunit );
        set( joint5, 'XData', -xunit, 'YData', -yunit);

        [xunit, yunit] = get_circle( l1*cos(t1)+l2*cos(u), l1*sin(t1)+l2*sin(u), rj );
        set( joint3, 'XData', xunit, 'YData', yunit );
        set( joint6, 'XData', -xunit, 'YData', -yunit );

        drawnow
        pause( 0.05 )

    end
    
    k = k-k_diff;
    % Reversing direction
    temp = k_start;
    k_start = k_end;
    k_end = temp;
    k_step = k_step*(-1);
    k_diff = k_diff*(-1);

end