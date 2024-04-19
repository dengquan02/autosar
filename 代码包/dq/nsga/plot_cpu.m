function plot_cpu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load OutputConfig_v1 chromosome;
load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v5.mat', 'chromosome');
load matlab CET;
load origin ans;
clc;
V = 90; %维度（决策变量的个数）
ThreadSize=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chromosome = sortrows(chromosome, 91);

% dataset(1,:) = cpurt(ans);
% dataset(2,:) = cpurt(chromosome(2,:));
% dataset(3,:) = cpurt(chromosome(18,:));
% ch = chromosome(381,:);
% ch(22) = 3.3;
% dataset(4,:) = cpurt(ch);
% % dataset(4,:) = cpurt(chromosome(381,:));

% mosma
dataset(1,:) = cpurt(ans);
dataset(2,:) = cpurt(chromosome(3,:));
dataset(3,:) = cpurt(chromosome(137,:));
dataset(4,:) = cpurt(chromosome(422,:));

GO = bar(dataset,1,'EdgeColor','k');

% 坐标区调整
set(gca, 'Box', 'off', ...                                         % 边框
         'XGrid', 'off', 'YGrid', 'on', ...                        % 网格
         'TickDir', 'out', 'TickLength', [.02 .02], ...            % 刻度
         'XMinorTick', 'off', 'YMinorTick', 'off', ...             % 小刻度
         'XColor', [.1 .1 .1],  'YColor', [.1 .1 .1],...           % 坐标轴颜色
         'YTick', 0:10:100,...                                      % 刻度位置、间隔
         'Ylim' , [0 100], ...                                     % 坐标轴范围
         'Xticklabel',{'0' '1' '2' '3' '4' '5' 'A07' 'A08' 'A09'},...% X坐标轴刻度标签
         'Yticklabel',{[0:10:100]})                                 % Y坐标轴刻度标签

% 标签及Legend 设置    
hYLabel = ylabel('CPULoad (%)');
hXLabel = xlabel('方案编号');
hLegend = legend([GO(1),GO(2),GO(3),GO(4),GO(5),GO(6)], ...
    'Core1', 'Core2', 'Core3','Core4', 'Core5', 'Core6');
% Legend位置微调 
% P = hLegend.Position;
% hLegend.Position = P + [0.015 0.03 0 0];

% 刻度标签字体和字号
set(gca, 'FontName', 'Times', 'FontSize', 9)
% 标签及Legend的字体字号 
set([hYLabel,hXLabel,hLegend], 'FontName',  'Helvetica')
set([hYLabel,hXLabel,hLegend], 'FontSize', 10)

% 背景颜色
% set(gca,'Color',[1 1 1])

end