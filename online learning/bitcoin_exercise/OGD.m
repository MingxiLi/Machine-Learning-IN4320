% Exercise: Online Gradient Descent (OGD)

clear all;
load coin_data;

a_init = [0.2, 0.2, 0.2, 0.2, 0.2]'; % initial action

n = 213; % is the number of days
d = 5; % number of coins

% we provide you with values R and G.
alpha = sqrt(max(sum(r.^2,2))); 
epsilon = min(min(r)); 
G = alpha/epsilon; 
R = 1; 

% set eta:
%%% your code here %%%
learning_rate = R / (G * sqrt(n));

a = a_init; % initialize action. a is always a column vector

L = nan(n,1); % keep track of all incurred losses
A = nan(d,n); % keep track of all our previous actions

for t = 1:n
    
    % we play action a
    [l,g] = mix_loss(a,r(t,:)'); % incur loss l, compute gradient g
    
    A(:,t) = a; % store played action
    L(t) = l; % store incurred loss
    
    % update our action, make sure it is a column vector
    %%% your code here %%%
    
    a = a - learning_rate * g;
    % after the update, the action might not be anymore in the action
    % set A (for example, we may not have sum(a) = 1 anymore). 
    % therefore we should always project action back to the action set:
    a = project_to_simplex(a')'; % project back (a = \Pi_A(w) from lecture)

end

% compute total loss
%%% your code here %%%
L_total = sum(L);

% compute total gain in wealth
%%% your code here %%%
W = 1;
for t = 1: n
    W = W * A(:, t)' * r(t, :)';
end

% compute best fixed strategy (you may make use of loss_fixed_action.m and optimization toolbox if needed)
%%% your code here %%%
Aeq = [1, 1, 1, 1, 1];
beq = 1;
best = fmincon(@loss_fixed_action, A(:, 1), [],[], Aeq, beq, 0, 1);
best = loss_fixed_action(best);

% compute regret 
%%% your code here %%%
regret = L_total - best;
%% plot of the strategy A and the coin data

% if you store the strategy in the matrix A (size d * n)
% this piece of code will visualize your strategy

figure
subplot(1,2,1);
plot(A')
legend(symbols_str)
title('rebalancing strategy OGD')
xlabel('date')
ylabel('investment action a_t')

subplot(1,2,2);
plot(s)
legend(symbols_str)
title('worth of coins')
xlabel('date')
ylabel('USD')
