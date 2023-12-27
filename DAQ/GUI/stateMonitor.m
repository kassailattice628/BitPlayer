function stateMonitor(app)
%Show current state in GUI window;
switch app.CurrentState
    case "DAQstop"
        app.StateText.Text = 'Ready';
        app.StateText.FontColor = [0, 0, 0];

    case 'Aqcuisition.Buffering'
        app.StateText.Text = 'Buffering Data...';

    case 'Capture.LookingForRTS'
        app.StateText.Text = 'Wating for RTS from PTB...';
        app.StateText.FontColor = [1.00,0.00,0.00];

    case 'Capture.LookingForTrigger'
        app.StateText.Text = 'Wating for Trigger...';
        app.StateText.FontColor = [1.00,0.41,0.16];

    case 'Capture.CapturingData'
        app.StateText.Text = 'Capturing Data...';
        app.StateText.FontColor = [0, 0, 1];
        
    case 'Capture.CaptureComplete'
        app.StateText.Text = 'Finish Capture!!!!';
        app.StateText.FontColor = [0.07,0.62,1.00];

    case 'Saving.Movie'
        app.StateText.Text = 'Saving movie file...';
        app.StateText.FontColor = [0,1,0];

    case 'Loop.End'
        app.StateText.Text = 'Waiting ITI...';
        app.StateText.FontColor = [0, 0, 0];
end

end