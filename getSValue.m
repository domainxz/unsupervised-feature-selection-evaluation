function [] = getSValue()
    fid = fopen('datasets.csv','r');
    C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
    ds = C{1};
    m = size(ds, 1);
    for i = 1:m
        filename = sprintf('data/%s.mat', ds{i, 1});
        load(sprintf(filename));
        ZX = zeros(size(X));
        nz = (X ~= 0);
        ZX(nz) = X(nz)./(abs(X(nz)).^0.5);
        ZX = NormalizeFea(ZX, 0);
        save(filename,'X','Y','ZX');
    end
end

