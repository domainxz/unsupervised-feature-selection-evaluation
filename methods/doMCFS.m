function [idx] = doMCFS(X, Y, W, k)
options = [];
options.k = 5;
options.W = W;
[idx,~] = MCFS(X, k, options);
idx = idx{1,1};
end

