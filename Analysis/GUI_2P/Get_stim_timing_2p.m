function [ON, OFF] = Get_stim_timing_2p(app)
%
% Show stimi timing in the 2P GUI
%

p = app.ParamsSave;
n_stim = app.sobj.Blankloop + 1: size(p,2);

area_X = zeros(4, length(n_stim));
area_Y = repmat([-1; 10; 10; -1], 1, length(n_stim));

for i = n_stim
     %if isfield(p{i}.stim1, 'correct_StimON_timing')
     if ~isempty(p{i}.stim1.correct_StimON_timing)
        ON = p{i}.stim1.correct_StimON_timing;
        OFF = p{i}.stim1.correct_StimOFF_timing;
        
        area_X(:, i) = [ON; ON; OFF; OFF];
     end
end

%save to sobj
app.sobj.stim_area_X = area_X;
app.sobj.stim_area_Y = area_Y;

end