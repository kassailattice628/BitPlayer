function ChangeGUI_StartPTB(gui, state)
% Change Button by Trigger State

switch state
    case 'wait'
        gui.Text = 'Wait Trig';
        %gui.FontColor = [0,0,0];
        %gui.BackgroundColor = [1,1,0];
        
    case 'start'
        gui.Text = 'Looping';
        %gui.FontColor = [1,1,1];
        %gui.BackgroundColor = [0,0,1];
        
    case 'finish'
        gui.Text = 'PTB Start';
        %gui.FontColor = [0,0,0];
        %gui.BackgroundColor = [0.96, 0.96, 0.96];
end


end

