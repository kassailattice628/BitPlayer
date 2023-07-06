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

fname = '/home/lattice/Share/s2p_working/20230629daq/1471/daq_2_.mat';
load(fname)

%Edit here
sobj.ISI_sec = '4';
%sobj.Stim_valiation_type = 'Fixed';%'Free';
%mainvar = rmfield(mainvar, 'PhotoSensorloaded');
%mainvar.PhotoSensorloaded = true;

%SaveData(:,3,:) =  SaveData(:,3,:)*1000;


save(fname)



