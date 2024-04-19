function f  = replace_chromosome(sorted_chromosome, M, V,pop)%精英选择策略
 
[N, ~] = size(sorted_chromosome);

max_rank = max(sorted_chromosome(:,M + V + 1));
 
previous_index = 0;
for i = 1 : max_rank
    current_index = max(find(sorted_chromosome(:,M + V + 1) == i));
    if current_index > pop
        remaining = pop - previous_index;
        temp_pop = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        [temp_sort,temp_sort_index] = ...
            sort(temp_pop(:, M + V + 2),'descend');
        for j = 1 : remaining
            f(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
        return;
    elseif current_index < pop
        f(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
    else
        f(previous_index + 1 : current_index, :) = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        return;
    end
    previous_index = current_index;
end
