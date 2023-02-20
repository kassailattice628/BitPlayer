function [ON, OFF] = Get_stim_timing(app)
%
% Correct Visual Stimulus timing by Photo sensor signal
% and Thoreshold (GUI).
%
ON = [];
OFF = [];

n = app.n_in_loop;
if ~isempty(app.sobj)
s = app.sobj;
p = app.ParamsSave;
th = app.Threshold_photo_sensor.Value;

end

%%
if n > prestim
    % May have photo sensor signals
    % Detect crossing point (ON, OFF)
    i_stim_on = find(app.SaveData(:, 3, n) > th, 1);
    i_stim_off = find(app.SaveData(:, 3, n) > th, 1, 'last');
    
    if ~isempty(i_stim_on) && ~isempty(i_stim_off)
        t_on = app.SaveTimestamps(i_stim_on, n);
        t_off = app.SaveTimestamps(i_stim_off, n);
        
        if ~isfield(p{1,n}.stim1, 'corON')
            ON = t_on - (s.RECT(4) - p{1,n}.stim1.centerY_pix -...
                
        endkassailattice628
        


end