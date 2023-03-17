function [ON, OFF] = Get_stim_timing_2p(app)
%
% Show stimi timing in the 2P GUI
%

p = app.ParamsSave;

% Check stim ON trial
test = 1;
n_end = size(p, 2);
while test
    % check
    if ~isfield(p{n_end}.stim1, 'correct_StimON_timing')
        n_end = n_end -1;
    else
        test = 0;
    end
end

%stim on trials
n_stim = app.sobj.Blankloop_times + 1: n_end;

area_X = zeros(4, length(n_stim));
area_Y = repmat([-10; 30; 30; -10], 1, length(n_stim));

for ii = 1:length(n_stim)
    i = n_stim(ii);
    %if isfield(p{i}.stim1, 'correct_StimON_timing')
    if ~isempty(p{i}.stim1.correct_StimON_timing) &&...
            p{i}.stim1.correct_StimON_timing ~= 0
        ON = p{i}.stim1.correct_StimON_timing;
        OFF = p{i}.stim1.correct_StimOFF_timing;

        area_X(:, ii) = [ON; ON; OFF; OFF];
    end
end

%save to sobj
app.sobj.stim_area_X = area_X;
app.sobj.stim_area_Y = area_Y;

end