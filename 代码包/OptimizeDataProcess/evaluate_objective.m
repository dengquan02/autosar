function f = evaluate_objective(x, ~, V)%%计算每个个体的M个目标函数值
load matlab CET;
f = [];
ThreadSize = V/3;

%CPULoad
CPULoad = zeros(1,6);
for i = 1:ThreadSize
    coreId = ceil(x(i));
    if(coreId == 0)
        coreId = 1;
    end
    CPULoad(coreId) = CPULoad(coreId) + CET(i,1)/CET(i,2)*100;
end
f(1) = max(CPULoad);

%RT
RT = CET(:,2)' + x(2*ThreadSize+1:3*ThreadSize);
[~,index] = sort(x(ThreadSize+1:2*ThreadSize),'descend');
for k = 1:30
    for i = 1 : ThreadSize
        taskid1 = index(i);
        coreId1 = ceil(x(taskid1));
        sum = 0;
        for j = 1 : i-1
            taskid2 = index(j);
            coreId2 = ceil(x(taskid2));
            if(coreId1 == coreId2)
                %sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) ) / CET(taskid2,2) );
                sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) - mod(x(2*ThreadSize+taskid2)-x(2*ThreadSize+taskid1),CET(taskid2,2)) ) / CET(taskid2,2) );
                
            end
        end
        RT(taskid1) = sum + CET(taskid1,1);
    end
end

RT_sum = zeros(1,6);
i_sum = ones(1,6);
RT_weigh = zeros(1,6);
for i = 1 : ThreadSize
    coreId = ceil(x(i));
    if(coreId == 0)
        coreId = 1;
    end
    RT_sum(coreId) = RT_sum(coreId) + RT(i)/i_sum(coreId);
    RT_weigh(coreId) = RT_weigh(coreId) + 1/i_sum(coreId);  
	i_sum(coreId) = i_sum(coreId) + 1;
end
f(2) = 0;
for i = 1 :6
    if(RT_weigh(i))
        f(2) = f(2) + RT_sum(i)/RT_weigh(i)/6;
    end
end

end
    