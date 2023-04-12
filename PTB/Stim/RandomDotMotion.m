function sobj = RandomDotMotion(sobj, INFO)
% --------------------------------------
% Movshon/Newsom random-dot kinematogram
% --------------------------------------
%
% Generate 3 (<- n_set) randomly located dot-sets with in a patch.
% Each set appears every 4 flip and interleaved with the other sets
% Among a dot-sets, randomly selected coherect dots move same direction,
% while the other dots relocated random position.
% dot density

%%
% -----------------------------------------------
% from Gold & Shadlen, 2003
% aperture = 5 deg
% dot size = 0.069 deg in diameter
% number of dots: 16.7 dots/deg^2/s
% -> round(16.7 * pi*(5/2)^2)/n_set = 328/3 = 110
%
% But this dot size is too small for mice?
% So I use 0.5 deg as a single dot size.
% -----------------------------------------------

n_dots = 100;

%Patch size in pix(Maximum radius from patch center)
R_max = Deg2Pix(sobj.Distance/2 , sobj.MonitorDist, sobj.Pixelpitch);
%area = pi * (sobj.Distance/2)^2; %pix^2

%s_dot = pi*(dot_r_deg)^2 -> s_dots = s_dot * n_dots -> s_dots/area = 0.0624
%dot_r_deg = sqrt(0.0624 * area/n_dots/pi);
dot_r_deg = 0.5;
dot_size = Deg2Pix(dot_r_deg, sobj.MonitorDist, sobj.Pixelpitch);

% speed
dot_speed_ppfs = Deg2Pix(sobj.MoveSpd, sobj.MonitorDist,...
    sobj.Pixelpitch) / sobj.FrameRate;

%%

n_coh = round(n_dots * sobj.CoherenceRDM);
n_incoh = n_dots - n_coh;

n_set = 3;

% Distnce and angle from cente of each dots (xy) pixel
r = R_max .* sqrt(rand(n_dots, n_set));
theta = 2*pi .* rand(n_dots, n_set);
cs = zeros(n_dots, 2, n_set);
xy = cs;
for i = 1:n_set
    cs(:,:,i) = [cos(theta(:,i)), sin(theta(:,i))];
    xy(:,:,i) = round([r(:,i), r(:,i)] .* cs(:,:,i));
end

motion_angle = deg2rad(sobj.MoveDirection); % Coherent moving direction

cs_motion = [cos(motion_angle), sin(motion_angle)];
dxdy = [dot_speed_ppfs, dot_speed_ppfs] .* cs_motion;

i_list = 1:n_set;
i_list = repmat(i_list, [1, ceil(sobj.FlipNum/length(i_list))]);
i_list = i_list(1:sobj.FlipNum);


% ----------
% Stim Start
% ----------

% Set the first frame
Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
Screen('DrawDots', sobj.wPtr, transpose(xy(:,:,1)),...
    dot_size, sobj.stimlumi, sobj.StimCenterPos, 1);
% First flip
[sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
vbl = sobj.vbl_2;
ShowStimInfo(sobj, INFO);
drawnow;

%Mvoing flips
for i_set = i_list(2:end)
    xy(:,:,i_set)  = xy(:,:,i_set) + dxdy;
    [~, R] = cart2pol(xy(:, 1, i_set), xy(:, 2, i_set));
    i_out = find(R > R_max); % move to random position
    i_in = setdiff(1:n_dots, i_out);
    %i_in のうちから，n_incoh - n_out 個えらんで randomize
    n_rand = n_incoh - length(i_out);
    if n_rand > 0
        i_rand = randperm(length(i_in), n_rand);
        i_rand = [i_out', i_in(i_rand)];
    else
        i_rand = i_out';
    end

    r(i_rand, i_set) = R_max * sqrt(rand(length(i_rand), 1));
    theta(i_rand,i_set) = 2*pi * rand(length(i_rand), 1);
    cs(i_rand, :, i_set) = ...
        [cos(theta(i_rand,i_set)), sin(theta(i_rand, i_set))];
    xy(i_rand, :, i_set) =...
        [r(i_rand, i_set), r(i_rand, i_set)] .* cs(i_rand, :, i_set);


    Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
    Screen('DrawDots', sobj.wPtr, transpose(xy(:,:,i_set)),...
        dot_size, sobj.stimlumi, sobj.StimCenterPos, 1);
    %Flip
    vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
end

%Stim OFF
sobj = MovingStim_off(sobj, INFO, vbl);

%%
end
