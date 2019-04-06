function [xyt_stack, img_size1, img_size2, num_images] = fun_importCSVstack(filenames, pathname)

    % returns an array with xy in first two dimensions, stack in thrid
    % dimension, and multi [color] channels (if present) in fourth dimension
    
if iscell(filenames)
    num_images = length(filenames);
    first_image = flipud(csvread([pathname, char(filenames(1))]));
    [img_size1, img_size2] = size(first_image);
    xyt_stack=zeros(img_size1, img_size2, num_images);

    for k = 1:num_images
        data_name = char(filenames(k));
        xyt_stack(:,:,k) = flipud(csvread([pathname,data_name]));
    end
else
    num_images = 1;
    xyt_stack = flipud(csvread([pathname,filenames]));
    [img_size1, img_size2] = size(xyt_stack);
end