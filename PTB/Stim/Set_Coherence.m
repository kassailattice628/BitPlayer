function sobj = Set_Coherence(Coh, Mode, sobj)
%
% Set Coherence value for Random Dot Motion stimuli
%

i = sobj.n_in_loop - sobj.Blankloop_times;

%sobj.Coherence_list = [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1];
%sobj.Coherence_list = linspace(0.01, 0.99, 50);


if strcmp(Mode, 'Hard')
    sobj.Coherence_list = logspace(-1.8, -0.1, 15);
%[0.0158, 0.0210, 0.0277, 0.0367, 0.0485, 0.0641, 0.0848, 0.1122,,,,
% 0.1484, 0.1963, 0.2596, 0.3433, 0.4541, 0.6006, 0.7943]
elseif strcmp(Mode, 'Easy')
    a = logspace(-1.4, -0.01, 15);
    sobj.Coherence_list  = a(6:end);
%[0.1249, 0.1569, 0.1972, 0.2479, 0.3116, 0.3916, 0.4922, 0.6186,,,,
% 0.7775, 0.9772]
end

switch Coh.Value
    case 'Random'
        sobj.CoherenceRDM =...
            sobj.Coherence_list(Get_RandomCoherence(i, sobj.Coherence_list));

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