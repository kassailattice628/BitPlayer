function detectTrigger(app)
% Dtects trigger condition and update relevant properties.
% Update TrigActive, TrigMoment, and CapturStartMoment
%
persistent wait_trig


trigLevel = 4;
condition = app.DataFIFOBuffer(:,4) > trigLevel;

app.TrigActive = any(condition) & ~all(condition);

% trigger timing
app.TrigMoment = [];

if app.TrigActive
    %Find the momoent when trigger condition has been met
    disp('Triggered')
    moment_index = 1 + find(diff(condition)==1, 1, 'first');
    app.TrigMoment = app.TimestampsFIFOBuffer(moment_index);

    wait_trig = [];
else
    wait_trig = [wait_trig, 1];
    if length(wait_trig) == 50
        errordlg({'Missing first trigger!',...
            'Stop DAQ and start again.'})

        %Stop looping
        app.loopON = false;

        %Quit standalne mode
        app.StandAloneModeButton.Value = 0;
        app.StandAloneModeButton.BackgroundColor = [1, 0.82, 0.82];
        app.StandAloneModeButton.FontColor = [0, 0, 0];
        app.ITI.Enable = "off";
    end
end


app.CaptureStartMoment = app.TrigMoment;

end



