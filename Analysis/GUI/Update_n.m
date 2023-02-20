function N = Update_n(app, set_n, select_plot)
%
% Update Trial or ROI numbe for plot traces.
%

%% 
switch select_plot
    case 'Trial'
        max_n = size(app.SaveData, 3);
        n_gui = app.Trial_n;
        n = app.n_in_loop;
        
    case 'ROI'
        max_n = app.imgobj.maxROIs;
        n_gui = app.nROI;
        n = app.n_in_roi;
end

%%
switch set_n
    case '+' %Forward n
        if n < max_n
            N = n + 1;
        else
            %End Trial/ROI
            N = max_n;
            disp(['No more ', select_plot])
        end
        
    case '-' %Backword n
        if n > 1
            N = app.n - 1;
        else
            N = 1;
            disp(['This is the first ', select_plot])
        end
        
    case 0 %Current n
        N = n;
        
    otherwise
        % Manually set from GUI
        if n < 0 || n > max_n
            disp(['Out of range! Reset ', select_plot, '.'])
            N = 1;
            n_gui.Value = 1;
            
        else
            N = set_n;
            disp([select_plot, ' #: ', num2str(N)])
        end
end

%% Update GUI
n_gui.Value = double(N);

switch select_plot
    case 'Trial'
        app.n_in_loop = n;
        
    case 'ROI'
        app.n_in_roi = n;
end

end