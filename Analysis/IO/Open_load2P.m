function Open_load2P(app)
%
% Load extracted fluprescnce changes of etracted ROIs.
%
%%
mainvar = app.mainvar;
im = app.imgobj;
im.imgsz = app.ImageSize.Value;


%% (Re)load Data
if isfield(mainvar, 'dirname_2p')
    % original dFF file location
    d = mainvar.dirname_2p;
else
    d = '~/Share/s2p_working/';
end

[f, d] = uigetfile({[d, '*.mat']}, 'Select 2P data');

%file check
if d == 0
    % When file is not selected.
    errordlg('No 2P data file selected.')
else
    % Load data 
    app.imgobj = Load_imaging_data(im.imgsz, d, f, app.sobj.Pattern);
end

app.FileName.Text = ['File: ', d, f];
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function im = Load_imaging_data(im, d, f, pattern)

if contains(f, 'Fall')
    %extracted by suite2P
    [F, Mask_rois, centroid] = ...
        Load_Fall_suite2p(im, d, f);
    dFF = [];

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
if isfield(im, 'FVsampt')
    fvt = im.FVsampt;
else
    fvt = im.FVsampt_tentative;
end


%% Update imgobj
[FVflames, maxROIs] = size(dFF);

im.FVt = 0:fvt:fvt*(FVflames - 1);
im.F = F;
im.dFF = dFF;
im.dFF_raw = dFF;
im.maxROIs = maxROIs;
im.Mask_rois = Mask_rois;
im.centroid = centroid;

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
if isfiled(im, 'Params_bootstrap')
    fields = {'Params_bootstrap', 'roi_ds', 'roi_os'};
end
im = rmfiled(im, fields);
    
end

    
