function cpuloadcalc
load SelectChrome SelectChrome;
load matlab CET;
CPULoad = zeros(4,6);
for s = 1:4
    for i = 1:30
        coreId = ceil(SelectChrome(s,i));
        if(coreId == 0)
            coreId = 1;
        end
        CPULoad(s,coreId) = CPULoad(s,coreId) + CET(i,1)/CET(i,2)*100;
    end
end
save('OutputPara.mat',"CPULoad",'-append');
end

