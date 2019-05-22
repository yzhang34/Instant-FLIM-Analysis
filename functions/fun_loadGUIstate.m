function [] = fun_loadGUIstate(handles, hObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles, 'GSgood')

    [filename, pathname] = uigetfile({'*.mat'},'Select the state file to be loaded', 'MultiSelect','off');
    if ischar(filename)
        load([pathname, filename], 'state');
    end
    

    set(handles.Edit_GSscale, 'string',  state.Edit_GSscale);
    set(handles.Edit_MinPerc, 'string',  state.Edit_MinPerc);
    set(handles.Edit_MaxPerc, 'string',  state.Edit_MaxPerc);
    set(handles.Edit_MinL, 'string',  state.Edit_MinL);
    set(handles.Edit_MaxL, 'string',  state.Edit_MaxL);
    set(handles.Edit_ModFreq, 'string',  state.Edit_ModFreq);
    set(handles.Edit_Rep, 'string',  state.Edit_Rep);
    set(handles.Edit_K, 'string',  state.Edit_K);
    set(handles.Edit_MaxBin, 'string',  state.Edit_MaxBin);
    set(handles.Edit_Grid, 'string',  state.Edit_Grid);
    set(handles.Edit_Imax, 'string',  state.Edit_Imax);
    set(handles.Edit_Imin, 'string',  state.Edit_Imin);
    set(handles.Edit_Smax, 'string',  state.Edit_Smax);
    set(handles.Edit_Smin, 'string',  state.Edit_Smin);
    set(handles.Edit_Gmax, 'string',  state.Edit_Gmax);
    set(handles.Edit_Gmin, 'string',  state.Edit_Gmin);
    set(handles.Edit_ROI1c_S, 'string',  state.Edit_ROI1c_S);
    set(handles.Edit_ROI2c_S, 'string',  state.Edit_ROI2c_S);
    set(handles.Edit_ROI3c_S, 'string',  state.Edit_ROI3c_S);
    set(handles.Edit_ROI4c_S, 'string',  state.Edit_ROI4c_S);
    set(handles.Edit_ROI5c_S, 'string',  state.Edit_ROI5c_S);
    set(handles.Edit_ROI1c_G, 'string',  state.Edit_ROI1c_G);
    set(handles.Edit_ROI2c_G, 'string',  state.Edit_ROI2c_G);
    set(handles.Edit_ROI3c_G, 'string',  state.Edit_ROI3c_G);
    set(handles.Edit_ROI4c_G, 'string',  state.Edit_ROI4c_G);
    set(handles.Edit_ROI5c_G, 'string',  state.Edit_ROI5c_G);    
    set(handles.Edit_ROI1r, 'string',  state.Edit_ROI1r);
    set(handles.Edit_ROI2r, 'string',  state.Edit_ROI2r);
    set(handles.Edit_ROI3r, 'string',  state.Edit_ROI3r);
    set(handles.Edit_ROI4r, 'string',  state.Edit_ROI4r);
    set(handles.Edit_ROI5r, 'string',  state.Edit_ROI5r);    
    
    
    set(handles.Check_IntensityFilter, 'value',  state.Check_IntensityFilter);    
    set(handles.Check_isOHSV, 'value',  state.Check_isOHSV);
    set(handles.Check_isLHSV, 'value',  state.Check_isLHSV); 
    set(handles.Check_AutoI, 'value',  state.Check_AutoI); 
    set(handles.Check_ROI1, 'value',  state.Check_ROI1); 
    set(handles.Check_ROI2, 'value',  state.Check_ROI2); 
    set(handles.Check_ROI3, 'value',  state.Check_ROI3); 
    set(handles.Check_ROI4, 'value',  state.Check_ROI4); 
    set(handles.Check_ROI5, 'value',  state.Check_ROI5); 
    
    set(handles.Pop_FilterSelect, 'value',  state.Pop_FilterSelect); 
    set(handles.Pop_OLabels, 'value',  state.Pop_OLabels); 
    set(handles.Pop_Distance, 'value',  state.Pop_Distance); 
    set(handles.Pop_Colormap, 'value',  state.Pop_Colormap);
    
    set(handles.Radio_ROI1, 'value',  state.Radio_ROI1); 
    set(handles.Radio_ROI2, 'value',  state.Radio_ROI2); 
    set(handles.Radio_ROI3, 'value',  state.Radio_ROI3); 
    set(handles.Radio_ROI4, 'value',  state.Radio_ROI4); 
    set(handles.Radio_ROI5, 'value',  state.Radio_ROI5); 
    set(handles.Radio_None, 'value',  state.Radio_None); 
        
    handles.ROI1 = state.ROI1;
    handles.ROI2 = state.ROI2;
    handles.ROI3 = state.ROI3;
    handles.ROI4 = state.ROI4;
    handles.ROI5 = state.ROI5;
    set(handles.ROI1, 'Parent', handles.Axes_PH);
    set(handles.ROI2, 'Parent', handles.Axes_PH);
    set(handles.ROI3, 'Parent', handles.Axes_PH);
    set(handles.ROI4, 'Parent', handles.Axes_PH);
    set(handles.ROI5, 'Parent', handles.Axes_PH);
    
    handles.ROI1_r = str2double(get(handles.Edit_ROI1r, 'string'));
    handles.ROI2_r = str2double(get(handles.Edit_ROI2r, 'string'));
    handles.ROI3_r = str2double(get(handles.Edit_ROI3r, 'string'));
    handles.ROI4_r = str2double(get(handles.Edit_ROI4r, 'string'));
    handles.ROI5_r = str2double(get(handles.Edit_ROI5r, 'string'));
    
    handles.ROI1_c = [str2double(get(handles.Edit_ROI1c_G, 'string')),...
        str2double(get(handles.Edit_ROI1c_S, 'string'));];
    handles.ROI2_c = [str2double(get(handles.Edit_ROI2c_G, 'string')),...
        str2double(get(handles.Edit_ROI2c_S, 'string'));];
    handles.ROI3_c = [str2double(get(handles.Edit_ROI3c_G, 'string')),...
        str2double(get(handles.Edit_ROI3c_S, 'string'));];
    handles.ROI4_c = [str2double(get(handles.Edit_ROI4c_G, 'string')),...
        str2double(get(handles.Edit_ROI4c_S, 'string'));];
    handles.ROI5_c = [str2double(get(handles.Edit_ROI5c_G, 'string')),...
        str2double(get(handles.Edit_ROI5c_S, 'string'));];
    
    guidata(hObject,handles); 
    
else
    msgbox('Please calculate phasors first.', 'Error','error');
end
    
end

