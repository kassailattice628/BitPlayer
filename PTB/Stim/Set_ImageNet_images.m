function s = Set_ImageNet_images(s)
%
% Select ImageNet image file
% for Decode SC project
% images were given from KAMITANI lab
%
% randamized order is shared across same session

%%

% ImageNet file names list is defined @Load_ImageNet.m
% as, s.ImageNet_list
switch s.Pattern
    case "ImageNet train"
        %keep randamized order in s.RandOrderImages;
        if ~isfield(s, 'i_presented')
            s.i_presented = 1;
        elseif s.i_presented > s.n_Images
            s.i_presented = 1;
        end

        if s.i_presented == 1
            s.RandOrderImages = randperm(s.n_Images);
        end

        s.img_i = s.RandOrderImages(s.i_presented);
        s.ImageNet_f = s.ImageNet_list{s.img_i};

        % Count up for next stim
        s.i_presented = s.i_presented + 1;

    case "ImageNet test"
        %%
        i = s.n_in_loop - s.Blankloop_times - 8;

        % Get randamized index. sobj.n_Images = 20 image?
        s.img_i = Get_Randomized_Order(i, s.n_Images);
        s.ImageNet_f = s.ImageNet_list{s.img_i};

end
s.ImageNet_f = s.ImageNet_list{s.img_i};



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