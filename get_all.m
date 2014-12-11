function [exit_code] = get_all()
addpath('methods');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
datasets = C{1};
fclose(fid);
[a, b] = size(datasets);
iterval = 30;
map = zeros(a,iterval);
minf = zeros(a,iterval);
for i = 1:a
    load(sprintf('benchmarks/%s.mat', datasets{i,1}));
    load(sprintf('data/%s.mat', datasets{i,1}));
    [m, n] = size(benchmark2);
    for b = 1:iterval
        original = k_means_quick(X', 'random', n);
        cindex = bestMap(benchmark1, original);
        cmatrix = zeros(m,n);
        for k = 1:m
            cmatrix(k,cindex(m,1)) = 1;
        end
        map(i,b) = calACC(benchmark1, cindex);
        minf(i,b) = MutualInfo(original, benchmark1);
    end
end
filename = sprintf('results/%s.mat', 'all');
eval(['save ' filename ' map minf']);
exit_code = 1;
end
