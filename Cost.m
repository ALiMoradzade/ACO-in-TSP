function cost = Cost(direction, model)

    n = numel(direction);

    direction = [direction, direction(1)];
    
    cost = 0;
    for i = 1 : n
        cost = cost + model.distances(direction(i), direction(i + 1));
    end
end
