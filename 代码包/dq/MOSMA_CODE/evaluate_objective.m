% M. Premkumar, P. Jangir, R. Sowmya, H. H. Alhelou, A. A. Heidari and H. Chen, 
% "MOSMA: Multi-objective Slime Mould Algorithm Based on Elitist Non-dominated Sorting," 
% in IEEE Access, doi: 10.1109/ACCESS.2020.3047936.
function f = evaluate_objective(x,m)

%% function f = evaluate_objective(x)
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% D is the number of decision variables. 
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and D matches your initial user
% input.
% A set of testing function is stored in folder TEST
%% Retrieve function from folder TEST
f = zdt3(x); % change the name of function we can use different functions
end