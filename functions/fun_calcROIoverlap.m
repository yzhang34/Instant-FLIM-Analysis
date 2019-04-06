function [I_frame] = fun_calcROIoverlap(handles, slice_idx)
%FUN_CALCROIOVERLAP Summary of this function goes here
%   Detailed explanation goes here
    cc = fun_HSVcolors(5, 1);
    I_stack = handles.imageI;
    G_stack = handles.imageG;
    S_stack = handles.imageS;
    if get(handles.Check_AutoI, 'Value')
        Imin = min(I_stack(:));
        Imax = max(I_stack(:));
    else
        Imin = str2double(get(handles.Edit_Imin, 'String'));
        Imax = str2double(get(handles.Edit_Imax, 'String'));
    end
    I_frame = mat2gray(I_stack(:,:,slice_idx),[Imin Imax]);
    I_frame = repmat(I_frame,[1 1 3]);
    G_frame = G_stack(:,:,slice_idx);
    S_frame = S_stack(:,:,slice_idx);

    map_value = I_frame(:,:,1);
    map_saturation = ones(size(map_value));
    map_hue = ones(size(map_value));
    hue_max = 0.7;
    hue_min = 0;
    ROI_hue = linspace(hue_max, hue_min, 5)';

    if isfield(handles, 'ROI1') && get(handles.Check_ROI1, 'Value')
        ROI1_r = handles.ROI1_r;
        ROI1_c = handles.ROI1_c;
        select = (((G_frame-ROI1_c(1)).^2+(S_frame-ROI1_c(2)).^2)<=ROI1_r^2);
        nonsel_frame = bsxfun(@times, I_frame, ~select);
        if ~get(handles.Check_isOHSV, 'Value')
            sel_frame = bsxfun(@times, reshape(cc(5,:), [1,1,3]), select);
        else
            sel_frame = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(5)*map_hue, map_saturation, map_value)), select);
        end
        I_frame = nonsel_frame + sel_frame;
    end
    if isfield(handles, 'ROI2') && get(handles.Check_ROI2, 'Value')
        ROI2_r = handles.ROI2_r;
        ROI2_c = handles.ROI2_c;
        select = (((G_frame-ROI2_c(1)).^2+(S_frame-ROI2_c(2)).^2)<=ROI2_r^2);
        nonsel_frame = bsxfun(@times, I_frame, ~select);
        if ~get(handles.Check_isOHSV, 'Value')
            sel_frame = bsxfun(@times, reshape(cc(4,:), [1,1,3]), select);
        else
            sel_frame = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(4)*map_hue, map_saturation, map_value)), select);
        end
        I_frame = nonsel_frame + sel_frame;
    end
    if isfield(handles, 'ROI3') && get(handles.Check_ROI3, 'Value')
        ROI3_r = handles.ROI3_r;
        ROI3_c = handles.ROI3_c;
        select = (((G_frame-ROI3_c(1)).^2+(S_frame-ROI3_c(2)).^2)<=ROI3_r^2);
        nonsel_frame = bsxfun(@times, I_frame, ~select);
        if ~get(handles.Check_isOHSV, 'Value')
            sel_frame = bsxfun(@times, reshape(cc(3,:), [1,1,3]), select);
        else
            sel_frame = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(3)*map_hue, map_saturation, map_value)), select);
        end
        I_frame = nonsel_frame + sel_frame;
    end
    if isfield(handles, 'ROI4') && get(handles.Check_ROI4, 'Value')
        ROI4_r = handles.ROI4_r;
        ROI4_c = handles.ROI4_c;
        select = (((G_frame-ROI4_c(1)).^2+(S_frame-ROI4_c(2)).^2)<=ROI4_r^2);
        nonsel_frame = bsxfun(@times, I_frame, ~select);
        if ~get(handles.Check_isOHSV, 'Value')
            sel_frame = bsxfun(@times, reshape(cc(2,:), [1,1,3]), select);
        else
            sel_frame = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(2)*map_hue, map_saturation, map_value)), select);
        end
        I_frame = nonsel_frame + sel_frame;
    end
    if isfield(handles, 'ROI5') && get(handles.Check_ROI5, 'Value')
        ROI5_r = handles.ROI5_r;
        ROI5_c = handles.ROI5_c;
        select = (((G_frame-ROI5_c(1)).^2+(S_frame-ROI5_c(2)).^2)<=ROI5_r^2);
        nonsel_frame = bsxfun(@times, I_frame, ~select);
        if ~get(handles.Check_isOHSV, 'Value')
            sel_frame = bsxfun(@times, reshape(cc(1,:), [1,1,3]), select);
        else
            sel_frame = bsxfun(@times, hsv2rgb(cat(3, ROI_hue(1)*map_hue, map_saturation, map_value)), select);
        end
        I_frame = nonsel_frame + sel_frame;
    end
end

