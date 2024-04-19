function Untitled

%% 在一张图中比较两个前沿
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

x1 = initialize_variables(50, M, V, min_range, max_range);%初始化种群
x1 = non_domination_sort_mod(x1, M, V);%对初始化种群进行非支配快速排序和拥挤度计算
load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v7.mat', 'chromosome');
x2 = chromosome;

len1 = 0;
for i = 1:length(x1)
    if x1(i, V+2+1) == 1
        len1 = len1 + 1;
    else
        break;
    end
end
len2 = 0;
for i = 1:length(x2)
    if x2(i, V+2+1) == 1
        len2 = len2 + 1;
    else
        break;
    end
end
figure(1)
scatter(x1(1:len1,V + 1),x1(1:len1,V + 2),90,'filled','o');
hold on;
scatter(x2(1:len2,V + 1),x2(1:len2,V + 2),90,'filled','o');
xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% xlim([35 100]);
% ylim([1.3 3]);
legend('优化前','优化后');
title('Pareto Front','FontSize',14,'FontName','Times New Roman','FontWeight','bold');

end