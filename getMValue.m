function [] = getMValue()
    fid = fopen('datasets.csv','r');
    C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
    ds = C{1};
    m = size(ds, 1);
    for i = 1:m
        filename = sprintf('data/%s.mat', ds{i, 1});
        load(sprintf(filename));
        [p, q] = size(X);
        ZX = zeros(p, q);
        for j = 1:p
            minv = min(X(j,:));
            maxv = max(X(j,:));
            if minv ~= maxv
                ZX(j,:) = (X(j,:)-minv)./(maxv-minv);
            else
                ZX(j,:) = zeros(1,q);
            end
        end
        %ZX = NormalizeFea(ZX, 0);
        save(filename,'X','Y','ZX');
    end
end

