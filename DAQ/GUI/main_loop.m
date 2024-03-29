function main_loop(app)
%
% Loop fucntion of BitPlayer_DAQ
% 
% Structure update 20230321
% previous version is main_loop_20230320
%

%% Initialize condition

app.recobj.n_in_loop = 1;
% Reset TTL
write(app.d_out, [0, 0, 0, 0])
app.d_in.ScansAvailableFcn = @(src, evt) scanAvailableCallback_BP(app, src, evt);
% Start Background recording >> See scanAvailableCallback_BP.m
% To detect RTS
start(app.d_in, 'continuous');
app.CurrentState = 'Aqcuisition.Buffering';
stateMonitor(app)

app.recobj.DAQt = [];

%% Loop start %%%%%%%%
while app.loopON

    % GUI Button check
    if ~app.loopON
        % Loop stop
        write(app.d_out, [0, 0, 0, 0])
        break
    end

    %%%----- Video setting
    if app.CameraSave.Value % When CameraSave is ON
        app.imaq = LoggingVideoSetting(app.imaq, app.recobj.n_in_loop);
    end

    %%%----- AO for TTL
    if app.TTLSwitch.Value % TTL is ON
        %flush(app.d_out_ao);
        preload(app.d_out_ao, 5*app.recobj.TTL.outputSignal) % 5V ouput
        start(app.d_out_ao);
    end


    %% Start Recording
    %Start DAQ, trigger PTB and other devices
    %(1) DAQ trigger, (2) FV trigger, (3) PTB triggers(CTS)a, (4) nothing

    if app.CameraSave.Value && ~isrunning(app.imaq.vid)
        start(app.imaq.vid) %Video rec ready
        fprintf("Start Loop & Video: #%d\n", app.recobj.n_in_loop);
    else
        fprintf("Start Loop: #%d\n", app.recobj.n_in_loop);
    end

    if app.recobj.n_in_loop == 1
        t = tic;
        %write(app.d_out, [1, 1, 1, 0]);
        FVtrig = 1;
    else
        % TTL for FV is not ON after the 1st loop.
        FVtrig = 0;
        %write(app.d_out, [1, 0, 1, 0]);
    end
    
    %Trigger
    write(app.d_out, [1, FVtrig, 1, 0]);
    fprintf('Trig #%d >>>> ', app.recobj.n_in_loop)
    app.recobj.DAQt = [app.recobj.DAQt; toc(t)];
    app.capturing = 1;


    % Wait for complete capture
    while app.capturing

        if strcmp(app.CurrentState, 'Loop.End') || ~app.loopON

            break

        end
        pause(0.1)
    end
    
    %% Finishing loop
    if app.StandAloneModeButton.Value
        disp('Wait for ITI')
        
        t_ITI = tic;
        t0 = toc(t_ITI);
        n_check = 1;
        while toc(t_ITI) < app.recobj.interval
            if ~app.loopON
                break
            else
                pause(0.1);
            end

          
            if toc(t_ITI) - t0 > 10
                disp(strcat(...
                    'Waiting ITI...', num2str(10*n_check), 's'));
                t0 = toc(t_ITI);
                n_check = n_check + 1;
            end
        end
    else
        while ~app.RTS
            % Wait for finishing visual stimuli
            if ~app.loopON
                break
            end
            pause(0.1)
        end
    end

    
    app.CurrentState = 'Aqcuisition.Buffering';
    app.recobj.n_in_loop = app.recobj.n_in_loop + 1;

end %% Loop end %%%%%%%%



if app.saveON
    % Save DAQ data to the file
    app.recobj.n_in_loop = app.recobj.n_in_loop - 1;
    recobj = app.recobj;

    SaveData = app.SaveData;
    SaveTimestamps = app.SaveTimestamps;

    disp('Saving MAT >>>')
    save(app.recobj.FileName, 'recobj', 'SaveData', 'SaveTimestamps');
    fprintf('Saved: %s\n', app.recobj.FileName);

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