function main_loop(app)
%
% Loop fucntion of BitPlayer_DAQ
%

%% 
recobj = app.recobj;
app.recobj.n_in_loop = 1;

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
            
            % Whne CameraSave is ON
            % Generate experiment fodler and movie file name with trial number
            movie_trial_dir =...
                [app.recobj.SaveMovieDirMouse, '\Movie_', num2str(app.recobj.n_in_loop)];

            if exist(movie_trial_dir, 'dir')==0
                mkdir(movie_trial_dir)
            end

            app.imaq = LoggingVideoSetting(app.imaq, app.recobj.n_in_loop);
        end

        %% Prep analog output for external TTL
        if app.TTLSwitch.Value
            preload(app.d_out_ao, 5 * recobj.TTL.outputSignal) % 5V ouput
            start(app.d_out_ao);
        end
        
        %% Start Recording

        %Start Video (with delay)
        if app.CameraSave.Value && isrunning(app.imaq.vid) == 0
            pause(app.imaq.delay_ms/1000)

            disp('Start camera rec')
            imaq_t = app.imaq.duration_ms/1000;
            start(app.imaq.vid)
        else
            imaq_t = 0;
        end

        %Start DAQ, trigger PTB and other devices
        %(1) DAQ trigger, (2) FV trigger, (3) PTB triggers, (4) nothing
        write(app.d_out, [1, 1, 1, 0]);
        
        pause(0.1)
        app.recobj.DAQt = [app.recobj.DAQt; toc(t)];
        fprintf("Loop#: %d.\n", app.recobj.n_in_loop);
        %turn off triggers
        write(app.d_out, [0, 0, 0, 0]); % PTB trigger OFF


        %% Wait for data acquisition
        pause(max(app.recobj.rect/1000, imaq_t));

        %% Finishing loop

        % Save Movie
        if app.CameraSave.Value

            fprintf("%d. frame is afquired", app.imaq.vid.FramesAcquired);
            while app.imaq.vid.FramesAcquired < app.imaq.vid.DiskLoggerFrameCount
                pause(.1);
                disp('video saving...')
            end
            disp(['Movie is saved as: ', app.imaq.movie_fname]);
            stop(app.imaq.vid)
        end

        % Reset TTL pulse
        if app.TTLSwitch.Value
            stop(app.d_out_ao);
        end

    end %end of RTS detected.

    if app.StandAloneModeButton.Value
        pause(app.recobj.interval)
    else
        pause(0.01) %Look for RTS
    end

end % end of loop

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%


app.recobj.n_in_loop = app.recobj.n_in_loop - 1;

%% Save DAQ data to the file
if app.saveON
    SaveData = app.SaveData;
    SaveTimestamps = app.SaveTimestamps;

    save(app.recobj.FileName, 'recobj', 'SaveData', 'SaveTimestamps');

    clear SaveData SaveTimestamps

    app.SaveData = [];
    app.SaveTimestamps = [];

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