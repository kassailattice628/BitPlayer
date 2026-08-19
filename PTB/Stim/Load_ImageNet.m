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
        s.ImageNet_dir = '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetTest20/';
        
    case 'ImageNet NoiseCorr'
        s.ImageNet_dir = '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetNoiseCorr/';
end

%impath = [s.ImageNet_dir, 'n*.JPEG'];
% 複数パターンをまとめて取得
%a = dir(impath);

% 取得したい拡張子のパターンをセル配列で定義
patterns = {'n*.JPEG', 'n*.jpg', 'n*.png', 'n*.PNG'};

% 各パターンの検索結果を結合する
a = [];
for i = 1:length(patterns)
    a = [a; dir(fullfile(s.ImageNet_dir, patterns{i}))];
end

s.ImageNet_list = {a.name}; % cell
s.n_Images = length(s.ImageNet_list);

end