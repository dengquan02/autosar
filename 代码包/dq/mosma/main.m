function main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all;
load matlab CET;
pop = 500; %种群数量
gen = 1000; %迭代次数
M = 2; %目标函数数量
OptiPara = zeros(gen,M); % 记录每次迭代的群落目标函数平均值
V = 90; %维度（决策变量的个数）
ThreadSize = V/3;
min_range = zeros(1, V); %下界 生成1*30的个体向量 全为0
max_range = ones(1,V); 
for i = 1:ThreadSize
    max_range(i) = max_range(i) * 6; % 映射内核编号上界 6
	max_range(i + ThreadSize) = max_range(i + ThreadSize) * 50; % 优先级上界 50
	max_range(i + 2*ThreadSize) = CET(i,2); % 周期：即偏移量上界（偏移量必须小于周期）
end %上界 生成1*30的个体向量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [chromosome, OptiPara] = MOSMA(V, M, min_range, max_range, pop, gen, 10);
chromosome = initialize_variables(pop, M, V, min_range, max_range);%初始化种群
chromosome = non_domination_sort_mod(chromosome, M, V);%对初始化种群进行非支配快速排序和拥挤度计算
% % 1-30,31-60,61-90列：映射内核，优先级，偏移量；
% % 91,92,93,94列：最大cpu负载，加权最坏响应时间,帕累托前沿等级,拥挤度（目标函数距离之和）

% save('OutputConfig.mat',"chromosome");
% save('OutputConfig.mat',"OptiPara",'-append');

% 计算Pareto Optimal Front的长度
len = 0;
for i = 1:pop
    if chromosome(i, V+M+1) == 1
        len = len + 1;
    else
        break;
    end
end
figure(1)
plot(chromosome(1:len,V + 1),chromosome(1:len,V + 2),'*','MarkerSize',10);
xlabel('CPUload\_max'); ylabel('RT\_wavg');
title('Pareto Optimal Front');

figure(2)
yyaxis left
plot(0:gen, OptiPara(:,1),"LineWidth",1.5);
xlabel('Generations  ','FontSize',14); 
ylabel('CPULoad (%)','FontSize',14);
% xlim([-10 2000]);
yyaxis right
plot(0:gen, OptiPara(:,2),"LineWidth",1.5);
ylabel('RT (ms)','FontSize',14);

end

