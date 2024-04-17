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

        blank_duration = (app.sobj.MovingDuration + app.sobj.ISI_sec)*...
            app.sobj.Blankloop_times;

    case {'Decode SC_v2', 'Decode test_v2',...
            'ImageNet train', 'ImageNet test'}
          
        [distance, duration] = Set_MovingDuration(app.sobj);
        app.sobj.MovingDuration = duration;
        app.sobj.MovingDistance = distance;
        %Update GUI
        app.DurationMoveStim_Label.Text = ...
            ['Duration in Moving Stim: ' num2str(duration, 3), ' sec'];

        app.DurationMoveStim_Label.Enable = 'on';

        blank_duration = (app.sobj.MovingDuration + app.sobj.ISI_sec)*...
            app.sobj.Blankloop_times;

    
    case 'Image Presentation'
        app.DurationMoveStim_Label.Enable = 'off';
        app.Duration.Enable = 'off';
        app.Duration_Label.Enable = 'off';

        Duration_sec = 1; %ON + OFF + ON + OFF + ON (200ms each)
        app.sobj.FlipNum = round(Duration_sec * app.sobj.FrameRate);
        app.Duration_Label.Text = ['sec = ', num2str(app.sobj.FlipNum), ' flips'];
        blank_duration = (Duration_sec + app.sobj.ISI_sec)*...
            app.sobj.Blankloop_times;
        
    otherwise
        app.DurationMoveStim_Label.Enable = 'off';
        app.Duration.Enable = 'on';
        app.Duration_Label.Enable = 'on';

        blank_duration = (app.sobj.Duration_sec + app.sobj.ISI_sec)*...
            app.sobj.Blankloop_times;

        
end

%GUI
app.BlankloopLabel.Text = ['loops = ', num2str(blank_duration),' sec'];

end 