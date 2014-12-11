function [X, obj]= MGFS(A, k, r, p, X0)
NIter = 20;
hp = p / 2;
n = size(A, 2);
if nargin < 5
    d = ones(n,1);
else
    Xi = (sum(X0.*X0,2)+eps).^(1-hp);
    d = hp./(Xi);
end;

for iter = 1:NIter
    D = diag(d);
    M = A+r*D;
    M = max(M,M');
    [evec, eval] = eig(M);
    eval = diag(eval);
    [~, idx] = sort(eval);
    X = evec(:,idx(1:k));
    
    Xi = (sum(X.*X,2)+eps).^(1-hp);
    d = hp./(Xi);
    
    obj(iter) = trace(X'*A*X) + r*sum(Xi);
    if iter ~= 1 && abs(obj(iter) - obj(iter-1)) < 10^-6
        break;
    end
end
%plot(obj);
