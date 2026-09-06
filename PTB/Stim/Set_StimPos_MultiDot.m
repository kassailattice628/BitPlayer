function sobj = Set_StimPos_MultiDot(sobj)
% SET_STIMPOS_MULTIDOT 複数点同時提示(ランダム化)用の位置選択
%
% Prepare_stim_spot (VisStimON.m内の入れ子関数) から、sobj.UseMultiDot が
% true のときに Set_StimPos_Spot の代わりに呼ばれる。既存の単一点方式
% (Set_StimPos_Spot.m、app.PositionOrderDropDown経由)には一切手を入れず、
% GUIのドロップダウンにも新しい項目を追加していない
% (sobj.UseMultiDot をスクリプト側でセットするだけで有効化する設計)。
%
% 初回(そのFine Mappingブロックの試行1)だけ、安全マージンを満たす
% ランダムな組み合わせのスケジュールを generate_multidot_mapping_trials
% で計算してpersistentにキャッシュし、以降の試行では試行番号でスケジュール
% を引くだけにする(既存のSet_StimPos_Spot.m内Get_RandomCenterPositionの
% persistent list_orderと同じ流儀)。
%
% 必要なsobjフィールド(未指定ならデフォルト値を使う。詳細・根拠は
% DecodeSC_sub-analysys リポジトリの docs/THESIS_PLAN.md 参照):
%   .CenterPos_list      [N x 2] 全候補位置(pixel)。VisStimONの
%                        'Fine Mapping'ケースで既に作られている
%   .MultiDotMargin_deg  安全マージン[deg] (default 17 = SC想定、
%                        4*RFのsigma(4度)+点サイズ(1度))
%   .MultiDotTargetCap   1位置あたりの目標反復数の上限 (default 30)
%   .NTrialsFineMap      このFine Mappingブロックの総試行数 (default 470)
%   .MonitorDist, .Pixelpitch  既存フィールド、deg->pixel変換に使用

persistent schedule_cache scheduleKey

if ~isfield(sobj, 'MultiDotMargin_deg'), sobj.MultiDotMargin_deg = 17; end
if ~isfield(sobj, 'MultiDotTargetCap'),  sobj.MultiDotTargetCap = 30;  end
if ~isfield(sobj, 'NTrialsFineMap'),     sobj.NTrialsFineMap = 470;    end

i = sobj.n_in_loop - sobj.Blankloop_times;

% CenterPos_list・パラメータが変わったら再計算されるよう簡単なキーで判定
thisKey = [size(sobj.CenterPos_list, 1), sobj.MultiDotMargin_deg, ...
    sobj.MultiDotTargetCap, sobj.NTrialsFineMap];

if isempty(schedule_cache) || i == 1 || ~isequal(thisKey, scheduleKey)
    M_pix = Deg2Pix(sobj.MultiDotMargin_deg, sobj.MonitorDist, sobj.Pixelpitch);
    schedule_cache = generate_multidot_mapping_trials(...
        sobj.CenterPos_list, M_pix, sobj.NTrialsFineMap, ...
        'TargetCap', sobj.MultiDotTargetCap);
    scheduleKey = thisKey;
end

idx = mod(i - 1, numel(schedule_cache)) + 1;
sobj.index_center_in_mat = schedule_cache{idx};                        % [1 x k]
sobj.StimCenterPos = sobj.CenterPos_list(sobj.index_center_in_mat, :);  % [k x 2]

end
