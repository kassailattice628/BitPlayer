function r = Genrate_savefilename(app)

r = app.recobj;
if isfield(r, 'fname') && ischar(r.fname)
else
    r = SelectSaveFile(r);
end

[~, fname, ext] = fileparts([r.dirname, r.fname]);
e_fname = dir([r.dirname, fname, '_*.mat']);

if size(e_fname, 1) == 0
    r.savecount = 1;
else
    ind = zeros(1, size(e_fname), 1);
    for i = 1:size(e_fname, 1)
        [startIndex2, ~] = regexp(e_fname(n), name, '_');
        ind(n) = str2double(e_fname(n).name(startIndex2+1:end-4));
    end
    r.savecount = max(ind) + 1;
end

r.savefilename = [r.dirname, fname, '_', num2str(r.savecount), ext];
app.FileName.Text = [fname, '_', num2str(r.savecount), ext];

disp(['Save as::   ', r.savefilename]);
end

%%
function r = SelectSaveFile(r)

if isfield(r, 'dirname') == 0
    DIRname = r.save_dirname;
    [r.fname, r.dirname] = uiputfile([DIRname, '*.mat']);
else
    if r.dirname == 0
        r.dirname = r.save_dirname;
    else
        [r.fname, r.dirname] = uiputfile('*.mat', 'Select File to Write', r.dirname);
    end
end

end
