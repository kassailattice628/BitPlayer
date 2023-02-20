function Open_daq_mat(app)
%
% Original is select Select_Open_Mat.
% Modified to use in BitPlayer.
% 2023/02/10
% Select [DAQ].mat file and extract each data.

%% Clean up preloaded variables;

% app.SaveData= [];
% app.SaveTimestamps
% app.imgobj = [];
% app.sobj = [];
% app.recobj = [];
% app.ParamsSave = [];

SaveData = [];
app.n_in_loop = 1;

%% Load New Data
if isempty(app.mainvar)
    % If this is the first time to select daq data.
    % There is no information about location of the ,mat files.
    [f, d] = uigetfile({'~/Share/s2p_working/*.mat'});
    
    if f == 0 
        % When file is not selected.
        errordlg('File is not selected.')
    else
        load([d,f]); %#ok<*LOAD
        while isempty(SaveData)
            errordlg('DataSave is missing! Select other file.')
            % Select another file
            [f, d] = uigetfile({[d, '*.mat']});
            load([d, f]);
        end
        
        %% Assign vars of savedata directory
        mainvar.dirname = d;
        
        %% Check file name
        if length(regexp(f, '_')) > 1
            i = regexp(f, '_');
            mainvar.fname = [f(1:i(end)-1), '.mat'];
            disp(f)
        else
            mainvar.fname = f;
        end
        
        app.FileName.Text = ['File Name: ', f];
        app.SaveFileName.Value = f;
        
        %% Check imgobj <- for imaging data
        if ~exist('imgobj', 'var')
            %First time to select mat file.
            imgobj.nROI = 0;
            imgobj.selectROI = 1;
            imgobj.maxROIs =  0;
            imgobj.dFF =[];
            
            %Photo sensor V -> mV
            SaveData(:,3,:) =  SaveData(:,3,:)* 1000;
            
%         elseif ~isfield(imgobj, 'dFF')  %#ok<NODEF>
%             imgobj.dFF = [];
        end
        
        %% Check frame rate
        if isfield(imgobj, 'FVsampt')
            %Put in GUI.
            app.FVsampt.Value = imgobj.FVsampt;
        end
        
        %         app.filenameLabel.Text = f;
        %         app.StimPatternLabel.Text = sobj.pattern;
        
        %% Return
        app.imgobj = imgobj;
        app.mainvar = mainvar;
%         app.ParamsSave = ParamsSave;
        app.SaveData = SaveData;
        app.recobj = recobj;
%         app.sobj = sobj;
        
        disp(mainvar)
        
    end
end


end
