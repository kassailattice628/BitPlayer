function scanAvailableCallback_BP(app, src, ~)
%scansAvailableFcn Executes on DAQ ScansAvailable event
%
%  This callback function gets executed periodically as more data is acquired.
%  For a smooth live plot update, it stores the latest N seconds
%  (specified time window) of acquired data and relative timestamps in
%  FIFO(First in, First out) buffers. 
%  A live plot is updated with the data in the FIFO buffer.
%

c = app.c; % Capture setting

%% Get data from daq
[data, timestamps, ~] =...
    read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");

% Store continuous acquisition data in FIFO data buffers
app.TimestampsFIFOBuffer =...
    storeDataInFIFO(app.TimestampsFIFOBuffer, c.BufferSize, timestamps);

app.DataFIFOBuffer =...
    storeDataInFIFO(app.DataFIFOBuffer, c.BufferSize, data);

%% Update live plot data
samplesToPlot =...
    min([round(c.livePlotTimeSpan * src.Rate), size(app.DataFIFOBuffer,1)]);

firstPoint = size(app.DataFIFOBuffer, 1) - samplesToPlot + 1;

if samplesToPlot > 1
    a = app.TimestampsFIFOBuffer;
    xlim(app.PupilCenterXY, [a(firstPoint), a(end)])
    xlim(app.PhotoSensor,[a(firstPoint), a(end)])
    xlim(app.TriggerMonitor,[a(firstPoint), a(end)])
    xlim(app.RotaryEncoder,[a(firstPoint), a(end)])
end

% Channel assignment %
%1 addinput(d_in, "Dev2", "ai0", "Voltage") %pupil X
%2 addinput(d_in, "Dev2", "ai1", "Voltage") %pupil Y
%3 addinput(d_in, "Dev2", "ai2", "Voltage") %photo sensor
%4 addinput(d_in, "Dev2", "ai3", "Voltage") %trigger monitor
%5 addinput(d_in, "Dev2", "ai4", "Voltage") %pupil size
%6 addinput(d_in, "Dev2", "ai5", "Voltage") %researve
%7 addinput(d_in, "Dev2", "ctr0",  "Position") %rotary encoder
%8 addinput(d_in, "Dev2", "Port0/Line4", "Digital") %RST monitor

%Pupil
t = app.TimestampsFIFOBuffer(firstPoint:end);
app.plot1(1).XData = t;
app.plot1(1).YData = app.DataFIFOBuffer(firstPoint:end, 1);
app.plot1(2).XData = t;
app.plot1(2).YData = app.DataFIFOBuffer(firstPoint:end, 2);

%Photo sensor
app.plot2.XData = t;
app.plot2.YData = app.DataFIFOBuffer(firstPoint:end, 3);

%Rotary Encoder (-> Checking RTS(ch8))
app.plot3.XData = t;
REang = Decode_RotaryEncoder(app.DataFIFOBuffer(firstPoint:end, 7));
app.plot3.YData = REang - REang(1); %offset

%Trigger monitor
app.plot5.XData = t;
app.plot5.YData = app.DataFIFOBuffer(firstPoint:end, 4);

%% Detect RTS trigger from PTB
if app.StandAloneModeButton.Value
    app.RTS = true;
else
    app.RTS = any(app.DataFIFOBuffer(firstPoint:end, 8));
end

stateMonitor(app);
%disp(app.CurrentState)

%% App state control logic
switch app.CurrentState
    case 'Aqcuisition.Buffering'

        if size(app.TimestampsFIFOBuffer, 1) > 1 %app.c.BufferSize/2
            app.CurrentState = 'Capture.LookingForRTS';
        end

    case 'Capture.LookingForRTS'

        if app.RTS
            app.CurrentState = 'Capture.LookingForTrigger';
            app.RTS = false;
        end

    case 'Capture.LookingForTrigger'
        % Check Trigger condition
        detectTrigger(app);
        
        if app.TrigActive
            app.CurrentState = 'Capture.CapturingData';
            %Reset trigger
            write(app.d_out, [0, 0, 0, 0]);
            app.TrigActive = false;
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
        

        if app.CameraSave.Value
            app.CurrentState = 'Saving.Movie';
        else
            app.capturing = false;
            app.CurrentState = 'Loop.End';
        end

    case 'Saving.Movie'
        if isrunning(app.imaq.vid)
            % Still acquiring video
            fprintf("%d frame is acquired.\n", app.imaq.vid.FramesAcquired);
            while app.imaq.vid.FramesAcquired < app.imaq.vid.DiskLoggerFrameCount
                pause(.1);
                disp('Movie saving...')
            end
            stop(app.imaq.vid)
        end

        fprintf("%d frame is acquired.\n", app.imaq.vid.FramesAcquired);
        disp(['Movie is saved as: ', app.imaq.movie_fname]);
        app.capturing = false;
        app.CurrentState = 'Loop.End';

end
end


%% subfunctions
function data = storeDataInFIFO(data, buffersize, datablock)
%storeDataInFIFO Store continuous acquisition data in a FIFO data buffer
% Storing data in a finite-size FIFO buffer is used to plot the 
% latest "N" seconds of acquired data for a smooth live plot.
%
% The most recently acquired data ("datablock") is added to the buffer
% If the amount of data in the buffer exceeds the specified buffer size
% ("buffersize") the oldest data is discarded to cap the size of
% the data in the buffer to buffersize.
%
% INPUT 
% data:         existing data buffer (column vector Nx(# of channels))
% buffersize:   desired buffer size (maximum number of rows in data buffer)
% datablock:    a new data block to be added to the buffer (column vector Kx(#Channels)).
% 
% OUTPUT
% data:         updated data buffer (column vector Mx1).



% If the data size is greater than the buffer size, keep only the
% the latest "buffer size" worth of data.
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
        % example)
        % current data: [1,1,1,0,0,0,0,0], new data: [2,2,2]
        % updated data: [2,2,2,1,1,1,0,0] -> discard [0,0,0]
        shiftPosition = size(datablock,1);
        data = circshift(data,-shiftPosition); 
        data(end-shiftPosition+1:end,:) = datablock;


    elseif (size(data,1) < buffersize) &&...
            (size(data,1)+size(datablock,1) > buffersize)
        % Current data size is less than buffer size and appending the new
        % data block results in a size greater than the buffer size.
        data = [data; datablock];
        shiftPosition = size(data,1) - buffersize;
        data = circshift(data,-shiftPosition);
        data(buffersize+1:end, :) = [];

    else
        % Current data size is less than buffer size and appending the new
        % data block results in a size smaller than or equal to the buffer size.
        % size(data,1) < buffersize
        % size(data,1)+size(datablock,1) <= buffersize
        data = [data; datablock];
    end
else
    % Data block size (number of rows) is larger than or equal to buffer size
    data = datablock(end-buffersize+1:end,:);
end

end

