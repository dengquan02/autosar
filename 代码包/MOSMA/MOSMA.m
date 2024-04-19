% M. Premkumar, P. Jangir, R. Sowmya, H. H. Alhelou, A. A. Heidari and H. Chen, 
% "MOSMA: Multi-objective Slime Mould Algorithm Based on Elitist Non-dominated Sorting," 
% in IEEE Access, doi: 10.1109/ACCESS.2020.3047936.
function f = MOSMA(dim,M,lb,ub,N,Max_iter,ishow)    
% dim:决策变量的数量 30
% M:目标函数的数量 2
% lb, ub:决策变量的上下界 0 1
% N:种群规模 200
% Max_iter:最大迭代次数 200
% ishow:展示频率 10

X = zeros(N,dim);
Sol = zeros(N,dim); 
weight = ones(N,dim);%fitness weight of each slime mold
%% Initialize the population
for i=1:N
   % 在上下界间的空间随机初始化黏菌群落𝑆(0)用于迭代 
   X(i,:)=lb+(ub-lb).*rand(1,dim); %x(i,:)=lb+(ub-lb).*rand(1,dim); 
   f(i,1:M) = evaluate_objective(X(i,:), M); %f(i,1:M) = evaluate_objective(x(i,:), M);
end

% Sol即[S(t) f(t)]
Sol=[X f]; %new_Sol=[x f]; 
Sol = solutions_sorting(Sol, M, dim);
% 此时Sol是按照frontRank排序后的结果，dim+m+1:frontRank dim+m+2:拥挤度

% ul_Sol即[𝑆𝑢𝑙𝑡𝑖𝑚𝑢𝑚,f()]
ul_Sol = Sol;
% new_Sol即[S(t+1), f(t+1)]

for i = 1 : Max_iter
    [SmellOrder,SmellIndex] = sort(Sol(:, dim+1:dim+M));  
    worstFitness = SmellOrder(N);
    bestFitness = SmellOrder(1);
    S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero
    for k=1:N % 计算当前黏菌群落个体每个维度的适应权重 𝑊𝑖
        if k<=(N/2)
            weight(SmellIndex(k),:) = 1+rand()*log10((bestFitness-SmellOrder(k))/(S)+1);
        else
            weight(SmellIndex(k),:) = 1-rand()*log10((bestFitness-SmellOrder(k))/(S)+1);
        end
    end     
    a = atanh(1-i/Max_iter); % b1  v1 ∈ [-b1, b1]
    b = 1-i/Max_iter; % b2 v2 ∈ [-b2, b2]
    for j=1:N 
        %best=(new_Sol(j,1:dim) - new_Sol(1,(1:dim)));
        best=Sol(1,1:dim);
        if rand<0.03 % r1 < q
            new_X(j,:) = (ub-lb).*rand+lb; 
        else % r1 > q
            p =tanh(abs(f(j)-best));  
            vb = unifrnd(-a,a,1,dim); % v1
            vc = unifrnd(-b,b,1,dim); % v2       
            r = rand();
            A = randi([1,N]);  
            B = randi([1,N]);
            if r<p % r1 > q, r2 < p     
                new_X(j,:) = best+ vb.*(weight(j,:).*X(A,:)-X(B,:));
            else % r1 > q, r2 >= p
                new_X(j,:) =vc.*X(j,:);
            end  
        end
        Sol(j,1:dim) = X(j,1:dim);       
        Flag4ub=Sol(j,1:dim)>ub;
        Flag4lb=Sol(j,1:dim)<lb;
        Sol(j,1:dim)=(Sol(j,1:dim).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;  
        %% Evalute the fitness/function values of the new population
        Sol(j, dim+1:dim+M) = evaluate_objective(Sol(j,1:dim),M);
        if Sol(j,dim+1:dim+M) <= new_Sol(1,(dim+1:dim+M)) 
           new_Sol(1,1:(dim+M)) = Sol(j,1:(dim+M));  
        end
    end    
%% ! Very important to combine old and new bats !
   Sort_bats(1:N,:) = new_Sol; % 合并𝑆𝑢𝑙𝑡𝑖𝑚𝑢𝑚
   Sort_bats((N + 1):(2*N), 1:M+dim) = Sol; % 合并S(t+1)
%% Non-dominated sorting process (a separate function/subroutine)
   Sorted_bats = solutions_sorting(Sort_bats, M, dim); 
%% Select npop solutions among a combined population of 2*npop solutions  
%     new_Sol = cleanup_batspop(Sorted_bats, M, dim, N);
    % 10. 选择排序后上半部分的合并黏菌群落更新 𝑆𝑢𝑙𝑡𝑖𝑚𝑢𝑚
    new_Sol = Sorted_bats(1:N, :); 
    if rem(i, ishow) == 0
        fprintf('Generation: %d\n', i);        
    end
end
f=new_Sol;