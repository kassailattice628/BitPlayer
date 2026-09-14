function [trials, order_info] = generate_singledot_free_trials(L, T, varargin)
% GENERATE_SINGLEDOT_FREE_TRIALS Fine Mapping Free用、1試行1点(k=1)の連続配置スケジュール生成
%
%   trials = generate_singledot_free_trials(L, T, 'MinConsecutiveDist', 0.375*L, 'Seed', 0);
%
% generate_multidot_free_trials.m(1試行に複数点を同時提示する版)は、実データ
% (DecodeSC_sub-analysys, SC_M064, 2026-09-10)での検証で、RFの位置推定は
% グリッド版Fine Mappingと良く一致する一方、RFの形(大きさ・楕円性)は
% Ridge回帰の正則化ノイズに埋もれてグリッド版ほど正確に求まらないことが
% 判明した(1試行に複数点を同時提示するため、応答から各点の寄与を回帰で
% 逆算する必要があり、この試行数では基底の数に対して過小決定になりやすい
% ため)。本関数はその対策として、1試行に1点だけを提示する(重ね合わせの
% 逆算が不要になるので、単純な逆相関/直接測定に近い精度が期待できる)
% 連続配置版のスケジュールを作る。
%
% 単純な一様ランダム配置(VisStimON.m のFine Mapping Freeケース、
% UseMultiDot=falseのときの既定動作)は、点数が有限である以上、必然的に
% 疎密のムラ(ポアソン過程特有のクランプ)が生じる
% (DecodeSC_sub-analysysリポジトリのscripts/multidot/fig_placement_uniformity_compare.png
% で定量比較済み: 500点なら9x9ビンで最小1〜最大12点のムラが出る)。
% 本関数は代わりに次の2段階の設計を使う:
%
%   1. 層別(ストラティファイド)+セル内ジッター:
%      サブエリアをn_cell x n_cell (n_cell=floor(sqrt(T)))のセルに分け、
%      まず全セルに1点ずつ(ジッター付きでセル内のランダムな位置に)配置する
%      "1巡目"(n_cell^2点)を作り、残り(T-n_cell^2点、必ずn_cell^2未満)を
%      "2巡目"としてランダムに選んだ別々のセルに追加で1点ずつ配置する。
%      1巡目を試行順で必ず先に(2巡目より前に)提示することで、実際の
%      試行数が計画より少なく打ち切られても(何らかの理由で予定の
%      試行数に届かなくても)、1巡目さえ完走していれば「一度も刺激が
%      出ないセル」が原理的に発生しない
%      (fig_staged_design_truncation.png で検証済み: 単純シャッフル版は
%      563点中547点で打ち切ると12/529セルが空になったが、段階版は0)。
%
%   2. 提示順を「直前の試行から一定距離以上離す」貪欲法で決める:
%      隣接試行が近い位置ばかりにならないよう、1巡目・2巡目それぞれの
%      中で、直前の点からMinConsecutiveDist以上離れた点をランダムに
%      選ぶ貪欲法で順序を決める(候補が尽きた場合のみ、その時点で
%      一番遠い点を選んで妥協する)。1巡目が2巡目より先、という順序は
%      変えない。
%      (fig_trial_order_min_distance.png / _sweep.png で検証済み:
%      MinConsecutiveDist=0.375*L程度なら、単純ランダム順で16%だった
%      「目標距離未満の連続提示」が1%程度まで下がり、妥協(緩和)も
%      ほぼ発生しない)
%
% 入力
%   L   サブエリアの一辺の長さ(pixelで呼ぶ場合はDeg2Pixで変換したものを渡す。
%       generate_multidot_free_trials.mと同じ単位規約)
%   T   生成する総試行数
%
% オプション
%   'MinConsecutiveDist'  連続する2試行間の目標最小距離(Lと同じ単位)
%                         (default 0.375*L。degでいうと40deg四方のサブエリア
%                         なら15deg相当。0.375という比率は、緩和(候補切れ)が
%                         ほぼ起きず、かつ実質的な制約になる値として
%                         fig_trial_order_min_distance_sweep.pngで確認した範囲)
%   'Seed'                乱数シード (default 0、再現性のため)
%
% 出力
%   trials      {T x 1} cell配列。trials{t}は[1 x 2]、サブエリア左下(0,0)を
%               原点とする試行tの点座標(generate_multidot_free_trials.mと
%               同じ座標規約。k=1のみだが、Set_StimPos側での既存の[k x 2]
%               の扱いとインターフェースを揃えるためcell配列のままにする)
%   order_info  診断用struct: n_cell, n_round1, n_round2, n_relaxed
%               (貪欲法で候補が尽きて妥協した回数)

