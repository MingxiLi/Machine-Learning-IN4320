clear all;

close all;



losses = [0, 0, 1, 0; 0.1, 0, 0, 0.9; 0.2, 0.1, 0, 0];

T = length(losses) + 1;

d = 3;



% Strategy A - trust current most accurate expert

% Initialize variables

p_A = zeros(d, T);

p_A(:,1) = [1/3, 1/3, 1/3]';



% Calculate decision for every time step

for t = 2:T

    cum_loss = sum(losses(:,1:t-1), 2);

    [~, i] = min(cum_loss);

    p_A(i, t) = 1;

end

print_matrix(p_A, 't', 'p', 'Decisions from strategy A:');



% Strategy B - aggregate algorithm

% Initialize variables

eta = 1; % Agg = exp with eta == 1

weights = zeros(d, T);

weights(:,1) = [1, 1, 1]';



p_B = zeros(d, T);

p_B(:,1) = [1/3, 1/3, 1/3]';



% Calculate decision for every time step

for t = 2:T

    weights(:, t) = weights(:, t-1) .* exp(-eta .* losses(:,t-1));

    p_B(:, t) = weights(:, t) ./ sum(weights(:,t));

end



print_matrix(p_B, 't', 'p', 'Decisions from strategy B:');



% Calculate cumulative losses

cum_loss_A = 0;

cum_loss_B = 0;



for i = 1:T-1

    cum_loss_A = cum_loss_A + p_A(:,i)' * losses(:,i);

    cum_loss_B = cum_loss_B + p_B(:,i)' * losses(:,i);

end



% Find and compare to the best expert to get expert regret

best_expert = min(sum(losses, 2));

expert_regret_A = cum_loss_A - best_expert;

expert_regret_B = cum_loss_B - best_expert;



fprintf('Strategy\t|Total loss\t|Expert regret\n');

fprintf('A\t\t|%.4f\t\t|%.4f\n', cum_loss_A, expert_regret_A);

fprintf('B\t\t|%.4f\t\t|%.4f\n\n', cum_loss_B, expert_regret_B);



% Calculate the cumulative loss bound

cum_loss_bound = log(d) + best_expert;

fprintf('Upper bound for cumulative mix loss: %.4f\n', cum_loss_bound);
