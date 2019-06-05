function [] = fun_exportSegChannels(handles)
%FUN_EXPORTSEGCHANNELS Summary of this function goes here
%   This function is used to display segmented channels
%
%   Author: Yide Zhang
%   Email: yzhang34@nd.edu
%   Date: June 5, 2019
%   Copyright: University of Notre Dame, 2019



switch get(handles.Pop_OLabels, 'Value')
    
    case 1 % ROIs
        if isfield(handles, 'imagePH')
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','ROI_Segment');
            if filename~=0
                fun_calcROIsegs(handles, 'export', filename, filepath);
            end
        else
            msgbox('Please calculate phasors first.', 'Error','error');
        end
    case 2 % Clusters  

        if isfield(handles, 'Clusteridx') && isfield(handles, 'xyzgood')
            [filename, filepath] = uiputfile({'*.tif'},'Export the image to 32-bit (RGB) tif files.','Cluster_Segment');
            if filename~=0
                fun_calcClusterSegs(handles, 'export', filename, filepath);
            end
        else
            msgbox('Please calculate clusters first.', 'Error','error');
        end
end

end