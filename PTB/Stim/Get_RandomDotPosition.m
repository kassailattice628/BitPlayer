function [xy, cs, theta, dxdy, r, dr] = Get_RandomDotPosition(sobj, R_max)
%
% Calculate position of dots and moving distance in each frame
%

%number of dots in the pathc
n_dots = sobj.DotNum;

%dot_speed (pixels/frame)
dot_speed_ppfs = Deg2Pix(sobj.MoveSpd, sobj.MonitorDist,...
    sobj.Pixelpitch) / sobj.FrameRate ;

% Distnce and angle from cente of each dots (xy) pixel
r = R_max * sqrt(rand(n_dots, 1)); 
theta = 2*pi * rand(n_dots, 1);
cs = [cos(theta), sin(theta)];
xy = round([r, r] .* cs);
%xy = xy + sobj.StimCenterPos;

% Select coherenct dots
i_coh = randperm(n_dots, round(n_dots * sobj.CoherenceRDM));
%i_rand = setdiff(1:n_dots, i_coh);

%% Motion of each dot
motion_angle = 2*pi + rand(n_dots, 1);
%Set same moving angle for coherenct dots
motion_angle(i_coh) = deg2rad(sobj.MoveDirection);
cs_motion = [cos(motion_angle), sin(motion_angle)];
% moving distance in each frame
dxdy = [dot_speed_ppfs, dot_speed_ppfs] .* cs_motion;
dr = dot_speed_ppfs;



end