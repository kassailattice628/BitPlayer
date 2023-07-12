function Plot_dFF_next(app)
%
% plot dFF in GUI
%

im = app.imgobj;
n = app.n_ROI.Value;
ax1_plot = app.ax1_p;

if isfield(im, 'F')

    app.UIAxes.Title.String = ['ROI# ', num2str(n)];
    %% Update plot
    y = im.dFF(:,n);
    %plot(ax, im.FVt, y);

    ax1_plot.XData = im.FVt;
    ax1_plot.YData = y;

    if ~isnan(y(1))
        app.UIAxes.YLim = [min(y) * 1.2, max(y)*1.2];
        app.UIAxes.XLim = [0, im.FVt(end)];
    else
        disp(['ROI# ', num2str(n), ' does not contain data.']);
    end


end
end