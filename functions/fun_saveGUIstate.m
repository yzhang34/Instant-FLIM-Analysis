function [] = fun_saveGUIstate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [filename, filepath] = uiputfile({'*.mat'},'Save the current state of the GUI.','state_name');
    fullname = [filepath filename];
    if filename~=0
        state.a = 1;
        
        state = fun_saveHandlesVar(handles, state, 'Edit_GSscale', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_MinPerc', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_MaxPerc', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_MinL', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_MaxL', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ModFreq', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Rep', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_K', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_MaxBin', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Grid', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Imax', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Imin', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Smax', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Smin', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Gmax', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_Gmin', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI1c_S', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI2c_S', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI3c_S', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI4c_S', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI5c_S', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI1c_G', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI2c_G', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI3c_G', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI4c_G', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI5c_G', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI1r', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI2r', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI3r', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI4r', 'string');
        state = fun_saveHandlesVar(handles, state, 'Edit_ROI5r', 'string');
        
       
        state = fun_saveHandlesVar(handles, state, 'Check_IntensityFilter', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_isOHSV', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_isLHSV', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_AutoI', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_ROI1', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_ROI2', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_ROI3', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_ROI4', 'value');
        state = fun_saveHandlesVar(handles, state, 'Check_ROI5', 'value');
        
        state = fun_saveHandlesVar(handles, state, 'Pop_FilterSelect', 'value');
        state = fun_saveHandlesVar(handles, state, 'Pop_OLabels', 'value');
        state = fun_saveHandlesVar(handles, state, 'Pop_Distance', 'value');
        state = fun_saveHandlesVar(handles, state, 'Pop_Colormap', 'value');
        
        state = fun_saveHandlesVar(handles, state, 'Radio_ROI1', 'value');
        state = fun_saveHandlesVar(handles, state, 'Radio_ROI2', 'value');
        state = fun_saveHandlesVar(handles, state, 'Radio_ROI3', 'value');
        state = fun_saveHandlesVar(handles, state, 'Radio_ROI4', 'value');
        state = fun_saveHandlesVar(handles, state, 'Radio_ROI5', 'value');    
        state = fun_saveHandlesVar(handles, state, 'Radio_None', 'value');
        
        state = fun_saveHandlesVar(handles, state, 'ROI1', []);
        state = fun_saveHandlesVar(handles, state, 'ROI2', []);
        state = fun_saveHandlesVar(handles, state, 'ROI3', []);
        state = fun_saveHandlesVar(handles, state, 'ROI4', []);
        state = fun_saveHandlesVar(handles, state, 'ROI5', []);
        
        save(fullname, 'state');
    end

end

