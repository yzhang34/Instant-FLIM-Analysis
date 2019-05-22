function [] = fun_interactROIs(hObject, handles, ROI_idx, mouse_pos, mouse_mode)
%FUN_INTERACTROIS Summary of this function goes here
%   Function used to interactively draw ROIs
      
cc_ROIs = fun_HSVcolors(5, 1);
line_width = 2;
               
switch mouse_mode
    case 'Down'
        init_pos = mouse_pos;
        start_draw = true;
        switch ROI_idx
            case 1
                if ~isfield(handles, 'ROI1')
                    ROI1 = rectangle('Parent', handles.Axes_PH,...
                        'Position', [init_pos, 0, 0],...
                        'EdgeColor', cc_ROIs(5,:),...
                        'LineWidth', line_width,...
                        'Curvature', 1,...
                        'HitTest', 'off');
                    handles.ROI1 = ROI1; 
                else
                    handles.ROI1.Visible = 'on';
                end
                set(handles.Check_ROI1, 'value', true);
            case 2
                if ~isfield(handles, 'ROI2')
                    ROI2 = rectangle('Parent', handles.Axes_PH,...
                        'Position', [init_pos, 0, 0],...
                        'EdgeColor', cc_ROIs(4,:),...
                        'LineWidth', line_width,...
                        'Curvature', 1,...
                        'HitTest', 'off');
                    handles.ROI2 = ROI2; 
                else
                    handles.ROI2.Visible = 'on';                    
                end
                set(handles.Check_ROI2, 'value', true);
            case 3
                if ~isfield(handles, 'ROI3')
                    ROI3 = rectangle('Parent', handles.Axes_PH,...
                        'Position', [init_pos, 0, 0],...
                        'EdgeColor', cc_ROIs(3,:),...
                        'LineWidth', line_width,...
                        'Curvature', 1,...
                        'HitTest', 'off');
                    handles.ROI3 = ROI3; 
                else
                    handles.ROI3.Visible = 'on';                    
                end
                set(handles.Check_ROI3, 'value', true);
            case 4
                if ~isfield(handles, 'ROI4')
                    ROI4 = rectangle('Parent', handles.Axes_PH,...
                        'Position', [init_pos, 0, 0],...
                        'EdgeColor', cc_ROIs(2,:),...
                        'LineWidth', line_width,...
                        'Curvature', 1,...
                        'HitTest', 'off');
                    handles.ROI4 = ROI4; 
                else
                    handles.ROI4.Visible = 'on';                    
                end
                set(handles.Check_ROI4, 'value', true);
            case 5                
                if ~isfield(handles, 'ROI5')
                    ROI5 = rectangle('Parent', handles.Axes_PH,...
                        'Position', [init_pos, 0, 0],...
                        'EdgeColor', cc_ROIs(1,:),...
                        'LineWidth', line_width,...
                        'Curvature', 1,...
                        'HitTest', 'off');
                    handles.ROI5 = ROI5; 
                else
                    handles.ROI5.Visible = 'on';                    
                end
                set(handles.Check_ROI5, 'value', true);
        end
        handles.init_pos = init_pos; 
        handles.start_draw = start_draw; 
        guidata(hObject,handles) 

    case 'Motion'
        if isfield(handles, 'init_pos') && isfield(handles, 'start_draw') 
            if handles.start_draw
                init_pos = handles.init_pos;
                center = init_pos;
                radius = sqrt(sum((mouse_pos - center).^2));
                new_pos = [center-radius, 2*radius, 2*radius];
                switch ROI_idx
                    case 1
                        if isfield(handles, 'ROI1')
                            handles.ROI1.Position = new_pos;
                            handles.ROI1_r = radius;
                            handles.ROI1_c = center;
                            set(handles.Edit_ROI1r, 'String', num2str(radius));
                            set(handles.Edit_ROI1c_G, 'String', num2str(center(1)));
                            set(handles.Edit_ROI1c_S, 'String', num2str(center(2)));
                        end
                    case 2
                        if isfield(handles, 'ROI2')
                            handles.ROI2.Position = new_pos;
                            handles.ROI2_r = radius;
                            handles.ROI2_c = center;
                            set(handles.Edit_ROI2r, 'String', num2str(radius));
                            set(handles.Edit_ROI2c_G, 'String', num2str(center(1)));
                            set(handles.Edit_ROI2c_S, 'String', num2str(center(2)));                            
                        end 
                    case 3
                        if isfield(handles, 'ROI3')
                            handles.ROI3.Position = new_pos;
                            handles.ROI3_r = radius;
                            handles.ROI3_c = center;
                            set(handles.Edit_ROI3r, 'String', num2str(radius));
                            set(handles.Edit_ROI3c_G, 'String', num2str(center(1)));
                            set(handles.Edit_ROI3c_S, 'String', num2str(center(2)));                            
                        end 
                    case 4
                        if isfield(handles, 'ROI4')
                            handles.ROI4.Position = new_pos;
                            handles.ROI4_r = radius;
                            handles.ROI4_c = center;
                            set(handles.Edit_ROI4r, 'String', num2str(radius));
                            set(handles.Edit_ROI4c_G, 'String', num2str(center(1)));
                            set(handles.Edit_ROI4c_S, 'String', num2str(center(2)));                            
                        end
                    case 5
                        if isfield(handles, 'ROI5')
                            handles.ROI5.Position = new_pos;
                            handles.ROI5_r = radius;
                            handles.ROI5_c = center;
                            set(handles.Edit_ROI5r, 'String', num2str(radius));
                            set(handles.Edit_ROI5c_G, 'String', num2str(center(1)));
                            set(handles.Edit_ROI5c_S, 'String', num2str(center(2)));                            
                        end 
                end
                guidata(hObject,handles) 
            end
        end
    
    case 'Up'
        if isfield(handles, 'init_pos') && isfield(handles, 'start_draw') 
            
            fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');
            
            handles.start_draw = false; 
            guidata(hObject, handles) 
        end
      
end


    



end

