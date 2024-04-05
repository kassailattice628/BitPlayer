function [x_elip_rot, y_elip_rot] = RF_Elipse(beta_fit)
%
% Using parameters of Rotated 2D Gaussian,
% generate Edge of SD line by a elipse.
%

theta = linspace(0, 2*pi, 200);

x0      = beta_fit(2);
x_sd    = beta_fit(3);
y0      = beta_fit(4);
y_sd    = beta_fit(5);
phi     = beta_fit(6);

%% Elipse setting
x_elip = x_sd * cos(theta);
y_elip = y_sd * sin(theta);

% add rotation and shift the center to (x0, y0)
x_elip_rot = cos(phi) * x_elip - sin(phi) * y_elip + x0;
y_elip_rot = sin(phi) * x_elip + cos(phi) * y_elip + y0;

end