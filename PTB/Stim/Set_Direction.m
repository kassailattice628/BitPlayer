function sobj = Set_Direction(direction, sobj)
%
% Select stim moving direction in degree
%
%%
i = sobj.n_in_loop - sobj.Blankloop_times;

%%
randomize = 0;

if contains(direction, 'Rand')
    n_directions = str2double(extract(direction, digitsPattern));
    randomize = 1;

elseif contains(direction, 'Ord')
    n_directions = str2double(extract(direction, digitsPattern));
end

%%

switch direction
    case {'Rand12', 'Rand16', 'Ord12', 'Ord16'}
        [dir_list, list_size] = make_list(n_directions);
        sobj.MoveDir_i_in_list = Get_RandomDirection(i, list_size, randomize);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
    
    case 'Free'
        % Set direction randomly.
        % Do not choose angles that in changes of less than 1 pixel.
        % 0.1 deg ~ 1 pix -> Round to the first decimal place.
        sobj.MoveDirection = round(rand * 360, 1);

    case {'Ord12+jump', 'Ord16+jump'}
        % after 5 to 9 rotation unexpected jump of direction was 
        [dir_list, list_size] = make_list(n_directions);
        sobj.MoveDir_i_in_list = Get_RotationJumpDirection(i, list_size);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
        disp(sobj.MoveDirection)

    % for rondom-dot stim
    case '0 vs 180'
        sobj.MoveDir_i_in_list = [0, 180];
        sobj.MoveDirection = sobj.MoveDir_i_in_list(randperm(2, 1));

    case '90 vs 270'
        sobj.MoveDir_i_in_list = [90, 270];
        sobj.MoveDirection = sobj.MoveDir_i_in_list(randperm(2, 1));

    otherwise %Fixed direction is set in GUI(appdesigner)
        sobj.MoveDir_i_in_list = 1;
end
end

%% Get Direction List
function [dir_list, list_size] = make_list(n)
step = 360/n;
dir_list = 0:step:360-step;
list_size = length(dir_list);
end

%% Direction Randomization
function index_list = Get_RandomDirection(i_in_mainloop, list_size, randomize)

persistent list_order %keep this in this function

%Randomize
i_in_cycle = mod(i_in_mainloop, list_size);

if i_in_cycle == 0
    i_in_cycle = list_size;
    
elseif i_in_cycle == 1
    %Reset random order
    if randomize == 1
        list_order = randperm(list_size);
    else
        list_order = 1:list_size;
    end
end 

index_list = list_order(i_in_cycle);
end

%% Direction with random jump
function index_list = Get_RotationJumpDirection(i_in_mainloop, list_size)

persistent i_list i_randomize rand_step stepsize

if i_in_mainloop == 1
    %initialize
    stepsize = 1;
    i_list = 0;
    %timing of random jump
    rand_step = randperm(5,1) + 4; 
    fprintf('Randomized after %d loops.\n', rand_step);
    i_randomize = 0;

end

i_list = i_list + stepsize;
i_randomize = i_randomize + 1;

if i_randomize == rand_step
    %random position
    List = setdiff(1:list_size, [i_list, i_list-stepsize]);
    i_list = List(randperm(list_size, 1));
    stepsize = -stepsize; %opposite rotation

    %reset timing of random jump
    rand_step = randperm(5,1) + 4; 
    fprintf('Randomized after %d loops.\n', rand_step);
    i_randomize = 0;
end

index_list = i_list;

if index_list > list_size
    index_list = 1;
elseif index_list < 1
    index_list = list_size;
end






end