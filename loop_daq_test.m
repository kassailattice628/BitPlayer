function loop_daq_test(app)

%start triggre
for i = 1:5
    disp(['loop#: ', num2str(i)])
    outputSingleScan(app.dio.VSon, 0)
    pause(3)
    %trigger state off
    outputSingleScan(app.dio.VSon,1)
    pause(1)
end

loop_end_daq_test(app);
end
