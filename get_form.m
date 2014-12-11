function [] = get_form()
fprintf(1, 'Generate the csv file\n');
fid = fopen('datasets.csv','r');
C = textscan(fid, repmat('%s',1, 2), 'delimiter',',', 'CollectOutput',true);
rlist = C{1};
fclose(fid);
rows = size(rlist, 1);

fid = fopen('outputs.csv','r');
C = textscan(fid, repmat('%s',1, 1), 'delimiter',',', 'CollectOutput',true);
clist = C{1};
fclose(fid);
columns = size(clist, 1);

form1 = zeros(rows,2*columns);
form2 = zeros(rows,2*columns);

for i = 1:columns
    load(sprintf('results/%s.mat', clist{i, 1}));
    dimension = size(size(map)',1);
    if dimension ~= 3
        form1(:,i*2-1) = nanmean(map,dimension);
        form1(:,i*2) = nanstd(map,[],dimension);
        form2(:,i*2-1) = nanmean(minf,dimension);
        form2(:,i*2) = nanstd(minf,[],dimension);
    else
        mean_map = nanmean(map,dimension);
        std_map = nanstd(map,[],dimension);
        mean_minf = nanmean(minf,dimension);
        std_minf = nanstd(minf,[],dimension);
        for j=1:rows
            [form1(j,i*2-1), index] = max(mean_map(j,:));
            form1(j,i*2) = std_map(j,index);
            [form2(j,i*2-1), index] = max(mean_minf(j,:));
            form2(j,i*2) = std_minf(j,index);
        end
    end
end

fid = fopen('result.csv','w');
for i = 1:rows
    for j = 1:2*columns
        fprintf(fid,'%0.1f,',form1(i,j)*100);
    end
    fprintf(fid,'\r\n');
end
fclose(fid);

fid = fopen('result.csv','a');
for i = 1:rows
    for j = 1:2*columns
        fprintf(fid,'%0.1f,',form2(i,j)*100);
    end
    fprintf(fid,'\r\n');
end
fclose(fid);

end

