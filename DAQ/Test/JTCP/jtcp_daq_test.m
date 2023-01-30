function jtcp_daq_test
addpath("C:\Users\lattice\Documents\MATLAB\jtcp");
clear all
jTcpObj = jtcp('request','10.238.1.225', 3000, 'timeout', 2000);
mssg = [];
for i = 1:10
    disp('-------------------')
    disp(['Send: ' num2str(i)])
    jtcp('write', jTcpObj, num2str(i));

    pause(1)
    while isempty(mssg)
        mssg = jtcp('read',jTcpObj);
    end
    disp(mssg)
    mssg = [];
end
jtcp('write', jTcpObj, 'quit');
jtcp('close',jTcpObj);

end