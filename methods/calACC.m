function [acc] = calACC(l1, l2)
sum = 0;
m = size(l1,1);
for i = 1:m
    %sprintf('%d:%d',l1(m,1),l2(m,1))
    if l1(i,1) == l2(i,1)
        sum = sum + 1;
    end
end
acc = sum / m;
end