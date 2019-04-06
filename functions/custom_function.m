function [] = custom_function(hObject, handles)
%CUSTOM_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

disp('------------ Custom Functions ------------');

%% plotting options
line_width = 3;
axes_width = 1.25;
font_size = 18;
plot_font_size = 18;
marker_size = 10;
cc_ROIs = fun_HSVcolors(5, 1);


%% parameters
MaxL = str2double(get(handles.Edit_MaxL, 'String'));
MinL = str2double(get(handles.Edit_MinL, 'String'));



%% plot lifetime bar
hue_max = 0.7;
hue_min = 0;
           
m = 1000; % number of colormap bins
map_hue = linspace(hue_max,hue_min,m)'; % scale of hue
map_saturation = ones(m,1);
map_value = ones(m,1);
hsvmap = [map_hue map_saturation map_value];
rgbmap = hsv2rgb(hsvmap);


figure;
axis off
colormap(rgbmap)
c = colorbar;
c.Label.String = 'Lifetime (ns)';
c.FontSize = font_size/3*2;
caxis(gca, [MinL*1e9 MaxL*1e9]);

end

