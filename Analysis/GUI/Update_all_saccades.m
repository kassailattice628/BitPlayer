function Update_all_saccades(app)
%
% Re-calcurate all saccade from all traials.
%

p = app.ParamsSave;
t = app.SaveTimestamps;
disp('Update all saccades...')
for i = 1:size(t, 2)
    if ~isfield(p{1,i}, 'correct_StimON_timing')
        [ON, OFF] = Get_stim_timing(app); 
        p{1,i}.stim1.correct_StimON_timing = ON;
        p{1,n}.stim1.correct_StimOFF_timing = OFF;
    end
    
    [locations, ~] = Get_detect_saccade(...
        p{1,i}.eye_velocity, app.recobj.sampf,...
        [app.Threshold_saccade_low.Value,...
        app.Threshold_saccade_high.Value]);
    
    t_saccades = t(locations, i);
    app.ParamsSave{1,i}.p_saccades = locations; %time point
    app.ParamsSave{1,i}.t_saccades = t_saccades; %time
    
end
disp('Done...')
app.n_in_loop = i;
app.Trial_n.Value = i;

end