fname = ["", ""];
fname(1) = "/home/lattice/Share/s2p_working/20230425daq/1399/daq_5_.mat";
fname(2) = "/home/lattice/Share/s2p_working/20230425daq/1399/daq_6_.mat";


fname(1) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_1_.mat";
fname(2) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_2_.mat";


fname(1) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_4_.mat";
fname(2) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_6_.mat";


fname(1) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_3_.mat";
fname(2) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_4_.mat";


fname(1) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_5_.mat";
fname(2) = "/home/lattice/Share/s2p_working/20230529daq/1399/daq_6_.mat";
%%

for i = 1:2
    load(fname(i), "imgobj")
    if i == 1
        A = zeros(4, imgobj.Num_ROIs, 2);
        %A(1,:):DSI
        %A(2,:):Pref direction
        %A(3,:):OSI
        %A(4,:):Pref orientation
    end
    A(1,:,i) = imgobj.L_DS(1,:);
    A(2,:,i) = imgobj.Ang_DS(1,:);
    A(3,:,i) = imgobj.L_OS(1,:);
    A(4,:,i) = imgobj.Ang_OS(1,:);
end
%%

figure;
tiledlayout(1,2)
nexttile()

roi = A(1,:,1) > 0.2; %DS
scatter(A(2, roi, 1), A(2, roi, 2));
hold on
scatter(A(2, ~roi, 1), A(2, ~roi, 2));
line([0, 2*pi], [0, 2*pi], 'Color','k','LineStyle','--')
xlim([0, 2*pi])
ylim([0, 2*pi])
title("Direction")
xlabel('Free')
ylabel('Rand12')
hold off

nexttile()
roi = A(3,:,1) > 0.15; %OS
scatter(A(4, roi, 1), A(4, roi, 2));
hold on
scatter(A(4, ~roi, 1), A(4, ~roi, 2));
line([-pi/2, pi/2], [-pi/2, pi/2], 'Color','k','LineStyle','--')
xlim([-pi/2, pi/2])
ylim([-pi/2, pi/2])
title("Orientation")
xlabel('Free')
ylabel('Rand12')
hold off