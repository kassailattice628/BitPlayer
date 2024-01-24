f_csv = "/home/lattice/Share/Julia/DSOS/data/list_DSOS_20231013.csv";

df = readtable(f_csv);

for i = 1:size(df,1)
    mouse = num2str(df.mouse(i));
    date = num2str(df.date(i));
    n_rec = df.n_rec(i);
    condition = df.condition(i);
    depth = df.depth(i);
    stimulus = df.stimulus(i);

    DAQ2HDF5(mouse, date, n_rec);
end