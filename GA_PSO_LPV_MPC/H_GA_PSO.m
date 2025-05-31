%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Yassine Kebbati
% Date: 10/02/2022
% Control RNN_LPV-MPC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = H_GA_PSO(problem, params,problem2, params2)


    % Problem 

    %%GA Definition
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarSize = [1, nVar];
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    %%PSO Definition
    % CostFunction2 = problem2.CostFunction2;  % Cost Function
    nVar2 = problem2.nVar;     % Number of Unknown (Decision) Variables
    VarSize2 = [1 nVar2];    %Matrix Size of Decision Variables
    VarMin2 = problem2.VarMin;          %Lower Bound of Decision Variables
    VarMax2 = problem2.VarMax;          %Upper Bound of Decision Variables



    
    % Parameters GA
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    pC = params.pC;
    nC = round(pC*nPop/2)*2;
    gamma = params.gamma;
    mu = params.mu;
    sigma = params.sigma;
    
    

    %%Parameters of PSO
    % MaxIt2 = params2.MaxIt;     %Maximum Number of Iterations
    % nPop2 = params2.nPop;       %Population size (swarm size)
    w = params2.w;           % inertia coefficient
    wdamp = params2.wdamp;     % Damping Ratio of Inertia Weight
    c1 = params2.c1;          %Personal acceleration coefficient
    c2 = params2.c2;          %social acceleration coefficient
    ShowIterationInfo = params2.ShowIterInfo;    %the Flag for Showing interation information
    MaxVelocity = 0.2*(VarMax2 - VarMin2);
    MinVelocity = -MaxVelocity; 



    %%Initialization for GA

    %Template for empty individuals
    empty_individual.Position = [];  %empty_individual.Position = out.pop.Position; 
    empty_individual.Cost =[];

    
    % Best Solution Ever Found
    bestsol.Cost = inf;
    
    
    
    %%Initialization for PSO

    % The Particle Template
    empty_particle.Position = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];


    %Create Population Array
    particle = repmat(empty_particle, nPop, 1);



%     Initialize Global Best PSO
    GlobalBest.Cost = inf;

% %   Initialize Global Best GA_PSO
%     GlobalBest2.Cost = inf;







    % Initialization
    pop = repmat(empty_individual, nPop, 1);
    for i = 1:nPop
        
        % Generate Random Solution GA
        pop(i).Position = unifrnd(VarMin, VarMax,VarSize);

        % Generate Random Solution PSO
        particle(i).Position = unifrnd(VarMin, VarMax, VarSize);
        % Initialize Velocity PSO
        particle(i).Velocity = zeros(VarSize);
        



        % Evaluate Solution GA
        pop(i).Cost = CostFunction(pop(i).Position);

        % Evaluation PSO
        particle(i).Cost = CostFunction(particle(i).Position);
        %Update the Personal Best PSO
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;


        % Compare Solution to Best Solution Ever Found
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
        end


        %Update Global Best
        if particle(i).Best.Cost < GlobalBest.Cost
            GlobalBest = particle(i).Best;
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if GlobalBest.Cost < bestsol.Cost
            bestsol = GlobalBest;
        else
            GlobalBest = bestsol;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    
    % Best Cost of Iterations GA
    bestcost = nan(MaxIt,1);
    
    % Array to Hold Best Cost Value on Each Iteration PSO
    BestCosts = zeros(MaxIt,1);
    


    % Main Loop
    for it = 1:MaxIt
        it
        % Selection Probabilities
        c = [pop.Cost];
        avgc = mean(c);
        if avgc ~= 0
            c = c/avgc;
        end    
        probs = exp(-beta*c);
        
        % Initialize Offsprings Population
        popc = repmat(empty_individual, nC/2, 2);
        
        % Crossover
        for k = 1:nC/2
            
%             % Select Parents randomly
%             q = randperm(nPop);
%             p1 = pop(q(1));
%             p2 = pop(q(2));



%             if mod(k,2) == 0
%             % Select Parents 
                s1 = pop(RouetteWheelSelection(probs));
                s2 = pop(RouetteWheelSelection(probs));
            
      
%                 MatingPool = TournamentSelection([pop.Cost],nPop);
%                 MatingPool = TournamentSelection([pop.Cost],nPop);
                s3 = pop(TournamentSelection([pop.Cost],nPop));
                s4 = pop(TournamentSelection([pop.Cost],nPop));
%             end
                if s1.Cost < s2.Cost && s3.Cost < s4.Cost
                    p1 = s1;
                    p2 = s3;
                elseif s1.Cost < s2.Cost
                    p1 = s1;
                    p2 = s4;
                else
                    p1 = s2;
                    p2 = s3;
                end
                

            
            % Perform Crossover
            [popc(k,1).Position, popc(k,2).Position] = ...
                UniformCrossover(p1.Position, p2.Position, gamma);
%                 UniformCrossover(p1.Position, p2.Position);
%                 DoublePointCrossover(p1.Position, p2.Position);
%                 singlePointCrossover(p1.Position, p2.Position);
                
            
            
        end
        
        % Convert popc to Single-coloumn Matrix
        popc = popc(:);
        
        % Mutation
        for l = 1:nC
            
            popc(l).Position = Mutate(popc(l).Position, mu, sigma);
            
            %Check for variable bounds
            popc(l).Position = max(popc(l).Position, VarMin);
            popc(l).Position = min(popc(l).Position, VarMax);
           
            %Evaluation 
            popc(l).Cost = CostFunction(popc(l).Position);
            
            % Compare Solution to Best Solution Ever Found
            if popc(l).Cost < bestsol.Cost
                bestsol = popc(l);
            end
        
        end
        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:nPop

            %Update Velocity
            particle(i).Velocity = w*particle(i).Velocity...
                + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position)...
                + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity); 
            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            %Apply Lower and Upper Bound Limits
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);          

            % Evaluation
            particle(i).Cost = CostFunction(particle(i).Position);

            % Update Personal Besy
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;

                %Update Global Best
                if particle(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = particle(i).Best;
                end

            end

        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




        if GlobalBest.Cost < bestsol.Cost
            bestsol = GlobalBest;
        else
            GlobalBest = bestsol;
        end
       
        
        % Merge and Sort Populations
        pop = SortPopulation([pop; popc]);
        
        % Remove Extra Individuals 
        pop = pop(1:nPop);

        
        % Update Best Cost of Iteration
        bestcost(it) = bestsol.Cost;
        
        % Display Iteration Information
        disp(['Iteration' num2str(it) ': Best Cost =' num2str(bestcost(it))])


        %Store the Best Cost Value
        BestCosts(it) = GlobalBest.Cost;

        %Display Iteration Information
% % %         if ShowIterationInfo
% % %             disp(['Iteration ' num2str(it) ' : Best Cost PSO = ' num2str(BestCosts(it))]);
% % %         end
        %Damping Inertia Coeffiecient
        w = w * wdamp;
        
    end
    
    


    out.pop = particle;
    out.BestSol = GlobalBest;
    out.BestCosts = BestCosts; 

end