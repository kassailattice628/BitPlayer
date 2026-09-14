function enable_singledot_free(app, varargin)
% ENABLE_SINGLEDOT_FREE Fine Mapping Freeで1試行1点(k=1)の層別+距離制約つき配置を有効化する
%
%   enable_singledot_free()
%   enable_singledot_free('MinConsecDeg', 15)
%   enable_singledot_free('NTrials', 550)
%   enable_singledot_free(app, ...)   % appを明示的に渡すことも可能
%
% appを省略した場合、実行中のBitPlayer_ptbアプリを自動検出する
% (get_running_app.m参照)。enable_multidot.mのk=1版。UseMultiDotとは
% 排他(両方trueにはしない。VisStimON.mはUseMultiDotを先にチェックする
% ので、両方trueだとUseMultiDot側が優先されてしまう点に注意)。
%
% 名前-値ペアで指定した項目だけをsobjに反映する。対応するsobjフィールド:
%   'MinConsecDeg' -> sobj.SingleDotMinConsecDeg  連続する2試行間の目標最小距離[deg]
%                     (default 0.375*sobj.Distance)
%   'NTrials'      -> sobj.NTrialsFineMap         このFine Mapping Freeブロックの総試行数
%                     (default 500。実際の撮影枚数・フレームレートから
%                     見込まれる試行数に合わせること。詳細は
%                     generate_singledot_free_trials.mのヘッダコメント参照)

if nargin == 0 || ischar(app) || isstring(app)
    if nargin > 0
        varargin = [{app}, varargin];
    end
    app = get_running_app('BitPlayer_ptb');
end

p = inputParser;
addParameter(p, 'MinConsecDeg', []);
addParameter(p, 'NTrials', []);
parse(p, varargin{:});
opt = p.Results;

app.sobj.UseSingleDotFree = true;
app.sobj.UseMultiDot = false;

if ~isempty(opt.MinConsecDeg), app.sobj.SingleDotMinConsecDeg = opt.MinConsecDeg; end
if ~isempty(opt.NTrials),      app.sobj.NTrialsFineMap        = opt.NTrials;      end

end
