function [] = fun_updateLimRange(handles, update_mode)
%FUN_LIMIT2RANGE Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles, 'imageI')
    image_stack = handles.imageI;

    switch update_mode
        case 'lim2range'
            Imin = str2double(get(handles.Edit_Imin, 'String'));
            Imax = str2double(get(handles.Edit_Imax, 'String'));
            max_perc = (Imax-min(image_stack(:)))/(max(image_stack(:))-min(image_stack(:)))*100;
            min_perc = (Imin-min(image_stack(:)))/(max(image_stack(:))-min(image_stack(:)))*100;
            within = max_perc - min_perc;
            set(handles.Edit_MaxPerc, 'String', num2str(max_perc)); 
            set(handles.Edit_MinPerc, 'String', num2str(min_perc)); 
            set(handles.Text_Within, 'String', ['Dynamic Range: ',num2str(within), '%']);
            
        case 'range2lim'
            if get(handles.Check_AutoI, 'Value')
                max_perc = 100;
                min_perc = 0;
                set(handles.Edit_MaxPerc, 'String', num2str(max_perc)); 
                set(handles.Edit_MinPerc, 'String', num2str(min_perc)); 
            else
                max_perc = str2double(get(handles.Edit_MaxPerc, 'String'));
                min_perc = str2double(get(handles.Edit_MinPerc, 'String'));
            end
            within = max_perc - min_perc;
            Imax = min(image_stack(:)) + (max(image_stack(:))-min(image_stack(:)))*max_perc/100;
            Imin = min(image_stack(:)) + (max(image_stack(:))-min(image_stack(:)))*min_perc/100;            
            set(handles.Edit_Imin, 'String', num2str(Imin));  
            set(handles.Edit_Imax, 'String', num2str(Imax));  
            set(handles.Text_Within, 'String', ['Dynamic Range: ',num2str(within), '%']);

        otherwise
            error('Unexpected update mode')
    end
    
    if isfield(handles, 'IntHist') && isfield(handles, 'lineImin') && isfield(handles, 'lineImax')
        h_IntHist = handles.IntHist;
        if isvalid(h_IntHist)
            Imin = str2double(get(handles.Edit_Imin, 'String'));
            Imax = str2double(get(handles.Edit_Imax, 'String'));
            h_lineImin = handles.lineImin;
            h_lineImax = handles.lineImax;
            h_lineImin.XData = [Imin Imin];
            h_lineImax.XData = [Imax Imax];
        end
    end
    
end

end

