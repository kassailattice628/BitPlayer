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

% sobj.FixPos is defined (and set from the GUI) as an index into the
% DivNum x DivNum coarse matrix. That's a valid index into
% CenterPos_list only when CenterPos_list *is* that coarse matrix.
% For sub-area patterns such as 'Fine Mapping', CenterPos_list is
% instead built from a Div_grid x Div_grid sub-area (see VisStimON.m),
% so FixPos does not correspond to any particular cell in it -- using it
% directly there can index past the end of CenterPos_list (crash) or
% silently land on the wrong cell. Detect that case from the list size
% itself (no extra GUI control needed) and fall back to the middle
% element of CenterPos_list, i.e. the center of the mapped sub-area.
if list_size == sobj.DivNum^2
    ref_pos = sobj.FixPos;
else
    ref_pos = ceil(list_size / 2);
end

i = sobj.n_in_loop - sobj.Blankloop_times;
%%%%%%
switch mode
    case 'Random Matrix'
        %Randmize position center
        sobj.index_center_in_mat = Get_RandomCenterPosition(i, list_size, 1);
        sobj.StimCenterPos =...
            sobj.CenterPos_list(sobj.index_center_in_mat, :); %[X, Y] on pixel

    case 'Ordered Matrix'
        %Present stim in order (start from FixPos in GUI, or from the
        %center of the sub-area for Fine-Mapping-style patterns)
        i_center = Get_RandomCenterPosition(i, list_size, 0);
        sobj.index_center_in_mat = Sfhit_position(i_center, ref_pos, list_size);

        sobj.StimCenterPos =...
            sobj.CenterPos_list(sobj.index_center_in_mat, :); %[X, Y] on pixel

    case 'Fix Repeat'
        %Center pos is fixed at ref_pos (FixPos, or the center of the
        %sub-area for Fine-Mapping-style patterns)
        sobj.index_center_in_mat = ref_pos;
        sobj.StimCenterPos = sobj.CenterPos_list(ref_pos,:);

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
