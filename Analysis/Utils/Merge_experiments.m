function Merge_experiments(im, p, daq, ptb)
%
% Merge daq & ptb files
% daq: file path to daq file for adding data
% ptb: file path to ptb file for adding data
%

im2 = load(daq, 'imgobj');
p2 = load(ptb, 'ParamsSave');

% Find the last trial
t1 = im.FVt(end);
p_ = cell(1,1);

for i = 1:length(p)
    if isfield(p{i}.stim1, 'correct_StimON_timing')
        t2 = p{i}.stim1.correct_StimON_timing;
        
        if isempty(t2) || t2 < t1
            p_{i} = p{i};
        else
            break
        end
    else
        break
    end
end






end