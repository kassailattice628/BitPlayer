function sobj = Set_StimPos_Spot(mode, sobj)
%%%%%%
% Number of candidate center positions, taken directly from
% sobj.CenterPos_list (always DivNum^2 or Div_grid^2 rows -- whichever
% the caller used to build it via Get_StimCenter_in_matrix, right before
% calling this function). Deriving it this way -- instead of matching
% sobj.Pattern against a hardcoded name list -- avoids "Unrecognized
% variable" crashes for any stimulus pattern that calls this function
% but was missing from that list (e.g. Sinusoidal, Gabor, Looming,
% ImageNet train/test all hit this previously).
list_size = size(sobj.CenterPos_list, 1);

i = sobj.n_in_loop - sobj.Blankloop_times;
%%%%%%
switch mode
    case 'Random Matrix'
        %Randmize position center
        sobj.index_center_in_mat = Get_RandomCenterPosition(i, list_size, 1);
        sobj.StimCenterPos =...
            sobj.CenterPos_list(sobj.index_center_in_mat, :); %[X, Y] on pixel

    case 'Ordered Matrix'
        %Present stim in order (start from FixPos in GUI)
        %Start from sobj.FixPos
        i_center = Get_RandomCenterPosition(i, list_size, 0);
        sobj.index_center_in_mat = Sfhit_position(i_center, sobj.FixPos, list_size);

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
function index_list = Get_RandomCenterPosition(...
    i_in_mainloop, list_size, randomize)
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

%%
function shifted_i_center = Sfhit_position(i_center, FixPos, list_size)

shifted_i_center = i_center + FixPos -1;
if shifted_i_center > list_size
    shifted_i_center = shifted_i_center - list_size;
end
disp(shifted_i_center)

end
