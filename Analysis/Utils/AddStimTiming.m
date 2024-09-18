function AddStimTiming()
%
%
%

fimg = '/home/lattice/Share/s2p_working/20240425/1651/1_tif/2/movie/dFF(1-1000).tif';
v = tiffreadVolume(fimg);
%v = double(v);
v = (v - min(v,[],'all'))/ (max(v,[], 'all') - min(v, [], 'all'));
v = v/0.35;
v(v>1) = 1;


stimON = [];
stimOFF = [];
sampf = imgobj.FVsampt;
p = ParamsSave;
for i = 1:size(p,2)
    if ~p{i}.stim1.Blank
        ON = fix(p{i}.stim1.correct_StimON_timing/sampf);
        OFF = fix(p{i}.stim1.correct_StimOFF_timing/sampf);
        stimON = [stimON, ON];
        stimOFF = [stimOFF, OFF];
    end
end

%% add stim timing on right bottom of the image

v_stim = v;
for i = 1:length(stimON)
    if stimOFF(i) <= size(v,3)
        v_stim(285:315, 300:315, stimON(i):stimOFF(i)) = 1;
    end
end

%% Video
fout = '/home/lattice/Share/s2p_working/20240425/1651/1_tif/2/movie/dFF(1-1000)_stim.avi';
outputVideo = VideoWriter(fout);
outputVideo.FrameRate = sampf*10;
open(outputVideo)

for i = 1:size(v,3)
    writeVideo(outputVideo, v_stim(:,:,i))
end
close(outputVideo);

% mov = immovie(mri, map);
% implay(mov)
end