function PlotModel(direction, model)

    direction = [direction, direction(1)];
    plot(model.x(direction), model.y(direction), 'k-s', ...
        'MarkerSize',12,...
        'MarkerFaceColor','y',...
        'LineWidth',2);
end
