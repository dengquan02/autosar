function plusChromosome

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load matlab CET;
clc;
V = 90; %维度（决策变量的个数）
M = 2;
ThreadSize=30;
pop = 500;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 在一张图中比较两个前沿
load('D:\study\autosar\代码包\dq\nsga\OutputConfig_v1.mat', 'chromosome');
x1 = chromosome;
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
% figure(1)
% % scatter(x1(1:len1,V + 1),x1(1:len1,V + 2),90,linspace(6,6,len1),'filled','o');
% % hold on;
% % scatter(x2(1:len2,V + 1),x2(1:len2,V + 2),90,linspace(9,9,len2),'filled','o');
% scatter(x1(1:len1,V + 1),x1(1:len1,V + 2),90,'filled','o');
% hold on;
% scatter(x2(1:len2,V + 1),x2(1:len2,V + 2),90,'filled','o');
% xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% % xlim([35 100]);
% % ylim([1.3 3]);
% legend('NSGA-II','MOSMA');
% title('Pareto Front','FontSize',14,'FontName','Times New Roman','FontWeight','bold');
% % text(60,0.8,'PF of NSGA-II','Color','b','FontSize',12,'FontWeight','bold')
% % text(45,5,'PF of MOSMA','Color','r','FontSize',12,'FontWeight','bold')


%% 合并两个前沿，再进行非支配排序，输出新的前沿
x = x1;
x(pop+1:pop*2,:) = x2;
x = non_domination_sort_mod(x, M, V);
len = 0;
for i = 1:length(x)
    if x(i, V+M+1) == 1
        len = len + 1;
    else
        break;
    end
end
%% mosma nsga
load OutputConfig_mn chromosome;
mn = chromosome; lenmn = 500;
%% nsga mosma
load OutputConfig_nm chromosome;
nm = chromosome; lennm = 498;

% figure(1)
% scatter(x1(1:len1,V + 1),x1(1:len1,V + 2),90,linspace(6,6,len1),'filled','o');
% xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% xlim([30 100]);
% ylim([0.5 5]);
% title('PF of method1','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );
% 
% figure(2)
% scatter(nm(1:lennm,V + 1),nm(1:lennm,V + 2),90,linspace(7,7,lennm),'filled','o');
% xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% xlim([30 100]);
% ylim([0.5 5]);
% title('PF of method2','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );
% 
% figure(3)
% scatter(mn(1:lenmn,V + 1),mn(1:lenmn,V + 2),90,linspace(9,9,lenmn),'filled','o');
% xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% xlim([30 100]);
% ylim([0.5 5]);
% title('PF of method3','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );

figure(4)
scatter(x1(1:len1,V + 1),x1(1:len1,V + 2),90,'filled','o');
hold on;
scatter(x2(1:len2,V + 1),x2(1:len2,V + 2),90,'filled','o');
% hold on;
% scatter(x(1:len,V + 1),x(1:len,V + 2),90,'filled','o');
% hold on;
% scatter(nm(1:lennm,V + 1),nm(1:lennm,V + 2),90,'filled','o');
% hold on;
% scatter(mn(1:lenmn,V + 1),mn(1:lenmn,V + 2),90,'filled','o');
xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
xlim([30 100]);
ylim([0.5 5]);
legend('NSGA-II','MOSMA');
% legend('NSGA-II','MOSMA','method1','method2','method3');
title('Pareto Front','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );

end