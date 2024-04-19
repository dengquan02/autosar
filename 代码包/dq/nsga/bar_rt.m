function bar_rt
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

% [~,dataset(1,:)] = cpurt(ans);
% [~,dataset(2,:)] = cpurt(chromosome(2,:));
% [~,dataset(3,:)] = cpurt(chromosome(18,:));
% ch = chromosome(381,:); ch(22) = 3.3;
% [~,dataset(4,:)] = cpurt(ch);

[~,dataset(1,:)] = cpurt(ans);
[~,dataset(2,:)] = cpurt(chromosome(3,:));
[~,dataset(3,:)] = cpurt(chromosome(137,:));
[~,dataset(4,:)] = cpurt(chromosome(422,:));

% GO = bar(dataset','stacked');

dataset = dataset';
GO = barh(dataset,1,'EdgeColor','k');
% GO = barh(dataset,'stacked');

% 坐标区调整
set(gca, 'Box', 'off', ...                                         % 边框
         'XGrid', 'off', 'YGrid', 'on', ...                        % 网格
         'TickDir', 'out', 'TickLength', [.02 .02], ...            % 刻度
         'XMinorTick', 'off', 'YMinorTick', 'off', ...             % 小刻度
         'XColor', [.1 .1 .1],  'YColor', [.1 .1 .1],...           % 坐标轴颜色
         'XTick', .0:5:55,... %0:20:180,..              % 刻度位置、间隔
         'Xlim' , [0 55], ...     % [0 180],...             % 坐标轴范围
        'ytick',1:1:30,...
         'Yticklabel',{'Task\_Rte\_500ms\_Core0',
            'Task\_Rte\_200ms\_Core0',
            'Task\_Rte\_100ms\_Core0',
            'Task\_Rte\_50ms\_Core0',
            'Task\_Rte\_20ms\_Core0',
            'Task\_Rte\_10ms\_Core0',
            'Task\_Rte\_2ms\_Core0',
            'Task\_Sch\_20ms\_Core0',
            'Task\_Sch\_10ms\_Core0',
            'Task\_Sch\_5ms\_Core0',
            'Task\_Rte\_100ms\_Core1',
            'Task\_Rte\_20ms\_Core1',
            'Task\_Rte\_2ms\_Core1',
            'Task\_Sch\_10ms\_Core1',
            'Task\_Rte\_100ms\_Core2',
            'Task\_Rte\_20ms\_Core2',
            'Task\_Sch\_10ms\_Core2',
            'Task\_Rte\_500ms\_Core3',
            'Task\_Rte\_200ms\_Core3',
            'Task\_Rte\_100ms\_Core3',
            'Task\_Rte\_50ms\_Core3',
            'Task\_Rte\_10ms\_Core3',
            'Task\_Rte\_2ms\_Core3',
            'Task\_Sch\_10ms\_Core3',
            'Task\_Rte\_100ms\_Core4',
            'Task\_Rte\_1ms\_Core4',
            'Task\_Sch\_10ms\_Core4',
            'Task\_Rte\_100ms\_Core5',
            'Task\_Rte\_2ms\_Core5',
            'Task\_Sch\_10ms\_Core5'},...% Y坐标轴刻度标签
         'Xticklabel',{[0:5:55]})       % X坐标轴刻度标签

% 标签及Legend 设置    
hYLabel = ylabel('任务名称');
hXLabel = xlabel('WCRT (ms)');
hLegend = legend([GO(1),GO(2),GO(3),GO(4)], ...
    '方案0', '方案1', '方案2','方案3');
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