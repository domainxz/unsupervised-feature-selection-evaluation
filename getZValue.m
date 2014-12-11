function [] = getZValue()
    fid = fopen('datasets.csv','r');
    C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
    ds = C{1};
    m = size(ds, 1);
    for i = 1:m
        filename = sprintf('data/%s.mat', ds{i, 1});
        load(sprintf(filename));
        ZX = zscore(X, [], 2);
        save(filename,'X','Y','ZX');
    end
end

