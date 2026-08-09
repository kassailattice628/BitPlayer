function MainLoop(app)
%
% Main loop function, start after pushing Start PTB button.
% Wait TTL from DAQ when StartPTB button is on.
%
% CTS monitor TTL signal from DAQ. Whne the TTL is 0 (from 1) ,
% "trig" becaome "true", then visual stimulus sequence starts.
%
% RTS should be "true <- false", before the first loop starts.
% to start the DAQ loop.
% During visual stimuli, RTS is "true" (ON).
% While the RTS is false, DAQ wait to start the next loop.
%
% For PTB test
% Use "StandAlonMode" button.
% Whne it turns ON, TTL from DAQ does not need to start PTB loop.
%
%%%%%%%%%%

gui = app.PTBSTARTButton;

%Save data
ParamsSave = {};
mfile = []; %matfile handle for per-trial (incremental) save

n_blankloop = 1;%%% need to change %%%
n_in_loop = 1;

n_off = 1;

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%%
while 1

    %% Read state of the trigger from DAQ
    if app.StandAloneModeButton.Value
        %stand alone mode (test)
        CTSstate = 1;
    else
        %CTSstate is trigger info from DAQ
        %High => 1
        %Low => 0
        CTSstate = getpinstatus(app.SerPort).ClearToSend;
    end

    %% Check state of the start button
    if ~app.loopON
        disp('Loop Stop')
        break;
    end

    %% Evaluate CTS state
    if CTSstate
        disp('Trigger ON')
        ChangeGUI_StartPTB(gui, 'start');
        app.TTLfromDAQLamp.Color = [1,1,0];
        disp(['Trial# : ', num2str(n_in_loop)]);


        %false: "Presenting a stimulus"
        setRTS(app.SerPort, false);
        pause(0.01) %for GUI update

        %%%%% Visual Stim ON %%%%%
        VisStimON(app, n_in_loop, n_blankloop);

        %get stim parameters
        if n_blankloop > app.Blankloop.Value
            blank = false;
        else
            blank = true;
        end
        ParamsSave{1, n_in_loop} = Get_ParamsSave(app.sobj, blank); %#ok<AGROW>

        %%%%% Save this trial to disk immediately (per-trial save) %%%%%
        %  Even if the DAQ/serial link or MainLoop is aborted before the
        %  session finishes normally, trials saved up to this point are
        %  not lost.
        if app.SAVEONButton.Value
            try
                if isempty(mfile) || ~strcmp(mfile.Properties.Source, app.sobj.FileName)
                    mfile = matfile(app.sobj.FileName, 'Writable', true);
                end
                mfile.sobj = app.sobj;
                mfile.ParamsSave = ParamsSave;
            catch ME
                warning('MainLoop:SaveFailed', ...
                    'Trial #%d could not be saved to disk (%s). Will retry next trial.', ...
                    n_in_loop, ME.message);
            end
        end

        %%%%% ISI
        pause(app.ISI.Value)
        setRTS(app.SerPort, true) %Ready to start DAQ
        %%%%%%%%%%%%%%%%%%%%%%%%%%

        n_in_loop = n_in_loop + 1;
        n_blankloop = n_blankloop + 1;
        n_off = 1;
    else
        %% RTS monitor (~1k Hz)
        if n_off == 1
            disp ('PTB: Loop start >>>>>')
            % Wating trigger
            app.TTLfromDAQLamp.Color = [0,0,0];
            %disp('Wating Trigger');
            ChangeGUI_StartPTB(gui, 'wait');
        elseif n_off == 2
            disp('Waiting for Trigger (CTS)')
        elseif n_off == 1000
            n_off = 1;
        end
        n_off = n_off + 1;
        pause(0.001)


    end

end

%%%%%%%%%% Out of Loop %%%%%%%%%%

sobj = app.sobj;
sobj.n_in_loop = n_in_loop - 1;


%% When SAVE is ON, parameters are saved as .mat
if app.SAVEONButton.Value
    disp('Saving ...')
    try
        if isempty(mfile) || ~strcmp(mfile.Properties.Source, app.sobj.FileName)
            mfile = matfile(app.sobj.FileName, 'Writable', true);
        end
        mfile.sobj = sobj;
        mfile.ParamsSave = ParamsSave;
        fprintf('Done. \n Save as: %s\n', app.sobj.FileName)
    catch ME
        warning('MainLoop:SaveFailed', ...
            'Final save failed (%s). Trials already written per-trial should still be on disk at: %s', ...
            ME.message, app.sobj.FileName);
    end

    %SAVE Button
    app.SAVEONButton.Enable = "on";
    app.SAVEONButton.Value = false;

    app.SAVEOFFButton.Enable = "off";
end

clear mfile %release the file handle

end
