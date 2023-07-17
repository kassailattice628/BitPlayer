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

        app.EditFieldMouseID.Editable = 'on';
        app.EditFieldFileName.Editable = 'on';
        app.RecTime.Editable = 'on';
        app.SamplingRate.Editable = 'on';

    case 'Recording'
        app.EditFieldMouseID.Editable = 'off';
        app.EditFieldFileName.Editable = 'off';
        app.RecTime.Editable = 'off';
        app.SamplingRate.Editable = 'off';

    case 'CameraON'
        app.AdujstROIButton.Enable = 'on';
        app.CameraPreviewButton.Enable = 'on';
        
        if app.saveON
            app.CameraSave.Enable = 'on';
        end

        app.VideoCaptureDelay.Enable = 'on';
        app.VideoCaptureTime.Enable = 'on';
        app.VideoFrameRate.Enable = 'on';
        app.CameraButton.Text = 'Camera ON';
        app.CameraButton.BackgroundColor = [0, 1, 0];

    case 'CameraOFF'
        app.AdujstROIButton.Enable = 'off';
        app.CameraPreviewButton.Enable = 'off';
        app.CameraSave.Enable = 'off';
        app.CameraSave.Value = 0;
        app.CameraSave.BackgroundColor = [0.96, 0.96, 0.96];
        app.CameraSave.Text = 'SAVE CAM OFF';
        app.VideoCaptureDelay.Enable = 'off';
        app.VideoCaptureTime.Enable = 'off';
        app.VideoFrameRate.Enable = 'off';
        app.CameraButton.Text = 'Camera OFF';
        app.CameraButton.BackgroundColor = [.96, .96, .96];

end