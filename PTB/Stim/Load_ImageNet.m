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
        % このフォルダの5枚のテスト画像(noise.png=グレー単色を除く)は、
        % 実体をコピーせずImageNetTest20/内の同名ファイルへの
        % シンボリックリンクにしてある（二重管理を避けるため）。
        %
        % 2026-09-05に画像セットを選定し直した。旧セットの1枚
        % (n02190790_15121.JPEG)がSCデータでグレー条件とほぼ同じ
        % 集団応答パターン(signal corr=0.916)を示しており、原因は
        % コントラスト不足(5枚中最低)と判明。ImageNetTest20の20枚から、
        % (1)グレースケールのコントラスト(std)が高いこと、(2)画像同士の
        % 32x32ダウンサンプル後のピクセル相関が低いこと、の2条件で
        % 貪欲法選定した5枚に差し替えた:
        %   n04507155_21299 (傘、コントラスト最高)
        %   n01677366_18182 (イグアナ、既存から維持)
        %   n02437971_5013  (ラマ、既存から維持)
        %   n04554684_53399 (洗濯機のある室内)
        %   n03272010_11001 (ギターを弾く人物、既存から維持)
        % 選定根拠の詳細・相関行列はDecodeSC_sub-analysys リポジトリの
        % docs/ANALYSIS_NOTES.md「noise correlationプロトコルの刺激画像
        % 5枚の選び直し」を参照。
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