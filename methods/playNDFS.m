function [ output_args ] = playNDFS(data)
%PLAYNDFS Summary of this function goes here
%   Detailed explanation goes here
eval(['method = @NDFS;']);
rp = [-6:2:6];
[M, N] = size(data);
Woptions.k = 5;
Woptions.WeightMode = 'Binary';
W = constructW(data, Woptions);
D = diag(sum(W,2));
L = D - W;
Y = Eigenmap(W, M);
F = Y*(Y'*Y)^(-0.5);
A = rand(N, N);
for alpha=rp
    for beta=rp
        [~,fsm] = method(data', L, F, A, 20, 10^alpha, 10^beta, 10^8);
    end
end
end

