function disable_multidot(app)
% DISABLE_MULTIDOT 複数点同時提示(MultiDot)を無効化し、通常の単一点方式に戻す
%
%   disable_multidot()
%   disable_multidot(app)   % appを明示的に渡すことも可能
%
% enable_multidot.mと対になる関数。appを省略した場合は実行中のアプリを
% 自動検出する(get_running_app.m参照)。

if nargin == 0
    app = get_running_app('BitPlayer_ptb');
end

app.sobj.UseMultiDot = false;

end
