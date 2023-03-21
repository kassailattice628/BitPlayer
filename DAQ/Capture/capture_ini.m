function capture_ini(app)
%% DAQ capture settings
% Specify triggered capture timespan, in seconds
capture.TimeSpan = app.recobj.rect/1000; % ms -> sec

% Specify continuous data plot timespan
capture.livePlotTimeSpan = app.LiveTime.Value/1000; %ms -> sec

% Determine the timespan corresponding to the block of samples supplied
% to the DataAvailable event callback function.
% default: 0.1sec (10 times/s)
capture.callbackTimeSpan = double(app.d_in.ScansAvailableFcnCount)/app.d_in.Rate;

% Determine required buffer timespan, seconds
%buffertimespan= max([capture.TimeSpan, capture.livePlotTimeSpan]);
capture.BufferTimeSpan = capture.TimeSpan + 2 * capture.callbackTimeSpan;
%2 * callbackTimeSpan is too short?? change to 5 //20230208

% Determine data buffer size (point)
capture.BufferSize = ceil(app.d_in.Rate * capture.BufferTimeSpan);

app.c = capture;
end
