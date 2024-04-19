function PrintData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load OutputConfig_v1 chromosome;
% load OutputConfig_v1 OptiPara;
% load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v5.mat', 'chromosome');
% load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v5.mat', 'OptiPara');
load OutputConfig_mn chromosome;
load OutputConfig_mn OptiPara;

load matlab CET;
gen = length(OptiPara) - 1; %迭代次数
V = 90; %维度（决策变量的个数）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

len = 0;
for i = 1:length(chromosome)
    if chromosome(i, V+2+1) == 1
        len = len + 1;
    else
        break;
    end
end
figure(1)
% plot(chromosome(1:len,V + 1),chromosome(1:len,V + 2),'k*','MarkerSize',10);
c = linspace(8,10,len);
scatter(chromosome(1:len,V + 1),chromosome(1:len,V + 2),90,c,'filled','o');
xlabel('CPULoad\_max (%)'); ylabel('weighted\_WCRT (ms)');
% xlim([35 100]);
% ylim([1.3 3]);
% title('Pareto Front','FontSize',14);
title('Pareto Front','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );

figure(2)
yyaxis left
plot(0:gen, OptiPara(:,2),"LineWidth",1);
xlabel('Generations','FontSize',14); 
xlim([-10 1010]);
ylabel('weighted\_WCRT (ms)','FontSize',14);
% ylabel('weighted\_WCRT (ms)','FontSize',14,'Times New Roman','FontWeight','bold');
% ylim([1.3 3]);
yyaxis right
plot(0:gen, OptiPara(:,1),"LineWidth",1);
ylabel('CPULoad\_max (%)','FontSize',14);
% ylim([35.6 36.5]);

% figure(3)
% yyaxis left
% plot(0:gen, OptiPara(:,4),"LineWidth",1);
% xlabel('Generations','FontSize',14); 
% xlim([-10 1010]);
% ylabel('weighted\_WCRT (ms)','FontSize',14);
% % ylabel('weighted\_WCRT (ms)','FontSize',14,'Times New Roman','FontWeight','bold');
% % ylim([1.3 3]);
% yyaxis right
% plot(0:gen, OptiPara(:,3),"LineWidth",1);
% ylabel('CPULoad\_max (%)','FontSize',14);
% % ylim([35.6 36.5]);

end