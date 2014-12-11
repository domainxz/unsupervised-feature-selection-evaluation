function [exit_code] = get_result()
fprintf(1, 'Do the evaluation\n');
addpath('methods');
fid = fopen('methods.csv','r');
C = textscan(fid, repmat('%s',1, 1), 'delimiter',',', 'CollectOutput',true);
ms = C{1};
fclose(fid);
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
datasets = C{1};
fclose(fid);
[a, ~] = size(datasets);
iterval = 30;
for mn = 1:size(ms,1)
    map = zeros(a,6,iterval);
    minf = zeros(a,6,iterval);
    methods = ms{mn,1};
    for i = 1:a
        load(sprintf('benchmarks/%s.mat', datasets{i,1}));
        eval(['feature_num = ' datasets{i, 2} ';']);
        for j = 1:6
            load(sprintf('features/%s-%s-%d.mat', datasets{i,1}, methods, feature_num(j)));
            n = size(benchmark2, 2);
            for b = 1:iterval
                original = k_means_quick(result', 'random', n);
                cindex = bestMap(benchmark1, original);
                map(i,j,b) = calACC(benchmark1, cindex);
                minf(i,j,b) = MutualInfo(original, benchmark1);
            end
        end
    end
    filename = sprintf('results/%s.mat', methods);
    eval(['save ' filename ' map minf;']);
end

exit_code = 1;
end
