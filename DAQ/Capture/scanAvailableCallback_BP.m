function scanAvailableCallback_BP(app, src, ~)
%scansAvailableFcn Executes on DAQ ScansAvailable event
%
%  This callback function gets executed periodically as more data is acquired.
%  For a smooth live plot update, it stores the latest N seconds
%  (specified time window) of acquired data and relative timestamps in
%  FIFO(First in, First out) buffers. 
%  A live plot is updated with the data in the FIFO buffer.
%%
c = app.c; % Capture setting

% Get data from daq
[data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");

% Store continuous acquisition data in FIFO data buffers
app.TimestampsFIFOBuffer = storeDataInFIFO(app.TimestampsFIFOBuffer, c.BufferSize, timestamps);
app.DataFIFOBuffer = storeDataInFIFO(app.DataFIFOBuffer, c.BufferSize, data);

%% Update live plot data
samplesToPlot = min([round(c.livePlotTimeSpan * src.Rate), size(app.DataFIFOBuffer,1)]);
firstPoint = size(app.DataFIFOBuffer, 1) - samplesToPlot + 1;

if samplesToPlot > 1
    xlim(app.PupilCenterXY, [app.TimestampsFIFOBuffer(firstPoint), app.TimestampsFIFOBuffer(end)])
    xlim(app.PhotoSensor, [app.TimestampsFIFOBuffer(firstPoint), app.TimestampsFIFOBuffer(end)])
    xlim(app.TriggerMonitor, [app.TimestampsFIFOBuffer(firstPoint), app.TimestampsFIFOBuffer(end)])
    xlim(app.RotaryEncoder, [app.TimestampsFIFOBuffer(firstPoint), app.TimestampsFIFOBuffer(end)])
end

%Pupil
t = app.TimestampsFIFOBuffer(firstPoint:end);
app.plot1(1).XData = t;
app.plot1(1).YData = app.DataFIFOBuffer(firstPoint:end, 1);
app.plot1(2).XData = t;
app.plot1(2).YData = app.DataFIFOBuffer(firstPoint:end, 2);

%Photo sensor
app.plot2.XData = t;
app.plot2.YData = app.DataFIFOBuffer(firstPoint:end, 3);

%Rotary Encoder -> Checking RTS
app.plot3.XData = t;
app.plot3.YData = app.DataFIFOBuffer(firstPoint:end, 8);

%Trigger monitor
app.plot5.XData = t;
app.plot5.YData = app.DataFIFOBuffer(firstPoint:end, 4);

% Detect RTS trigger from PTB
if app.StandAloneModeButton.Value
    app.RTS = true;
else
    app.RTS = any(app.DataFIFOBuffer(firstPoint:end, 8));
end

%%
% After enough data is acquired for a complete capture,
% as specified by the capture duration, extract the capture data from the
% data buffer and save it to a base workspace variable.

%{
% For trigger detection, store previous and current ScanAvailable callback
% data and timestamps
if isempty(app.Timestamps)
    app.Data = data;
    app.Timestamps = timestamps;
else

    app.Data = app.TimestampsFIFOBuffer(firstPoint:end,:);
    app.TimeStamps = app.TimestampsFIFOBuffer(firstPoint:end);
    %app.Data = [app.Data(end, :); data];
    %app.Timestamps = [app.Timestamps(end,:); timestamps];
end
%}


stateMonitor(app);

%% App state control logic
switch app.CurrentState
    case 'Aqcuisition.Buffering'
        app.CurrentState = 'Capture.LookingForRTS';

%         if size(app.TimestampsFIFOBuffer, 1) > 1 %app.c.BufferSize/2
%             app.CurrentState = 'Capture.LookingForTrigger';
%         end

    case 'Capture.LookingForRTS'

        if app.RTS %&& size(app.TimestampsFIFOBuffer, 1) > 1
            app.CurrentState = 'Capture.LookingForTrigger';
        end

    case 'Capture.LookingForTrigger'
        detectTrigger(app)
        if app.TrigActive
            app.CurrentState = 'Capture.CapturingData';
        end

    case 'Capture.CapturingData'
        %Not enough acquired data to cover capture timespan (rect) during
        %this ScanAvailable callback execution
        if isEnoughDataCpatured(...
                app.TimestampsFIFOBuffer(end), ...
                app.CaptureStartMoment, ...
                app.c.TimeSpan)

            app.CurrentState = 'Capture.CaptureComplete';
        end

    case 'Capture.CaptureComplete'
        %Acquired enough data to complete capture of specified duration
        CompleteCapture(app)

        app.CurrentState = 'Capture.LookingForRTS';
end


end


%% subfunctions
function data = storeDataInFIFO(data, buffersize, datablock)
%storeDataInFIFO Store continuous acquisition data in a FIFO data buffer
%  Storing data in a finite-size FIFO buffer is used to plot the latest "N" seconds of acquired data for
%  a smooth live plot update and without continuously increasing memory use.
%  The most recently acquired data ("datablock") is added to the buffer and if the amount of data in the
%  buffer exceeds the specified buffer size ("buffersize") the oldest data is discarded to cap the size of
%  the data in the buffer to buffersize.
%
%  input 
%  "data" is the existing data buffer (column vector Nx(#Channels))
%  "buffersize" is the desired buffer size (maximum number of rows in data buffer) and can be changed.
%  "datablock" is a new data block to be added to the buffer (column vector Kx(#Channels)).
%  output
%  "data" is the updated data buffer (column vector Mx1).

% If the data size is greater than the buffer size, keep only the
% the latest "buffer size" worth of data
% This can occur if the buffer size is changed to a lower value during acquisition
if size(data,1) > buffersize
    data = data(end-buffersize+1:end, :);
end

if size(datablock,1) < buffersize
    % Data block size (number of rows) is smaller than the buffer size
    if size(data,1) == buffersize
        % Current data size is already equal to buffer size.
        % Discard older data and append new data block,
        % and keep data size equal to buffer size.
        % current data(=[0,0,0,0,0,0,1,1,1])
        % new data (=[2,2,2])
        %  [([0,0,0]<- discard, ),0,0,0,1,1,1,(<- append [2,2,2])]
        % update data (= [0,0,0,1,1,1,2,2,2])
        shiftPosition = size(datablock,1);
        data = circshift(data,-shiftPosition); 
        data(end-shiftPosition+1:end,:) = datablock;

    elseif (size(data,1) < buffersize) && (size(data,1)+size(datablock,1) > buffersize)
        % Current data size is less than buffer size and appending the new
        % data block results in a size greater than the buffer size.
        data = [data; datablock];
        shiftPosition = size(data,1) - buffersize;
        data = circshift(data,-shiftPosition);
        data(buffersize+1:end, :) = [];

    else
        % Current data size is less than buffer size and appending the new
        % data block results in a size smaller than or equal to the buffer size.
        % (if (size(data,1) < buffersize) && (size(data,1)+size(datablock,1) <= buffersize))
        data = [data; datablock];
    end
else
    % Data block size (number of rows) is larger than or equal to buffer size
    data = datablock(end-buffersize+1:end,:);
end

end

