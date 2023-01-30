function cycles_per_pixel = CPD2CPP(cpd, MonitorDistance, PixelPitch)

%cycle/deg -> deg/cycle
dpc = 1/cpd;
%deg/cycle -> pix/cycle
ppc = Deg2Pix(dpc, MonitorDistance, PixelPitch);
%pix/cycle -> cycles/pix
cycles_per_pixel = 1/ppc;

end