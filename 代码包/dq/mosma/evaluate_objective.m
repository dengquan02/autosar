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

% f(2) = 0;
% weight = 0;
% for i = 1 : ThreadSize
%     f(2) = f(2) + RT(i) * (CET(i,4) / 5 + 1);
%     weight = weight + CET(i,4) / 5 + 1;
% end
% 
% f(2) = f(2) / weight / ThreadSize;
    
RT_sum = zeros(1,6);
i_sum = ones(1,6); % 当前内核的任务总数
RT_weigh = zeros(1,6); 
for i = 1 : ThreadSize
    taskId = index(i);
    coreId = ceil(x(taskId));
    if(coreId == 0)
        coreId = 1;
    end
    % 优先级最高，权重为 1；优先级最低，权重为 1/CoreTaskCount
    RT_sum(coreId) = RT_sum(coreId) + RT(taskId)/i_sum(coreId);
    RT_weigh(coreId) = RT_weigh(coreId) + 1/i_sum(coreId);
	i_sum(coreId) = i_sum(coreId) + 1;
end
f(2) = 0;
for i = 1 : 6
    if(RT_weigh(i))
        f(2) = f(2) + RT_sum(i)/RT_weigh(i)/6;
    end
end

if f(1) > 100   % cpu负载率超过100
    f(1) = Inf;
    f(2) = Inf;
end

end
    