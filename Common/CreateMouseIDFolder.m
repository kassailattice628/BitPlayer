function savedir = CreateMouseIDFolder(app, mode)
% mode: 'ptb' or 'daq'

switch mode
    case 'ptb'
        obj = app.sobj;
    case {'daq', 'video'}
        obj = app.recobj;
end

%input Mouse ID
mouseID =  app.EditFieldMouseID.Value;

%Date Folder
switch mode
    case {'ptb', 'daq'}
        d = obj.SaveDir;
    case 'video'
        d = obj.SaveMovieDir;
end

%Mouse Folder
savedir = [d, filesep, mouseID];
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

%output
switch mode
    case {'ptb', 'daq'}
        obj.SaveDirMouse = savedir;
    case 'video'
        obj.SaveMovieDirMouse = savedir;
end


switch mode
    case 'ptb'
        app.sobj = obj;
    case {'daq', 'video'}
        app.recobj = obj;
end
end