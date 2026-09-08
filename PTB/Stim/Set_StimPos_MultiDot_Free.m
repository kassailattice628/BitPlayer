function sobj = Set_StimPos_MultiDot_Free(sobj)
% SET_STIMPOS_MULTIDOT_FREE Fine Mapping Freeで複数点同時提示(連続配置)を有効化する
%
% VisStimON.m内の'Fine Mapping Free'ケースから、sobj.UseMultiDot が
% trueのときに通常の単一点ランダム配置の代わりに呼ばれる。
% Set_StimPos_MultiDot.m(グリッド版、'Fine Mapping'用)の連続配置版。
%
% 初回(そのブロックの試行1)だけ、安全マージンを満たすランダムな連続
% 配置のスケジュールを generate_multidot_free_trials でまとめて計算して
% persistentにキャッシュし、以降の試行では試行番号でスケジュールを引く
% だけにする(Set_StimPos_MultiDot.mと同じ流儀)。
%
% 必要なsobjフィールド(未指定ならデフォルト値を使う。詳細・根拠は
% DecodeSC_sub-analysys リポジトリの docs/THESIS_PLAN.md、および
% scripts/multidot/check_multidot_continuous.py 参照):
%   .Distance            サブエリアの一辺の長さ[deg]
%   .MultiDotMargin_deg  安全マージン[deg] (default 17 = SC想定、
%                        4*RFのsigma(4度)+点サイズ(1度))
%   .MultiDotPad_deg     境界補正用パディング[deg] (default 0.5*Margin)
%   .MultiDotMaxK        1試行あたりの点数上限 (default 20)
%   .NTrialsFineMap      このFine Mapping Freeブロックの総試行数 (default 470)
%   .MonitorDist, .Pixelpitch  既存フィールド、deg->pixel変換に使用

persistent schedule_cache scheduleKey

if ~isfield(sobj, 'MultiDotMargin_deg'), sobj.MultiDotMargin_deg = 17; end
if ~isfield(sobj, 'MultiDotPad_deg'),    sobj.MultiDotPad_deg = 0.5*sobj.MultiDotMargin_deg; end
if ~isfield(sobj, 'MultiDotMaxK'),       sobj.MultiDotMaxK = 20; end
if ~isfield(sobj, 'NTrialsFineMap'),     sobj.NTrialsFineMap = 500; end

i = sobj.n_in_loop - sobj.Blankloop_times;

L_pix = Deg2Pix(sobj.Distance, sobj.MonitorDist, sobj.Pixelpitch);

% Distance・パラメータが変わったら再計算されるよう簡単なキーで判定
thisKey = [sobj.Distance, sobj.MultiDotMargin_deg, sobj.MultiDotPad_deg, ...
    sobj.MultiDotMaxK, sobj.NTrialsFineMap];

if isempty(schedule_cache) || i == 1 || ~isequal(thisKey, scheduleKey)
    M_pix   = Deg2Pix(sobj.MultiDotMargin_deg, sobj.MonitorDist, sobj.Pixelpitch);
    Pad_pix = Deg2Pix(sobj.MultiDotPad_deg,    sobj.MonitorDist, sobj.Pixelpitch);
    schedule_cache = generate_multidot_free_trials(L_pix, M_pix, sobj.NTrialsFineMap, ...
        'Pad', Pad_pix, 'MaxK', sobj.MultiDotMaxK);
    scheduleKey = thisKey;
end

idx = mod(i - 1, numel(schedule_cache)) + 1;
xy_list = schedule_cache{idx};   % [k x 2], サブエリア(0,0)-(L,L)基準、左下原点

% Define center of the subarea (fix pos in DivNum^2 matrix) -- 既存の
% 単一点版'Fine Mapping Free'ケースと同じ手順でサブエリア中心Cを求める
Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
C = Pos_list(sobj.FixPos, :);

% 保存(Get_ParamsSave.m)も表示(ShowStimInfo.m)もこの絶対ピクセル値を
% そのまま使う(deg換算は解析側でPix2Deg.mと同じ式を使って行う。理由:
% 生のピクセル値さえ残っていれば、将来変換式に問題が見つかっても記録し
% 直さずに解析側だけ直せる)。
sobj.StimCenterPos = C + round(xy_list - L_pix/2);   % [k x 2]

end
