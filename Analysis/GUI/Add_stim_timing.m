function Add_stim_timing(ax, ON, OFF, type)

switch type
    case 'Velocity'
        lower = -0.2;
        upper = 8;
        ax.YLim = [lower, upper];
        
    otherwise
        lower = ax.YLim(1);
        upper = ax.YLim(2);
end

% Addd shaded area
if ~isempty(ON) && ~isempty(OFF)
    hold(ax, 'on');
    area_ax = area(ax, [ON, OFF], [upper, upper],...
        'FaceColor', 'k', 'LineStyle', 'none', 'ShowBaseLine', 'off',...
        'basevalue', lower);
    alpha(area_ax, 0.1);
    hold(ax, 'off');
end