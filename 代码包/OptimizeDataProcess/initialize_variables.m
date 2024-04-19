function f = initialize_variables(N, M, V, min_range, max_range)%f是一个由种群个体组成的矩阵
%load matlab CET;
min = min_range;
max = max_range;
ThreadSize = V/3;
K = M + V;%%K是数组的总元素个数。为了便于计算，决策变量和目标函数串在一起形成一个数组。  
tmp = zeros(1,V);
tmp(1:ThreadSize) = CET(:,3);
tmp(ThreadSize+1:2*ThreadSize) = CET(:,4);
tmp(2*ThreadSize+1:3*ThreadSize) = CET(:,5);
%对于交叉和变异，利用目标变量对决策变量进行选择
for i = 1 : N
    for j = 1 : V
        f(i,j) = min(j) + (max(j) - min(j))*rand(1);%f(i j)表示的是种群中第i个个体中的第j个决策变量，
                                                    %这行代码为每个个体的所有决策变量在约束条件内随机取值
    end
    if ~mod(i,3)
        f(i,1:V) = tmp;
    end
    f(i,V + 1: K) = evaluate_objective(f(i,:), M, V); % M是目标函数数量 V是决策变量个数
                                                    %为了简化计算将对应的目标函数值储存在染色体的V + 1 到 K的位置。
end