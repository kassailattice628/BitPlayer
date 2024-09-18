function Merge_daq(f1, f2)
%
% Merge the daq data of two different session with same condition
% f1 and f2 are the 'daq.mat' data.
%

[imgobj1, mainvar1, ParamsSave1, recobj1, sobj1, SaveData1, SaveTimestamps1] = ...
    load_daq(f1);

[imgobj2, mainvar2, ParamsSave2, recobj2, sobj2, SaveData2, SaveTimestamps2] = ...
    load_daq(f2);

%Check
if ~strcmp(mainbar1.dirname_daq, mainbar2.dirname_daq)
    errordlg("The files being merged may have different mouse or different date")
else

    %start to merge




end





end

function [p1, p2, p3, p4, p5, p6, p7] = load_daq(f)

load(f, 'imgobj', 'mainvar', 'ParamsSave', 'recobj', 'sobj', 'SaveData', 'SaveTimestamp')
p1 = imgobj;
p2 = mainvar;
p3 = ParamsSave;
p4 = recobj;
p5 = sobj;
p6 = SaveData;
p7 = SaveTimestamp;

end