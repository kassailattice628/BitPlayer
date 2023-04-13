function sobj = Set_StimPos_Spot(mode, sobj)
%%%%%%
%if strcmp(sobj.Pattern, 'Uni')
if contains(sobj.Pattern, {'Uni', 'Size Random',...
        'Moving Spot', 'Static Bar','Random Dot Motion'})
    div = sobj.DivNum;
elseif strcmp(sobj.Pattern, 'Fine Mapping')
    div = sobj.Div_grid;
end

i = sobj.n_in_loop - sobj.Blankloop_times;
%%%%%%
switch mode
    case 'Random Matrix'
        %Randmize position center
        sobj.index_center_in_mat = Get_RandomCenterPosition(i, div^2, 1);
        sobj.StimCenterPos =...
            sobj.CenterPos_list(sobj.index_center_in_mat, :); %[X, Y] on pixel
 
    case 'Ordered Matrix'
        %Present stim in order (start from FixPos in GUI)
        sobj.index_center_in_mat =...
            Get_RandomCenterPosition(i, div^2, 0) + sobj.FixPos - 1;
        sobj.StimCenterPos =...
            sobj.CenterPos_list(sobj.index_center_in_mat, :); %[X, Y] on pixel
        
    case 'Fix Repeat'
        %Center pos is fixed i in n x n matrix.
        sobj.index_center_in_mat = sobj.FixPos;
        sobj.StimCenterPos = sobj.CenterPos_list(sobj.FixPos,:);
        
    case 'Concentric'
        sobj.index_center_in_mat = sobj.FixPos;
        sobj.StimCenterPos
        %Concentric Distance
        %Concentric Angle
        
%         position_list = 0 : (round(sobj.Dist/sobj.Div_zoom) * sobj.Div_zoom);
%         if strcmp(sobj.Direction, 
%         index_center_in_concentric = GetRandomCenterPosition(sobj.n_in_loop, ...
%             sobj.
end

end

%% Position Randomization
function index_list = Get_RandomCenterPosition(i_in_mainloop, list_size, randomize)
%
% Generate randomized order
%
% n_in_loop is current cycle in loop.
% list_size is the length of list items.
% When randomize == 1, list_items are randomized.
%
%

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
%

end