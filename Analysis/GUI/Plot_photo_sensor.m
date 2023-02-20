function [corON, corOFF] = Plot_photo_sensor(app, t, d)
%
% Plot photo senseor data.
% Return crossing point of sensor threshold to correcting visual stimulus
% timing.
%


%% Correct stim onset/offset
% [corON, corOFF] = Get_correct_stim_timing(app, t, d, th, flag);
% app.ParamsSave{1,n}.stim1.corON = corON;
% app.ParamsSave{1,n}.stim1.corOFF = corOFF;

%% Sensor data


if n > app.recobj.prestim
    %stim line
    hold(app.UIAxes_photosensor, 'on');
    line(app.UIAxes_photosensor, [corON, corON], [-1, 150], 'Color', 'r');
    line(app.UIAxes_photosensor, [corOFF, corOFF], [-1, 150], 'Color', 'g');
    
    %threshold line
    line(app.UIAxes_photosensor, [t(1), t(end)],[th, th],'Color', 'r');
    hold(app.UIAxes_photosensor, 'off');
end

end