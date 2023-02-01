function CheckDuration_Camera(app)

rect = app.recobj.rect;

if app.VideoCaptureTime.Value + app.VideoCaptureDelay.Value > rect
    errordlg('Camera capture duration is longer than the DAQ recording time!')
    
    %Reset capture time
    app.VideoCaptureTime.Value = 1000;
    app.VideoCaptureDelay.Value = 0;
end

app.imaq.duration_ms = app.VideoCaptureTime.Value;
app.imaq.delay_ms = app.VideoCaptureTime.Value;

end