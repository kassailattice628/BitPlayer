%%%%%%%%%%%
%
% add new filed to analyze old data 
%
% fname: daq file
% app:
% obj_n: 1:sobj, 2:recobj, 3:imgobj 
% name: new filed name
% value: value of obj.name
%
%%%%%%%%%%%

fname = '/home/lattice/Share/s2p_working/20230616daq/1447/daq_1_.mat';
load(fname)

%Edit here
sobj.Stim_valiation_type = 'Fixed';%'Free';
%mainvar = rmfield(mainvar, 'PhotoSensorloaded');
%mainvar.PhotoSensorloaded = true;

%SaveData(:,3,:) =  SaveData(:,3,:)*1000;


save(fname)



