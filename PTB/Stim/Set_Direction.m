function sobj = Set_Direction(direction, sobj)

switch direction
    case 'Rand8'
        [dir_list, list_size] = make_list(8);
        %Randomize list
        sobj.MoveDir_i_in_list = Get_RandomDirection(sobj.n_in_loop, list_size, 1);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
        
        
    case 'Rand12'
        [dir_list, list_size] = make_list(12);
        %Randomize list
        sobj.MoveDir_i_in_list = Get_RandomDirection(sobj.n_in_loop, list_size, 1);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
        
    case 'Rand16'
        [dir_list, list_size] = make_list(16);
        %Randomize list
        sobj.MoveDir_i_in_list = Get_RandomDirection(sobj.n_in_loop, list_size, 1);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
        
    case 'Ord8'
        [dir_list, list_size] = make_list(8);
        %Randomize list
        sobj.MoveDir_i_in_list = Get_RandomDirection(sobj.n_in_loop, list_size, 0);
        sobj.MoveDirection = dir_list(sobj.MoveDir_i_in_list);
        
    otherwise
        sobj.MoveDir_i_in_list = 1;
        
        %Fixed irection: Set in GUI.
        %sobj.MiveDirection, sobj.MoveDir_i_in_list
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
