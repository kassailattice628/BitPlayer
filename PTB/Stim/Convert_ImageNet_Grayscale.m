function Convert_ImageNet_Grayscale(srcDirs, varargin)
% CONVERT_IMAGENET_GRAYSCALE  ImageNet刺激画像フォルダをグレースケール化して複製する
%
%   Convert_ImageNet_Grayscale({'/path/ImageNetTraining', '/path/ImageNetTest20'})
%
% マウスの色覚(2色型、M/S-opsin)は標準RGBモニターの発光特性と対応しないため、
% カラー画像をそのまま提示すると「色として意味のある信号」でも「単純な輝度」
% でもない解釈しづらい信号になる。本関数は各srcDir内の画像を標準的な輝度変換
% (rgb2gray、ITU-R BT.601相当の重み 0.299/0.587/0.114)でグレースケール化し、
% 提示前に固定ファイルとして保存しておくためのもの(提示時のリアルタイム変換
% ではなく事前変換を選んだ理由: 変換済みファイルそのものが「実際に提示した
% 画像」の記録になり、DecodeSC_sub-analysysリポジトリの解析側でも同じ画像を
% 独立に読み込んで局所特徴を抽出できるため)。
%
% 出力は R=G=B=輝度 の3チャンネル画像として [srcDir '_gray'] に同じファイル名
% で保存する(3チャンネルにするのは、Load_ImageNet.m等の既存コードが
% size(img,3)==3を前提にしていても変更なしで動くようにするため)。
%
% 入力
%   srcDirs : フォルダパス(文字列)、またはフォルダパスのcell配列
%
% オプション
%   'OutSuffix'      出力フォルダ名の接尾辞                     (default '_gray')
%   'OutDir'         出力フォルダを直接指定(srcDirsが単一の場合のみ) (default '')
%   'SingleChannel'  true=単チャンネルで保存(ファイルサイズ削減)   (default false)
%   'Overwrite'      既存の出力ファイルを上書きするか             (default false)
%   'Extensions'     対象拡張子                                 (default {'.JPEG','.jpg','.jpeg','.png','.bmp'})
%
% 出力: なし(グレースケール画像フォルダを生成)。フォルダごとに変換・リンク・
%        スキップ・エラー件数を表示する。
%
% 例(このリポジトリのPTB/Images配下、コピー&編集して使う。実際のフォルダ名は
%     Load_ImageNet.mのs.ImageNet_dirを参照: ImageNetTraining, ImageNetTest20,
%     ImageNetNoiseCorr):
%   Convert_ImageNet_Grayscale({ ...
%       '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetTraining', ...
%       '/home/lattice/Research/BitPlayer/PTB/Images/ImageNetTest20'});
%   % -> 同じ階層に ImageNetTraining_gray, ImageNetTest20_gray が作成される
%   %
%   % ImageNetNoiseCorrは実体フォルダだが、中の画像の大半(noise.pngを除く)
%   % はImageNetTest20内の同名ファイルへのシンボリックリンク(Load_ImageNet.m
%   % のコメント参照)。ピクセルを読み直して二重変換するのではなく、リンク先の
%   % "_gray"側パスを指す新しいシンボリックリンクを自動的に作る
%   % (下記「シンボリックリンクの扱い」参照)。
%   Convert_ImageNet_Grayscale('/home/lattice/Research/BitPlayer/PTB/Images/ImageNetNoiseCorr');
%   % -> ImageNetNoiseCorr_gray に、リンク先を(リンク先のフォルダ)_grayに
%   %    差し替えたシンボリックリンクが作成される(noise.pngは実体なので
%   %    通常通り変換される)。リンク先の実体(ImageNetTest20_gray)を先に
%   %    変換しておくこと。
%
% シンボリックリンクの扱い:
%   srcDir内のファイルがシンボリックリンクの場合、リンク先を実パスに解決し、
%   そのフォルダ名に'_gray'(またはOutSuffix)を付けたパスを指す新しい
%   シンボリックリンクをoutDirに作る(リンク先の画像を二重に変換しない
%   ため)。リンク先の"_gray"版がまだ存在しない場合は警告を出すが、リンク
%   自体は作成する(後で実体側を変換すれば解決する)。

p = inputParser;
p.addParameter('OutSuffix', '_gray');
p.addParameter('OutDir', '');
p.addParameter('SingleChannel', false);
p.addParameter('Overwrite', false);
p.addParameter('Extensions', {'.JPEG', '.jpg', '.jpeg', '.png', '.bmp'});
p.parse(varargin{:});
opt = p.Results;

