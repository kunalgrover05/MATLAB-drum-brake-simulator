syms t3 t4
l1=sqrt(1.5^2+12^2);
l2=3;
l3=10;
l4=6;

t1=atan(1.5/12);
t2=degtorad(80);
u=degtorad(100);
w=degtorad(140);
k = 0;
k_step = 1;
for t2=degtorad(0):degtorad(k_step):degtorad(360)
    k=k+k_step;
    du=2;
    dw=2;

    while (du>0.1 | dw>0.1)
        f(t3,t4)=l1*cos(t1)+l2*cos(t2)+l3*cos(t3)-l4*cos(t4);
        g(t3,t4)=l1*sin(t1)+l2*sin(t2)+l3*sin(t3)-l4*sin(t4);
        fd3(t3)=diff(f,t3);
        fd4(t4)=diff(f,t4);
        gd3(t3)=diff(g,t3);
        gd4(t4)=diff(g,t4);

        A = [fd3(u), fd4(w) ; gd3(u), gd4(w)];
        B = -[f(u,w);g(u,w)];
        C = inv(A)*B;

        du = eval(C(1));
        dw = eval(C(2));
        u = u+du;
        w = w+dw;
    end
    arru(k) = u;
    arrw(k) = w;
end
figure
hold on
plot(arru,'Color','m')
plot(arrw,'Color','b')
hold off

syms w3 w4 t
w1=0;
w2=10;
k=0;
for t2=degtorad(0):degtorad(k_step):degtorad(360)
    du=2;
    dw=2;
    
    k=k+k_step;
    while (du>0.1 | dw>0.1)
        fd(w3,w4)=-l2*sin(t2)*w2-l3*sin(arru(k))*w3+l4*w4*sin(arrw(k));
        gd(w3,w4)=l2*cos(t2)*w2+l3*cos(arru(k))*w3-l4*w4*cos(arrw(k));
        fdd3(w3)=diff(fd,w3);
        fdd4(w4)=diff(fd,w4);
        gdd3(w3)=diff(gd,w3);
        gdd4(w4)=diff(gd,w4);

        A = [fdd3(u), fdd4(w) ; gdd3(u), gdd4(w)];
        B = -[fd(u,w);gd(u,w)];
        C = inv(A)*B;

        du = eval(C(1));
        dw = eval(C(2));
        u = u+du;
        w = w+dw;
    end
    arrdu(k) = u;
    arrdw(k) = w;
end
figure
hold on
plot(arrdu,'Color','m')
plot(arrdw,'Color','b')
hold off

syms a3 a4
a1=0;
a2=0;
k=0;

t2=0;
        
for t2=degtorad(0):degtorad(k_step):degtorad(360)
    du=2;
    dw=2;
      
    k=k+k_step;
    
    while (du>0.1 | dw>0.1)
        fdd(a3,a4)=-l2*cos(t2)*(w2)^2-l2*sin(t2)*a2 - l3*cos(arru(k))*(arrdu(k))^2-l3*sin(arru(k))*a3*(arrdu(k)) + l4*(arrdw(k))^2*cos(arrw(k))+l4*a4*sin(arrw(k))*arrdw(k);
        gdd(a3,a4)=-l2*sin(t2)*(w2)^2+l2*cos(t2)*a2 - l3*sin(arru(k))*(arrdu(k))^2+l3*cos(arru(k))*a3*(arrdu(k)) + l4*(arrdw(k))^2*sin(arrw(k))-l4*a4*cos(arrw(k))*arrdw(k);
        fddd3(a3)=diff(fdd,a3);
        fddd4(a4)=diff(fdd,a4);
        gddd3(a3)=diff(gdd,a3);
        gddd4(a4)=diff(gdd,a4);

        A = [fddd3(u), fddd4(w) ; gddd3(u), gddd4(w)];
        B = -[fdd(u,w);gdd(u,w)];
        C = inv(A)*B;

        du = eval(C(1));
        dw = eval(C(2));
        u = u+du;
        w = w+dw;
    end
    arrdddu(k) = u;
    arrdddw(k) = w;
end

figure
hold on
plot(arrdddu,'Color','m')
plot(arrdddw,'Color','b')
hold off
