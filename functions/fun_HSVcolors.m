function [cc] = fun_HSVcolors(num_cc, value)
%FUN_HSVCOLORS Summary of this function goes here
%   Detailed explanation goes here

hue_max = 0.7;
hue_min = 0;

map_hue = linspace(hue_max,hue_min,num_cc)'; % scale of hue
map_saturation = ones(num_cc,1);
map_value = value * ones(num_cc,1);
hsvmap = [map_hue map_saturation map_value];
cc = hsv2rgb(hsvmap);


end

