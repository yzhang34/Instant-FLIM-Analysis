function [] = fun_exportFigures(handles, figureName)
%FUN_EXPORTFIGURES Summary of this function goes here
%   Detailed explanation goes here

switch figureName
    
    case 'G'
        if isfield(handles, 'imageG')
            image_stack = handles.imageG;
            % Gmin = str2double(get(handles.Edit_Gmin, 'String'));
            % Gmax = str2double(get(handles.Edit_Gmax, 'String'));
            % image_stack(image_stack>Gmax) = Gmax;
            % image_stack(image_stack<Gmin) = Gmin;
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (single precision) tif files.','imageG');
            fullname = [filepath filename];
            if filename~=0
                fun_exportRealTIF(image_stack, fullname)
            end
        else
            msgbox('G image not exist.', 'Error','error');
        end
        
    case 'S'
        if isfield(handles, 'imageS')
            image_stack = handles.imageS;
            % Smin = str2double(get(handles.Edit_Smin, 'String'));
            % Smax = str2double(get(handles.Edit_Smax, 'String'));
            % image_stack(image_stack>Smax) = Smax;
            % image_stack(image_stack<Smin) = Smin;
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (single precision) tif files.','imageS');
            fullname = [filepath filename];
            if filename~=0
                fun_exportRealTIF(image_stack, fullname)
            end
        else
            msgbox('S image not exist.', 'Error','error');
        end
        
    case 'I'
        if isfield(handles, 'imageI')
            image_stack = handles.imageI;
            % Imin = str2double(get(handles.Edit_Imin, 'String'));
            % Imax = str2double(get(handles.Edit_Imax, 'String'));
            % image_stack(image_stack>Imax) = Imax;
            % image_stack(image_stack<Imin) = Imin;
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (single precision) tif files.','imageI');
            fullname = [filepath filename];
            if filename~=0
                % fun_exportGrayTIF(image_stack, fullname)
                fun_exportRealTIF(image_stack, fullname)
            end
        else
            msgbox('Intensity image not exist.', 'Error','error');
        end
        
    case 'L'
        if isfield(handles, 'imageL')
            L_stack = handles.imageL;
            if get(handles.Check_isLHSV, 'Value') && isfield(handles, 'RGB_Stack')
                RGB_Stack = handles.RGB_Stack;
                [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imageLifetimeHSV');
                fullname = [filepath filename];
                if filename~=0
                    fun_exportColorTIF(RGB_Stack, fullname);
                end
            else
                [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (single precision) tif files.','imageLifetime');
                fullname = [filepath filename];
                if filename~=0
                    fun_exportRealTIF(L_stack, fullname)
                end
            end
        else
            msgbox('Lifetime image not exist.', 'Error','error');
        end
        
    case 'PH'
        if isfield(handles, 'imagePH')
            fun_updateFigures(handles, -1, 'PH');
            PH_frame = getframe(handles.Axes_PH);
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imagePhasorHistogram');
            fullname = [filepath filename];
            if filename~=0
                fun_exportColorTIF(PH_frame.cdata, fullname);
            end
        else
            msgbox('Phasor Histogram image not exist.', 'Error','error');
        end
       
    case 'PC'
        if isfield(handles, 'Clusteridx') && isfield(handles, 'ClusterC')
            fun_updateFigures(handles, -1, 'PC');
            PC_frame = getframe(handles.Axes_PC);
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imagePhasorCluster');
            fullname = [filepath filename];
            if filename~=0
                fun_exportColorTIF(PC_frame.cdata, fullname);
            end
        else
            msgbox('Phasor Cluster image not exist.', 'Error','error');
        end
        
    case 'O'   
        if isfield(handles, 'imageI')
            switch get(handles.Pop_OLabels, 'Value')
                case 1 % ROIs
                    I_stack = handles.imageI;
                    [~,~,slice_n] = size(I_stack);  
                    PH_frame = cell(slice_n, 1);
                    hwb_progress = waitbar(0, 'Preparing for export ...');
                    for i_slice = 1:slice_n
                        waitbar(i_slice/slice_n, hwb_progress);
                        I_frame = fun_calcROIoverlap(handles, i_slice);
                        PH_frame{i_slice} = I_frame;
                    end
                    close(hwb_progress);
                    if get(handles.Check_isOHSV, 'Value')
                        [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imageOverlapROIHSV');
                    else
                        [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imageOverlapROI');
                    end
                    fullname = [filepath filename];
                    if filename~=0
                        fun_exportColorTIF(cat(4, PH_frame{:}), fullname);
                    end
                    
                case 2 % Clusters       
                    if isfield(handles, 'imageO') && isfield(handles, 'imageOHSV')
                        if get(handles.Check_isOHSV, 'Value')
                            OHSV_stack = handles.imageOHSV; 
                            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imageOverlapClusterHSV');
                            fullname = [filepath filename];
                            if filename~=0
                                fun_exportColorTIF(OHSV_stack, fullname);
                            end
                        else
                            O_stack = handles.imageO;
                            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','imageOverlapCluster');
                            fullname = [filepath filename];
                            if filename~=0
                                fun_exportColorTIF(O_stack, fullname)
                            end
                        end
                    end
            end
        else
            msgbox('Overlap image not exist.', 'Error','error');
        end
        
    case 'Summary'
            [filename, filepath] = uiputfile({'*.tif'},'Save a screenshot of the program.','PM_FLIM_Summary');
            fullname = [filepath filename];
            if filename~=0
                F = getframe(gcf);
                fun_exportColorTIF(F.cdata, fullname);
            end        
        
    otherwise
        error('Unexpected figure name')

end

