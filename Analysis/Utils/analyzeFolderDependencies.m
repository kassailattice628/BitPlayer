function T = analyzeFolderDependencies(folderPath)
    % フォルダ内の .m ファイルを再帰的に解析し
    % 使用している関数とToolboxを一覧化する
    %
    % 使い方:
    %   T = analyzeFolderDependencies('~/Research/BitPlayer/Analysis/StimSpecific/DSOS');

    if nargin < 1
        folderPath = pwd;
    end

    files = dir(fullfile(folderPath, '**', '*.m'));
    visited = containers.Map;
    T = table(cell(0,1),cell(0,1),cell(0,1), ...
              'VariableNames', {'Caller','Callee','Toolbox'});

    for k = 1:numel(files)
        file = fullfile(files(k).folder, files(k).name);
        subT = analyzeFile(file, visited, folderPath);
        T = [T; subT]; %#ok<AGROW>
    end

    [groupCounts, toolboxes] = groupcounts(T.Toolbox);
    toolboxSummary = table(toolboxes, groupCounts);
    disp(toolboxSummary)
end


function T = analyzeFile(file, visited, rootFolder)
    % 個別ファイルを解析
    T = table(cell(0,1),cell(0,1),cell(0,1), ...
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

    % ---- 前処理 ----
    code = regexprep(code, '%[^\n]*', '');          % コメント削除
    code = regexprep(code, '''[^'']*''', '');       % ''文字列''
    code = regexprep(code, '"[^"]*"', '');          % ""文字列""
    code = regexprep(code, '\.\.\.[^\n]*\n', '');   % 行継続 "..."

    % ---- 関数呼び出しを抽出 ----
    matches = regexp(code, '(?<!@)([a-zA-Z]\w*)\s*\(', 'tokens', 'dotall','ignorecase');
    funcs = unique(string([matches{:}]));

    % 制御構文を除外
    exclude = ["if","for","parfor","while","switch","case","otherwise", ...
               "try","catch","classdef","methods","properties","end","function"];
    funcs = setdiff(funcs, exclude);

    % ---- 解析ループ ----
    Caller  = {};
    Callee  = {};
    Toolbox = {};

    for i = 1:numel(funcs)
        callee = funcs(i);
        w = which(callee);

        % 自作関数補完
        if isempty(w)
            possibleFile = fullfile(rootFolder, callee + ".m");
            if isfile(possibleFile)
                w = possibleFile;
            end
        end

        toolboxName = getToolboxNameFromPath(w);

        Caller{end+1,1}  = file;
        Callee{end+1,1}  = char(callee);
        Toolbox{end+1,1} = toolboxName;

        % 自作関数なら再帰解析
        if ~isempty(w) && exist(w,'file')==2 && endsWith(w,'.m') ...
                && startsWith(w, rootFolder)
            subT = analyzeFile(w, visited, rootFolder);
            T = [T; subT]; %#ok<AGROW>
        end
    end

    % このファイルの結果をまとめる
    T = [T; table(Caller, Callee, Toolbox)];
end


function toolboxName = getToolboxNameFromPath(pathStr)
    if isempty(pathStr)
        toolboxName = 'Unknown';
        return;
    end

    if contains(pathStr, 'toolbox/shared/')
        % shared 以下のマッピング
        if contains(pathStr, 'statslib')
            toolboxName = 'stats';
        elseif contains(pathStr, '/signal')
            toolboxName = 'signal';
        elseif contains(pathStr, 'imageslib')
            toolboxName = 'image';
        elseif contains(pathStr, 'controllib')
            toolboxName = 'control';
        elseif contains(pathStr, '/coder')
            toolboxName = 'coder';
        else
            toolboxName = 'shared'; % 未知のものは shared のまま
        end

    elseif contains(pathStr, 'toolbox')
        tokens = regexp(pathStr, 'toolbox/([^/]+)/', 'tokens');
        if ~isempty(tokens)
            toolboxName = tokens{1}{1};
        else
            toolboxName = 'matlab';
        end

    elseif contains(pathStr, matlabroot)
        toolboxName = 'matlab';

    else
        toolboxName = 'User-defined';
    end
end
