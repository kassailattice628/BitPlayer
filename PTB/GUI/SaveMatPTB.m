function SaveMatPTB(app)

sobj = app.sobj;
ParamsSave = app.ParamsSave;

save(app.sobj.FileName, 'sobj', 'ParamsSave');
end