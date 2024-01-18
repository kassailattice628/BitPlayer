function Plot_stim_area(app)
%
% Show stim timing as a gray boxes.
%

ax1 = app.UIAxes;   % n_ROI

Get_stim_timing_2p(app);

%%
s = app.sobj;

% plot stim area1
fill(ax1, s.stim_area_X, s.stim_area_Y, [0.9, 0.9, 0.9], 'EdgeColor', 'none');
hold(ax1, 'on');

if ~isfield(app.imgobj, 'FVt')
    app.imgobj.FVt = app.FVsampt.Value;
end

if isfield(app.imgobj, 'F')
    app.ax1_p = plot(ax1, app.imgobj.FVt,...
        zeros(1, size(app.imgobj.F, 1)), 'Color', [0 0.4470 0.7410]);
end

hold(ax1, 'off');

end