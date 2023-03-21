function Check_Stim_Duration(app)
%
% When Moving Bar/Spot is selected,
% Stim Duration will be presented in GUI.
%
pattern = app.PatternDropDown.Value;

switch pattern
    case {'Moving Bar', 'Moving Spot', 'Looming'}    
        [distance, duration] = Set_MovingDuration(app.sobj);

        app.sobj.MovingDuration = duration;
        app.sobj.MovingDistance = distance;

        %Update GUI

        app.DurationMoveStim_Label.Text = ...
            ['Duration in Moving Stim: ' num2str(duration, 3), ' sec'];

        app.DurationMoveStim_Label.Enable = 'on';
        app.Duration.Enable = 'off';
        app.Duration_Label.Enable = 'off';

        app.BlankloopLabel.Text = ['loops = ',...
            num2str(app.sobj.MovingDuration * app.sobj.Blankloop_times),...
            ' sec'];
        
    otherwise
        app.DurationMoveStim_Label.Enable = 'off';
        app.Duration.Enable = 'on';
        app.Duration_Label.Enable = 'on';

        app.BlankloopLabel.Text = ['loops = ',...
                num2str((app.sobj.Duration_sec + app.sobj.ISI_sec)*app.sobj.Blankloop_times),...
                ' sec'];

        
end

end 