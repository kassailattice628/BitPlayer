function enable_multidot(app)
% ENABLE_MULTIDOT Fine Mappingで複数点同時提示(MultiDot)を有効化する
%
%   enable_multidot(app)
%
% GUIで'Fine Mapping'を選択し、Distance/Divide等を設定した後、
% PTB STARTを押す前にコマンドウィンドウから呼ぶ。GUIには意図的に
% チェックボックス等を追加していないため、この関数はapp.sobj.UseMultiDot
% を直接立てるだけの薄いヘルパー(詳細はSet_StimPos_MultiDot.mのヘッダ
% コメント、およびDecodeSC_sub-analysys リポジトリのdocs/THESIS_PLAN.md参照)。

app.sobj.UseMultiDot = true;

end
