function [] = getLValue()
    fid = fopen('datasets.csv','r');
    C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
    ds = C{1};
    m = size(ds, 1);
    for i = 1:m
        filename = sprintf('data/%s.mat', ds{i, 1});
        load(sprintf(filename));
        [p, q] = size(X);
        ZX = zeros(p, q);
        for j = 1:q
            ZX(:,j) = X(:,j)/norm(X(:,j),1);
        end
        save(filename,'X','Y','ZX');
    end
end

