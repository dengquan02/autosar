function chromesort
load OutputConfig chromosome;
chromesorted = sortrows(chromosome,91);
save('OutputPara.mat',"chromesorted",'-append');

end

