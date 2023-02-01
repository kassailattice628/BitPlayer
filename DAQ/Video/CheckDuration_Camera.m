function CheckDuration_Camera(app)

rect = app.recobj.rect;

if app.VideoCaptureTime.Value > rect
    errordlg('Camera capture duration is longer than the DAQ recording time!')
    
    %Reset capture time
    app.VideoCaptureTime.Value = 1000;
end

app.imaq.duration_ms = app.VideoCaptureTime.Value;

end