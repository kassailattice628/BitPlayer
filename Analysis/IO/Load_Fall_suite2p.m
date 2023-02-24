function [F_neuron, Mask_rois, centroid] =...
    Load_Fall_suite2p(imagesize, d, f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input
%1, app.imgobj
%2, dirname
%3, fname

% structures of suite2p Fall.mat
% F: ROI fluorescence
% Fneu: Neuropil fluorescence
% iscell: ROI is cell or not (1/0)
% stat: other inof. like ROI position

%output
%1, calculated dFF
%2, image Masks of neurons' roi
%3, centroid of nurons' roi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load mat file
load([d, f], 'F', 'Fneu', 'iscell', 'stat');

% Check file
% errordolg('Select suite2p mat file!)
%

rois = find(iscell(:,1)==1);

%% 
F_neuron = F(rois', :) - 0.7*Fneu(rois',:); %Neuropil factor = 0.7
F_neuron = F_neuron';

%% Extract ROI shape and position (and roi center)
Mask_rois = zeros(imagesize * imagesize, length(rois));
centroid = zeros(length(rois), 2);
for i = 1:length(rois)
    n = rois(i);
    a = zeros(imagesize, imagesize);
    y = stat{n}.ypix + 1;
    x = stat{n}.xpix + 1;
    for m = 1:length(y)
        a(y(m), x(m)) = 1;
    end
    %figure, imshow(a)
    Mask_rois(:,i) = reshape(a,[imagesize^2, 1]);  
    %
    centroid(i,:) = fliplr(stat{n}.med);
end
%%
Mask_rois = logical(Mask_rois);
centroid = centroid';

end