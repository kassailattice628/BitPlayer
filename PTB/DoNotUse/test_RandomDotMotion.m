function test_RandomDotMotion(sobj)
%
% Generate random dot motion stimulus
% Based on DotDemo.m @ PTB3
%

AssertOpenGL;

% -------------------------
% set dot field parameters
% -------------------------

n_frames         = 1440; %sobj.FrameRate * 10;     % number of frames

dot_speed       = 5;   % deg/sec
f_kill          = 0.05; % fraction of dots to kill each frame

n_dots          = 500; % number of dots
max_d           = 15;   % maximum radius of annulus (deg) -> sobj.Size

center          = [960, 540]; %sobj.sobj.ScrCenterX, sobj.ScrCenterY;
% -------------
% screen set-up
% -------------
Priority(MaxPriority(sobj.wPtr));

% Do initial flip...
vbl = Screen('Flip', sobj.wPtr);


% ------------------------
% initialize dot positions
% ------------------------
%%
coherence = 0.2; % 30% of dots moves same direction. the others move randomly.


ppfs = Deg2Pix(dot_speed, sobj.MonitorDist,...
    sobj.Pixelpitch) / sobj.FrameRate;   % pix/frames
size_pix = Deg2Pix(1, sobj.MonitorDist, sobj.Pixelpitch);

% maximum radius of annuls (pix from center)
r_max = Deg2Pix(max_d, sobj.MonitorDist, sobj.Pixelpitch);

% distance frome center of dots
r = r_max * sqrt(rand(n_dots, 1));
theta = 2*pi*rand(n_dots, 1);
cs = [cos(theta), sin(theta)];
xy = [r, r] .* cs;

% Randomly select coherent dots
i_coh = randperm(n_dots, round(n_dots*coherence));
i_rand = setdiff(1:n_dots, i_coh);

% figure, scatter(xy(i_coh,1), xy(i_coh,2), 'b.')
% hold on, scatter(xy(i_rand,1), xy(i_rand,2), 'r.')


motion_angle = rand(n_dots, 1) * 2*pi; %rad
motion_angle(i_coh) = pi/4; % replace fixed angle for coherent dots
cs_motion = [cos(motion_angle), sin(motion_angle)];
% motion angle
dxdy = [ppfs, ppfs] .* cs_motion;
dr = ppfs;

% Generate XY and Radius matrix

%%
for i = 1:400
    % update position
    xy = xy + dxdy;
    r = r + dr;

    % Check if the position is inside r_max;
    i_warp = find(r > r_max | rand(n_dots, 1) < f_kill);
    n_out = length(i_warp);
    if n_out
        %new cordinate
        r(i_warp) = r_max * sqrt(rand(n_out, 1));
        theta(i_warp) = 2*pi*rand(n_out, 1);
        cs(i_warp, :) = [cos(theta(i_warp)), sin(theta(i_warp))];
        xy(i_warp, :) = [r(i_warp), r(i_warp)] .* cs(i_warp,:);
    end
    %xy(i_warp, :) = -1 * (xy(i_warp, :) - dxdy(i_warp, :));

    plot(xy(i_coh, 1), xy(i_coh,2), '.');
    hold on 
    plot(xy(i_rand,1), xy(i_rand,2), '.');
    hold off
    xlim([-200,200])
    ylim([-200,200])
    drawnow;
    pause(0.01)
end
%%

end
