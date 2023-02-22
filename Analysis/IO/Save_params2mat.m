function Save_params2mat(app)

mainvar = app.mainvar;
SaveData = app.SaveData;
SaveTimestamps = app.SaveTimestamps;
imgobj = app.imgobj;
ParamsSave = app.ParamsSave;
recobj = app.recobj;
sobj = app.sobj;

%% file name

save_fname = app.SaveFileName.Value;
save_file_path = [mainvar.dirname_daq, save_fname];

%% save as mat file
fprintf(['Saving... \n', save_file_path, '\n']);

save(save_file_path,...
    'mainvar', 'SaveData', 'SaveTimestamps',...
    'imgobj', 'ParamsSave', 'recobj', 'sobj');

disp('Done...');

%% update GUI
app.FileName.Text = ['File Nmae: ', save_fname];

end