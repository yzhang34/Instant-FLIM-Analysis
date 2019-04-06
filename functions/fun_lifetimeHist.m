function [] = fun_lifetimeHist(hObject, handles)
%CUSTOM_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles, 'LifetimeHist')
    if isvalid(handles.LifetimeHist)  
        close(handles.LifetimeHist.Parent.Parent);
    end
end

if isfield(handles, 'imageL')
    line_width = 2;
    % Set colormap for the plotting
    cc_ROIs = fun_HSVcolors(5, 1);

    nbins = 250;

    lifetime_stack = handles.imageL;
    lifetime_data = lifetime_stack(:);

    MaxL = str2double(get(handles.Edit_MaxL, 'String'));
    MinL = str2double(get(handles.Edit_MinL, 'String'));


    figure;
    h = histogram(lifetime_data, nbins);
    h.EdgeColor = 'none';
    h.FaceColor = 'black';
    h.FaceAlpha = 0.6;
    title('Lifetime Image (2D or 3D) Histogram')
    xlabel('Lifetime (s)')
    ylabel('Count')
    ylims = [min(h.Values)/10 max(h.Values)/10];
    hold on
    lineLmin = line([MinL, MinL], ylims, 'LineWidth', line_width, 'Color', cc_ROIs(1,:));
    lineLmax = line([MaxL, MaxL], ylims, 'LineWidth', line_width, 'Color', cc_ROIs(5,:));
    handles.LifetimeHist = h; 
    guidata(hObject,handles) 
end

end

