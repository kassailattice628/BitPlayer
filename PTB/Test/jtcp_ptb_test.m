function jtcp_ptb_test
addpath("/home/lattice/Documents/MATLAB/Toolbox/jtcp")
clear jTcpObj;
clearvars
i = 1;
disp('Waiting Access from client...')
jTcpObj = jtcp('accept', 3000, 'timeout', 30000);
disp(['Connected: ' jTcpObj.remoteHost])
mssg = [];
while true
    disp('---------------');
    disp(['trial: ' num2str(i) ', waiting stimID ...'])
    while isempty(mssg)
        mssg = jtcp('read',jTcpObj);
    end
    jTcpObj.outputStream.flush;
    ids{i} = mssg;
    if strcmp(mssg, 'quit')
        disp('Received "quit" closing socket...')
        jtcp('close',jTcpObj);
        break;
    end
    jtcp('write',jTcpObj,['Stim Server Received: "' mssg '"']);

    % stimuli
    disp(['"' mssg '" Start']);
    pause(2)
    disp(['"' mssg '" Finished']);

    i = i+1; mssg = [];
end
disp('')
disp('Session Finished')

end
