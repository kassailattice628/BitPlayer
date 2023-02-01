function UpdateSaveFileName(app, prefix, mode)
switch mode
    case 'ptb'
        obj = app.sobj;
    case 'daq'
        obj = app.recobj;
end

%%
ext = '.mat';
%obj.FileName = [prefix, ext];

if ~isfield(obj, 'SaveDirMouse')
    obj.SaveDirMouse = '';
    e_fname = dir([obj.SaveDirMouse, filesep, prefix, '_*', ext]);
else
    e_fname = dir([obj.SaveDirMouse, filesep, prefix, '_*', ext]);
end

%Count the maximum number of directory name
if size(e_fname, 1) == 0
    obj.savecount = 1;


else
    n_files = zeros(size(e_fname, 1), 1);
    for n = 1:size(e_fname, 1)
        %length of file prefix
        [startIindex, ~] = regexp(e_fname(n).name, '_');
        %extract the number of file name. "end-4" indicates the length of ".mat".
        n_files(n) = str2double(e_fname(n).name(startIindex+1:end-4));
        ind = n_files;
    end


    %{
    if strcmp(mode, 'daq') && isfield(obj, 'SaveMovieDirMouse')
        %Check movie folder
        mv_folders = dir([obj.SaveMovieDirMouse, filesep, 'Movie_*']);
        sz = size(mv_folders, 1);
        if sz > 0
            n_files2 = zeros(sz, 1);
            for n = 1:size(mv_folders)
                n_files2(n) = str2double(mv_folders(n).name(7:end));
            end

            % when the movie folder is empty, ignore that folder?

            ind = [n_files; n_files2];
        end
    end
    %}

    % Increment save count for next recording
    obj.savecount = max(ind) + 1;

end

fname_ind = [prefix, '_', num2str(obj.savecount), ext];

obj.FileName = [obj.SaveDirMouse, filesep, fname_ind];

switch mode
    case 'ptb'
        app.sobj = obj;
    case 'daq'
        app.recobj = obj;
end

app.FileNameTxt.Text = fname_ind;
