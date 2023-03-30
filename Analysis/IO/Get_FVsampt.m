function [im, f, d] = Get_FVsampt(im, OIB_dirname)
%
% Read Frame Rate (fps) & Size of the image
% from Olympus OIF/OIB file (FV10).
%
% Original: Get_FVsampt Appdesinger version 191192
% Modified: 20230224

key = {'Time Per Frame', '[Axis 0 Parameters Common] MaxSize',...
    '[Axis 1 Parameters Common] MaxSize'};

%Call python -> shell -> use bftools -> python -> txt -> mat -> Matlab
disp('Reading metadata....')

%params = Get_metadata([], key);
disp(OIB_dirname)
[params, f, d] = Get_metadata(OIB_dirname, key);

im.FVsampt = params(1) * 10^-6;
im.imgsz = [params(2), params(3)];

end

%% %%%%%%%%%%
function [params, f, d] = Get_metadata(fpath, keylist)
%
% Read imaging metadata from OIF/OIB file using python scripts.
%

% Check input
%fpath = strrep(fpath, 'mat/', '/');
%[f, d] = uigetfile({[fpath, '*.oif']}, 'Select OIF/OIB file');
[f, d] = uigetfile({[fpath, '/*.oif']}, 'Select OIF/OIB file');
fpath = [d, f];


%% Extract metadata
[d, f, e] = fileparts(fpath);

switch e
    case '.txt'
        params = py.bfloadpy.extract_any(fpath, keylist);
        
    case {'.oib', '.oif'}
        disp(['Extract metadata from ', f, e, ' file...'])
        py.bfloadpy.bioform_2_txt(fpath, fpath);
        txt_path = fullfile(d, [f, '_bfmeta.txt']);
        params = py.bfloadpy.extract_any(txt_path, keylist);
end
params = cellfun(@double, cell(params));

end