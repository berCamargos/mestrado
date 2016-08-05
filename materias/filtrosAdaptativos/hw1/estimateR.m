function e = estimateR(n,nd,M,Rr,pr)
    H = [0.3887;1;0.3887];
    a = 2*(rand(n+20,1)>0.5)-1; 
    d = a(end-nd-n+1:end-nd);
    ni = 0.001*randn(n,1);
    u = a(end-n+1:end)*H(1) + a(end-1-n+1:end-1)*H(2) + a(end-2-n+1:end-2)*H(3) + ni;
    r = xcorr(u,u,M-1,'biased');
    ru = r(M:end);
    R = toeplitz(ru);
    rdu = xcorr(d,u,M-1,'biased');
    p=rdu(M:end);
    e(1) = norm(R-Rr);
    e(2) = norm(p-pr);
end


