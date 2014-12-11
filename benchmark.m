function [exit_code] = benchmark()
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
ds = C{1};
fclose(fid);
[p, q] = size(ds);
for k = 1:p
     load(sprintf('data/%s.mat', ds{k, 1}));
     [m, n] = size(Y);
     benchmark1 = zeros(m,1);
     benchmark2 = zeros(m,n);
     for i = 1:m
         if n~=1
             for j = 1:n
                 if Y(i,j) == 1
                     benchmark1(i,1) = j;
                     benchmark2(i,j) = 1;
                     break;
                 end
             end
         else
             benchmark1(i,1) = Y(i,1);
             benchmark2(i,Y(i,1)) = 1;
         end
     end
     filename = sprintf('benchmarks/%s.mat', ds{k, 1});
     eval(['save ' filename ' benchmark1 benchmark2']);
end
exit_code = 1;
end

