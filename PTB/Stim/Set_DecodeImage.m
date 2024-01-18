function [img_col, img_i, img_shape] = Set_DecodeImage(s)
%
% Select TestImage and Show
% for Decode SC project
%
% s:sobj

%%
% loop #
i = s.n_in_loop - s.Blankloop_times;

% image data (matrix)
% Images is defined @Load_test_imagem

% Get randamized index.
img_i = Get_Randomized_Order(i, size(s.Images, 3));
img_col = s.Images(:,:, img_i);


if img_i == 1
    img_shape = 'square';
elseif img_i == 2
    img_shape = 'small frame';
elseif img_i == 3
    img_shape = 'large frame';
elseif img_i == 4
    img_shape = 'Plus';
elseif img_i == 5
    img_shape = 'X';

elseif img_i == 6
    img_shape = '28';
elseif img_i == 7
    img_shape = '6';
elseif img_i == 8
    img_shape = 'A';
elseif img_i == 9
    img_shape = 'K';
elseif img_i == 10
    img_shape = 'M';
end



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