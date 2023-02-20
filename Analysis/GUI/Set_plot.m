function Set_plot(ax, x, y)

ax.XLim = [min(x), max(x)];
plot(ax, x, y, 'Color', [0 0.4470 0.7410])

end