function Open_load2P(app)
%
% Load extracted fluprescnce changes of etracted ROIs.
%

im = app.imgobj;
im.imgsz = app.ImageSize.Value;

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
    d = '~/Share/s2p_working/';
    d = fullfile(d, date, mouse);
end

[f, d] = uigetfile({[d, '*.mat']}, 'Select 2P data');

%file check
if d == 0
    % When file is not selected.
    errordlg('No 2P data file selected.')
else
    app.mainvar.dirname_2p = d;
    app.mainvar.fname_2p = f;
    app.FileName.Text = {['File: ', d], f};
    % Load data 
    app.imgobj = Load_imaging_data(im, d, f, app.sobj.Pattern);
    
    app.mainvar.Detrend = 0;
    app.mainvar.Lowcutfilter = 0;
    app.mainvar.Offset = 0;
    app.mainvar.Zscore = 0;

    app.SaveFileName.Value = app.mainvar.fname_daq;
end


end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function im = Load_imaging_data(im, d, f, pattern)

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

% Remove colorap data
if isfield(im, 'mat2D')
    if strcmp(pattern, 'Moving Bar')
        fields = {'mat2D', 'mat2Dori', 'mat2D_i_sort', 'mat2Dori_i_sort'};
    else
        if isfield(im, 'mat2D_i_sort')
            fields = {'mat2D', 'mat2D_i_sort'};
        else
            fields = {'mat2D'};
        end
    end
    im = rmfiled(im, fields);
end

% Remove bootstrapping data
if isfield(im, 'Params_bootstrap')
    fields = {'Params_bootstrap', 'roi_ds', 'roi_os'};
    im = rmfiled(im, fields);
end
    
end

    
