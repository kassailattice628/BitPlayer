function trials = generate_multidot_free_trials(L, margin, T, varargin)
% GENERATE_MULTIDOT_FREE_TRIALS Fine Mapping Free用、複数点同時提示の連続配置スケジュール生成
%
%   trials = generate_multidot_free_trials(L, margin, T, ...
%                                           'Pad', 0.5*margin, 'MaxK', 20, ...
%                                           'MaxAttempts', 300, 'Seed', 0);
%
% generate_multidot_mapping_trials.m(グリッド版、'Fine Mapping'用)の連続
% 配置版。サブエリア(0,0)-(L,L)の正方形内に、安全マージンmarginを満たす
% 複数点をランダムに配置する。グリッドを使わないため、離散版で必須だった
% TargetCapによる反復数の均一化は不要(連続一様サンプリングは試行数が
% 十分あれば自然に均等になる)。
%
% 代わりに、サブエリア境界そのものに起因する「端・隅が過剰に選ばれる」
% 境界効果(点過程統計でいうedge effect)を補正するため、サブエリアの
% 外側にPad分の仮想領域を確保して計算し、実際に提示するのはサブエリア
% 内に落ちた点だけを使う。DecodeSC_sub-analysys リポジトリの
% scripts/multidot/check_multidot_continuous.py で検証済み: Pad=0だと
% 密度比[隅/中心]が3-4倍前後になるが、Pad=0.5*marginまで広げると1.6-2.0倍
% 程度まで改善し、それ以上Padを増やしても頭打ちになる(サブエリアがmargin
% に対して十分広ければ、この比率のPadでよい。サブエリアがmarginと同程度
% まで狭い場合はどれだけPadを増やしても補正しきれないので、そもそも
% margin対比で十分広いサブエリアで使うこと)。
%
% 入力
%   L        サブエリアの一辺の長さ(margin/gridXYと同じ単位。pixelで
%            呼ぶ場合はDeg2Pixで変換したものを渡す)
%   margin   安全マージン(Lと同じ単位)
%   T        生成する総試行数
%
% オプション
%   'Pad'         境界補正用の外側パディング幅 (default: 0.5*margin)
%   'MaxK'        1試行で置く点数の上限、拡張領域全体で数える(サブエリア
%                 内外問わず)。この上限に達するか、MaxAttempts回試しても
%                 置く場所が見つからなければ打ち切る (default 20)
%   'MaxAttempts' 1点あたりの棄却サンプリング試行回数の上限 (default 300)
%   'Seed'        乱数シード (default 0、再現性のため)
%
% 出力
%   trials   {T x 1} cell配列。trials{t}は[k x 2]、サブエリア左下(0,0)を
%            原点とする試行tのk個の点座標(サブエリア内のみ、Lと同じ単位)

p = inputParser;
addParameter(p, 'Pad', 0.5*margin);
addParameter(p, 'MaxK', 20);
addParameter(p, 'MaxAttempts', 300);
addParameter(p, 'Seed', 0);
parse(p, varargin{:});
pad = p.Results.Pad;
maxK = p.Results.MaxK;
maxAttempts = p.Results.MaxAttempts;
seed = p.Results.Seed;

rng(seed);
Lext = L + 2*pad;

trials = cell(T, 1);
for t = 1:T
    selected = zeros(0, 2);
    for kk = 1:maxK
        placed = false;
        for a = 1:maxAttempts
            cand = rand(1,2)*Lext - pad;
            if isempty(selected) || all(sqrt(sum((selected - cand).^2, 2)) >= margin)
                selected(end+1, :) = cand; %#ok<AGROW>
                placed = true;
                break;
            end
        end
        if ~placed
            break;
        end
    end
    inside = selected(:,1) >= 0 & selected(:,1) <= L & selected(:,2) >= 0 & selected(:,2) <= L;
    trials{t} = selected(inside, :);
end

ks = cellfun(@(x) size(x,1), trials);
fprintf('generate_multidot_free_trials: L=%.1f, margin=%.1f, pad=%.1f, T=%d trials\n', L, margin, pad, T);
fprintf('  simultaneous points k: min=%d median=%.1f max=%d mean=%.2f\n', min(ks), median(ks), max(ks), mean(ks));

end
