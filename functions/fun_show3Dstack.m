function [ ] = fun_show3Dstack(ax, slider, text_slice, image_stack, slice_idx)
%FUN_SHOW3DSTACK Summary of this function goes here
%   Detailed explanation goes here

slice_n = size(image_stack, 3);

set(slider, 'visible', 'on');
set(slider, 'Min', 1)
set(slider, 'Max', slice_n)

cmax = max(image_stack(:));
cmin = min(image_stack(:));

axes(ax);
imshow(squeeze(image_stack(:,:,slice_idx,:)),[cmin cmax]);
colormap(ax, gray);


set(text_slice, 'String', ['Slice #: ',num2str(slice_idx),'/',num2str(slice_n)]);

set(ax,'XTick',[],'YTick',[]); 

