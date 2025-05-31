
clc;
clear;
close all;

%% load network
load Jordan_net;% best_net%net_data3

%% load References
load DLC_data   

% % Load postion data
load DLC_pos_data

% load wind disturbance data
load DLCwind_data

%% Problem Definition GA
problem.CostFunction = @(x) LPV_MPC(x,xmean, xstdev, ymean,ystdev, mod, Ts, UU, XX, XP, YP, THETAP,v_wind);
problem.nVar = 7;
problem.VarMin = [0.5 0.00001 0.01 10 0.001 0.003 0.0001];
problem.VarMax = [50 0.01 0.05 100 10 1 0.02];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Problem Definition PSO

% problem2.CostFunction2 = @(x) Sphere(x);  % Cost Function
problem2.nVar = 7;     % Number of Unknown (Decision) Variables
problem2.VarMin = [0.5 0.00001 0.01 10 0.001 0.003 0.0001];
problem2.VarMax = [50 0.01 0.05 100 10 1 0.02];



%% GA Parameters

params.MaxIt = 3%15;%50;     %maximum number of generations
params.nPop = 3%25;       %Population size

params.beta = 0.8;        %Selection pressure 
params.pC = 0.8;        %percentage of children \parents
params.gamma = 0.2;     %parameter for extending possibilities for children beyond parents
params.mu = 0.3;       %mutation rate
params.sigma = 0.15;     %variance for mutation


%%Parameters of PSO

kappa = 1;
phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2*kappa/abs(2-phi-sqrt(phi^2-4*phi));

% params2.MaxIt = 100;     %Maximum Number of Iterations
% params2.nPop = 10;       %Population size (swarm size)
params2.w = chi;           % inertia coefficient
params2.wdamp = 1;    % Damping Ratio of Inertia Weight
params2.c1 = chi*phi1;          %Personal acceleration coefficient
params2.c2 = chi*phi2;          %social acceleration coefficient
params2.ShowIterInfo = true;  %Flag for showing Iteration




%% Calling PSO
out = H_GA_PSO(problem, params,problem2, params2);
BestSol = out.BestSol
BestCosts = out.BestCosts;



%% Results GA-PSO

figure(1);
semilogy(BestCosts, 'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

