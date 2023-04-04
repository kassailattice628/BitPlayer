function Merge_experiments(im, p, daq, ptb)
%
% Merge daq & ptb files
% daq: file path to daq file for adding data
% ptb: file path to ptb file for adding data
%
im = imgobj;
p = ParamsSave;

daq = '/home/lattice/Share/s2p_working/20230322daq/1399/daq_2_kas.mat';
add = load(daq);
if isfield(add, 'imgobj')
    im2 = add.imgobj;
end
if isfield(add, 'ParamsSave')
    p2 = add.ParamsSave;
else
    add2 = load(ptb);
    p2 = add2.ParamsSave;
end

clear add add2


% Find the last trial
t1_end = im.FVt(end);
p_ = cell(1,1);

for i = 1:length(p)
    if isfield(p{i}.stim1, 'correct_StimON_timing')
        t2 = p{i}.stim1.correct_StimON_timing;
        
        if isempty(t2) || t2 < t1_end
            p_{i} = p{i};
        else
            break
        end
    else
        break
    end
end

t2_end = im2.FVt(end);
p2_ = cell(1,1);
for i = 1:length(p2)
    if isfield(p2{i}.stim1, 'correct_StimON_timing')
        t_on = p2{i}.stim1.correct_StimON_timing;
        t_off = p2{i}.stim1.correct_StimOFF_timing;
        if isempty(t_on)
%             if ~isemptyp(p_saccades)
%                 p2{i}.t_saccades = p2{i}.t_saccades + t
%                 p2{i}.p_saccades = 
%             end
            p2_{i} = p2{i};

        elseif t_on < t2_end
            p2{i}.stim1.correct_StimON_timing =...
                t_on + t1_end + im.FVsampt;
            p2{i}.stim1.correct_StimOFF_timing =...
                t_off + t1_end + im.FVsampt;
            p2_{i} = p2{i};
        else
            break
        end
    else
        break
    end
end


p = cell(1,length(p_) + length(p2_));
for i = 1:(length(p_) + length(p2_))
    p{i} = 










end