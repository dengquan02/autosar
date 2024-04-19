function [CPULoad,RT] = cpurt(x)%%计算每个个体的M个目标函数值
load matlab CET;
ThreadSize = 30;

%CPULoad
CPULoad = zeros(1,6);
for i = 1:ThreadSize
    coreId = ceil(x(i));
    if(coreId == 0)
        coreId = 1;
    end
    CPULoad(coreId) = CPULoad(coreId) + CET(i,1)/CET(i,2)*100;
end

%RT 
RT = CET(:,1)';
[~,index] = sort(x(ThreadSize+1:2*ThreadSize),'descend'); % 优先级降序排列后对应的index
for k = 1:30 % 迭代的方式计算
    for i = 1 : ThreadSize
        taskid1 = index(i);
        coreId1 = ceil(x(taskid1));
        if coreId1 == 0
            coreId1 = 1;
        end
        sum = 0;
        for j = 1 : i-1 % 遍历优先级更高的task，计算 被抢占时间
            taskid2 = index(j);
            coreId2 = ceil(x(taskid2));
            if coreId2 == 0
                coreId2 = 1;
            end
            if(coreId1 == coreId2)
                %sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) ) / CET(taskid2,2) );
                sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) + mod(x(2*ThreadSize+taskid1)-x(2*ThreadSize+taskid2),CET(taskid2,2)) - CET(taskid2,2) ) / CET(taskid2,2) );
                
            end
        end
        RT(taskid1) = sum + CET(taskid1,1); % 响应时间 = 被抢占时间 + 净运行时间（+ 总损耗时间）
        if RT(taskid1)/CET(taskid1,2) > 1 % 响应时间超过周期
            RT(taskid1) = Inf;
        end
    end
end

end
    