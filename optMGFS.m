function [exit_code] = optMGFS()
addpath('methods');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
ds = C{1};
fclose(fid);
m = size(ds, 1);
%eval('method = @MGFS;');
eval('method = @MGFS;');
fprintf(1, 'method : %s\n', func2str(method));
k1 = 1;
k2 = 0;
k3 = 0;
p  = 1;
rp = -6:2:6;
para.k = 5;
para.lamda = 1000;
for i = 1:m
    load(sprintf('data/%s.mat', ds{i, 1}));
    fprintf(1, sprintf('dataset : %s\n', ds{i, 1}));
    load(sprintf('benchmarks/%s.mat', ds{i, 1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    M = LocalDisAna(ZX, para);
    Woptions.k = size(ZX,2);
	Woptions.WeightMode = 'Cosine';
    Woptions.t = mean(mean(EuDist2(ZX')));
    W = constructW(ZX', Woptions);
    D = full(diag(sum(W,2)));
    L = D - W;
    X2 = sum(ZX.^2, 1);
    N = size(ZX, 2);
    distance = repmat(X2, N, 1) + repmat(X2', 1, N)-2 * ZX' * ZX;
    [~,index] = sort(distance);
    nb = index(1:6, :);
    S = calcu_opt_matrix(X, nb, 3);
    A = ZX*(k1*M+k2*L+k3*S)./(k1+k2+k3)*ZX';
    for alpha=rp
        [W, ~] = method(A, size(benchmark2,2), 10^alpha, p);
        %[W, ~] = method(A, size(benchmark2,2), 10^alpha);
        score= sum(W.*W, 2);
        [~, index] = sort(score, 'descend');
        for num=feature_num
            result = ZX(index(1:num,:),:);
            filename = sprintf('features/%s-%s-%d-%s-%s-%d.mat', ds{i, 1}, func2str(method), alpha, sprintf('%s-%s-%s', num2str(k1), num2str(k2), num2str(k3)), num2str(p), num);
            eval(['save ' filename ' result']);
        end
    end
end

[a, ~] = size(ds);
b = length(rp);
iterval = 30;
map = zeros(a, 6, b, iterval);
minf = zeros(a, 6, b, iterval);
fprintf(1, 'Do the evaluation\n');

for i = 1:a
    load(sprintf('benchmarks/%s.mat', ds{i,1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    for j = 1:b
        for fnum=1:6
            filename = sprintf('features/%s-%s-%d-%s-%s-%d.mat', ds{i, 1}, func2str(method),rp(j), sprintf('%s-%s-%s', num2str(k1), num2str(k2), num2str(k3)), num2str(p), feature_num(fnum));
            load(filename);
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
filename = sprintf('results/%s-%s-%s.mat', func2str(method), sprintf('%s-%s-%s', num2str(k1), num2str(k2), num2str(k3)), num2str(p));
eval(['save ' filename ' map minf;']);

fprintf(1, 'Generate the csv file\n');
load(sprintf('results/%s-%s-%s.mat', func2str(method), sprintf('%s-%s-%s', num2str(k1), num2str(k2), num2str(k3)), num2str(p)));
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
fid = fopen(sprintf('%s-%s-%s.csv', func2str(method), sprintf('%s-%s-%s', num2str(k1), num2str(k2), num2str(k3)), num2str(p)), 'w');
for i = 1:a*2
    for j = 1:2
        fprintf(fid,'%0.1f,',forms(i,j)*100);
    end
    fprintf(fid,'\r\n');
end
fclose(fid);
exit_code=1;
end
