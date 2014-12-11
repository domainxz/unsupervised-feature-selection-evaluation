function [] = getMNValue()
    fid = fopen('datasets.csv','r');
    C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
    ds = C{1};
    m = size(ds, 1);
    for i = 1:m
        filename = sprintf('data/%s.mat', ds{i, 1});
        load(sprintf(filename));
        [p, q] = size(X);
        ZX = zeros(p, q);
        means = mean(X,2);
        for j = 1:p
            ZX(j,:) = X(j,:)-means(j);
        end
%         means = mean(X);
%         for j = 1:q
%             ZX(:,j) = ZX(:,j)-means(j);
%         end
        ZX = NormalizeFea(ZX, 0);
        save(filename,'X','Y','ZX');
    end
end

