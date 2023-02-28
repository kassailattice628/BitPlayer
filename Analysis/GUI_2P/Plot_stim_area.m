function Plot_stim_area(app)
%
% Show stim timing as a gray boxes.
%

ax1 = app.UIAxes;   % n_ROI
ax2 = app.UIAxes_2; % selected_ROI

Get_stim_timing(app);

%%
s = app.sobj;

% plot stim area1
fill(ax1, s.stim_area_X, s.stim_area_Y, [0.9, 0.9, 0.9], 'EdgeColor', 'none');
hold(ax1, 'on');
app.ax1_p = plot(ax1, app.imgobj.FVt, zeros(1, size(app.imgobj.F, 1)),...
    'Color', [0 0.4470 0.7410]);
hold(ax1, 'off');

% plot stim area2
fill(ax2, s.stim_area_X, s.stim_area_Y, [0.9, 0.9, 0.9], 'EdgeColor', 'none');
hold(ax2, 'on');
app.ax2_p = plot(ax2, app.imgobj.FVt, zeros(1, size(app.imgobj.F, 1)), 'k');
hold(ax2, 'off');
end