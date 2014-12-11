function [exit_code] = optOthers()
addpath('methods');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
ds = C{1};
fclose(fid);
fid = fopen('methods.csv','r');
C = textscan(fid, repmat('%s',1, 1), 'delimiter',',', 'CollectOutput',true);
ms = C{1};
fclose(fid);
m = size(ds, 1);
p = size(ms, 1);

for i = 1:m
    load(sprintf('data/%s.mat', ds{i, 1}));
    fprintf(1, 'dataset : %s\n', ds{i, 1});
    load(sprintf('benchmarks/%s.mat', ds{i, 1}));
    eval(['feature_num = ' ds{i, 2} ';']);
    Woptions.k = 5;
    Woptions.t = mean(mean(EuDist2(ZX')));
    Woptions.WeightMode = 'HeatKernel';
    W = constructW(ZX', Woptions);
    for j = 1:p
        eval(['method = @' ms{j,1} ';']);
        fprintf(1, 'method : %s\n', ms{j,1});
        select_idx = method(ZX', benchmark2, W, feature_num(length(feature_num)));
        for num=feature_num
            filename = sprintf('features/%s-%s-%d.mat', ds{i, 1}, func2str(method), num);
            result = ZX(select_idx(1:num),:);
            save(filename, 'result');
        end
    end
end
get_result;
get_form;
%sendEmail('domainxz@gmail.com');
exit_code = 1;
end