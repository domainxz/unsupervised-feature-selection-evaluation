function [exit_code] = playUSFS(data)
addpath('methods');
eval(['method = @call_USFSFN;']);

Woptions.k = 5;
Woptions.WeightMode = 'Binary';
W = constructW(data, Woptions);
D = diag(sum(W,2));
L = D - W;
result = method(data, L, 20, size(data, 2), 10);
exit_code=1;
end