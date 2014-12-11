function [ output_args ] = playUDFS( data )
%PLAYUDFS Summary of this function goes here
%   Detailed explanation goes here

Woptions.k = 5;
Woptions.WeightMode = 'Binary';
W = constructW(data, Woptions);
D = diag(sum(W,2));
L = D - W;
A = data'*L*data;
[W, ~]=LquadR21_reg(A, 350, 10);
end

