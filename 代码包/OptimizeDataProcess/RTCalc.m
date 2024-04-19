function RTCalc
load SelectChrome SelectChrome;
load matlab CET;
ThreadSize = 30;
prio = ones(4,30);
RT4 = zeros(4,30);
for n = 1:4
    RT = CET(:,1)' + SelectChrome(n,2*ThreadSize+1:3*ThreadSize);
    [~,index] = sort(SelectChrome(n,ThreadSize+1:2*ThreadSize),'descend');
    for k = 1: 30
        for i = 1 : ThreadSize
            taskid1 = index(i);
            coreId1 = ceil(SelectChrome(n,taskid1));
            sum = 0;
            for j = 1 : i-1
                taskid2 = index(j);
                coreId2 = ceil(SelectChrome(n,taskid2));
                if(coreId1 == coreId2)
                    %sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) ) / CET(taskid2,2) );
                    sum = sum + CET(taskid2,1)*ceil( (RT(taskid1) - mod(SelectChrome(n,2*ThreadSize+taskid2)-SelectChrome(n,2*ThreadSize+taskid1),CET(taskid2,2)) ) / CET(taskid2,2) );
                end
            end
            RT(taskid1) = sum + CET(taskid1,1);
        end
    end
    
    [~,index] = sort(SelectChrome(n,ThreadSize+1:2*ThreadSize),'ascend');
    for i = 1 : ThreadSize
            taskid1 = index(i);
            coreId1 = ceil(SelectChrome(n,taskid1));     
            for j = i+1 : ThreadSize
                taskid2 = index(j);
                coreId2 = ceil(SelectChrome(n,taskid2));
                if(coreId1 == coreId2)
                    prio(n,taskid2) =  prio(n,taskid2) + 1;
                end
            end
    end
                    
        
    
    RT4(n,:) = RT;
end
    
    
save('OutputPara.mat',"RT4",'-append');
end

