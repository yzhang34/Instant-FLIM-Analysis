function [] = fun_colorbarHSV2RGB(handles)
%FUN_COLORBARHSV2RGB Summary of this function goes here
%   Detailed explanation goes here

hue_max = 0.7;
hue_min = 0;
            


% customized hsv colormap
m = 1000; % number of colormap bins
map_hue = linspace(hue_max,hue_min,m)'; % scale of hue
map_saturation = ones(m,1);
map_value = ones(m,1);
hsvmap = [map_hue map_saturation map_value];
rgbmap = hsv2rgb(hsvmap);

colorbar_matrix = linspace(100, 0, 1000)';
colorbar_matrix = repmat(colorbar_matrix, 1, m/10);

axes(handles.Axes_LBar);
imagesc(colorbar_matrix, 'Parent', handles.Axes_LBar);
set(handles.Axes_LBar,'XTick',[],'YTick',[]); 
colormap(handles.Axes_LBar, rgbmap);
ylabel(handles.Axes_LBar, 'Lifetime (s)');

end

