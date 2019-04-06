function [] = fun_intensityHist(hObject, handles)
%CUSTOM_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles, 'IntHist')
    if isvalid(handles.IntHist)  
        close(handles.IntHist.Parent.Parent);
    end
end

if isfield(handles, 'imageI')
    line_width = 2;
    % Set colormap for the plotting
    cc_ROIs = fun_HSVcolors(5, 1);

    nbins = 250;

    image_stack = handles.imageI;
    image_data = image_stack(:);

    if get(handles.Check_AutoI, 'Value')
        Imin = min(image_data);
        Imax = max(image_data);
    else
        Imin = str2double(get(handles.Edit_Imin, 'String'));
        Imax = str2double(get(handles.Edit_Imax, 'String'));
    end

    figure;
    h = histogram(image_data, nbins);
    h.EdgeColor = 'none';
    h.FaceColor = 'black';
    h.FaceAlpha = 0.6;
    title('Intensity Image (2D or 3D) Histogram')
    xlabel('Intensity (a.u.)')
    ylabel('Count')
    ylims = [min(h.Values) max(h.Values)];
    hold on
    lineImin = line([Imin, Imin], ylims, 'LineWidth', line_width, 'Color', cc_ROIs(1,:));
    lineImax = line([Imax, Imax], ylims, 'LineWidth', line_width, 'Color', cc_ROIs(5,:));
    handles.IntHist = h; 
    handles.lineImin = lineImin; 
    handles.lineImax = lineImax; 
    guidata(hObject,handles) 
end

end

