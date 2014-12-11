%This function is used to calculate any L norm
function norm = lnorm(X, p, q)
    norm = 0;
    m = size(X, 1);
    for i = 1:m
        if q ~= 0 && p ~= 0
            norm = norm + sum(X(i,:).^p)^(q/p);
        elseif q == 0 && p ~= 0 
            norm = norm + (sum((X(i,:).^p))~=0);
        end
    end
    if q ~= 0 && p ~= 0
        norm = norm ^ (1/q);
    end
end

