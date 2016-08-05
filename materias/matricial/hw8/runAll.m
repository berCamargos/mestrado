close all
clear all

X = [0.1 0.5 1 2 2.5 3]
Fx = [1.6912 1.9562 2.7460 3.9765 4.4972 5.3141]
D = [0:0.1:3];

'---------------------------------------'
A = [X' ones(size(X))'];
b = Fx';

Ap = (A'*A)^-1*A';
Wls1 = Ap*b
r1 = A*Wls1 - b
norm(r1)

At = [D' ones(size(D))'];
figure()
subplot(311)
title('g(x) = px + q')
hold on
plot(D,At*Wls1,'k-')
plot(X,b,'kx')

'---------------------------------------'
A2 = [X'.^2 X' ones(size(X))'];
b2 = Fx';

Ap = (A2'*A2)^-1*A2';
Wls2 = Ap*b
Wls2 - pinv(A2)*b
r2 = A2*Wls2 - b
norm(r2)

At = [D'.^2 D' ones(size(D))'];
subplot(312)
title('g(x) = rx^2 + sx + t')
hold on
plot(D,At*Wls2,'k-')
plot(X,b,'kx')


'---------------------------------------'
a = [3.5 1]
bi = 6.2250

Ph1 = A'*A
Wls1
Wls1 = Wls1 + (((Ph1^-1)*a')/(1+a*(Ph1^-1)*a'))*(bi - a*Wls1)

A = [A; a];
b = [b;bi];

Ap = (A'*A)^-1*A';
Ap*b - Wls1

'---------------------------------------'
a = [3.5^2 3.5 1]
bi = 6.2250

Ph2 = A2'*A2
Wls2 = Wls2 + (((Ph2^-1)*a')/(1+a*(Ph2^-1)*a'))*(bi - a*Wls2)

A2 = [A2; a];
b2 = [b2;bi];

Ap = (A2'*A2)^-1*A2';
Ap*b2 - Wls2


'---------------------------------------'
A3 = [X'.^5 X'.^4 X'.^3 X'.^2 X' ones(size(X))'];
b3 = Fx';

Ap = (A3'*A3)^-1*A3';
Wls3 = Ap*b3
Wls3 - pinv(A3)*b3
r3 = A3*Wls3 - b3
norm(r3)

At = [D'.^5 D'.^4 D'.^3 D'.^2 D' ones(size(D))'];
subplot(313)
title('g(x) = a_5x^5 + a_4x^4 + ... + a_0')
hold on
plot(D,At*Wls3,'k-')
plot(X,b3,'kx')


print('res.png','-dpng')
