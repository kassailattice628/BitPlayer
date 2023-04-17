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
% aperture(patch size) = 5 deg
% dot size = 0.069 deg in diameter
% number of dots: 16.7 dots/deg^2/s
% -> round(16.7 * pi*(5/2)^2)/n_set = 328/3 = 110
%
% But this dot size is too small for mice?
% So I use 0.5 deg as a single dot size.
% s_dot = pi*(dot_r_deg)^2 -> s_dots = s_dot * n_dots -> s_dots/area = 0.0624
% dot_r_deg = sqrt(0.0624 * area/n_dots/pi); % <- too small? for mice?
% -----------------------------------------------

%Patch size in pix(Maximum radius from patch center)
R_max = Deg2Pix(sobj.Distance/2 , sobj.MonitorDist, sobj.Pixelpitch);
%area = pi * (sobj.Distance/2)^2; %pix^2


% -----------------------------------------
% Generate "n_set = 3" sets of dot location
% -----------------------------------------
n_set = 3;

if sobj.Distance < 5 %Small patch
    density = 16.7;
    n_dots = round(density * (sobj.Distance/2)^2 * pi);
    sobj.dot_RDM_deg = 0.069;

elseif sobj.Distance <= 5
    density = 16.7/2;
    n_dots = round(density * (sobj.Distance/2)^2 * pi);
    sobj.dot_RDM_deg = 0.12;
else
    %Fix the size of dot
    density = 0.1;
    sobj.dot_RDM_deg = 0.2;
    n_dots = density * (sobj.Distance/sobj.dot_RDM_deg)^2;
    n_dots = round(n_dots);
end
    
dot_size = Deg2Pix(sobj.dot_RDM_deg, sobj.MonitorDist, sobj.Pixelpitch);
disp(dot_size)

% speed
dot_speed_ppfs = Deg2Pix(sobj.MoveSpd, sobj.MonitorDist,...
    sobj.Pixelpitch) / sobj.FrameRate;

%%

n_coh = round(n_dots * sobj.CoherenceRDM);
n_incoh = n_dots - n_coh;



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

%Stim duration = the number of flips.
i_flip = 1:n_set;
i_flip = repmat(i_flip, [1, ceil(sobj.FlipNum/length(i_flip))]);
i_flip = i_flip(1:sobj.FlipNum);


% ----------
% Stim Start
% ----------

% Prep Delay
[sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
% Set the first screen + photo sensor;
Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
Screen('DrawDots', sobj.wPtr, transpose(xy(:,:,1)),...
    dot_size, sobj.stimlumi, sobj.StimCenterPos, 1);
% First flip
[sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
vbl = sobj.vbl_2;
ShowStimInfo(sobj, INFO);
drawnow;

% Moving flip
for i_set = i_flip(2:end)
    % Select one of dot-set from n_set, and displace with dxdy
    xy(:,:,i_set)  = xy(:,:,i_set) + dxdy;

    % Distance from the patch center of each dot
    [~, R] = cart2pol(xy(:, 1, i_set), xy(:, 2, i_set));
    
    % Find dots go out from the patch, needed to relocate
    i_out = find(R > R_max);
    i_in = setdiff(1:n_dots, i_out);

    % Select incoherent dot from "i_in"
    n_rand = n_incoh - length(i_out);
    if n_rand > 0
        i_rand = randperm(length(i_in), n_rand);
        i_rand = [i_out', i_in(i_rand)];
        n_rand = length(i_rand);
    else
        i_rand = i_out';
    end

    % Relocat incoherent + leaving dots at random position
    if n_rand > 0
        r(i_rand, i_set) = R_max * sqrt(rand(n_rand, 1));
        theta(i_rand, i_set) = 2*pi * rand(n_rand, 1);
        cs(i_rand, :, i_set) = ...
            [cos(theta(i_rand, i_set)), sin(theta(i_rand, i_set))];
        xy(i_rand, :, i_set) =...
            [r(i_rand, i_set), r(i_rand, i_set)] .* cs(i_rand, :, i_set);
    end

    % Draw
    Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
    Screen('DrawDots', sobj.wPtr, transpose(xy(:,:,i_set)),...
        dot_size, sobj.stimlumi, sobj.StimCenterPos, 1);

    % Flip (Why /2 is added? <- flip as fast as possible)
    vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
end

%Stim OFF
sobj = MovingStim_off(sobj, INFO, vbl);

%%
end
