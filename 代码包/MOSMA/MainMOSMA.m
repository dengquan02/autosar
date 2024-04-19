%% Multiple Objective Slime Mould Algorithm (MOSMA)
% M. Premkumar, P. Jangir, R. Sowmya, H. H. Alhelou, A. A. Heidari and H. Chen, 
% "MOSMA: Multi-objective Slime Mould Algorithm Based on Elitist Non-dominated Sorting," 
% in IEEE Access, doi: 10.1109/ACCESS.2020.3047936.
%% Objective Function
% The objective function description contains information about the
% objective function. M is the dimension of the objective space, D is the
% dimension of decision variable space, LB and UB are the
% range for the variables in the decision variable space. User has to
% define the objective functions using the decision variables. Make sure to
% edit the function 'evaluate_objective' to suit your needs.
clc
clear all
D = 30; % Number of decision variables
M = 2; % Number of objective functions
K=M+D;
LB = ones(1, D).*0; %  LB - A vector of decimal values which indicate the minimum value for each decision variable.
UB = ones(1, D).*1; % UB - Vector of maximum possible values for decision variables.
GEN = 200;  % Set the maximum number of generation (GEN)
ecosize = 200;      % Set the population size (NP)
ishow = 10; % 展示频率
%% Start the evolution process
% Pareto = MOSMA(D,M,LB,UB,ecosize,GEN,ishow);
Pareto = oldMOSMA(D,M,LB,UB,ecosize,GEN,ishow);
Obtained_Pareto= Pareto(:,D+1:D+M); % extract data to plot
% Obtained_Pareto=sortrows(Obtained_Pareto,2);
True_Pareto=load('ZDT3.txt');
%% Plot data
if M == 2
    plot(Obtained_Pareto(:,1),Obtained_Pareto(:,2),'o','LineWidth',2,...
        'MarkerEdgeColor','r','MarkerSize',2);
    hold on
    plot(True_Pareto(:,1),True_Pareto(:,2),'k'); 
    title('Optimal Solution Pareto Set using MOSMA');
    legend('MOSMA');
    xlabel('F_1');
    ylabel('F_2');
elseif M == 3
    plot3(Obtained_Pareto(:,1),Obtained_Pareto(:,2),Obtained_Pareto(:,3),'o','LineWidth',2,...
        'MarkerEdgeColor','r','MarkerSize',2);
    hold on
    plot3(Obtained_Pareto(:,1),Obtained_Pareto(:,2),Obtained_Pareto(:,3),'.','LineWidth',2,...
        'MarkerEdgeColor','k','MarkerSize',6);
    title('Optimal Solution Pareto Set using MOSMA');
    legend('MOSMA');
    xlabel('F_1');
    ylabel('F_2');
    zlabel('F_3');
end
%%  Metric Value
M_IGD=IGD(Obtained_Pareto,True_Pareto);
M_GD=GD(Obtained_Pareto,True_Pareto);
M_HV=HV(Obtained_Pareto,True_Pareto);
M_Spacing=Spacing(Obtained_Pareto,True_Pareto);
M_Spread=Spread(Obtained_Pareto,True_Pareto);
M_DeltaP=DeltaP(Obtained_Pareto,True_Pareto);
display(['The IGD Metric obtained by MOSMA is     : ', num2str(M_IGD)]);
display(['The GD Metric obtained by MOSMA is      : ', num2str(M_GD)]);
display(['The HV Metric obtained by MOSMA is      : ', num2str(M_HV)]);
display(['The Spacing Metric obtained by MOSMA is : ', num2str(M_Spacing)]);
display(['The Spread Metric obtained by MOSMA is  : ', num2str(M_Spread)]);
display(['The DeltaP Metric obtained by MOSMA is  : ', num2str(M_DeltaP)]);