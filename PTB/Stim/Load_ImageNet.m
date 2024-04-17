function s = Load_ImageNet(s, pattern)
%
% Load ImageNet images from Kamitani's lab
%
% 
% s = app.sobj;
% pattern = app.PatternDropDown.Value;

switch pattern
    case 'ImageNet train'
        s.ImageNet_dir = '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetTraining/';

    case 'ImageNet test'
        s.ImageNet_dir = '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetTest/';
end

impath = [s.ImageNet_dir, 'n*.JPEG'];
a = dir(impath);
s.ImageNet_list = {a.name}; % cell

end