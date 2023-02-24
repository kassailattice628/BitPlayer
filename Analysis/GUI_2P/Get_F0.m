function im = Get_F0(app)
%
% Extract F0
%
%%
p = app.ParamsSave;
s = app.sobj;
im = app.imgobj;

n = s.Blankloop + 1;

%%
if isfield(p{1, n}.stim1, 'correct_StimON_timing')
    F0end = floor(p{1, n}.stim1.correct_StimON_timing / im.FVsampt) - 1;
    
    if F0end < 1
        im.f0 = 1;
    else
        im.f0 = 1: F0end;
    end
else
    
    errordlg('Onset of the first stimulus timing is not defined!!!')
end

end