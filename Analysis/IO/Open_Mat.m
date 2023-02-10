function Open_Mat(app)
%
% Original is select Select_Open_Mat.
% Modified to use in BitPlayer.
% 2023/02/10
% Select [DAQ].mat file and extract each data.

%% Clean up variables.

app.DataSave = [];
app.imgobj = [];
app.sobj = [];
app.recobj = [];
app.ParamsSave = [];
DataSave = [];
app.n = 1;

%% Load New Data
if isempty(app.mainvar)
    % No information about save data directry.
    [f, d] = uigetfile({'~/Share/s2p_working/*.mat'});
    load([d,f]); %#ok<*LOAD
    
    while isempty(DataSave)
        errordlg('DataSave is missing! Select other file.')
        % select another file
        [f, d] = uigetfile({[d, '*.mat']});
        load([d, f]);
    end
    
else
    %Select New Data
    [f, d] = uigetfile({[app.mainvar.dirname, '*.mat']});
    load([d,f]);
end

%% Assign vars of savedata directory and file name
mainvar.dirname = d;
mainvar.fname = f;

%% Check file name
if length(regexp(f, '_')) > 1
    i = regexp(f, '_');
    mainvar.fname = [f(1:i(end)-1), '.mat'];
    disp(f)
else
    mainvar.fname = f;
end

%% Check imgobj <- for imaging data
if ~exist('imgobj', 'var')
    imgobj.nROI = 0;
    imgobj.selectROI = 1;
    imgobj.maxROIs =  0;
    imgobj.dFF =[];
    imgobj.FVsampt_tentative = 0.574616;
    DataSave(:,3,:) =  DataSave(:,3,:)* 1000;
    
elseif ~isfield(imgobj, 'dFF')  %#ok<NODEF>
    imgobj.dFF = [];
end

if isfield(imgobj, 'FVsampt')
    %Put in GUI.
    app.FVsampt.Value = imgobj.FVsampt;
end

app.filenameLabel.Text = f;
app.StimPatternLabel.Text = sobj.pattern;

%% output
app.imgobj = imgobj;
app.mainvar = mainvar;
app.ParamsSave = ParamsSave;
app.DataSave = DataSave;
app.recobj = recobj;
app.sobj = sobj;

disp(mainvar)
end
