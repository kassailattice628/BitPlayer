function CheckDuration_Camera(app)

rect = app.recobj.rect;
if app.CaptureTime.Value > rect
    errordlg('Camera capture duration is longer than the DAQ recording time!')
    
    %Reset capture time
    app.CaptureTime.Value = 1000;
    app.imaq.duration_ms = 1000;
else
    app.imaq.duration_ms = app.VideoCaptureTime.Value;
end


end