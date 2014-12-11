function [idx] = MAXVAR(X, Y, W, k)
    fvar = std(X);
    [~, idx] = sort(fvar, 'descend');
end

