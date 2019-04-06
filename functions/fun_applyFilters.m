function [ ] = fun_applyFilters(hObject, handles)
%FUN_CALCPHASORHIST Summary of this function goes here
%   This function is used to calculate phasors

if isfield(handles, 'imageG_backup') && isfield(handles, 'imageS_backup') && isfield(handles, 'imageI_backup')
   
    G_stack = handles.imageG_backup;
    S_stack = handles.imageS_backup;
    I_stack = handles.imageI_backup;
    
    if isequal(size(G_stack),size(S_stack)) && isequal(size(G_stack),size(I_stack))
        
        FilterSelect_val = get(handles.Pop_FilterSelect, 'Value');
        switch FilterSelect_val

            case 2 % 3x3 Median Filter (1 Time)
                filtered_G = fun_filterSelect(G_stack, 'median3_x1');
                filtered_S = fun_filterSelect(S_stack, 'median3_x1');
                filtered_I = fun_filterSelect(I_stack, 'median3_x1');

            case 3 % 3x3 Median Filter (2 Times)
                filtered_G = fun_filterSelect(G_stack, 'median3_x2');
                filtered_S = fun_filterSelect(S_stack, 'median3_x2');
                filtered_I = fun_filterSelect(I_stack, 'median3_x2');            

            case 4 % 3x3 Median Filter (3 Times)
                filtered_G = fun_filterSelect(G_stack, 'median3_x3');
                filtered_S = fun_filterSelect(S_stack, 'median3_x3');
                filtered_I = fun_filterSelect(I_stack, 'median3_x3');            

            case 5 % 5x5 Median Filter (1 Time)
                filtered_G = fun_filterSelect(G_stack, 'median5_x1');
                filtered_S = fun_filterSelect(S_stack, 'median5_x1');
                filtered_I = fun_filterSelect(I_stack, 'median5_x1');            

            case 6 % 5x5 Median Filter (2 Times)
                filtered_G = fun_filterSelect(G_stack, 'median5_x2');
                filtered_S = fun_filterSelect(S_stack, 'median5_x2');
                filtered_I = fun_filterSelect(I_stack, 'median5_x2');

            case 7 % 5x5 Median Filter (3 Times)
                filtered_G = fun_filterSelect(G_stack, 'median5_x3');
                filtered_S = fun_filterSelect(S_stack, 'median5_x3');
                filtered_I = fun_filterSelect(I_stack, 'median5_x3');

            case 8 % Smoothing Filter
                filtered_G = fun_filterSelect(G_stack, 'smooth');
                filtered_S = fun_filterSelect(S_stack, 'smooth');
                filtered_I = fun_filterSelect(I_stack, 'smooth');

            otherwise % No Filter
                filtered_G = G_stack;
                filtered_S = S_stack;
                filtered_I = I_stack;

        end

        handles.imageG = filtered_G; 
        handles.imageS = filtered_S;
        if get(handles.Check_IntensityFilter, 'Value')
            handles.imageI = filtered_I;      
        else
            handles.imageI = I_stack;
        end
        guidata(hObject,handles) 

        fun_updateFigures(handles, -1, 'G');
        fun_updateFigures(handles, -1, 'S');
        fun_updateFigures(handles, -1, 'I');

    else
        msgbox('G, S, I sizes not match.', 'Error','error');
    end 
else
    msgbox('G, S, or I do not exist.', 'Error','error');
end


end

