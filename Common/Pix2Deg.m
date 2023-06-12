function Y = Pix2Deg(pix, dist, pixpitch)

% pix => (pixel number)
% dist => (mm)
% pixel pitch = sobj.Pixelpitch

Y = 2*atand(pixpitch*pix/2/dist);


