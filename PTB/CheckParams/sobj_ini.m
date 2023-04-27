function sobj = sobj_ini
%
% Initializing parameters of visual stimulus (Psychtoolbox3)
% 20230113
%

%%%%% X-Display setting %%%%%%
%XOrgConfCreator(Display0 (HDMI), Disoplay1 (DP)
%XOrgConfSelector -> Logout -> Login
%
% Refresh Rate setting
%oldsetting = Screen('ConfigureDisplays', 'Scanout', 1, 0, 1920, 1080, 144)
%Screen('ConfigureDisplay', 'Scanout', 1, 0, [], [], 144)
%oldSettings = Screen('ConfigureDisplay', setting, screenNumber, outputId [, newwidth][, newheight][, newHz][, newX][, newY]);
%
% Confirmation
%Screen('NominalFrameRate', 1, 1) %--- 143.854
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get monitor info
%sobj.MP = get(0, 'MonitorPosition'); %position matrix for malti monitors
AssertOpenGL;
sobj.Screens = Screen('Screens');
%For Ubuntu, main display:=0, sub:= 1
sobj.scr = Screen('ConfigureDisplay', 'Scanout', 1, 0);
disp(['Frame Rate of Stim Monitor: ', num2str(sobj.scr.hz), 'hz.']);

if sobj.scr.hz < 100
    %Screen('ConfigureDisplasy', 'Scaanout') failed to change setting
    %Screen('ConfigureDisplays', 'Scanout', 1, 1, 1920, 1080, 144, [], [])
    
    %Screen('Resolution') works!
    oldsetting=Screen('Resolution', 1, 1920, 1080, 144);
    sobj.scr = Screen('ConfigureDisplay', 'Scanout', 1, 0);
    %disp(['Frame Rate of Stim Monitor was updated to: ', num2str(sobj.scr.hz), 'hz.'])
    
    disp(['Frame rate of stim monitor is set as **', num2str(sobj.scr.hz), ' hz** from ',...
       num2str(oldsetting.hz), ' hz.'])
end

% # of connected displays
sobj.Num_screens = size(sobj.Screens, 2);

sobj.FrameRate = Screen('NominalFrameRate', 1, 1);
if sobj.scr.displayWidthMM == 0
    %When the monitor is tunred off, Width/HightMM are not recognized.
    % 0.2714 or MSI Optix 242G
    sobj.Pixelpitch = 0.2714;
else
    sobj.Pixelpitch = sobj.scr.displayWidthMM / sobj.scr.width;
end

sobj.MonitorDist = 200; %Changed by GUI

%% Initialize parameters of visual stimuli

sobj.Pattern = 'Uni';%Default single spot
sobj.PositionMode = 'Random Matrix';%Default position random
sobj.Shape_list = [{'FillRect'};{'FillOval'}];
sobj.Shape = 'FillOval'; %Default shape

%Luminance & Color
sobj.black = BlackIndex(1);
sobj.white = WhiteIndex(1);
sobj.gray = round((sobj.white + sobj.black)/2);

sobj.stimlumi = sobj.white;
sobj.bgcol = sobj.black;
if sobj.gray == sobj.stimlumi
    sobj.gray = sobj.white/2;
end
sobj.stimRGB = [1,1,1];
sobj.stimColor = sobj.stimlumi * sobj.stimRGB;

%%%%%%
%Duration, 1sec == 144 flip, for MSI Optix 242G =: 144Hz
sobj.Duration_sec = 1;
sobj.FlipNum = round(sobj.Duration_sec * sobj.FrameRate);

sobj.Delay_sec = 0.2;
sobj.Delay_FlipNum = round(sobj.Delay_sec * sobj.FrameRate);

sobj.ISI_sec = 2;

sobj.Blankloop_times = 2;

%%%%%%
sobj.StimSize_pix = round(ones(1,2) * Deg2Pix(1, sobj.MonitorDist, sobj.Pixelpitch)); %Defafult 1 deg
sobj.StimSize_deg = 1;
sobj.Bar_width = sobj.StimSize_deg;
sobj.Bar_width_pix = sobj.StimSize_pix(1);

%Size Random
sobj.StimSize_deg_list = [0.5; 1; 3; 5; 10; 20; 30]; %for Size_radom stim
sobj.StimSize_pix_list = round(Deg2Pix(sobj.StimSize_deg_list, sobj.MonitorDist, sobj.Pixelpitch));

%Position
sobj.DivNum = 9; %Default 9x9 matirx
sobj.FixPos = 41; %Center for 9x9 matrix


%%
%Moving bar & spot direction
sobj.MoveDirection = 0; %rightward
sobj.MoveDirection_i = 1;
%Moving speed
sobj.MoveSpd = 10; %deg/sec

sobj.Bar_height = 65; %deg
sobj.Bar_heigth_pix = ...
    round(Deg2Pix(sobj.Bar_height, sobj.MonitorDist, sobj.Pixelpitch));

%Grating contras (cannot change from GUI)
sobj.GratingContrast = 100;
%Grating speed
sobj.TemporalFreq = 2; %2Hz
sobj.TemporalFreq_i = 3;
%Grating spatial frequency
sobj.SpatialFreq = 0.08; %cpd (cycle per degree)
sobj.SpatialFreq_i = 4;

%Bar angle
sobj.BarOrientation = 0;

%Looming
%sobj.LoomingSpd_list = [5; 10; 20; 40; 80; 160];
sobj.LoomingSpd = 5; %deg/sec
sobj.LoomingMaxSize = 40; %deg

%Concentric or Fine Mapping, 
sobj.Div_grid = 5; %deg step
sobj.Distance = 15; %deg

%Images
sobj.Img_i = 0; %# image;
sobj.ImageNum = 256;
sobj.list_img = 1:sobj.ImageNum;

%Mosaic
sobj.DotDensity = 0.3; % 30%

%RandomDotMotion -> Set_Coherence

%Concentric
sobj.DotNum = 300;
sobj.ConcentricDirection = 0;
sobj.ConcentricDirection_i = 1;

%% 2 points
% sobj.stimsz2 = sobj.stimsz; %1 deg
% sobj.shape2 = 'FillOval';
% sobj.stimlumi2 = sobj.white;
% sobj.stimcol2 = sobj.stimcol;
% sobj.flipNum2 = sobj.flipNum;
% sobj.delayPTBflip2 = sobj.delayPTBflip;
% sobj.dealyPTB2 = 0;

end