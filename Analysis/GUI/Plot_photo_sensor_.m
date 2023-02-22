function Plot_photo_sensor(ax, th, ON, OFF, t)
%
% Plot photo senseor data.
% Return crossing point of sensor threshold to correcting visual stimulus
% timing.
%

%% Sensor data

hold(ax, 'on');
%stim line
line(ax, [ON, ON], [ax.YLim(1), ax.YLim(2)], 'Color', "#4DBEEE");
line(ax, [OFF, OFF], [ax.YLim(1), ax.YLim(2)], 'Color', "#4DBEEE");

%threshold line
line(ax, [t(1), t(end)],[th, th],'Color', 'c');
hold(ax, 'off');



end