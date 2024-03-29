function sobj = Set_StimSize_Spot(sobj)

%Randomize size order.
i = sobj.n_in_loop - sobj.Blankloop_times;

% Get randamized index.
index_size_in_list = Get_RandomSize(i, length(sobj.StimSize_deg_list));

% Get stim size (diameter) in degree
sobj.StimSize_deg = sobj.StimSize_deg_list(index_size_in_list);

% Get stim size (diameter) in pixels
sobj.StimSize_pix = round(ones(1,2) * ...
    Deg2Pix(sobj.StimSize_deg, sobj.MonitorDist, sobj.Pixelpitch)); %Defafult 1 deg

end


%% Size Randomization
function index_list = Get_RandomSize(i_in_mainloop, list_size)

persistent list_order %keep this in this function

%Randomize
i_in_cycle = mod(i_in_mainloop, list_size);
if i_in_cycle == 0
    i_in_cycle = list_size;
elseif i_in_cycle == 1
    list_order = randperm(list_size);
end

index_list = list_order(i_in_cycle);

end
