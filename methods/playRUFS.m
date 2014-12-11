function [exit_code] = optRUFS(data)
addpath('methods');
eval(['method = @RUFS;']);
rp = [-6:2:6];
options.nu = 1;
options.MaxIter = 10;
options.epsilon = 1e-4;
options.verbose = 0;

Woptions.k = 5;
Woptions.WeightMode = 'Binary';
W = constructW(data, Woptions);
D = diag(sum(W,2));
L = D - W;
F = rand(size(data));
for alpha=rp
    options.alpha = 10^alpha;
    for beta=rp
        options.beta  = 10^beta;
        [fsm,~,~] = method(data, L, F, options);
    end
end
exit_code=1;
end

