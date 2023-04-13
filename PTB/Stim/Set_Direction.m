function sobj = Set_Direction(direction, sobj)
%
% Select stim moving direction in degree
%
%%
i = sobj.n_in_loop - sobj.Blankloop_times;

switch direction
    case 'Rand8'
        n_directions = 8;
        randomized = 1;
        
    case 'Rand12'
        n_directions = 12;
        randomized = 1;
        
    case 'Rand16'
        n_directions = 16;
        randomized = 1;
        
    case 'Ord8'
        n_directions = 8;
        randomized = 0;

    case 'Ord12'
        n_directions = 12;
        randomized = 0;
end

%%

switch direction
    case {'Rand8', 'Rand12', 'Rand16', 'Ord8', 'Ord12'}
        [dir_list, list_size] = make_list(n_directions);
        sobj.MoveDir_i_in_list = Get_RandomDirection(i, list_size, randomized);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
    
    case 'Free'
        % Set direction not using fixed list
        sobj.MoveDirection = rand * 360;

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
