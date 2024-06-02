clc;
clear;
close all;

%% ACO Parameters

model = CreateModel(100);
CostFunction = @(direction) Cost(direction, model);

repeatCount = 600;      
antCount = 100;        

Q = 1;            % Amount of Pheromone Increase

alpha = 1;        % وزن نمایی فرومون
beta = 1;         % Heuristic Exponential Weight

rho = 0.05;       % ضریب تبخیر

tau0 = 10 * Q / (model.cityCount * mean(model.distances(:,1)));	% Initial Phromone
tau = tau0 * ones(model.cityCount);   % Phromone Matrix

eta = 1 ./ model.distances;             % Heuristic Information Matrix

%% Initialization

BestCost = zeros(repeatCount, 1);    % Array to Hold Best Cost Values
BestAnt.Cost = inf;

% Empty Ant
empty_ant.Direction = [];
empty_ant.Cost = [];

% Ant Colony Matrix
ant = repmat(empty_ant, antCount, 1);

%% ACO Main Loop

for counter = 1 : repeatCount

    % Move Ants
    for k = 1 : antCount
        
        ant(k).Direction = randi([1, model.cityCount]);
        
        for l = 2 : model.cityCount
            
            i = ant(k).Direction(end);
            
            P = tau(i, :) .^ alpha .* eta(i, :) .^ beta;
            P(ant(k).Direction) = 0;
            P = P / sum(P);
            
            j = SelectNextCity(P);
            
            ant(k).Direction = [ant(k).Direction, j];
        end
        
        ant(k).Cost = CostFunction(ant(k).Direction);
        
        if ant(k).Cost < BestAnt.Cost
            BestAnt = ant(k);
        end
        
    end
    
    % Update Phromones
    for k = 1 : antCount
        
        direction = ant(k).Direction;
        direction = [direction, direction(1)];
        
        for l = 1 : model.cityCount
            
            i = direction(l);
            j = direction(l + 1);
            
            tau(i, j) = tau(i, j) + Q / ant(k).Cost;
        end
    end
    
    % Evaporation
    tau = (1 - rho) * tau;
    
    % Store Best Cost
    BestCost(counter) = BestAnt.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(counter) ': Best Cost = ' num2str(BestCost(counter))]);
    
    % Plot Solution
    figure(1);
    PlotModel(BestAnt.Direction, model);
end

%% Results
figure(2)
plot(BestCost, 'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
