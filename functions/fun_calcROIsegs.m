function [] = fun_calcROIsegs(handles, mode, filename, filepath)
%FUN_CALCROISEGS Summary of this function goes here
%   Detailed explanation goes here


I_stack = handles.imageI;
G_stack = handles.imageG;
S_stack = handles.imageS;

[~, ~, n_z] = size(I_stack);


if get(handles.Check_AutoI, 'Value')
    Imin = min(I_stack(:));
    Imax = max(I_stack(:));
else
    Imin = str2double(get(handles.Edit_Imin, 'String'));
    Imax = str2double(get(handles.Edit_Imax, 'String'));
end

% convert to gray scale
I_stack = mat2gray(I_stack,[Imin Imax]);
disp_stack = zeros(size(I_stack,1), size(I_stack,2), 3, n_z);    
for i_z = 1:n_z  
    % empty pixels being white pixels
    disp_stack(:,:,:,i_z) = ones(size(I_stack,1), size(I_stack,2), 3);
end


temp_stack = disp_stack;



hue_max = 0.7;
hue_min = 0;
ROI_hue = linspace(hue_max, hue_min, 5)'; % scale of hue


if isfield(handles, 'ROI1') && get(handles.Check_ROI1, 'Value')
    ROI1_r = handles.ROI1_r;
    ROI1_c = handles.ROI1_c;
    select = (((G_stack-ROI1_c(1)).^2+(S_stack-ROI1_c(2)).^2)<=ROI1_r^2); 
    for i_z = 1:n_z  
        map_value = I_stack(:, :, i_z);
        map_saturation = ones(size(map_value));
        map_hue = ones(size(map_value));
        disp_stack(:,:,:,i_z) = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(5)*map_hue, map_saturation, map_value)), select(:,:,i_z))...
            + bsxfun(@times, disp_stack(:,:,:,i_z), ~select(:,:,i_z));
    end
    switch mode
        case 'show'
            figure;
            imshow(disp_stack(:,:,:,round(n_z/2)));    
        case 'export'
            cluster_filename = [filename(1:end-4), '_ROI1.tif'];
            fun_exportColorTIF(disp_stack, [filepath cluster_filename]);
    end
    disp_stack = temp_stack;
end

if isfield(handles, 'ROI2') && get(handles.Check_ROI2, 'Value')
    ROI2_r = handles.ROI2_r;
    ROI2_c = handles.ROI2_c;
    select = (((G_stack-ROI2_c(1)).^2+(S_stack-ROI2_c(2)).^2)<=ROI2_r^2);    
    for i_z = 1:n_z  
        map_value = I_stack(:, :, i_z);
        map_saturation = ones(size(map_value));
        map_hue = ones(size(map_value));
        disp_stack(:,:,:,i_z) = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(4)*map_hue, map_saturation, map_value)), select(:,:,i_z))...
            + bsxfun(@times, disp_stack(:,:,:,i_z), ~select(:,:,i_z));
    end
    switch mode
        case 'show'
            figure;
            imshow(disp_stack(:,:,:,round(n_z/2)));    
        case 'export'
            cluster_filename = [filename(1:end-4), '_ROI2.tif'];
            fun_exportColorTIF(disp_stack, [filepath cluster_filename]);
    end
    disp_stack = temp_stack;
end

if isfield(handles, 'ROI3') && get(handles.Check_ROI3, 'Value')
    ROI3_r = handles.ROI3_r;
    ROI3_c = handles.ROI3_c;
    select = (((G_stack-ROI3_c(1)).^2+(S_stack-ROI3_c(2)).^2)<=ROI3_r^2);    
    for i_z = 1:n_z  
        map_value = I_stack(:, :, i_z);
        map_saturation = ones(size(map_value));
        map_hue = ones(size(map_value));
        disp_stack(:,:,:,i_z) = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(3)*map_hue, map_saturation, map_value)), select(:,:,i_z))...
            + bsxfun(@times, disp_stack(:,:,:,i_z), ~select(:,:,i_z));
    end
    switch mode
        case 'show'
            figure;
            imshow(disp_stack(:,:,:,round(n_z/2)));     
        case 'export'
            cluster_filename = [filename(1:end-4), '_ROI3.tif'];
            fun_exportColorTIF(disp_stack, [filepath cluster_filename]);
    end
    disp_stack = temp_stack;
end

if isfield(handles, 'ROI4') && get(handles.Check_ROI4, 'Value')
    ROI4_r = handles.ROI4_r;
    ROI4_c = handles.ROI4_c;
    select = (((G_stack-ROI4_c(1)).^2+(S_stack-ROI4_c(2)).^2)<=ROI4_r^2);    
    for i_z = 1:n_z  
        map_value = I_stack(:, :, i_z);
        map_saturation = ones(size(map_value));
        map_hue = ones(size(map_value));
        disp_stack(:,:,:,i_z) = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(2)*map_hue, map_saturation, map_value)), select(:,:,i_z))...
            + bsxfun(@times, disp_stack(:,:,:,i_z), ~select(:,:,i_z));
    end
    switch mode
        case 'show'
            figure;
            imshow(disp_stack(:,:,:,round(n_z/2)));    
        case 'export'
            cluster_filename = [filename(1:end-4), '_ROI4.tif'];
            fun_exportColorTIF(disp_stack, [filepath cluster_filename]);
    end
    disp_stack = temp_stack;
end

if isfield(handles, 'ROI5') && get(handles.Check_ROI5, 'Value')
    ROI5_r = handles.ROI5_r;
    ROI5_c = handles.ROI5_c;
    select = (((G_stack-ROI5_c(1)).^2+(S_stack-ROI5_c(2)).^2)<=ROI5_r^2);    
    for i_z = 1:n_z  
        map_value = I_stack(:, :, i_z);
        map_saturation = ones(size(map_value));
        map_hue = ones(size(map_value));
        disp_stack(:,:,:,i_z) = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(1)*map_hue, map_saturation, map_value)), select(:,:,i_z))...
            + bsxfun(@times, disp_stack(:,:,:,i_z), ~select(:,:,i_z));
    end
    switch mode
        case 'show'
            figure;
            imshow(disp_stack(:,:,:,round(n_z/2)));    
        case 'export'
            cluster_filename = [filename(1:end-4), '_ROI5.tif'];
            fun_exportColorTIF(disp_stack, [filepath cluster_filename]);
    end
end





end

