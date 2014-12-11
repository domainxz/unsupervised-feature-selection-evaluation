function [idx] = doLScore(X, Y, W, k)
    fvar = LaplacianScore(X, W);
    [~, idx] = sort(fvar, 'descend');
end