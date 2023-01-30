function SelectSaveFile(app)

sobj = app.sobj;

if isfield(sobj, 'DirName') == 0
    d1 = app.sobj.SaveDir;
    [FileName, DirName] = uiputfile([d1, '/*.mat']);
else
    if sobj.DirName == 0
        sobj.DirName = sobj.SaveDir;
    else
        [FileName, DirName] = uiputfile('*.mat', 'Select File to Write', sobj.DirName);
    end
    
end

sobj.FileName = FileName;
sobj.DirName = DirName;

app.sobj = sobj;
end
