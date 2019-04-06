function [ ] = fun_calcPhasors(hObject, handles)
%FUN_CALCPHASORHIST Summary of this function goes here
%   This function is used to calculate phasors

if isfield(handles, 'imageG') && isfield(handles, 'imageS') && isfield(handles, 'imageI')
    G_stack = handles.imageG;
    S_stack = handles.imageS;
    I_stack = handles.imageI;
    [n_x, n_y, n_z] = size(I_stack);
    if isequal(size(G_stack),size(S_stack)) && isequal(size(G_stack),size(I_stack))
        
        % select pixels with correct intensity values for phasor analysis
        Imin = str2double(get(handles.Edit_Imin, 'String'));
        Imax = str2double(get(handles.Edit_Imax, 'String'));
                
        Gmin = str2double(get(handles.Edit_Gmin, 'String'));
        Gmax = str2double(get(handles.Edit_Gmax, 'String'));
        Smin = str2double(get(handles.Edit_Smin, 'String'));
        Smax = str2double(get(handles.Edit_Smax, 'String'));        
        GS_grid = str2double(get(handles.Edit_Grid, 'String'));
        G_array = linspace(Gmin, Gmax, GS_grid);
        S_array = linspace(Smin, Smax, GS_grid);
        PH_matrix = zeros(GS_grid, GS_grid);

        % use a matrix to store phasor information for the whole volume/frame
        
        % n_good = numel(find(((I_stack <= Imax) & (I_stack >= Imin)) &...
        %     ((G_stack <= Gmax) & (G_stack >= Gmin)) & ...
        %     ((S_stack <= Smax) & (S_stack >= Smin))));
        n_good = numel(find(((I_stack < Imax) & (I_stack > Imin)) &...
                    ((G_stack < Gmax) & (G_stack > Gmin)) & ...
                    ((S_stack < Smax) & (S_stack > Smin))));
        G_good = zeros(n_good,1);
        S_good = zeros(n_good,1);
        x_good = zeros(n_good,1);
        y_good = zeros(n_good,1);
        z_good = zeros(n_good,1);
        
        i_good = 1;
        hwb_progress = waitbar(0, 'Calculating phasors ...');
        for i_z = 1:n_z            
            waitbar(i_z/n_z, hwb_progress);
            for i_x = 1:n_x
                for i_y = 1:n_y
                    iG = G_stack(i_x, i_y, i_z);
                    iS = S_stack(i_x, i_y, i_z);
                    iI = I_stack(i_x, i_y, i_z);
                    if iI <= Imax && iI >= Imin &&...
                            iG <= Gmax && iG >= Gmin &&...
                            iS <= Smax && iS >= Smin
                        [~, G_idx] = min(abs(iG-G_array));
                        [~, S_idx] = min(abs(iS-S_array));
                        % row = S, col = G
                        PH_matrix(S_idx, G_idx) = PH_matrix(S_idx, G_idx)+1;

                        % reserve data for K-means clustering
                        G_good(i_good) = iG;
                        S_good(i_good) = iS;
                        x_good(i_good) = i_x;
                        y_good(i_good) = i_y;
                        z_good(i_good) = i_z;
                        i_good = i_good + 1;
                    end
                end
            end
            
        end
        
        GS_good = [G_good, S_good];
        xyz_good = [x_good, y_good, z_good];
        
        set(handles.Edit_MaxBin, 'String', num2str(max(PH_matrix(:))));
        
        handles.imagePH = PH_matrix;
        handles.GSgood = GS_good; 
        handles.xyzgood = xyz_good; 
        guidata(hObject,handles) 
        
        close(hwb_progress);

    else
        msgbox('G, S, I sizes not match.', 'Error','error');
    end 
else
    msgbox('G, S, or I do not exist.', 'Error','error');
end


fun_updateFigures(handles, -1, 'PH');


end

