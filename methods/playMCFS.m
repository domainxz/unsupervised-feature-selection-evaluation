function [exit_code] = playMCFS(data)
%PLAYMCFS Summary of this function goes here
%   Detailed explanation goes here
Woptions.k = 5;
Woptions.WeightMode = 'Binary';
W = constructW(data, Woptions);
options = [];
options.k = 5;
options.W = W;
[FeaIndex,FeaNumCandi] = MCFS(data,350,options);
for i = 1:length(FeaNumCandi)
    SelectFeaIdx = FeaIndex{i};
end
exit_code = 1;
end

