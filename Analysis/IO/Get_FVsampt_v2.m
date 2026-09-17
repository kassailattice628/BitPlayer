function [im, f, d] = Get_FVsampt_v2(im, OIB_dirname)
%
% Read Frame Rate (fps) & Size of the image
% from Olympus OIF/OIB file (FV10).
%
% Drop-in replacement for Get_FVsampt.m: reads metadata directly via
% Bio-Formats' Java library (bioformats_package.jar, already shipped in
% bftools/) instead of round-tripping through Python -> shell (showinf)
% -> text file -> Python. Same input/output interface, same metadata
% keys, same values (verified against Get_FVsampt.m's showinf-based
% output on a real file: FV01.oif in 20260914/49/0_OIF, both give
% Time Per Frame=574616.000, Axis0/1 MaxSize=320).
%
% Requires bioformats_package.jar on the Java classpath (added lazily,
% once per MATLAB session, on first call).
%
% im.FVt is regenerated here too (same formula as Open_load2P.m's
% Load_imaging_data: im.FVt = 0:fvt:fvt*(FVflames-1)), since im.FVt is
% otherwise left stale at whatever im.FVsampt held when it was first
% built -- e.g. if this function is called standalone/after the fact to
% correct im.FVsampt for a session whose scan size differs from the
% default (frame period depends on scan resolution, see 2026-09-17 bug:
% a 256x256-scan session's im.FVt had been generated with a 320x320
% session's frame period, 0.575s vs the true 0.429s).

persistent bfJarAdded
bfJarPath = '/home/lattice/Share/Ana_ver11_AppDesigner/extra/bftools/bioformats_package.jar';
if isempty(bfJarAdded)
    if isempty(which('loci.formats.ImageReader'))
        javaaddpath(bfJarPath);
    end
    bfJarAdded = true;
end

key = {'Time Per Frame', '[Axis 0 Parameters Common] MaxSize', ...
    '[Axis 1 Parameters Common] MaxSize'};

disp('Reading metadata (Bio-Formats Java, no Python)....')
disp(OIB_dirname)
[params, f, d] = Get_metadata(OIB_dirname, key);

im.FVsampt = params(1) * 10^-6;
im.imgsz = [params(2), params(3)];

% フレーム数: dFF/Fが既にあればその行数を正とする(Open_load2P.mと同じ数え方)。
% まだ無ければ既存(古い)im.FVtの長さを使う(要素数はスキャン設定を変えても
% 不変なはずで、変わるのは1フレームあたりの時間だけ)。
if isfield(im, 'dFF') && ~isempty(im.dFF)
    n_frame = size(im.dFF, 1);
elseif isfield(im, 'F') && ~isempty(im.F)
    n_frame = size(im.F, 1);
elseif isfield(im, 'FVt') && ~isempty(im.FVt)
    n_frame = numel(im.FVt);
else
    n_frame = [];
end

if ~isempty(n_frame)
    im.FVt = 0:im.FVsampt:im.FVsampt*(n_frame - 1);
else
    warning('Get_FVsampt_v2:noFrameCount', ...
        'im.dFF/im.F/im.FVt all empty; cannot regenerate im.FVt (frame count unknown). Only FVsampt/imgsz were updated.');
end

end

%% %%%%%%%%%%
function [params, f, d] = Get_metadata(fpath, keylist)
%
% Read imaging metadata from OIF/OIB file directly via Bio-Formats' Java
% reader (loci.formats.ImageReader), bypassing showinf/Python entirely.
%

[f, d] = uigetfile({[fpath, '/*.oif']}, 'Select OIF/OIB file');
fpath = [d, f];

reader = javaObject('loci.formats.ImageReader');
reader.setId(fpath);
meta = reader.getGlobalMetadata();  % java.util.Hashtable<String,Object>, same
                                     % table showinf prints as "key: value"
reader.close();

params = zeros(1, numel(keylist));
for i = 1:numel(keylist)
    v = meta.get(keylist{i});
    if isempty(v)
        error('Get_FVsampt_v2:missingKey', 'Metadata key not found: %s', keylist{i});
    end
    params(i) = str2double(char(v));
end

end
