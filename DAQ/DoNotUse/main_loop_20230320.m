function main_loop_20230320(app)
%
% Loop fucntion of BitPlayer_DAQ
%

%% Intialize condition.
recobj = app.recobj;
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
n_off = 0;
RTSwait = 0.2;

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%%
%% Loop start

while 1
    stateMonitor(app)

    % Stop loop by GUI (DAQ STOP button)
    if ~app.loopON
        disp('Loop Stop')
        write(app.d_out, [0, 0, 0, 0])
        break; % get out from main loop
    end

    %% Check RTS state
    if ~app.RTS
        if n_off == 0
            disp('DAQ: Loop start >>>>')
        elseif n_off == 1
            disp('Waiting for RTS')
        elseif n_off == round(1/RTSwait)
            n_off = 0;
        end
        n_off = n_off + 1;
        pause(RTSwait);

    elseif app.RTS
        %
        fprintf("Start Loop#: %d.\n", app.recobj.n_in_loop);
        stateMonitor(app)

        %% Video setting
        if app.CameraSave.Value % When CameraSave is ON
            app.imaq = LoggingVideoSetting(app.imaq, app.recobj.n_in_loop);
        end

        %% Prep analog output for external TTL
        if app.TTLSwitch.Value % TTL is ON
            preload(app.d_out_ao, 5 * recobj.TTL.outputSignal) % 5V ouput
            start(app.d_out_ao);
        end
        
        %% Start Recording
        %Start DAQ, trigger PTB and other devices
        %(1) DAQ trigger, (2) FV trigger, (3) PTB triggers(CTS)a, (4) nothing
        if app.recobj.n_in_loop == 1
            t = tic;
            write(app.d_out, [1, 1, 1, 0]);
        else
            write(app.d_out, [1, 0, 1, 0]);
            
        end
        app.recobj.DAQt = [app.recobj.DAQt; toc(t)];
        app.loopend = 0;

        %Start Video (with delay)
        if app.CameraSave.Value && isrunning(app.imaq.vid) == 0
            pause(app.imaq.delay_ms/1000) %delay
            start(app.imaq.vid)
        end

        %% Wait for data acquisition
        while 1
            if app.TrigActive
                %turn off triggers
                pause(0.05)
                write(app.d_out, [0, 0, 0, 0]); % PTB trigger OFF
                app.TrigActive = false;
                disp('reset DAQ trigger')
            end

            if strcmp(app.CurrentState, 'Loop.End')
                app.recobj.n_in_loop = app.recobj.n_in_loop + 1;
                app.CurrentState = 'Aqcuisition.Buffering';
                break
            end
            pause(0.1)
        end

        n_off = 1;

    end %end of RTS detected.

    if app.StandAloneModeButton.Value
        disp('ITI')
        pause(app.recobj.interval)
    end
    
end % end of loop

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%

%% Loop stop
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