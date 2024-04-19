function PrintData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load OutputConfig chromosome;
load OutputConfig OptiPara;
load matlab CET;
gen = 2000; %迭代次数
V = 90; %维度（决策变量的个数）
ThreadSize = V/3; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = chromosome(1,:);
%CPULoad
CPULoad = zeros(1,6);
for i = 1:ThreadSize
    coreId = ceil(x(i));
    if(coreId == 0)
        coreId = 1;
    end
    CPULoad(coreId) = CPULoad(coreId) + CET(i,1)/CET(i,2)*100;
end
save('OutputPara.mat',"CPULoad",'-append');

%RT
RT = CET(:,2)' + x(2*ThreadSize+1:3*ThreadSize);
[~,index] = sort(x(ThreadSize+1:2*ThreadSize),'descend');
for k = 1:300
    for i = 1 : ThreadSize
        taskid1 = index(i);
        coreId1 = ceil(x(taskid1));
        sum = 0;
        for j = 1 : i-1
            taskid2 = index(j);
            coreId2 = ceil(x(taskid2));
            if(coreId1 == coreId2)
                sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) + mod(x(2*ThreadSize+taskid1)-x(2*ThreadSize+taskid2),CET(taskid2,2)) - CET(taskid2,2) ) / CET(taskid2,2) );
            end
        end
        RT(taskid1) = sum + CET(taskid1,1);
    end
end
save('OutputPara.mat',"RT",'-append');

figure(1)
plot(chromosome(:,V + 1),chromosome(:,V + 2),'*','MarkerSize',10);
xlabel('CPUload\_max'); ylabel('RT\_wavg');
title('Pareto Optimal Front');

figure(2)
yyaxis left
plot(0:gen, OptiPara(:,1),"LineWidth",1.5);
xlabel('Generations  ','FontSize',14); 
ylabel('CPULoad (%)','FontSize',14);
xlim([-5 1000]);
yyaxis right
plot(0:gen, OptiPara(:,2),"LineWidth",1.5);
ylabel('RT (ms)','FontSize',14);

end

