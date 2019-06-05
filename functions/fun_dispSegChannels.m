function [] = fun_dispSegChannels(handles)
%FUN_DISPSEGCHANNELS Summary of this function goes here
%   This function is used to display segmented channels
%
%   Author: Yide Zhang
%   Email: yzhang34@nd.edu
%   Date: June 5, 2019
%   Copyright: University of Notre Dame, 2019



switch get(handles.Pop_OLabels, 'Value')

    case 1 % ROIs
        if isfield(handles, 'imagePH')
            fun_calcROIsegs(handles, 'show', '', '')
        else
            msgbox('Please calculate phasors first.', 'Error','error');
        end

    case 2 % Clusters   
        if isfield(handles, 'Clusteridx') && isfield(handles, 'xyzgood')
            fun_calcClusterSegs(handles, 'show', '', '')
        else
            msgbox('Please calculate clusters first.', 'Error','error');
        end
end

end

