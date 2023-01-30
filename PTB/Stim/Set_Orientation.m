function sobj = Set_Orientation(orientation, sobj)

switch orientation
    case 'Rand6'
        [ori_list, list_size] = make_list(6);
        %Randomize list
        sobj.Orientation_i_in_list = Get_RandomOrientation(sobj.n_in_loop, list_size, 1);
        sobj.BarOrientation = ori_list(sobj.Orientation_i_in_list);
        
    case 'Rand12'
        [ori_list, list_size] = make_list(12);
        %Randomize list
        sobj.Orientation_i_in_list = Get_RandomOrientation(sobj.n_in_loop, list_size, 1);
        sobj.BarOrientation = ori_list(sobj.Orientation_i_in_list);
        
    case 'Ord6'
        [ori_list, list_size] = make_list(6);
        %Randomize list
        sobj.Orientation_i_in_list = Get_RandomOrientation(sobj.n_in_loop, list_size, 0);
        sobj.BarOrientation = ori_list(sobj.Orientation_i_in_list);
        
    otherwise
        sobj.Orientation_i_in_list = 1;
        sobj.BarOrientation = str2double(orientation);

end

end

%% Get Direction List
function [orientation_list, list_size] = make_list(n)
step = 180/n;
orientation_list = -90+step :step:90;
list_size = length(orientation_list);
end

%% Direction Randomization
function index_list = Get_RandomOrientation(i_in_mainloop, list_size, randomize)

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
