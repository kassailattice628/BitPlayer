function Open_ptb_mat(app)
%
% Select [PTB].mat file
%

%% Clean up preloaded variables

% sobj
% ParamsSave

sobj = [];
ParamsSave = [];

mainvar = app.mainvar;

%% Load Data
if isfield(mainvar, 'dirname_ptb')
    % If data directory is already exist.
    [f, d] = uigetfile({[mainvar.dirname_ptb, '*.mat']});
elseif isfield(mainvar, 'mouse')
    a = split(mainvar.dirname_daq, filesep);
    d = fullfile(a{1:end-3}, [mainvar.date,'ptb'], mainvar.mouse, '/');
    
    [f, d] = uigetfile({['/', d, '*.mat']});
    
else
    [f, d] = uigetfile({'~/Share/s2p_working/*.mat'});
end

%% File check
if f == 0
    % When file is not selected.
    errordlg('PTB data file is not selected.')
else
    load([d, f]); %#ok<*LOAD
    while isempty(sobj)
        errordlg('sobj is missing! Select other file.')
        % Select another file
        [f, d] = uigetfile({[d, '*.mat']});
        load([d, f]);
    end
    % Assign vars of savedata directory
    mainvar.dirname_ptb = d;
    
    %% Check file name
    if length(regexp(f, '_')) > 1
        i = regexp(f, '_');
        mainvar.fname_ptb = [f(1:i(end)-1), '.mat'];
        disp(f)
    else
        mainvar.fname_ptb = f;
    end
    
    %% Return
    disp(mainvar)
    
    app.sobj = sobj;
    app.ParamsSave = ParamsSave;
    
    %% GUI
    app.StimPattern.Text = ['Stim: ', sobj.Pattern];
end
    