p = inputParser;
addParameter(p, 'MinConsecutiveDist', 0.375*L);
addParameter(p, 'Seed', 0);
parse(p, varargin{:});
min_dist = p.Results.MinConsecutiveDist;
seed = p.Results.Seed;

rng(seed);

n_cell = floor(sqrt(T));
n_cell_sq = n_cell^2;
n_extra = T - n_cell_sq;   % 0 <= n_extra < 2*n_cell+1 (floorの定義より)

edges = linspace(0, L, n_cell+1);

% --- 1巡目: 全セルに1点ずつ(ジッター) ---
round1 = zeros(n_cell_sq, 2);
ci = 0;
for iy = 1:n_cell
    for ix = 1:n_cell
        ci = ci + 1;
        x_lo = edges(ix);   x_hi = edges(ix+1);
        y_lo = edges(iy);   y_hi = edges(iy+1);
        round1(ci, :) = [x_lo + rand()*(x_hi-x_lo), y_lo + rand()*(y_hi-y_lo)];
    end
end

% --- 2巡目: 残りをランダムな(重複しない)セルに追加で1点ずつ ---
if n_extra > 0
    extra_cells = randperm(n_cell_sq, n_extra);
    round2 = zeros(n_extra, 2);
    for k = 1:n_extra
        ci = extra_cells(k);
        iy = ceil(ci / n_cell);
        ix = ci - (iy-1)*n_cell;
        x_lo = edges(ix);   x_hi = edges(ix+1);
        y_lo = edges(iy);   y_hi = edges(iy+1);
        round2(k, :) = [x_lo + rand()*(x_hi-x_lo), y_lo + rand()*(y_hi-y_lo)];
    end
else
    round2 = zeros(0, 2);
end

% --- それぞれの巡の中で、距離制約つきの提示順を貪欲法で決める ---
[order1, nrelax1] = order_min_distance(round1, min_dist);
[order2, nrelax2] = order_min_distance(round2, min_dist);

pts_ordered = [round1(order1, :); round2(order2, :)];

trials = cell(T, 1);
for t = 1:T
    trials{t} = pts_ordered(t, :);
end

order_info = struct('n_cell', n_cell, 'n_round1', n_cell_sq, 'n_round2', n_extra, ...
    'n_relaxed', nrelax1 + nrelax2);

d = sqrt(sum(diff(pts_ordered, 1, 1).^2, 2));
fprintf('generate_singledot_free_trials: L=%.1f, T=%d (round1=%d, round2=%d)\n', L, T, n_cell_sq, n_extra);
fprintf('  min_consecutive_dist target=%.1f, achieved median=%.1f, min=%.1f, %%<target=%.1f%%, relaxed=%d/%d\n', ...
    min_dist, median(d), min(d), 100*mean(d < min_dist), nrelax1+nrelax2, T-1);

end


function [order, n_relaxed] = order_min_distance(pts, min_dist)
% 直前の点からmin_dist以上離れた点を、残りの候補からランダムに選ぶ貪欲法。
% 候補が無ければ(全ての残り点がmin_dist未満)、その時点で一番遠い点を選ぶ。
n = size(pts, 1);
order = zeros(n, 1);
n_relaxed = 0;
if n == 0
    return;
end
remaining = 1:n;
start = remaining(randi(numel(remaining)));
order(1) = start;
remaining(remaining == start) = [];
for k = 2:n
    last = pts(order(k-1), :);
    rem_pts = pts(remaining, :);
    d = sqrt(sum((rem_pts - last).^2, 2));
    valid = find(d >= min_dist);
    if ~isempty(valid)
        pick = valid(randi(numel(valid)));
    else
        [~, pick] = max(d);
        n_relaxed = n_relaxed + 1;
    end
    order(k) = remaining(pick);
    remaining(pick) = [];
end
end
