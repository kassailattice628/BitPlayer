function jTcpObj = jTCPserverON

disp('jtcp SERVER ON')
jTcpObj = jtcp('accept', 3000, 'timeout', 30000);

end