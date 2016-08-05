function q2Script()
    %q8Script()
    %return
    A = [1 2 1;2 2 0; -1 -2 -1;2 1 -1]
    B = [-1 2 -3;1 -2 3;2 -4 6;-1 2 -3]
    %q4Script(A)
    '--------------------------'
    q4Script(B)
    return
    q3Script()
    return
    B = getDTFT(4)
    A = getDTFT(8)
    A*[1 0 0 0 0 0 0 0]'
    A*[1 1 1 1 1 1 1 1]'
    [a b] = eig(B)
    2*a(:,1)
    B*a(:,1)
    syms t
    det(eye(4)*t - B)
    roots([1 -2+2i -4-4i 8-8i 16i])
    B*B'
    A*A'
end

function q8Script()
     q1 = [1 0 0 0]'/sqrt(inner8([1 0 0 0]',[1 0 0 0]'))
     e2 = [0 1 0 0]' - inner8([0 1 0 0]',q1)*q1
     q2 = e2/sqrt(inner8(e2,e2))
     c3 = [0 0 1 0]';
     e3 = c3 - inner8(c3,q1)*q1 - inner8(c3,q2)*q2
     q3 = e3/sqrt(inner8(e3,e3))
     c4 = [0 0 0 1]';
     e4 = c4 - inner8(c4,q1)*q1 - inner8(c4,q2)*q2 - inner8(c4,q3)*q3
     q4 = e4/sqrt(inner8(e4,e4))
     O = [q1 q2 q3 q4]
     Dc = [0 1 0 0;0 0 2 0;0 0 0 3;0 0 0 0]
     Do = Dc*O
end

function p = inner8(X,Y)
    B = [-1 0 1 2];
    n = 4;
    p = 0;
    for i = 1:n
        px = 0;
        py = 0;
        for j = 1:n
            px = px + (B(i)^(j-1)*X(j));
            py = py + (B(i)^(j-1)*Y(j)');
        end
        p = p + px*py'; 
    end
    p
end

function q4Script(A)
    format long
    A'*A
    %syms t
    %det(eye(3)*t - A'*A)
    %det(A'*A)
    det(A'*A)
    [a b] = eig(A'*A)
    S = sqrt(98)
    E = [S 0 0;0 0 0;0 0 0]
    V1 = [-0.5;1;-1.5]
    V1 = V1/norm(V1)
    A*(V1+[0;1;0])
    fdsaf

    V = [V1 [2;1;0]/norm([2;1;0]) [-3;0;1]/norm([-3;0;1])]
    U1 = A*V1*S^-1
    U1'*U1
    U1*S*V1'
    Uf = [U1 [1;0;0;0] [0;1;0;0] [0;0;1;0]]
    q1 = Uf(:,1)/norm(Uf(:,1))
    a2 = Uf(:,2) - dot(Uf(:,2),q1)*q1
    q2 = a2/norm(a2)
    a3 = Uf(:,3) - dot(Uf(:,3),q1)*q1 - dot(Uf(:,3),q2)*q2
    q3 = a3/norm(a3)
    a4 = Uf(:,4) - dot(Uf(:,4),q1)*q1 - dot(Uf(:,4),q2)*q2 - dot(Uf(:,4),q3)*q3
    q4 = a4/norm(a4)
    U = [q1 q2 q3 q4]
    U'*U
    U*U'

    %[U,S,V] = svd(A)
end

function q3Script()
    A = [1 2 1;2 2 0;-1 -2+3 -1];
    b = [1;2;2]
    A
    q1 = A(:,1)/norm(A(:,1))
    a2 = A(:,2) - dot(A(:,2),q1)*q1
    q2 = a2/norm(a2)
    a3 = A(:,3) - dot(A(:,3),q1)*q1 - dot(A(:,3),q2)*q2
    q3 = a3/norm(a3)
    Q = [q1 q2 q3]
    R = [norm(A(:,1)) dot(A(:,2),q1) dot(A(:,3),q1); 0 norm(a2) dot(A(:,3),q2); 0 0 norm(a3)] 
    bq = Q'*b
    x3 = bq(3)/R(3,3);
    x2 = (bq(2) - x3*R(2,3))/R(2,2);
    x1 = (bq(1) - x2*R(1,2) - x3*R(1,3))/R(1,1);
    X = [x1 x2 x3]'
    A*X
    b
    Q' 
    Q^-1
    Q*Q'
    '---------------'
    A(:,1)
    u = A(:,1) - norm(A(:,1))*[1 0 0]'
    v = u/norm(u)
    2*v*v'*A
    H1 = (eye(3,3) - 2*v*v')
    An = H1*A
    u = An(2:end,2) - norm(An(2:end,2))*[1 0]'
    v = u/norm(u)
    H2 = [zeros(2,1) (eye(2,2) - 2*v*v')]
    H2 = [1 0 0;H2];

    Q = (H2*H1)'
    R = Q'*A
    A
    bq = Q'*b
    x3 = bq(3)/R(3,3);
    x2 = (bq(2) - x3*R(2,3))/R(2,2);
    x1 = (bq(1) - x2*R(1,2) - x3*R(1,3))/R(1,1);
    X = [x1 x2 x3]'
    A*X
    b

end



function A = getDTFT(N)
    A = zeros(N,N);
    for k = 0:(N-1)
        for n = 0:(N-1)
            A(k+1,n+1) = exp(-i*2*pi*k*n/N);
        end
    end
end




