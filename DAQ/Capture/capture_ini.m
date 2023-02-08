function capture_ini(app)
%% DAQ capture settings
% Specify triggered capture timespan, in seconds
capture.TimeSpan = app.recobj.rect/1000; % ms -> sec

% Specify continuous data plot timespan
capture.livePlotTimeSpan = app.LiveTime.Value/1000; %ms -> sec

% Determine the timespan corresponding to the block of samples supplied
% to the DataAvailable event callback function.
capture.callbackTimeSpan = double(app.d_in.ScansAvailableFcnCount)/app.d_in.Rate;

% Determine required buffer timespan, seconds
buffertimespan= max([capture.TimeSpan, capture.livePlotTimeSpan]);
capture.BufferTimeSpan = buffertimespan + 5*capture.callbackTimeSpan;
%2 * callbackTimeSpan is too short?? change to 5 //20230208

% Determine data buffer size
capture.BufferSize = ceil(app.d_in.Rate * capture.BufferTimeSpan);
%capture.BufferSize =  round(capture.BufferTimeSpan * d_in.Rate);

app.c = capture;
end
