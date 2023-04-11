function Y = Deg2Pix(ang, dist, pixpitch)
% ang => (degree)
% dist => distance between Monitor and eye (mm)
% pixel pitch :sobj.Pixelpitch

% transform viewangle into length in pixels.

% pixel size of specified ang(deg)
theta = deg2rad(ang/2);
Y_mm = tan(theta) * dist * 2;
Y = Y_mm / pixpitch;
Y = round(Y);

%Y = 2*dist*tan(ang/2*2*pi/360)/pixpitch;


