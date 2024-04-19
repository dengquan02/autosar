%% �Գ�ʼ��Ⱥ��ʼ���� ���ٷ�֧������
% ʹ�÷�֧���������Ⱥ�������򡣸ú�������ÿ�������Ӧ������ֵ��ӵ�����룬��һ�����еľ���  
% ��������ֵ��ӵ��������ӵ�Ⱦɫ������� 
function f = non_domination_sort_mod(x, M, V)
[N, ~] = size(x);% NΪ����x��������Ҳ����Ⱥ������
clear m
front = 1;
F(front).f = [];
individual = [];
 
for i = 1 : N
    individual(i).n = 0;%n�Ǹ���i��֧��ĸ�������
    individual(i).p = [];%p�Ǳ�����i֧��ĸ��弯��
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M        %�жϸ���i�͸���j��֧���ϵ
            if (x(i,V + k) < x(j,V + k))  
                dom_less = dom_less + 1;
            elseif (x(i,V + k) == x(j,V + k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M % ˵��i��j֧�䣬��Ӧ��n��1
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M % ˵��i֧��j,��j����i��֧��ϼ���
            individual(i).p = [individual(i).p j];
        end
    end   
    if individual(i).n == 0 %����i��֧��ȼ�������ߣ����ڵ�ǰ���Ž⼯����Ӧ��Ⱦɫ����Я����������������Ϣ
        x(i,M + V + 1) = 1;
        F(front).f = [F(front).f i];%�ȼ�Ϊ1�ķ�֧��⼯
    end
end
%����Ĵ�����Ϊ���ҳ��ȼ���ߵķ�֧��⼯
%����Ĵ�����Ϊ�˸�����������зּ�
while ~isempty(F(front).f)
	Q = []; %�����һ��front����
	for i = 1 : length(F(front).f)%ѭ����ǰ֧��⼯�еĸ���
        if ~isempty(individual(F(front).f(i)).p)%����i���Լ���֧��Ľ⼯
            for j = 1 : length(individual(F(front).f(i)).p)%ѭ������i��֧��⼯�еĸ���
                individual(individual(F(front).f(i)).p(j)).n = individual(individual(F(front).f(i)).p(j)).n - 1;%�����ʾ����j�ı�֧�������1
                if individual(individual(F(front).f(i)).p(j)).n == 0% ���q�Ƿ�֧��⼯������뼯��Q��
               		x(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;%����Ⱦɫ���м���ּ���Ϣ
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
        end
	end
   front =  front + 1;
   F(front).f = Q;
end
sorted_based_on_front = sortrows(x, M + V + 1);
 
%% Crowding distance ����ÿ�������ӵ����

current_index = 0; 
for front = 1 : (length(F) - 1)%�����1����Ϊ����55�����F�����һ��Ԫ��Ϊ�գ�������������ѭ��������һ����length-1������ȼ�
    %distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);%y�д�ŵ�������ȼ�Ϊfront�ļ��Ͼ���
    end
    current_index = current_index + i;%current_index =i
    sorted_based_on_objective = [];%��Ż���ӵ����������ľ���
    for i = 1 : M
        [~, index_of_objectives] = sort(y(:,V + i));%����Ŀ�꺯��ֵ����
        sorted_based_on_objective = y(index_of_objectives, :);
        % Find the max and min of the fobj values  
        f_max = sorted_based_on_objective(length(index_of_objectives), V + i);%fmaxΪĿ�꺯�����ֵ fminΪĿ�꺯����Сֵ
        f_min = sorted_based_on_objective(1, V + i);
        % Calculate the range of the fobj
        f_range = f_max - f_min;
        %�������ĵ�һ����������һ������ľ�����Ϊ�����
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i) = Inf;
        y(index_of_objectives(1),M + V + 1 + i) = Inf;
        for j = 2 : length(index_of_objectives) - 1%ѭ�������г��˵�һ�������һ���ĸ���
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            % Check the range or special cases
            if (f_range == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = (next_obj - previous_obj)/f_range;
            end
        end
    end
    % Calculate and update the crowding distances on the Pareto Front
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
    end % distance��������Ŀ�꺯������֮��
    
    % Store the crowding distrance (dc) in the column of Rcol+1=ndim+m+2
    distance(isnan(distance(:,1)),1) = Inf;
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);
    % Update for the output
    z(previous_index:current_index,:) = y;
end

% �����򣬺���
f = sortrows(z, [M + V + 1, -(M + V + 2)]);
%�õ������Ѿ������ȼ���ӵ���ȵ���Ⱥ���� �����Ѿ����ȼ���ӵ������������
