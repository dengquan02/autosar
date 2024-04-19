function nsga_2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
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
    max_range(i) = max_range(i) * 6; % 映射内核编号上界
	max_range(i + ThreadSize) = max_range(i + ThreadSize) * 50; % 优先级上界
	max_range(i + 2*ThreadSize) = CET(i,2); % 周期：即偏移量上界（偏移量必须小于周期）
end %上界 生成1*30的个体向量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chromosome = initialize_variables(pop, M, V, min_range, max_range);%初始化种群
load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v7.mat', 'chromosome');
chromosome = non_domination_sort_mod(chromosome, M, V);%对初始化种群进行非支配快速排序和拥挤度计算
% 1-30,31-60,61-90列：映射内核，优先级，偏移量；
% 91,92,93,94列：最大cpu负载，加权最坏响应时间,帕累托前沿等级,拥挤度（目标函数距离之和）

OptiPara(1,1) = min(chromosome(:,V+1));
OptiPara(1,2) = min(chromosome(:,V+2));
OptiPara(1,3:4) = OptimalPF(chromosome,M,V);

for i = 1 : gen
    pool = round(pop/2);%round() 四舍五入取整 交配池大小
    tour = 2;%竞标赛  参赛选手个数
    parent_chromosome = tournament_selection(chromosome, pool, tour);%竞标赛选择适合繁殖的父代
    mu = 20;%交叉和变异算法的分布指数
    mum = 20;
    offspring_chromosome = genetic_operator(parent_chromosome,M,V,mu,mum,min_range,max_range);%进行交叉变异产生子代 该代码中使用模拟二进制交叉和多项式变异
    [main_pop,~] = size(chromosome);%父代种群的大小
    [offspring_pop,~] = size(offspring_chromosome);%子代种群的大小
    
    clear temp
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = offspring_chromosome;%合并父代种群和子代种群
    intermediate_chromosome = non_domination_sort_mod(intermediate_chromosome, M, V);%对新的种群进行快速非支配排序
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop);%选择合并种群中前N个优先的个体组成新种群
    
    if ~mod(i,30)
        clc;
        fprintf('%d generations completed\n',i);
    end
    OptiPara(i+1,1) = min(chromosome(:,V+1));
    OptiPara(i+1,2) = min(chromosome(:,V+2));
    OptiPara(i+1,3:4) = OptimalPF(chromosome,M,V);
end

save('OutputConfig.mat',"chromosome");
save('OutputConfig.mat',"OptiPara",'-append');

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
yyaxis right
plot(0:gen, OptiPara(:,2),"LineWidth",1.5);
ylabel('RT (ms)','FontSize',14);

end

