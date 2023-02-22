function Update_saccade(app)
p = app.ParamsSave;
n = app.n_in_loop;
t = app.SaveTimestamps;

% Recaluculate saccade timing
[locations, ~] = Get_detect_saccade(p{1,n}.eye_velocity, app.recobj.sampf,...
    [app.Threshold_saccade_low.Value, app.Threshold_saccade_high.Value]);
t_saccades = t(locations, n);
app.ParamsSave{1,n}.p_saccades = locations; %time point
app.ParamsSave{1,n}.t_saccades = t_saccades; %time

end