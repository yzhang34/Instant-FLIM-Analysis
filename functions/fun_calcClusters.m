function [] = fun_calcClusters(hObject, handles)
%FUN_CALCCLUSTERS Summary of this function goes here
%   This function is used to calculate k-means clusters

if isfield(handles, 'GSgood')
    
    
%     box = msgbox('Calculating clusters, please wait...');
    
    GS_good = handles.GSgood;
    
    K = str2double(get(handles.Edit_K, 'String'));

    Distance_val = get(handles.Pop_Distance, 'Value');
    switch Distance_val
        case 1
            Distance = 'sqeuclidean';
        case 2
            Distance = 'cityblock';
        otherwise
            Distance = 'cosine';
    end
    Replicates = str2double(get(handles.Edit_Rep, 'String'));
    opts = statset('Display','iter');
    
    if size(GS_good, 1) >= K
    [idx, C] = fun_kmeans(GS_good, K,...
        'Distance', Distance,... % sqeuclidean, cityblock, cosine
        'MaxIter', 1000,...
        'OnlinePhase', 'off',...
        'Replicates', Replicates,...
        'Start', 'plus',... % cluster, plus, sample, uniform
        'Options',opts);
    else
        idx = (1:K)';
        C = zeros(K, 2);
    end

    % sort idx based on the centroids in C
    [C_sort, C_idx] = sortrows(C);
    idx_sort = idx;
    for iK = 1:K
        idx_sort(idx==C_idx(iK))=iK;
    end
    
    handles.Clusteridx = idx_sort; 
    handles.ClusterC= C_sort; 
    guidata(hObject,handles) 
    
%     close(box);

else
    msgbox('Please calculate phasors first.', 'Error','error');
end



fun_updateFigures(handles, -1, 'PC');


end

