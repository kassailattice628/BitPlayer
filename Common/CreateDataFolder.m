function savedir = CreateDataFolder(savedir, foldername)
%Make folder name of today
%foldername is 'PTB', 'DAQ', or 'Camera'


d = char(datetime('now', 'Format', 'yyyyMMdd'));

%savedir = '/home/lattice/Research/BitPlayerData/'
name = [savedir, d, foldername];
if ~exist(name, 'dir')
    mkdir(name);
end

%output
savedir = name;
end
