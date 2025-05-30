%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Yassine Kebbati
% Date: 10/02/2022
% Control RNN_LPV-MPC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;



%% Problem Definition GA

problem.CostFunction = @(x) Sphere(x);
problem.nVar = 5;
problem.VarMin = [-10 -10 -10 -10 -10];
problem.VarMax = [10 10 10 10 10];


%%Problem Definition PSO

problem2.CostFunction = @(x) Sphere(x);  % Cost Function
problem2.nVar = 5;     % Number of Unknown (Decision) Variables
problem2.VarMin = [-10 -10 -10 -10 -10];
problem2.VarMax = [10 10 10 10 10];






%%Parameters of PSO

kappa = 1;
phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2*kappa/abs(2-phi-sqrt(phi^2-4*phi));

params2.MaxIt = 100;     %Maximum Number of Iterations
params2.nPop = 10;       %Population size (swarm size)
params2.w = chi;           % inertia coefficient
params2.wdamp = 1;     % Damping Ratio of Inertia Weight
params2.c1 = chi*phi1;          %Personal acceleration coefficient
params2.c2 = chi*phi2;          %social acceleration coefficient
params2.ShowIterInfo = true;  %Flag for showing Iteration




%% GA Parameters

params.MaxIt = 100;     %maximum number of generations
params.nPop = 10;       %Population size

params.beta = 0.8;        %Selection pressure 
params.pC = 0.8;        %percentage of children \parents
params.gamma = 0.2;     %parameter for extending possibilities for children beyond parents
params.mu = 0.25;       %mutation rate
params.sigma = 0.15;     %variance for mutation





%% Calling H-GA-PSO


out = H_GA_PSO(problem, params,problem2, params2);


BestSol = out.BestSol;
BestCosts = out.BestCosts;



%% Results GA-PSO

figure;
semilogy(BestCosts, 'LineWidth',2, 'Color','r');
legend('a');
xlabel('Iteration');
ylabel('Best Cost');
grid on;hold on;

