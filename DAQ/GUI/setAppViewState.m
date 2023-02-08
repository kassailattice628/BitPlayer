function setAppViewState(app, state)
%set ON/OFF of app.GUI.Enable depends on the app state

switch state
    case 'Setup'
        app.EditFieldMouseID.Enable = 'off';
        app.EditFieldFileName.Enable = 'off';
        app.RecTime.Enable = 'off';
        app.SamplingRate.Enable = 'off';
        app.LiveTime.Enable = 'off';
        app.SAVEONButton.Enable = 'off';
        app.DAQSTARTButton.Enable = 'off';
        app.StandAloneModeButton.Enable = 'off';
        app.CameraButton.Enable = 'off';
        app.TTLSwitch.Enable = 'off';
    case 'Ready'
        app.EditFieldMouseID.Enable = 'on';
        app.EditFieldFileName.Enable = 'on';
        app.RecTime.Enable = 'on';
        app.SamplingRate.Enable = 'on';
        app.LiveTime.Enable = 'on';
        app.SAVEONButton.Enable = 'on';
        app.DAQSTARTButton.Enable = 'on';
        app.StandAloneModeButton.Enable = 'on';
        app.CameraButton.Enable = 'on';
        app.TTLSwitch.Enable = 'on';
end