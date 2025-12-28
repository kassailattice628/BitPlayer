function latency = Pupil_dialation_latency(t, x)
%
% t: time ベクトル
% x: Pupil Area data

% ====== 設定 ======
stimOn  = 5.0;   % 刺激開始 (s)
stimOff = 7.0;   % 刺激終了 (s)

baselineWin = [3.0 5.0];   % baseline（刺激前2秒）
frac = 0.2;                % peak の 20%

smoothWinSec = 0.05;       % 平滑化（秒）0 にすると無し
% ==================

% ベクトルを縦に
t = t(:);
x = x(:);

% ---- 平滑化（任意）----
if smoothWinSec > 0
    dt = median(diff(t));
    win = max(1, round(smoothWinSec/dt));
    x = movmean(x, win);
end

% ---- baseline ----
idxBase = (t >= baselineWin(1)) & (t < baselineWin(2));
mu0 = mean(x(idxBase));

% ---- peak（刺激中）----
idxStim = (t >= stimOn) & (t <= stimOff);
peak = max(x(idxStim));

% ---- しきい値（baseline + 20% peak）----
th = mu0 + frac * (peak - mu0);

% ---- latency ----
idxSearch = (t >= stimOn);
iLat = find(idxSearch & (x >= th), 1, 'first');

if isempty(iLat)
    latency = NaN;
    t_cross = NaN;
else
    t_cross = t(iLat);
    latency = t_cross - stimOn;
end

% ---- 結果表示 ----
fprintf('Latency = %.3f s\n', latency);
end