function main_loop(app)
%%
% Loop fucntion of BitPlayer_DAQ
%
%
%

recobj = app.recobj;
n_in_loop = 1;

app.d_in.ScansAvailableFcn = @(src, evt) scanAvailableCallback_BP(app, src, evt);
%Start Background recording ---> See scanAvailableCallback_BP.m
start(app.d_in, 'continuous');

% Reset TTL
write(app.d_out, [0, 0, 0, 0])

app.CurrentState = 'Aqcuisition.Buffering';
stateMonitor(app)

app.recobj.DAQt = [];
t = tic;

while 1
    % Send CTS to PTB (Line3)
    %write(app.d_out, [0, 0, 1, 0]); %(1) DAQ trigger, (2) FV trigger, (3) PTB triggers, (4) ----
    stateMonitor(app)

    % Check button state
    if ~app.loopON
        disp('Loop Stop')
        write(app.d_out, [0, 0, 0, 0])
        break; % get out from main loop
    end

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%
    while app.RTS
        % Check button state
        if ~app.loopON
            break; % out from recording loop
        end
        stateMonitor(app)

        %% Video setting
        if app.CameraSave.Value
            app.imaq = LoggingVideoSetting(app.recobj, app.imaq, n_in_loop);
            %{
        % Whne CameraSave is ON
        % Generate experiment fodler and movie file name with trial number.
        movie_trial_dir = [app.recobj.SaveMovieDirMouse, '\Movie_', num2str(n_in_loop)];
        if exist(movie_trial_dir, 'dir')==0
            mkdir(movie_trial_dir)
        end

        % Save moive as AVI (<- originally MPEG-4)
        movie_fname = [movie_trial_dir, '\movie_', num2str(n_in_loop, '%03u')];
        %logvid = VideoWriter(movie_fname, 'MPEG-4');
        logvid = VideoWriter(movie_fname, 'Uncompressed AVI');
        logvid.FrameRate = app.imaq.src.FrameRate;
        app.imaq.vid.LoggingMode = 'disk';
        app.imaq.vid.DiskLogger = logvid;
        if isrunning(app.imaq.vid) == 0
            start(app.imaq.vid)
        end
            %}
        end

        %% Prep TTL
        if app.TTLSwitch.Value
            preload(app.d_out_ao, 5 * recobj.TTL.outputSignal) % 5V ouput
            start(app.d_out_ao);
        end
        
        %% Start Recording
        write(app.d_out, [1, 1, 1, 0]); %(1) DAQ trigger, (2) FV trigger, (3) PTB triggers, (4) nothing

        app.recobj.DAQt = [app.recobj.DAQt; toc(t)];
        fprintf("Loop#: %d.\n", n_in_loop);
        
        pause(0.05)
        %turn off triggers
        write(app.d_out, [0, 0, 0, 0]); % PTB trigger OFF
        %disp(app.StateText.Text)

        %% Wait for data acquisition
        %pause(app.recobj.interval + app.recobj.rect/1000)
        pause(app.recobj.rect/1000)

        %% Finishing loop
        % Store Data
        if length(app.CaptureTimestamps) == app.recobj.recp && app.saveON
            app.SaveData(:, :, n_in_loop) = app.CaptureData;
            app.SaveTimestamps(:, 1, n_in_loop) = app.CaptureTimestamps;
            fprintf("Saved loop#: %d.\n", n_in_loop)
        end

        % Save Movie
        if app.CameraSave.Value
            while app.imaq.vid.FramesAcquired ~= app.imaq.vid.DiskLoggerFrameCount
                pause(.1);
            end
            stop(app.imaq.vid)
            disp(['Movie is saved as', app.imaq.movie_fname]);
        end

        % Reset TTL pulse
        if app.TTLSwitch.Value
            stop(app.d_out_ao);
        end
        n_in_loop = n_in_loop + 1;        %% Start Recording

    end %end of RTS detected.



    pause(0.01) %Look for RTS

end % end of loop

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%

SaveData = app.SaveData;
SaveTimestamps = app.SaveTimestamps;
recobj.n_in_loop = n_in_loop - 1;

%% Save DAQ data to the file
if app.saveON
    save(app.recobj.FileName, 'recobj', 'SaveData', 'SaveTimestamps');

    clear SaveData SaveTimestamps
    app.SaveData = [];
    app.SaveTimestamps = [];
    app.Data = [];
    app.Timestamps = [];

    %SAVE Button change
    app.DAQSTOPButton.Enable = "off";
    app.DAQSTARTButton.Enable = "on";
    app.SAVEONButton.Enable = "on";
    app.SAVEOFFButton.Enable = "off";

    %flush memory
    stop(app.d_in);
    flush(app.d_in);
    %Rest state
    app.CurrentState = 'DAQstop';
    app.CaptureData = [];
    app.CaptureTimestamps = [];
    stateMonitor(app)
end


end