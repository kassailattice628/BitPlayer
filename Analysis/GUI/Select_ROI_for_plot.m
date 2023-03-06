function Select_ROI_for_plot(app)
%
%
%

selectROIs = str2num(app.SelectROIs.Value); %#ok<*ST2NM>
deselectROIs = str2num(app.DeselectROIs.Value);
if ~isempty(selectROIs) && ~isempty(deselectROIs)
    selectROIs = setdiff(selectROIs, deselectROIs);
end
app.imgobj.selected_ROIs = selectROIs;
