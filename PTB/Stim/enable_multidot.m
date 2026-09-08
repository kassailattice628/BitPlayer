function enable_multidot(app, varargin)
% ENABLE_MULTIDOT Fine Mapping / Fine Mapping Freeで複数点同時提示(MultiDot)を有効化する
%
%   enable_multidot(app)
%   enable_multidot(app, 'Margin', 22)
%   enable_multidot(app, 'Margin', 22, 'TargetCap', 25, 'NTrials', 470)
%   enable_multidot(app, 'Margin', 22, 'Pad', 11, 'MaxK', 20)
%
% 名前-値ペアで指定した項目だけをsobjに反映する(省略した項目は既存値の
% ままなので、変えたいものだけ書けばよい)。対応するsobjフィールド:
%   'Margin'    -> sobj.MultiDotMargin_deg  安全マージン[deg] (default 17)
%   'TargetCap' -> sobj.MultiDotTargetCap   1位置あたりの目標反復数上限 (default 30)
%                  ('Fine Mapping'のグリッド版でのみ使用)
%   'Pad'       -> sobj.MultiDotPad_deg     境界補正用パディング[deg]
%                  (default 0.5*Margin。'Fine Mapping Free'の連続配置版
%                  でのみ使用。サブエリア境界付近で点が過剰に選ばれる
%                  現象を補正する。詳細はSet_StimPos_MultiDot_Free.m
%                  のヘッダコメント、およびDecodeSC_sub-analysys
%                  リポジトリのscripts/multidot/check_multidot_continuous.py
%                  参照)
%   'MaxK'      -> sobj.MultiDotMaxK        1試行あたりの点数上限 (default 20。
%                  'Fine Mapping Free'の連続配置版でのみ使用)
%   'NTrials'   -> sobj.NTrialsFineMap      このFine Mapping(Free)ブロックの総試行数 (default 470)
%
% GUIで'Fine Mapping'または'Fine Mapping Free'を選択し、Distance/Divide等
% を設定した後、PTB STARTを押す前にコマンドウィンドウから呼ぶ。GUIには
% 意図的にチェックボックス等を追加していないため、この関数はsobjの該当
% フィールドを立てるだけの薄いヘルパー(詳細はSet_StimPos_MultiDot.m/
% Set_StimPos_MultiDot_Free.mのヘッダコメント参照)。コマンドウィンドウで
% 直接フィールド名を打つより打ち間違いが減る。

p = inputParser;
addParameter(p, 'Margin', []);
addParameter(p, 'TargetCap', []);
addParameter(p, 'Pad', []);
addParameter(p, 'MaxK', []);
addParameter(p, 'NTrials', []);
parse(p, varargin{:});
opt = p.Results;

app.sobj.UseMultiDot = true;

if ~isempty(opt.Margin),    app.sobj.MultiDotMargin_deg = opt.Margin;    end
if ~isempty(opt.TargetCap), app.sobj.MultiDotTargetCap  = opt.TargetCap; end
if ~isempty(opt.Pad),       app.sobj.MultiDotPad_deg    = opt.Pad;       end
if ~isempty(opt.MaxK),      app.sobj.MultiDotMaxK       = opt.MaxK;      end
if ~isempty(opt.NTrials),   app.sobj.NTrialsFineMap     = opt.NTrials;   end

end
