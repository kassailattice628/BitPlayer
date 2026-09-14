function sobj = Set_StimPos_SingleDot_Free(sobj)
% SET_STIMPOS_SINGLEDOT_FREE Fine Mapping Freeで1試行1点(k=1)の連続配置を有効化する
%
% VisStimON.m内の'Fine Mapping Free'ケースから、sobj.UseSingleDotFree が
% trueのときに、既定の単純一様ランダム配置の代わりに呼ばれる。
% Set_StimPos_MultiDot_Free.m(1試行に複数点を同時提示する版)とは別に、
% 1試行1点(k=1)専用に、層別配置+距離制約つき提示順を使う
% (詳細・根拠はgenerate_singledot_free_trials.mのヘッダコメント参照)。
%
% 初回(そのブロックの試行1)だけ、スケジュールを generate_singledot_free_trials
% でまとめて計算してpersistentにキャッシュし、以降の試行では試行番号で
% スケジュールを引くだけにする(Set_StimPos_MultiDot_Free.mと同じ流儀)。
%
% 必要なsobjフィールド(未指定ならデフォルト値を使う):
%   .Distance                    サブエリアの一辺の長さ[deg]
%   .SingleDotMinConsecDeg       連続する2試行間の目標最小距離[deg]
%                                (default 0.375*Distance)
%   .NTrialsFineMap              このFine Mapping Freeブロックの総試行数 (default 500)
%   .MonitorDist, .Pixelpitch    既存フィールド、deg->pixel変換に使用

persistent schedule_cache scheduleKey

if ~isfield(sobj, 'SingleDotMinConsecDeg'), sobj.SingleDotMinConsecDeg = 0.375*sobj.Distance; end
if ~isfield(sobj, 'NTrialsFineMap'),        sobj.NTrialsFineMap = 500; end

i = sobj.n_in_loop - sobj.Blankloop_times;

L_pix = Deg2Pix(sobj.Distance, sobj.MonitorDist, sobj.Pixelpitch);

% Distance・パラメータが変わったら再計算されるよう簡単なキーで判定
thisKey = [sobj.Distance, sobj.SingleDotMinConsecDeg, sobj.NTrialsFineMap];

if isempty(schedule_cache) || i == 1 || ~isequal(thisKey, scheduleKey)
    MinDist_pix = Deg2Pix(sobj.SingleDotMinConsecDeg, sobj.MonitorDist, sobj.Pixelpitch);
    schedule_cache = generate_singledot_free_trials(L_pix, sobj.NTrialsFineMap, ...
        'MinConsecutiveDist', MinDist_pix);
    scheduleKey = thisKey;
end

idx = mod(i - 1, numel(schedule_cache)) + 1;
xy = schedule_cache{idx};   % [1 x 2], サブエリア(0,0)-(L,L)基準、左下原点

% Define center of the subarea (fix pos in DivNum^2 matrix)
Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
C = Pos_list(sobj.FixPos, :);

% 丸ごと再代入(部分代入だと、直前にMultiDotでk>1だった場合余分な行が
% 残ってしまうため)。保存(Get_ParamsSave.m)も表示(ShowStimInfo.m)も
% この絶対ピクセル値をそのまま使う(deg換算は解析側で行う)。
sobj.StimCenterPos = C + round(xy - L_pix/2);   % [1 x 2]

end
