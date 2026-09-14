function disable_singledot_free(app)
% DISABLE_SINGLEDOT_FREE 1試行1点(k=1)の層別配置を無効化し、通常の単一点ランダム方式に戻す
%
%   disable_singledot_free()
%   disable_singledot_free(app)   % appを明示的に渡すことも可能
%
% enable_singledot_free.mと対になる関数。appを省略した場合は実行中の
% アプリを自動検出する(get_running_app.m参照)。

if nargin == 0
    app = get_running_app('BitPlayer_ptb');
end

app.sobj.UseSingleDotFree = false;

end
