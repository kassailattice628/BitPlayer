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

fname = '/home/lattice/Share/s2p_working/20230425daq/1399/daq_6_.mat';
load(fname)

%Edit here
%sobj.Stim_valiation_type = 'Free';
sobj = rmfield(sobj, 'Stim_valiation_type');
disp(sobj)

save(fname)



