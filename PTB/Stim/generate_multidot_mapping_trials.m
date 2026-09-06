function [trials, usage] = generate_multidot_mapping_trials(gridXY, M, T, varargin)
% GENERATE_MULTIDOT_MAPPING_TRIALS 白点マッピングの複数点同時提示、刺激条件リストを生成する
%
%   [trials, usage] = generate_multidot_mapping_trials(gridXY, M, T, ...
%                                                       'TargetCap', 30, 'Seed', 0);
%
% 設計方針は DecodeSC_sub-analysys リポジトリの docs/THESIS_PLAN.md
% 「白点マッピング」④参照(同じアルゴリズムをここPTB側に移植したもの)。
% 1試行で複数のグリッド位置に白点を同時提示し、反復数(=マッピング精度)を
% 底上げする。ただし固定した組み合わせ(位相)を毎回使うと、どの位置が
% 実際にROIの応答を引き起こしたか解析側で区別できなくなる(「試行×位置」
% 行列の列が線形従属になり原理的に分離不可能)。そのため、
%   (1) 毎試行、安全マージンMを満たす範囲でランダムに複数点を選び直す
%   (2) 上限(TargetCap)を超えた位置は候補から除外し、反復数を均一化する
% という2点が必須。解析側は単純な位置ごとの平均ではなく、ROIごとの
% リッジ回帰(観測応答 ≈ 試行×位置の有無行列 * 各位置固有の応答)で行う
% 想定(解析コードは DecodeSC_sub-analysys 側の別TODO、このファイルは
% 刺激条件の生成のみ)。
%
% 入力
%   gridXY   [N x 2] 各グリッド位置の中心座標。単位は呼び出し側と揃えること
%            (Set_StimPos_MultiDot.m からはpixel単位のCenterPos_listを渡す)
%   M        安全マージン(gridXYと同じ単位。pixelで呼ぶ場合はDeg2Pixで変換)
%   T        生成する総試行数
%
% オプション
%   'TargetCap'  1位置あたりの目標反復数の上限 (default: ceil(T*7/N)の概算値)
%   'Seed'       乱数シード (default 0、再現性のため)
%
% 出力
%   trials   {T x 1} cell配列。trials{t} は試行tで同時提示するgridXYの行番号
%   usage    [N x 1] 生成後の実際の反復数(位置ごと)

p = inputParser;
N = size(gridXY, 1);
addParameter(p, 'TargetCap', ceil(T * 7 / N));
addParameter(p, 'Seed', 0);
parse(p, varargin{:});
targetCap = p.Results.TargetCap;
seed = p.Results.Seed;

rng(seed);
% [N x N] 全ペア距離 (Statistics and Machine Learning Toolboxのpdist/
% squareformには依存せず、基本演算だけで計算する)
dx = gridXY(:, 1) - gridXY(:, 1)';
dy = gridXY(:, 2) - gridXY(:, 2)';
D = sqrt(dx.^2 + dy.^2);

usage = zeros(N, 1);
trials = cell(T, 1);

for t = 1:T
    eligible = find(usage < targetCap);
    if isempty(eligible)
        % 全位置が上限到達済みなら一時的に制限解除(通常Tを適切に選べば起きない)
        eligible = (1:N)';
    end

    % 反復数が少ない順(同数はランダム)に並べ、貪欲に安全マージンを満たす点を追加
    r = rand(length(eligible), 1);
    [~, ord] = sortrows([usage(eligible), r]);
    order = eligible(ord);

    selected = [];
    for ii = 1:length(order)
        cand = order(ii);
        if isempty(selected) || all(D(cand, selected) >= M)
            selected(end+1) = cand; %#ok<AGROW>
        end
    end

    trials{t} = selected;
    usage(selected) = usage(selected) + 1;
end

ks = cellfun(@length, trials);
fprintf('generate_multidot_mapping_trials: N=%d位置, T=%d試行, 安全マージンM=%.1f\n', N, T, M);
fprintf('  同時点数k: min=%d median=%.1f max=%d 平均=%.2f\n', min(ks), median(ks), max(ks), mean(ks));
fprintf('  反復数(位置ごと): min=%d median=%.1f max=%d (変動係数=%.3f)\n', ...
    min(usage), median(usage), max(usage), std(usage) / mean(usage));

end
