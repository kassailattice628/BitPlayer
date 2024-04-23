function [sobj, imgtex, stimRect] = Set_ImagePresentation(sobj, img_folder, ext)
%
% Select a image from specified folder in a pseudo-randomized order.
%

% location of images
%   mg_folder = fullfile('Imgs', 'dataset1')
%   ext = '.tif';

%loop #
i = sobj.n_in_loop - sobj.Blankloop_times;

%%
img_folder = fullfile(pwd, img_folder);
img_fList = dir([img_folder, '/*', ext]);

sobj.n_Images = length(img_fList);

% Get randamized index.
sobj.i_image = Get_Randomized_Order(i, sobj.n_Images);
sobj.img_fname = img_fList(sobj.i_image).name;
img = imread(fullfile(img_folder, sobj.img_fname));

imgtex = Screen('MakeTexture', sobj.wPtr, img);

% Stim position

% Set stim size


base_stimRect = [0, 0, sobj.StimSize_pix];
stimRect = CenterRectOnPointd(base_stimRect,...
    sobj.StimCenterPos(1), sobj.StimCenterPos(2));
%Screen('DrawTexture', sobj.wPtr, imgtex, [], stimRect);





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