if ischar(srcDirs) || isstring(srcDirs)
    srcDirs = {char(srcDirs)};
end

if ~isempty(opt.OutDir) && numel(srcDirs) > 1
    error('Convert_ImageNet_Grayscale: OutDir can only be used with a single srcDir');
end

for i = 1:numel(srcDirs)
    srcDir = srcDirs{i};
    if ~isempty(opt.OutDir)
        outDir = opt.OutDir;
    else
        srcDirClean = regexprep(srcDir, '[\\/]+$', '');
        outDir = [srcDirClean, opt.OutSuffix];
    end
    convert_one_folder(srcDir, outDir, opt);
end

end


function convert_one_folder(srcDir, outDir, opt)

if ~isfolder(srcDir)
    warning('Convert_ImageNet_Grayscale: source folder not found, skipped: %s', srcDir);
    return;
end
if isfolder(outDir) && strcmp(outDir, srcDir)
    error('Convert_ImageNet_Grayscale: OutDir must differ from srcDir (%s)', srcDir);
end
if ~isfolder(outDir)
    mkdir(outDir);
end

files = dir(srcDir);
files = files(~[files.isdir]);

nConverted = 0;
nLinked = 0;
nSkipped = 0;
nError = 0;

for k = 1:numel(files)
    if startsWith(files(k).name, '._')
        % macOS AppleDouble リソースフォークの残骸(実データではない)。無視する。
        continue;
    end
    [~, ~, ext] = fileparts(files(k).name);
    if ~any(strcmpi(ext, opt.Extensions))
        continue;
    end
    srcPath = fullfile(srcDir, files(k).name);
    dstPath = fullfile(outDir, files(k).name);
    if (exist(dstPath, 'file') || islink_(dstPath)) && ~opt.Overwrite
        nSkipped = nSkipped + 1;
        continue;
    end

    if islink_(srcPath)
        % シンボリックリンク: リンク先の画像を読み直して二重変換するのでは
        % なく、リンク先フォルダの"_gray"版を指す新しいリンクを作る。
        try
            targetPath = resolve_link_(srcPath);
            [targetDir, targetName, targetExt] = fileparts(targetPath);
            targetDirClean = regexprep(targetDir, '[\\/]+$', '');
            grayTargetPath = fullfile([targetDirClean, opt.OutSuffix], [targetName, targetExt]);
            if ~isfile(grayTargetPath)
                warning('Convert_ImageNet_Grayscale: link target not yet converted, linking anyway: %s', grayTargetPath);
            end
            if exist(dstPath, 'file') || islink_(dstPath)
                delete(dstPath);
            end
            [status, cmdout] = system(['ln -sf ', shquote_(grayTargetPath), ' ', shquote_(dstPath)]);
            if status ~= 0
                error('ln -sf failed: %s', cmdout);
            end
            nLinked = nLinked + 1;
        catch ME
            warning('Convert_ImageNet_Grayscale: failed to link %s (%s)', srcPath, ME.message);
            nError = nError + 1;
        end
        continue;
    end

    try
        img = imread(srcPath);
        nCh = size(img, 3);
        if nCh == 3
            grayImg = rgb2gray(img);
        elseif nCh == 1
            grayImg = img;  % 既にグレースケール
        else
            error('unexpected channel count: %d', nCh);
        end
        if opt.SingleChannel
            outImg = grayImg;
        else
            outImg = repmat(grayImg, [1, 1, 3]);
        end
        imwrite(outImg, dstPath);
        nConverted = nConverted + 1;
    catch ME
        warning('Convert_ImageNet_Grayscale: failed on %s (%s)', srcPath, ME.message);
        nError = nError + 1;
    end
end

fprintf('Convert_ImageNet_Grayscale: %s -> %s : converted=%d, linked=%d, skipped=%d, error=%d\n', ...
    srcDir, outDir, nConverted, nLinked, nSkipped, nError);

end


function tf = islink_(p)
% ファイル/フォルダがシンボリックリンクかどうか(Linux/macOS前提)。
[status, ~] = system(['test -L ', shquote_(p)]);
tf = (status == 0);
end


function target = resolve_link_(p)
% シンボリックリンクのリンク先を絶対パスで解決する(readlink -f)。
[status, cmdout] = system(['readlink -f ', shquote_(p)]);
if status ~= 0
    error('readlink -f failed: %s', cmdout);
end
target = strtrim(cmdout);
end


function q = shquote_(p)
% シェルコマンドに渡すためシングルクォートでエスケープする。
q = ['''', strrep(p, '''', '''\'''''), ''''];
end
