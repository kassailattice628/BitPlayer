function Test_loop_PTB(app)
%Test code for main loop

sobj = app.sobj;

%setup serial
a = serialport('/dev/ttyUSB0', 115200);

%RTS: need this code?
setRTS(a, true);
n_in_loop = 1;

while app.StartPTBButton.Value
    disp('Wating Trigger')
    
    %When TTL level [Low/High], sate is [1/0].
    %TTL signal from DAQ
    state = getpinstatus(a).ClearToSend;
    
    if state == 1
        %GUI
        app.TTLSignalfromBP_daqLamp.Color = [1,1,0];
        app.StartPTBButton.Text = 'Triggered';
        disp('Triggered!')
        disp(['Trial: ', num2str(n_in_loop)]);
        
        %Visual Stimulus ON
        Test_PTB_on(sobj);
        
        app.StartPTBButton.Value = 0;
        disp('Loop Finished');
        
    elseif state == 0
        %app.TTLSignalfromBP_daqLamp.Color = [0,0,0];
        disp('Wating...')
    end
%     n = n+1;
%     if n == 1000
%         app.StartPTBButton.Value = 0;
%         disp('end')
%     end

    pause(0.01)
end

app.TTLSignalfromBP_daqLamp.Color = [0,0,0];
app.StartPTBButton.Text = 'Start PTB';
app.StartPTBButton.BackgroundColor = [0.96, 0.96, 0.96];


%     function trigon(a)
%         setRTS(a, false)
%     end
% 
%     function trigoff(a)
%         setRTS(a, true)
%     end

end
