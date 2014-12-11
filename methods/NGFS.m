function [Features] = NGFS(X, Y, L, fnum, k, alpha, maxiter)
% USFSFN Summary of this function goes here
%   X, data matrix, one column represents an instance
%   L, Laplacian Matrix
%   fnmu, the number of selected features
%   k, the number of expected clusters
%   rou, mu, alpha are the regular parameters
%   maxiter, the maximum number of iteration
rou = 1.05;
mu  = 0.0001;
[m, n] = size(X);
Lambda = ones(n, k);
Sigma  = ones(m, k);
Omega  = ones(n, k);
A = rand(m, k);
F = eye(size(Y));
Z = F;
NI = eye(n, k)*-1;
invX = eye(m) / (X*X'+eye(m));
AL = alpha*L;
flist = 1:fnum;
for iter = 1:maxiter
    %step 1 : update matrix E
    E = mu/(2+mu)*(X'*A-F-Lambda/mu);
    muE = mu * E;
    %step 2 : updata matrix B, A
    At = A + Sigma/mu;
	[~, q] = sort(sum(abs(At), 2), 'descend');
	B = zeros(m, k);
    B(q(flist),:)=At(q(flist),:);
    A = invX * (X*(E+F+Lambda/mu)+B-Sigma/mu);
    XA = X' * A;
    muXA = mu * XA;
    %step 3 update F, Z
    [U, ~, V] = svd(AL*Z + muE - muXA + Lambda + Omega - mu * Z);
    F = U*NI*V';
    muF = mu * F;
    Z = F - AL*F/mu + Omega/mu;
    Z(Z<0) = 0;
    muZ = mu * Z;
    %step 4 update regualr parameters
    Lambda = Lambda + muE - muXA + muF;
    Sigma  = Sigma + mu * (A - B);
    Omega  = Omega + muF - muZ;
    mu = min(10^10, rou*mu);
	v2 = norm(XA - F, 'fro')^2+trace(F'*AL*F);
    objvalues(iter,1) = v2;
    if iter ~= 1 && abs(objvalues(iter-1,1)-v2) < 0.001
        break;
    end
end
Features = X(q(flist),:);
end

