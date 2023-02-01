function imaq = LoggingVideoSetting(recobj, imaq, n_in_loop)
% Whne CameraSave is ON
% Generate experiment fodler and movie file name with trial number.

movie_trial_dir = [recobj.SaveMovieDirMouse, '\Movie_', num2str(recobj.savecount)];
if exist(movie_trial_dir, 'dir')==0
    mkdir(movie_trial_dir)
end

% Save moive as AVI.
movie_fname = [movie_trial_dir, '\movie_', num2str(n_in_loop, '%03u')];
imaq.movie_fname = movie_fname;

logvid = VideoWriter(movie_fname, "Motion JPEG AVI");
%logvid = VideoWriter(movie_fname, 'MPEG-4');
%logvid = VideoWriter(movie_fname, 'Uncompressed AVI');

logvid.FrameRate = imaq.src.FrameRate; %500Hz
logvid.Quality = 100; %100% quality

imaq.vid.LoggingMode = 'disk';
imaq.vid.DiskLogger = logvid;

if isrunning(imaq.vid) == 0
    start(imaq.vid)
end


end