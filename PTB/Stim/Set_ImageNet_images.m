function ImageNet_f = Set_ImageNet_images(s)
%
% Select ImageNet image file
% for Decode SC project
% images were given from KAMITANI lab
%

%%
% loop #
i = s.n_in_loop - s.Blankloop_times - 8;

% ImageNet file names list is defined @Load_ImageNet.m
n_images = length(s.ImageNet_list);

% Get randamized index.
img_i = Get_Randomized_Order(i, n_images);
ImageNet_f = s.ImageNet_list{img_i};


end

%% Randomize order of images
function index_list = Get_Randomized_Order(i_in_mainloop, list_size)

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