clear all
close all

R = zeros(2,2);
n = 3;
o = 0;
R(1,1) = 25*(1/2);
R(2,2) = 25*(1/2);
R(1,2) = 25*(1/2*cos(2*pi/10));
R(2,1) = 25*(1/2*cos(-2*pi/10));
R
R^-1
p = [5*1/2*cos(-pi/6); 5*1/2*cos(-pi/6-2*pi/10)]
Wo = (R^-1)*p
os = 0.01
ou = 0.5
os + ou - p'*Wo
eigs = eig(R)
uMax = 2/max(eigs)

figure()
hold on
for mi = [0.01 0.03 0.05]
J = 0;
[E W] = runLMS(mi,500,2,Wo,0);
J = E;
for i = 1:500
    [E W] = runLMS(mi,500,2,Wo,0);
    J = J + E;
end
J = J/500;
J = J.^2;
plot(J)
end
fdjksal
%deu 0.0710??
for mi = 0.06:0.001:0.2
    mi
    avgE = 0;
    for j = 1:1000
        [E W] = runLMS(mi,500,2,Wo,0,0);
        avgE = avgE + E;
        if(isnan(W(:,end)))
            'aaaaaaaa'
            break
        end
    end
    avgE/1000
    if(isnan(W(:,end)))
        break
    end
end


