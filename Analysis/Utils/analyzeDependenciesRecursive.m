function T = analyzeDependenciesRecursive(entryFile)
    visited = containers.Map;
    results = analyzeFile(entryFile, visited);
    if isempty(results)
        T = table(); % 空なら空table
    else
        T = struct2table(results);
    end
end

function results = analyzeFile(file, visited)
    % 構造体配列として初期化
    results = struct('Caller', {}, 'Callee', {}, 'Toolbox', {});
    
    if isKey(visited, file)
        return;
    end
    visited(file) = true;

    try
        code = fileread(file);
    catch
        return;
    end

    % 正規表現で関数呼び出し候補を抽出
    matches = regexp(code, '\<([a-zA-Z]\w*)\s*\(', 'tokens');
    funcs = unique(lower(string([matches{:}])));

    % 除外リスト（制御構文や予約語）
    exclude = ["if","for","parfor","while","switch","case","otherwise",...
               "try","catch","classdef","methods","properties","end","function"];
    funcs = setdiff(funcs, exclude);

    % 呼び出し関数を判定
    for i = 1:numel(funcs)
        callee = funcs(i);
        w = which(callee);
        toolboxName = getToolboxNameFromPath(w);
        results(end+1) = struct( ... %#ok<AGROW>
            'Caller', file, ...
            'Callee', callee, ...
            'Toolbox', toolboxName ...
        );

        % 自作関数なら再帰的に解析
        if ~isempty(w) && exist(w,'file')==2 && endsWith(w,'.m') ...
                && ~(contains(w, matlabroot))  % MATLAB本体を除外
            subRes = analyzeFile(w, visited);
            results = [results subRes]; %#ok<AGROW>
        end
    end
end

function toolboxName = getToolboxNameFromPath(pathStr)
    if isempty(pathStr)
        toolboxName = 'Unknown';
    elseif contains(pathStr, 'toolbox')
        tokens = regexp(pathStr, 'toolbox/([^/]+)/', 'tokens');
        if ~isempty(tokens)
            toolboxName = tokens{1}{1};
        else
            toolboxName = 'MATLAB Core';
        end
    elseif contains(pathStr, matlabroot)
        toolboxName = 'MATLAB Core';
    else
        toolboxName = 'User-defined';
    end
end
