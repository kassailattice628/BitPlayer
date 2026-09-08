function app = get_running_app(className)
% GET_RUNNING_APP 実行中のApp Designerアプリのインスタンスを取得する
%
%   app = get_running_app('BitPlayer_ptb')
%
% `app = BitPlayer_ptb;`のようにコマンドウィンドウから明示的に起動した
% 場合はそのインスタンスへの参照がワークスペースに残るが、実行ボタンや
% ダブルクリックで起動した場合は残らない。本関数は開いている全figureを
% 探索し、対象アプリのUIFigureが持つRunningAppInstanceプロパティ
% (App Designerアプリに対してMATLABが自動的にセットする。R2020b以降で
% サポート)から実行中のアプリインスタンスを取得する。起動方法に関わらず
% 使えるので、enable_multidot.m等から呼ぶ想定。

figs = findall(groot, 'Type', 'figure');
app = [];
for k = 1:numel(figs)
    f = figs(k);
    if isprop(f, 'RunningAppInstance') && ~isempty(f.RunningAppInstance) ...
            && isa(f.RunningAppInstance, className)
        app = f.RunningAppInstance;
        return;
    end
end

error('get_running_app:NotFound', ...
    '実行中の%sアプリが見つかりませんでした。アプリを起動してから呼んでください。', className);

end
