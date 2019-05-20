function [] = fun_applyGSscale(hObject, handles)
%CUSTOM_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles, 'imageG_backup') && isfield(handles, 'imageS_backup')
   
    G_stack = handles.imageG_backup;
    S_stack = handles.imageS_backup;
    
    
    if isequal(size(G_stack),size(S_stack))
        
        GS_scale = str2double(get(handles.Edit_GSscale, 'String'));

        handles.imageG = G_stack * GS_scale; 
        handles.imageS = S_stack * GS_scale; 
        guidata(hObject,handles) 

        fun_updateFigures(handles, -1, 'G');
        fun_updateFigures(handles, -1, 'S'); 
        
        % reset the applied filter
        set(handles.Pop_FilterSelect, 'Value', 1);

    else
        msgbox('G, S sizes not match.', 'Error','error');
    end 
else
    msgbox('G and S do not exist.', 'Error','error');
end




end

