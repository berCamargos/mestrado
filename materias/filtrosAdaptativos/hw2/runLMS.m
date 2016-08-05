function [e,W] = runLMS(mi,N,M,Wo,doPlot)
    phiu = rand*2*pi;
    n = 0:1:(N-1+M-1);
    u = zeros(M,N);
    for i = 0:(M-1)
        u(i+1,:) = 5*sin(2*pi*n((2-i):(end-i))/10 + phiu);
    end
    x = sin(2*pi*n(2:end)/10 + pi/6 + phiu);
    s = 0.1*randn(1,N); 
    d = s + x;
    W = zeros(M,N+1);
    e = zeros(1,N);
    for i = 1:N
        e(i) = d(i) - u(:,i)'*W(:,i);
        W(:,i+1) = W(:,i) + mi*e(i)*u(:,i);
    end
    E = sum((d(:) - u(:,:)'*W(:,end)).^2)/N;
    if doPlot == 1
        figure()
        subplot(311)
        plot(0:N-1,e)
        title('e')
        subplot(312)
        plot(0:N-1,u)
        title('u_1,u_2')
        subplot(313)
        plot(0:N-1,s)
        title('s')
        figure()
        hold on
        plot(0:N,W)
        a = ones(size(W));
        a(1,:) = a(1,:).*Wo(1);
        a(2,:) = a(2,:).*Wo(2);
        plot(0:N,a)
        legend('W_1','W_2','Wo_1','Wo_2')
        title('Coeficientes')
        limt = -100:1:100;
        sup = zeros(size(limt,2),size(limt,2));
        ci = 1;
        for i = limt
            cj = 1;
            for j = limt
                sup(ci,cj) = 0;
                E = (d(:) - u(:,:)'*[i;j]).^2;
                sup(ci,cj) = sum(E);
                sup(ci,cj) = sup(ci,cj)/N;
                cj = cj + 1;
            end
            ci = ci + 1
        end
        ecurvmax = sum((d(:) - u(:,:)'*[max(limt);min(limt)]).^2)/N %esse limite foi observado experimantalmente
        figure()
        surf(limt,limt,sup)
    end
end
