function f  = genetic_operator(parent_chromosome, M, V, mu, mum, l_limit, u_limit)
[N,~] = size(parent_chromosome);%N是交配池中的个体数量
 
p = 1;
was_crossover = 0;%是否交叉标志位
was_mutation = 0;%是否变异标志位
% 一次循环中，要么交叉（产生2个子代），要么变异（产生1个子代） 
for i = 1 : N%这里虽然循环N次，但是每次循环都会有概率产生2个或者1个子代，所以最终产生的子代个体数量大约是2N个
    if rand(1) < 0.9 %交叉概率0.9
        child_1 = [];
        child_2 = [];
        parent_1 = round(N*rand(1));
        if parent_1 < 1
            parent_1 = 1;
        end
        parent_2 = round(N*rand(1));
        if parent_2 < 1
            parent_2 = 1;
        end
        while isequal(parent_chromosome(parent_1,:),parent_chromosome(parent_2,:))
            parent_2 = round(N*rand(1));
            if parent_2 < 1
                parent_2 = 1;
            end
        end
        parent_1 = parent_chromosome(parent_1,:);
        parent_2 = parent_chromosome(parent_2,:);
        for j = 1 : V % 实数编码的交叉操作（SBX）
            u(j) = rand(1);
            if u(j) <= 0.5
                bq(j) = (2*u(j))^(1/(mu+1));
            else
                bq(j) = (1/(2*(1 - u(j))))^(1/(mu+1));
            end
            child_1(j) = ...
                0.5*(((1 + bq(j))*parent_1(j)) + (1 - bq(j))*parent_2(j));
            child_2(j) = ...
                0.5*(((1 - bq(j))*parent_1(j)) + (1 + bq(j))*parent_2(j));
            if child_1(j) > u_limit(j)
                child_1(j) = u_limit(j);
            elseif child_1(j) < l_limit(j)
                child_1(j) = l_limit(j);
            end
            if child_2(j) > u_limit(j)
                child_2(j) = u_limit(j);
            elseif child_2(j) < l_limit(j)
                child_2(j) = l_limit(j);
            end
        end
        child_1(:,V + 1: M + V) = evaluate_objective(child_1, M, V);
        child_2(:,V + 1: M + V) = evaluate_objective(child_2, M, V);
        was_crossover = 1;
        was_mutation = 0;
    else%if >0.9    不交叉
        parent_3 = round(N*rand(1));
        if parent_3 < 1
            parent_3 = 1;
        end
        child_3 = parent_chromosome(parent_3,:);
        for j = 1 : V
           r(j) = rand(1);
           if r(j) < 0.5
               delta(j) = (2*r(j))^(1/(mum+1)) - 1;
           else
               delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
           end
           child_3(j) = child_3(j) + delta(j);
           if child_3(j) > u_limit(j) % 条件约束
               child_3(j) = u_limit(j);
           elseif child_3(j) < l_limit(j)
               child_3(j) = l_limit(j);
           end
        end 
        child_3(:,V + 1: M + V) = evaluate_objective(child_3, M, V);
        was_mutation = 1;
        was_crossover = 0;
    end% if <0.9
    if was_crossover
        child(p,:) = child_1;
        child(p+1,:) = child_2;
        was_cossover = 0;
        p = p + 2;
    elseif was_mutation
        child(p,:) = child_3(1,1 : M + V);
        was_mutation = 0;
        p = p + 1;
    end
end
 
f = child;
