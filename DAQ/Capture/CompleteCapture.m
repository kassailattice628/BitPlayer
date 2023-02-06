function CompleteCapture(app)
%When capture was completed, plot them and save.

% Find index of first sample in data buffer to be captured
firstSampleIndex =...
    find(app.TimestampsFIFOBuffer >= app.CaptureStartMoment, 1, 'first');

% Find index of last sample in data buffer that complete the capture
lastSampleIndex = firstSampleIndex + app.recobj.recp -1;


%% Capture Error Handring
if isempty(firstSampleIndex) ||...
        isempty(lastSampleIndex) ||...
        lastSampleIndex > size(app.TimestampsFIFOBuffer, 1)
    % Something went wrong
    % Abort capture
    %app.StatusText.Text = 'Capture error';

    app.DAQSTOPButton.Enable = "off";
    app.loopON = false;
    stop(app.d_in);
    flush(app.d_in);
    app.DAQSTARTButton.Enable = "on";
    uialert(app.BitPlayer_DAQAppUIFigure,...
        'Could not complete capture.', 'Capture error');
    return
end

%% Extract captured data
app.CaptureData = app.DataFIFOBuffer(firstSampleIndex:lastSampleIndex,:);
app.CaptureTimestamps =...
    app.TimestampsFIFOBuffer(firstSampleIndex:lastSampleIndex);

%% Update captured plot
app.plot4(1).XData = app.CaptureTimestamps;
app.plot4(1).YData = app.CaptureData(:,1);
app.plot4(2).XData = app.CaptureTimestamps;
app.plot4(2).YData = app.CaptureData(:,2);
app.PlotRecorded.Title.String = ...
    ['Captured Trace: trial#:', num2str(app.recobj.n_in_loop)];

app.PlotRecorded.XLim =...
    [min(app.CaptureTimestamps), max(app.CaptureTimestamps)];

%% Save captured data to var.
if app.saveON
    app.SaveData(:, :, app.recobj.n_in_loop) = app.CaptureData;
    app.SaveTimestamps(:, app.recobj.n_in_loop) = app.CaptureTimestamps;
    fprintf("Saved capture loop#: %d.\n", app.recobj.n_in_loop)
else
    fprintf("Complete capture, loop#: %d.\n", app.recobj.n_in_loop)
end

% count up loop number
app.recobj.n_in_loop = app.recobj.n_in_loop + 1; 
       
end