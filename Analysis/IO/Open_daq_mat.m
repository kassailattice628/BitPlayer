function Open_daq_mat(app)
%
% Original is select Select_Open_Mat.
% Modified to use in BitPlayer.
% 2023/02/10
% Select [DAQ].mat file and extract each data.

%% Clean up preloaded variables

SaveData = [];
mainvar = app.mainvar;
if isfield(mainvar, 'PhotoSensorloaded')
    mainvar = rmfield(mainvar, 'PhotoSensorloaded');
end
sobj = [];
ParamsSave = [];


%% Load Data
if isfield(mainvar, 'dirname_daq')
    % If data directory is already exist.
    [f, d] = uigetfile({[mainvar.dirname_daq, '*.mat']});
    if ~strcmp(d, mainvar.dirname_daq) && isfield(mainvar, 'dirname_ptb')
        clear mainvar
    end

else
    % If this is the first time to select daq data.
    % There is no information about location of the ,mat files.
    [f, d] = uigetfile({'/mnt/SSD1_Work/s2p_working/*.mat'});
end

%% File check
if f == 0
    % When file is not selected.
    errordlg('DAQ data file is not selected.')
else
    load([d, f]); %#ok<*LOAD
    while isempty(SaveData)
        errordlg('SaveData is missing! Select other file.')
        % Select another file
        [f, d] = uigetfile({[d, '*.mat']});
        load([d, f]);
    end

    %% Successfully load a daq file
    app.n_in_loop = 1;
    app.Trial_n.Value = 1;

    mainvar.dirname_daq = d;
    if ~isfield(mainvar, 'PhotoSensorloaded') ||...
        ~mainvar.PhotoSensorloaded
        a = split(d, filesep);
        mainvar.mouse = a{end-1};
        mainvar.date = a{end-2}(1:end-3);

        %Photo sensor V -> mV
        SaveData(:,3,:) =  SaveData(:,3,:)* 1000;
        mainvar.PhotoSensorloaded = true;

    elseif mainvar.PhotoSensorloaded
        
    else
        mainvar.PhotoSensorloaded = false;
    end
    app.Mouse.Text = ['Mouse: ', mainvar.mouse];
    app.Date.Text = ['Date: ', mainvar.date];



    %% Check file name
    if length(regexp(f, '_')) > 1
        i = regexp(f, '_');
        %mainvar.fname_daq = [f(1:i(end)-1), '.mat'];
        if ~isfield(mainvar, 'fname_daq_original')
            mainvar.fname_daq_original = [f(1:i(end)-1), '.mat'];
        end
    end
    mainvar.fname_daq = f;

    app.FileName.Text = ['File Name: ', f];
    app.SaveFileName.Value = f;

    %% Check imgobj <- for imaging data
    if ~exist('imgobj', 'var')
        %First time to select mat file.
        imgobj.Num_ROIs = 1;
        imgobj.selected_ROIs = 1;
        imgobj.dFF = [];

        % Check frame rate
        if isfield(imgobj, 'FVsampt')
            %Put in GUI.
            app.FVsampt.Value = imgobj.FVsampt;
        end
    end

    %% Return
    disp(mainvar)

    app.imgobj = imgobj;
    app.mainvar = mainvar;
    app.SaveData = SaveData;
    app.SaveTimestamps = SaveTimestamps;
    app.recobj = recobj;
    app.sobj = sobj;
    app.ParamsSave = ParamsSave;
    if ~isempty(sobj)
        app.StimPattern.Text = ['Stim: ', sobj.Pattern];
    end

end


end
