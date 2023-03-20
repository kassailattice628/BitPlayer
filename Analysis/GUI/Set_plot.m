function YLims = Set_plot(ax, x, y)

% Plot data
ax.XLim = [min(x), max(x)];
plot(ax, x, y, 'Color', [0 0.4470 0.7410])

% YLim
y1 = min(y);
y2 = max(y);
yr = (y2 - y1)*0.1;

YLims = [y1 - yr, y2 + yr];

if YLims(1) < YLims(2)
    ax.YLim = [YLims(1), YLims(2)];
end

end