function f = OptimalPF(x, M, dim)
% x已经排序好
len = 0;
for i = 1:length(x)
    if x(i, dim+M+1) == 1
        len = len + 1;
    else
        break;
    end
end
f(1, 1) = sum(x(1:len, dim+1)) / len;
f(1, 2) = sum(x(1:len, dim+2)) / len;
% f(1, 1) = min(x(1:len, dim+1));
% f(1, 2) = min(x(1:len, dim+2));