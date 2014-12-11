function [exit_code] = optRUFS()
addpath('methods');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
ds = C{1};
fclose(fid);
m = size(ds, 1);
eval('method = @RUFS;');
fprintf(1, 'method : %s\n', func2str(method));
rs = -6:2:6;
options.nu = 1;
options.MaxIter = 10;
options.epsilon = 1e-4;
options.verbose = 0;

for i = 1:m
    load(sprintf('data/%s.mat', ds{i, 1}));
    fprintf(1, 'dataset : %s\n', ds{i, 1});
    load(sprintf('benchmarks/%s.mat', ds{i, 1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    Woptions.k = 5;
	Woptions.WeightMode = 'HeatKernel';
    Woptions.t = mean(mean(EuDist2(ZX')));
    W = constructW(ZX', Woptions);
    D = full(diag(sum(W,2)));
    L = D - W;
    F = rand(size(benchmark2));
    for alpha=rs
        options.alpha = 10^alpha;
        for beta=rs
			options.beta  = 10^beta;
            [fsm,~,~] = method(ZX', L, F, options);
            for num=feature_num
                [~, index] = sort(sum(abs(fsm),2), 'descend');
                result = ZX(index(1:num,:),:);
                filename = sprintf('features/%s-%s(%d_%d)-%d.mat', ds{i, 1}, func2str(method), alpha, beta, num);
                eval(['save ' filename ' result']);
            end
        end
    end
end

fprintf(1, 'Do the evaluation\n');
[a, ~] = size(ds);
b = length(rs);
iterval = 30;
map = zeros(a,6,b*b,iterval);
minf = zeros(a,b*b,iterval);

for i = 1:a
    load(sprintf('benchmarks/%s.mat', ds{i,1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    n = size(benchmark2, 2);
    for x=1:b
        for y=1:b
            for fnum = 1:6
                load(sprintf('features/%s-%s(%d_%d)-%d.mat', ds{i,1}, func2str(method), rs(x), rs(y), feature_num(fnum)));
                for iter = 1:iterval
                    original = k_means_quick(result', 'random', n);
                    cindex = bestMap(benchmark1, original);
                    map(i,fnum,x*b+y-b,iter) = calACC(benchmark1, cindex);
                    minf(i,fnum,x*b+y-b,iter) = MutualInfo(original, benchmark1);
                end
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

exit_code=1;
end

