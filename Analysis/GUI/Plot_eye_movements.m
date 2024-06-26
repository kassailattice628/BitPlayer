function Plot_eye_movements(app)
%
% Plot horizontal & vertical eye movements, and radial velocity of the
% pupil center.
% Add detected saccade if exists.
%
%%
p = app.ParamsSave;
n = app.n_in_loop;
t = app.SaveTimestamps;
data = app.SaveData;

ON = p{1,n}.stim1.correct_StimON_timing;
OFF = p{1,n}.stim1.correct_StimOFF_timing;
t_saccades = p{1,n}.t_saccades;
p_saccades = p{1,n}.p_saccades;


%% Plot
% Velocity
Set_plot(app.UIAxes_3, t(1:end-1, n), p{n}.eye_velocity);
Add_plot_saccade(app.UIAxes_3, t_saccades, p{n}.eye_velocity(p_saccades));
Add_stim_timing(app.UIAxes_3, ON, OFF, 'Velocity')



% Horizontal
Set_plot(app.UIAxes_1, t(:, n), data(:, 1, n));
Add_plot_saccade(app.UIAxes_1, t_saccades, data(p_saccades, 1, n));

if isempty(app.Max_H) || app.Fix_YButton.Value ~= 1

    app.UIAxes_1.YLimMode = 'manual';
    app.UIAxes_1.YLim = [min(data(:, 1, n)), max(data(:, 1, n))];
elseif app.Fix_YButton.Value == 1
    
    app.UIAxes_1.YLimMode = 'manual';
    app.UIAxes_1.YLim = [app.Min_H, app.Max_H];
end

Add_stim_timing(app.UIAxes_1, ON, OFF, 'Horiziontal')

% Vertical
Set_plot(app.UIAxes_2, t(:, n), data(:, 2, n));
Add_plot_saccade(app.UIAxes_2, t_saccades, data(p_saccades, 2, n));
if isempty(app.Max_H) || app.Fix_YButton.Value ~= 1
    app.UIAxes_2.YLimMode = 'manual';    
    app.UIAxes_2.YLim = [min(data(:, 2, n)), max(data(:, 2, n))];
elseif app.Fix_YButton.Value == 1

    app.UIAxes_2.YLimMode = 'manual';
    app.UIAxes_2.YLim = [app.Min_V, app.Max_V];
end
Add_stim_timing(app.UIAxes_2, ON, OFF, 'Vertical')

end