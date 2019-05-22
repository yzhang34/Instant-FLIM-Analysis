function [] = fun_updateROIrc(hObject, handles, ROI_idx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    switch ROI_idx
        case 1
            radius = str2double(get(handles.Edit_ROI1r, 'String'));
            center_G = str2double(get(handles.Edit_ROI1c_G, 'String'));
            center_S = str2double(get(handles.Edit_ROI1c_S, 'String'));
            center = [center_G, center_S];
            new_pos = [center-radius, 2*radius, 2*radius];
            if isfield(handles, 'ROI1')
                handles.ROI1.Position = new_pos;
                handles.ROI1_r = radius;
                handles.ROI1_c = center;
            end
                 
        case 2
            radius = str2double(get(handles.Edit_ROI2r, 'String'));
            center_G = str2double(get(handles.Edit_ROI2c_G, 'String'));
            center_S = str2double(get(handles.Edit_ROI2c_S, 'String'));
            center = [center_G, center_S];    
            new_pos = [center-radius, 2*radius, 2*radius];
            if isfield(handles, 'ROI2')
                handles.ROI2.Position = new_pos;
                handles.ROI2_r = radius;
                handles.ROI2_c = center;
            end 
            
        case 3
            radius = str2double(get(handles.Edit_ROI3r, 'String'));
            center_G = str2double(get(handles.Edit_ROI3c_G, 'String'));
            center_S = str2double(get(handles.Edit_ROI3c_S, 'String'));
            center = [center_G, center_S];
            new_pos = [center-radius, 2*radius, 2*radius];
            if isfield(handles, 'ROI3')
                handles.ROI3.Position = new_pos;
                handles.ROI3_r = radius;
                handles.ROI3_c = center;
            end 
                        
        case 4
            radius = str2double(get(handles.Edit_ROI4r, 'String'));
            center_G = str2double(get(handles.Edit_ROI4c_G, 'String'));
            center_S = str2double(get(handles.Edit_ROI4c_S, 'String'));
            center = [center_G, center_S];
            new_pos = [center-radius, 2*radius, 2*radius];
            if isfield(handles, 'ROI4')
                handles.ROI4.Position = new_pos;
                handles.ROI4_r = radius;
                handles.ROI4_c = center;
            end
            
        case 5
            radius = str2double(get(handles.Edit_ROI5r, 'String'));
            center_G = str2double(get(handles.Edit_ROI5c_G, 'String'));
            center_S = str2double(get(handles.Edit_ROI5c_S, 'String'));
            center = [center_G, center_S];
            new_pos = [center-radius, 2*radius, 2*radius];
            if isfield(handles, 'ROI5')
                handles.ROI5.Position = new_pos;
                handles.ROI5_r = radius;
                handles.ROI5_c = center;
            end             
    end

    guidata(hObject,handles) 
    
    fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

    
end

