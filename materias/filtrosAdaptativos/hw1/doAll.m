%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2a)
close all
clear all
'2a)'
'--------'
n  = 0:9;
n1 = 1:10;
u  = sin(2*pi*n1/10);
u1  = sin(2*pi*n/10);

d = 2*cos(2*pi*n1/10);
figure()
hold on
plot(u)
plot(u1,'r')
plot(d,'k')
figure()
R = zeros(2,2);
R(1,1) = 1/10*u*u';
R(2,1) = 1/10*u1*u';
R(1,2) = 1/10*u*u1';
R(2,2) = 1/10*u*u';

P = zeros(2,1);
P(1) = 1/10*d*u';
P(2) = 1/10*d*u1';

R
P
Wo = R\P

e = norm(d - (u*Wo(1) + u1*Wo(2)))
hold on
plot(d,'r')
plot(u*Wo(1) + u1*Wo(2))
'2b)'
'-------'
yo = u*Wo(1) + u1*Wo(2)
Wo(2)*exp(i*2*pi/10)
Wo(2)*exp(-i*2*pi/10)
(Wo(1)+Wo(2)*exp(i*2*pi/10))/i
(Wo(1)+Wo(2)*exp(-i*2*pi/10))/i

'3c)'
'-------'
close all
H = [0.3887;1;0.3887]
R = [H(1)^2 + H(2)^2 + H(3)^2 + 0.001; H(1)*H(2)+H(2)*H(3);H(1)*H(3);0;0;0;0];
R = toeplitz(R)
trace(R)
pB = [H(3);H(2);H(1)];
p2 = [pB;0;0;0;0]
p3 = [0;pB;0;0;0]
p4 = [0;0;pB;0;0]
p7 = [0;0;0;0;0;pB(1:2)]

errors = zeros(1000,2);

%figure()
%subplot(211)
%hold on
%for i = 1:10000
%    errors(i,:) = estimateR(i,7,7,R,p7);
%end
%plot(errors(:,2),'b')
%for i = 1:10000
%    errors(i,:) = estimateR(i,4,7,R,p4);
%end
%plot(errors(:,2),'r')
%for i = 1:10000
%    errors(i,:) = estimateR(i,3,7,R,p3);
%end
%plot(errors(:,2),'k')
%for i = 1:10000
%    errors(i,:) = estimateR(i,2,7,R,p2);
%end
%plot(errors(:,2),'y')
%title('Erro p')
%subplot(212)
%plot(errors(:,1),'b')
%title('Erro R')

Re = getR(100000,7,7,R,p7)
trace(Re)
sum(eig(Re))
eig(Re)


