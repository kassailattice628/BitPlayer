function DAQ2HDF5(mouse, date, n_rec)

%Create HDF5 file
% mouse = "1441";
% date = "20230731";
daq_path = append('/home/lattice/Share/s2p_working/', date,...
    'daq/', mouse, '/daq_', num2str(n_rec), '_.mat');
load(daq_path, "imgobj");

rec = sprintf('Rec%d', n_rec);
f_name = append("M", mouse, ".hdf5");
data_path = fullfile("/", mouse, date, rec, "Analysys");


save_dir = "~/Share/Julia/DSOS/data/";
f_name = append(save_dir, f_name);
%angle
angle = imgobj.stim_directions;
h5_data = fullfile(data_path, "angle");
h5create(f_name, h5_data, size(angle));
h5write(f_name, h5_data, angle);

%peak
peak = squeeze(imgobj.dFF_peak_each_positive);
h5_data = fullfile(data_path, "peak");
h5create(f_name, h5_data, size(peak))
h5write(f_name, h5_data, peak);

end