function savedir = CreateMouseIDFolder(app, mode)
%
% Generate folder(s) to save data of each experiment, trailas
% mode: 'ptb', 'daq' or 'video
%

% Mouse ID
mouseID =  app.EditFieldMouseID.Value;

switch mode
    case 'ptb'
        d = app.sobj.SaveDir;

    case 'daq'
        d = app.recobj.SaveDir;
        
    case 'video'
        d = app.recobj.SaveMovieDir;

end

% Generate Mouse Folder
savedir = [d, filesep, mouseID];
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

%%%%%%%%%%
end