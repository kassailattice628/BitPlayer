function T = analyzeFile(file, visited, rootFolder)
    % デフォルトは空テーブル
    T = table(strings(0,1), strings(0,1), strings(0,1), ...
              'VariableNames', {'Caller','Callee','Toolbox'});

    if isKey(visited, file)
        return;
    end
    visited(file) = true;

    try
        code = fileread(file);
    catch
        return;
    end

    % コメント・文字列削除
    code = regexprep(code, '%.*', '');
    code = regexprep(code, '''[^'']*''', '');
    code = regexprep(code, '"[^"]*"', '');

    % 関数呼び出し候補を抽出（@funcは除外）
    matches = regexp(code, '(?<!@)\<([a-zA-Z]\w*)\s*\(', 'tokens');
    funcs = unique(string([matches{:}]));

    % 制御構文を除外
    exclude = ["if","for","parfor","while","switch","case","otherwise", ...
               "try","catch","classdef","methods","properties","end","function"];
    funcs = setdiff(funcs, exclude);

    for i = 1:numel(funcs)
        callee = funcs(i);
        w = which(callee);

        % 自作関数の補完
        if isempty(w)
            possibleFile = fullfile(rootFolder, callee + ".m");
            if isfile(possibleFile)
                w = possibleFile;
            end
        end

        toolboxName = getToolboxNameFromPath(w);

        % 1行分をテーブルに追加
        newRow = {string(file), callee, toolboxName};
        T = [T; cell2table(newRow, 'VariableNames', {'Caller','Callee','Toolbox'})];

        % 自作関数なら再帰的に解析
        if ~isempty(w) && exist(w,'file')==2 && endsWith(w,'.m') ...
                && startsWith(w, rootFolder)
            subT = analyzeFile(w, visited, rootFolder);
            T = [T; subT];
        end
    end
end
