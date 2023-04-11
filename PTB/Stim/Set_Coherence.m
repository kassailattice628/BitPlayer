function sobj = Set_Coherence(Coh, sobj)
%
% Set Coherence value for Random Dot Motion stimuli
%

i = sobj.n_in_loop - sobj.Blankloop_times;

%sobj.CoherenceRDM = 0.5; %50%
%sobj.Coherence_list = [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1];

switch Coh.Value
    case 'Random'
        sobj.CoherenceRDM =...
            sobj.Coherence_list(Get_RandomCoherence(i, sobj.Coherencelist));

    otherwise
        sobj.CoherenceRDM =...
            str2double(extract(Coh.Value, digitsPattern)) / 100;
end

end

%% Randomize
function i_in_list = Get_RandomCoherence(i_in_mainloop, list)

persistent list_order %keep this in this function

list_size = length(list);

%Randomize
i_in_cycle = mod(i_in_mainloop, list_size);

if i_in_cycle == 1
    %Reset random order
    list_order = randperm(list_size);

elseif i_in_cycle == 0
    i_in_cycle = list_size;
end

i_in_list = list_order(i_in_cycle);

%
end