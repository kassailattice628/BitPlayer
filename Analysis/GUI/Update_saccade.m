function [locs, pks] = Update_saccade(app, opt, varargin)
% varargin
% [locs, pks] = Update_saccade()
%
% detect saccade event
% opt == 0, just reaad
% opt == 1, update sac_time from GUI
% opt == 2, re-calcurate sac_time from velocity data
%

%% Prep
sf = app.recobj.sampf;

%%
switch length(varargin)
    case 0
        n = app.n;
        data = app.DataSave(:,1:2,n);
        p = app.ParamsSave{1,n};
        
        recTime = get_recTime(app, n);
        [~, ~, vel] = get_eye_velocity(sf, data);
        
        th_low = app.Vel_threshold_low.Value;
        th_high = app.Vel_threshold_high.Value;
        th = [th_low, th_high];
        
    case 5
        n = app.n;
        p = varargin{1};       %ParamsSave{1,n}
        vel = varargin{2};     %velocity for #n trial
        recTime = varargin{3}; %recTime for #n trial
        th_low = varargin{4};
        th_high = varargin{5};
        th = [th_low, th_high];
        data = app.DataSave(:,1:2,n);
        
    otherwise
        errordlg('Input should be (app, opt, {p{1,n}, velocity, recTime, threshold_low, threshold_high})')
end

%%
if opt == 0
    if isfield(p, 'sac_t')
        sac_t = p.sac_t;
        locs = zeros(1, length(sac_t));
        pks = locs;
        
        for i = 1:length(sac_t)
            locs(i) = find(sac_t(i) > recTime, 1, 'last') + 1;
            pks(i) = vel(locs(i));
        end
    else
        [locs, pks] = get_detect_saccade(vel, sf, th);
    end
    
elseif opt == 1
    %Edit sac_t from GUI
    sac_t = str2num(app.spks.Value); %#ok<ST2NM>
    app.ParamsSave{1,n}.sac_t = sac_t;
    
    locs = zeros(1, length(sac_t));
    pks = locs;
    for i = 1:length(sac_t)
        locs(i) = find(sac_t(i) > recTime, 1, 'last') + 1;
        pks(i) = vel(locs(i));
    end
    
    Add_plot_saccade(app, recTime, data, locs, pks)
    
elseif opt == 2
    %Re calculation
    [locs, pks] = get_detect_saccade(vel, sf, th);
    
    
    %eye horizontal
    Set_plot(app.UIAxes_Eye_Horizontal, recTime, data(:,1));
    %eye vertical
    Set_plot(app.UIAxes_Eye_Vertical, recTime, data(:,2));
    %eye velocity
    Set_plot(app.UIAxes_Eye_Velo, recTime(1:end-1), vel);
    app.UIAxes_Eye_Velo.YLim = [0,2];
    
    Add_plot_saccade(app, recTime, data, locs, pks)

     
end

end


%%%%%%%%%%
%%
function [locs, pks] = get_detect_saccade(v, Fs, th)

th_high = th(2);
th_low = th(1);

p_dist_sec = 0.3; %peak distance in sec.

[pks,locs_in_sec] = findpeaks(v, Fs,...
    'MinPeakHeight', th_low,...
    'MinPeakDistance', p_dist_sec,...
    'MinPeakWidth', 0.07,...
    'MaxPeakWidth', 0.3);

locs = uint16(locs_in_sec * Fs);

%remove toomuch high values
MaxPeakHeight = th_high;
locs = locs(pks < MaxPeakHeight);
pks = pks(pks < MaxPeakHeight);

end