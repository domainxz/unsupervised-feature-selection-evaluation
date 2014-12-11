function [idx] = doSpec(X, Y, W, k)
    Pram.style = 1;
    Pram.expLam = mean(mean(EuDist2(X)));
    Pram.function = 3;
    [fw,~] = fsSpectrum(W, X, Y, Pram);
    [~, idx] = sort(fw, 'descend');
end

