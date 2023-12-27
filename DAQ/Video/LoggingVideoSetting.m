function imaq = LoggingVideoSetting(imaq, n_in_loop)
% Whne CameraSave is ON
% Generate experiment fodler and movie file name with trial number.

% Save moive as AVI
movie_fname = [imaq.movie_trial_dir, '\trial_', num2str(n_in_loop, '%03u'), '.avi'];
imaq.movie_fname = movie_fname;

logvid = VideoWriter(movie_fname, "Motion JPEG AVI");
%logvid = VideoWriter(movie_fname, 'MPEG-4');
%logvid = VideoWriter(movie_fname, 'Uncompressed AVI');

logvid.FrameRate = imaq.src.FrameRate; %500Hz
logvid.Quality = 75; %100% quality

imaq.vid.DiskLogger = logvid;

end