function Open_load2P(app)
%
% Load dFF from etracted ROIs.
%

im = app.imgobj;

if ~isfield(im, 'imgsz') || isempty(im.imgsz)
    im.imgsz = [app.ImageSize.Value, app.ImageSize.Value];
end

if isfield(app.sobj, 'Stim_valiation_type')
    stimval = app.sobj.Stim_valiation_type;
else
    stimval = "none";
end

if ~isfield(im, 'FVsampt')
    im.FVsampt = app.FVsampt.Value;
end


%% (Re)load Data
if isfield(app.mainvar, 'dirname_2p')
    % original dFF file location
    d = app.mainvar.dirname_2p;
else
    mouse = app.mainvar.mouse;
    date = app.mainvar.date;
    d = '/mnt/SSD1_Work/s2p_working/';
    d = fullfile(d, date, mouse);
end

[f, d] = uigetfile({[d, '/*.mat']}, 'Select 2P data');

%file check
if d == 0
    % When file is not selected.
    errordlg('No 2P data file selected.')
else
    app.mainvar.dirname_2p = d;
    app.mainvar.fname_2p = f;
    app.FileName.Text = {['File: ', d], f};
    % Load data 
    app.imgobj = Load_imaging_data(im, d, f, app.sobj.Pattern, stimval);
    
    %Reset buttons
    app.mainvar.Detrend = 0;
    Change_button_color(app.Detrend, 0);
    app.Detrend.Value = 0;

%     app.mainvar.Lowcutfilter = 0;
%     Change_button_color(app.Detrend, 0);
%     app.Detrend.Value = 0;

    app.mainvar.Offset = 0;
    Change_button_color(app.Offset, 0);
    app.Offset.Value = 0;

    app.mainvar.Zscore = 0;
    Change_button_color(app.Zscore, 0);
    app.Zscore.Value = 0;

    app.mainvar.ApplydFF = 0;
    Change_button_color(app.ApplyChanges, 0);
    app.ApplyChanges.Value = 0;

    app.SaveFileName.Value = app.mainvar.fname_daq;
end


end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function im = Load_imaging_data(im, d, f, pattern, stimval)

if contains(f, 'Fall')
    % Extracted by suite2P
    [F, Mask_ROIs, centroid] = ...
        Load_Fall_suite2p(im, d, f);
    
    % pre Calculate dFF
    F0 = mean(F(1:100, :));
    dFF = (F - F0)./ repmat(F0, size(F,1), 1);


else
    %manually drawn roi (Fiji) and extracted by batch_dFF
    [~, ~, ext] = fileparts(f);
    if strcmp(ext, '.mat')
        load([d, f], 'dFF_mat');
        dFF = dFF_mat;
        F = [];
        
    else
        errordlg('Select *dFF.mat file!')
    end
end

%%
fvt = im.FVsampt;

%% Update imgobj

% FV
[FVflames, num_ROIs] = size(F);
im.FVt = 0:fvt:fvt*(FVflames - 1);


im.F = F; % raw traces
im.dFF = dFF; % calculated dFF
im.Num_ROIs = num_ROIs;
im.Mask_ROIs = Mask_ROIs;
im.Centroid = centroid;
im.f0 = 1:100; %default f0 frames;

% Remove colormap data
if isfield(im, 'mat2D')
    if strcmp(pattern, 'Moving Bar')
        if strcmp(stimval, 'Free')
            fields = {'mat2D'};
        else
            fields = {'mat2D', 'mat2Dori', 'mat2D_i_sort', 'mat2Dori_i_sort'};
        end

    else
        if isfield(im, 'mat2D_i_sort')
            fields = {'mat2D', 'mat2D_i_sort'};
        else
            fields = {'mat2D'};
        end
    end
    im = rmfield(im, fields);
end

% Remove bootstrapping data
if isfield(im, 'Params_bootstrap')
    fields = {'Params_bootstrap', 'roi_ds', 'roi_os'};
    im = rmfiled(im, fields);
end
    
end

    
