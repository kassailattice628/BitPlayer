function Plot_dFF_next(app)
%
% plot dFF in GUI
%

im = app.imgobj;
n = app.n_ROI.Value;
ax1_plot = app.ax1_p;



%% Update plot
y = im.dFF(:,n);
%plot(ax, im.FVt, y);

ax1_plot.XData = im.FVt;
ax1_plot.YData = y;

if ~isnan(y(1))
    app.UIAxes.YLim = [min(y) * 1.2, max(y)*1.2];
else
    disp(['ROI# ', num2str(n), ' does not contain data.']);
end


end