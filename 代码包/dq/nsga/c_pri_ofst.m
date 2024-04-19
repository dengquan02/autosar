function c_pri_ofst
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load OutputConfig_v1 chromosome;
load('D:\study\autosar\代码包\dq\mosma\OutputConfig_v5.mat', 'chromosome');
load matlab CET;
clc;
V = 90; %维度（决策变量的个数）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chromosome = sortrows(chromosome, 91);

% nsga2
% x1 = chromosome(2,:);
% x1 = chromosome(18,:);
% x1 = chromosome(381,:);

% mosma
% x1 = chromosome(3,:);
% x1 = chromosome(137,:);
x1 = chromosome(422,:);

for i = 1:30
    x1(i) = ceil(x1(i));
    if(x1(i) == 0)
        x1(i) = 1;
    end
    x1(i+30) = round(x1(i+30),2);
    x1(i+60) = round(x1(i+60),2);
end

core = x1(1:30)';
pri = x1(31:60)';
ofst = x1(61:90)';

disp(vpa(pri,4));
% disp(vpa(ofst,4));

end