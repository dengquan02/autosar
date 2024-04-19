function plot_rt
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

RC=radarChart(dataset,'Type','Line');
% RC=radarChart(dataset,'Type','Patch');
% RC.PropName={'建模','实验','编程','总结','撰写','创新','摸鱼'};
RC.PropName={'Task\_Rte\_500ms\_Core0',
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
            'Task\_Sch\_10ms\_Core5',};
RC.ClassName={'方案0','方案1','方案2','方案3'};
RC.RLim=[0,45];
RC.RTick=[0,0:10:50];
RC=RC.draw(); 
RC.legend();

RC.setPropLabel('FontSize',6,'FontName','Cambria')
RC.setRLabel('FontSize',7,'FontName','Cambria','Color',[.8,0,0])

% RC.setBkg('FaceColor',[0,0,.1])
% RC.setRLabel('Color','none')

colorList=[78 101 155;
          138 140 191;
          184 168 207;
          231 188 198;
          253 207 158;
          239 164 132;
          182 118 108]./255;
% for n=1:RC.ClassNum
%     RC.setPatchN(n,'Color',colorList(n,:),'MarkerFaceColor',colorList(n,:))
% end
RC.setPatchN(1,'Color',colorList(4,:),'MarkerFaceColor',colorList(4,:))

end