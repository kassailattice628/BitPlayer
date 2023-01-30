function UpdateSaveFileName(app, prefix, mode)
switch mode
    case 'ptb'
        obj = app.sobj;
    case 'daq'
        obj = app.recobj;
end

%%
ext = '.mat';
obj.FileName = [prefix, ext];

if ~isfield(obj, 'SaveDirMouse')
    obj.SaveDirMouse = '';
    e_fname = dir([obj.SaveDirMouse, '/', prefix, '_*', ext]);
else
    e_fname = dir([obj.SaveDirMouse, '/', prefix, '_*', ext]);
end

if size(e_fname, 1) == 0
    obj.savecount = 1;
else
    for n = 1:size(e_fname,1)
        [startIindex, ~] = regexp(e_fname(n).name, '_'); 
        ind(n) = str2double(e_fname(n).name(startIindex+1:end-4)); %#ok<AGROW> 
    end
    obj.savecount = max(ind) + 1;

end

fname_ind = [prefix, '_', num2str(obj.savecount), ext];

obj.FileName = [obj.SaveDirMouse, '/', fname_ind];

switch mode
    case 'ptb'
        app.sobj = obj;
    case 'daq'
        app.recobj = obj;
end

app.FileNameTxt.Text = fname_ind;
