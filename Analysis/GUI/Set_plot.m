function Set_plot(ax, x, y, stim)

ON = stim(1);
OFF = stim(2);

%% Plot data
ax.XLim = [min(x), max(x)];
plot(ax, x, y, 'Color', [0 0.4470 0.7410])


%% Add stim timing
if ~isempty(ON) && ~isempty(OFF)

    upper = ax.YLim(1);
    lower = ax.YLim(2);
    
    hold(ax, 'on');
    area_ax = area(ax, [ON, OFF], [upper, upper],...
        'FaceColor', 'k', 'LineStyle', 'none', 'ShowBaseLine', 'off',...
        'basevalue', lower);
    alpha(area_ax, 0.1);
    
end
hold(ax, 'off');

end