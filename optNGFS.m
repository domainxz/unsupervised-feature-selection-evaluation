function [exit_code] = optNGFS()
addpath('methods');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
ds = C{1};
fclose(fid);
m = size(ds, 1);
eval('method = @doNGFS;');
fprintf(1,'method : %s\n', func2str(method));
rs = -6:2:6;

for i = 1:m
    load(sprintf('data/%s.mat', ds{i, 1}));
    fprintf(1,'dataset : %s\n', ds{i, 1});
    load(sprintf('benchmarks/%s.mat', ds{i, 1}));
    Woptions.k = 5;
	Woptions.WeightMode = 'HeatKernel';
    Woptions.t = mean(mean(EuDist2(ZX')));
    W = constructW(ZX', Woptions);
    D = full(diag(sum(W,2)));
    L = D - W;
    eval(['feature_num = ' ds{i, 2} ';']);
    for r = rs
        for num=feature_num
            result = method(ZX', benchmark2, L, num, size(benchmark2, 2), 10^r);
            filename = sprintf('features/%s-%s-%d(%d).mat', ds{i, 1}, func2str(method), num, r);
            eval(['save ' filename ' result']);
        end
    end
end

[a, ~] = size(ds);
b = length(rs);
iterval = 30;
map = zeros(a, 6, b, iterval);
minf = zeros(a, 6, b, iterval);
fprintf(1, 'Do the evaluation\n');

for i = 1:a
    load(sprintf('benchmarks/%s.mat', ds{i,1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    for j = 1:b
        for fnum=1:6
            load(sprintf('features/%s-%s-%d(%d).mat', ds{i,1}, func2str(method), feature_num(fnum), rs(j)));
            n = size(benchmark2, 2);
            for iter = 1:iterval
                original = k_means_quick(result', 'random', n);
                cindex = bestMap(benchmark1, original);
                map(i,fnum,j,iter) = calACC(benchmark1, cindex);
                minf(i,fnum,j,iter) = MutualInfo(original, benchmark1);
            end
        end
    end
end
filename = sprintf('results/%s.mat', func2str(method));
eval(['save ' filename ' map minf;']);

fprintf(1, 'Generate the csv file\n');
load(sprintf('results/%s.mat', func2str(method)));
forms = zeros(a*2,2);
mean_map = nanmean(map,4);
std_map = nanstd(map,[],4);
mean_minf = nanmean(minf,4);
std_minf = nanstd(minf,[],4);
for i=1:a
    ds_mean_map = mean_map(i,:);
    ds_std_map = std_map(i,:);
    ds_mean_minf = mean_minf(i,:);
    ds_std_minf = std_minf(i,:);
    [forms(i,1), index] = max(ds_mean_map);
    forms(i,2) = ds_std_map(index);   
    [forms(i+a,1), index] = max(ds_mean_minf); 
    forms(i+a,2) = ds_std_minf(index);
end
fid = fopen(sprintf('%s-reg.csv', func2str(method)), 'w');
for i = 1:a*2
    for j = 1:2
        fprintf(fid,'%0.1f,',forms(i,j)*100);
    end
    fprintf(fid,'\r\n');
end
fclose(fid);
%sendEmail('domainxz@gmail.com');
exit_code=1;
end

