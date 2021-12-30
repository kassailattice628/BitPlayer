function loop_ptb_test(app)
%setup serial
a = serialport('/dev/ttyUSB0', 115200);

%reset RTSer
setRTS(a, true);
n = 1;
%getpinstatus(a).ClearToSend
while app.OpenPTBButton.Value
    %disp(getpinstatus(a).ClearToSend);
    state = getpinstatus(a).ClearToSend;
    if state == 1
        app.SignalfromBP1Lamp.Color = [1,1,0];
        disp(['on', num2str(n)])
    elseif state == 0
        app.SignalfromBP1Lamp.Color = [0,0,0];
        disp('off')
    end
    n = n+1;
    if n == 1000
        app.StartPTBButton.Value = 0;
        disp('end')
    end
    pause(0.001)
end

app.SignalfromBP1Lamp.Color = [0,0,0];
app.StartPTBButton.Value = 0;
app.StartPTBButton.Text = 'Start PTB';
app.StartPTBButton.BackgroundColor = [0.96, 0.96, 0.96];
disp('loopfin')

    function trigon(a)
        setRTS(a, false)
    end

    function trigoff(a)
        setRTS(a, true)
    end

end