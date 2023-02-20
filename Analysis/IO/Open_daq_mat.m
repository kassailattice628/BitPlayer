function Open_daq_mat(app)
%
% Original is select Select_Open_Mat.
% Modified to use in BitPlayer.
% 2023/02/10
% Select [DAQ].mat file and extract each data.

%% Clean up preloaded variables

% app.SaveData
% app.SaveTimestamps
% app.imgobj
% app.recobj

SaveData = [];
mainvar = [];



%% Load Data
if isfield(mainvar, 'dirname_daq')
    % If data directory is already exist.
    [f, d] = uigetfile({[mainvar.dirname_daq, '*.mat']});   
else
    % If this is the first time to select daq data.
    % There is no information about location of the ,mat files.
    [f, d] = uigetfile({'~/Share/s2p_working/*.mat'});
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
    
    %% Success file load
    mainvar.dirname_daq = d;
    
    if ~isfield(mainvar, 'mouse')
        a = split(d, filesep);
        mainvar.mouse = a{end-1};
        app.Mouse.Text = ['Mouse: ', mainvar.mouse];
        mainvar.date = a{end-2}(1:end-3);
        app.Date.Text = ['Date: ', mainvar.date];
    end
    
    %Photo sensor V -> mV
    SaveData(:,3,:) =  SaveData(:,3,:)* 1000;
    
    %% Check file name
    if length(regexp(f, '_')) > 1
        i = regexp(f, '_');
        mainvar.fname_daq = [f(1:i(end)-1), '.mat'];
        disp(f)
    else
        mainvar.fname_daq = f;
    end
    
    app.FileName.Text = ['File Name: ', f];
    app.SaveFileName.Value = f;
    
    %% Check imgobj <- for imaging data
    if ~exist('imgobj', 'var')
        %First time to select mat file.
        imgobj.nROI = 0;
        imgobj.selectROI = 1;
        imgobj.maxROIs =  0;
        imgobj.dFF =[];
        
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
    
end


end
