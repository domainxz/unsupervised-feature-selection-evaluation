function [Features] = doNGFS(X, Y, L, fnum, k, alpha)
    Features = NGFS(X', Y, L, fnum, k, alpha, 50);
end

