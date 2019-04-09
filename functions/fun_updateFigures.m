function [] = fun_updateFigures(handles, slice_idx, figureName)
%FUN_UPDATEMATRIXFIGURES Summary of this function goes here
%   Detailed explanation goes here

% Set plotting parameters
marker_size = 2;
line_width = 2;

switch figureName
    
    case 'G'
        % update G figure
        if isfield(handles, 'imageG')
            image_stack = handles.imageG;
            [~,~,slice_n] = size(image_stack);
            Gmin = str2double(get(handles.Edit_Gmin, 'String'));
            Gmax = str2double(get(handles.Edit_Gmax, 'String'));
            image_stack(image_stack>Gmax) = Gmax;
            image_stack(image_stack<Gmin) = Gmin;
            if slice_n == 1
                imshow(image_stack, [min(image_stack(:)), max(image_stack(:))], 'Parent', handles.Axes_G); colormap(handles.Axes_G,gray);
                set(handles.Axes_G,'XTick',[],'YTick',[]); 
                set(handles.Slider_G, 'visible', 'off'); set(handles.Text_GSlice, 'String', []); 
            else
                if slice_idx == -1
                    slice_idx = round(slice_n/2);
                end
                fun_show3Dstack(handles.Axes_G, handles.Slider_G, handles.Text_GSlice, image_stack, slice_idx);
                set(handles.Slider_G, 'Value', slice_idx)
                set(handles.Slider_G, 'SliderStep', [1/slice_n 1/slice_n])
            end
        end
        
    case 'S'
        % update S figure
        if isfield(handles, 'imageS')
            image_stack = handles.imageS;
            [~,~,slice_n] = size(image_stack);
            Smin = str2double(get(handles.Edit_Smin, 'String'));
            Smax = str2double(get(handles.Edit_Smax, 'String'));
            image_stack(image_stack>Smax) = Smax;
            image_stack(image_stack<Smin) = Smin;
            if slice_n == 1
                imshow(image_stack, [min(image_stack(:)), max(image_stack(:))], 'Parent', handles.Axes_S); colormap(handles.Axes_S,gray);
                set(handles.Axes_S,'XTick',[],'YTick',[]); 
                set(handles.Slider_S, 'visible', 'off'); set(handles.Text_SSlice, 'String', []); 
            else
                if slice_idx == -1
                    slice_idx = round(slice_n/2);
                end
                fun_show3Dstack(handles.Axes_S, handles.Slider_S, handles.Text_SSlice, image_stack, slice_idx);
                set(handles.Slider_S, 'Value', slice_idx)
                set(handles.Slider_S, 'SliderStep', [1/slice_n 1/slice_n])
            end
        end
        
    case 'I'
        % update I figure
        if isfield(handles, 'imageI')
            image_stack = handles.imageI;
            [~,~,slice_n] = size(image_stack);
            % cap the intensity pixel values
            if get(handles.Check_AutoI, 'Value')
                set(handles.Edit_Imin, 'String', num2str(min(image_stack(:))));
                set(handles.Edit_Imax, 'String', num2str(max(image_stack(:))));
            else
                Imin = str2double(get(handles.Edit_Imin, 'String'));
                Imax = str2double(get(handles.Edit_Imax, 'String'));
                image_stack(image_stack>Imax) = Imax;
                image_stack(image_stack<Imin) = Imin;
            end
            if slice_n == 1
                imshow(image_stack, [min(image_stack(:)), max(image_stack(:))], 'Parent', handles.Axes_I); colormap(handles.Axes_I,gray);
                set(handles.Axes_I,'XTick',[],'YTick',[]); 
                set(handles.Slider_I, 'visible', 'off'); set(handles.Text_ISlice, 'String', []); 
            else
                if slice_idx == -1
                    slice_idx = round(slice_n/2);
                end
                fun_show3Dstack(handles.Axes_I, handles.Slider_I, handles.Text_ISlice, image_stack, slice_idx);
                set(handles.Slider_I, 'Value', slice_idx)
                set(handles.Slider_I, 'SliderStep', [1/slice_n 1/slice_n])
            end
        end     
        
    case 'L'
        % update Lifetime figure
        if isfield(handles, 'imageL')
            L_stack = handles.imageL;
            [~,~,slice_n] = size(L_stack);
            % plot Intensity + Lifetime combined
            if get(handles.Check_isLHSV, 'Value') && isfield(handles, 'RGB_Stack')
                RGB_Stack = handles.RGB_Stack;
                if slice_n == 1
                    slice_idx = 1;
                    set(handles.Axes_L,'XTick',[],'YTick',[]); 
                    set(handles.Slider_L, 'visible', 'off'); set(handles.Text_LSlice, 'String', []); 
                else
                    if slice_idx == -1
                        slice_idx = round(slice_n/2);
                    end
                    set(handles.Slider_L, 'Value', slice_idx)
                    set(handles.Slider_L, 'visible', 'on');
                    set(handles.Slider_L, 'Min', 1)
                    set(handles.Slider_L, 'Max', slice_n)
                    set(handles.Slider_L, 'SliderStep', [1/slice_n 1/slice_n])
                    set(handles.Text_LSlice, 'String', ['Slice #: ',num2str(slice_idx),'/',num2str(slice_n)]);
                    set(handles.Axes_L,'XTick',[],'YTick',[]);                                 
                end
                axes(handles.Axes_L);
                imshow(RGB_Stack(:,:,:,slice_idx));  
            % only plot Lifetime
            else
                if slice_n == 1
                    imshow(L_stack, [min(L_stack(:)), max(L_stack(:))], 'Parent', handles.Axes_L); colormap(handles.Axes_L,gray);
                    set(handles.Axes_L,'XTick',[],'YTick',[]); 
                    set(handles.Slider_L, 'visible', 'off'); set(handles.Text_LSlice, 'String', []);
                else
                    if slice_idx == -1
                        slice_idx = round(slice_n/2);
                    end
                    fun_show3Dstack(handles.Axes_L, handles.Slider_L, handles.Text_LSlice, L_stack, slice_idx);
                    set(handles.Slider_L, 'Value', slice_idx)
                    set(handles.Slider_L, 'SliderStep', [1/slice_n 1/slice_n])
                end
            end
        end
        
    case 'PH'
        % update Phasor Histogram figure
        if isfield(handles, 'imagePH')
            PH_matrix = handles.imagePH;
            
            PH_cmap_str = get(handles.Pop_Colormap, 'String');
            PH_cmap = PH_cmap_str{get(handles.Pop_Colormap, 'Value')};
            MaxBin = str2double(get(handles.Edit_MaxBin, 'String'));
            
            Gmin = str2double(get(handles.Edit_Gmin, 'String'));
            Gmax = str2double(get(handles.Edit_Gmax, 'String'));
            Smin = str2double(get(handles.Edit_Smin, 'String'));
            Smax = str2double(get(handles.Edit_Smax, 'String'));    
            
            % this way to avoid deleting ROIs
            if ~isfield(handles, 'im_PH')
                im_PH = imagesc('Parent',handles.Axes_PH, 'XData',[Gmin, Gmax],'YData',[Smin, Smax],'CData',PH_matrix);
                handles.im_PH = im_PH; guidata(handles.Axes_PH,handles);
            else
                im_PH = handles.im_PH;
                im_PH.CData = PH_matrix;
                im_PH.XData = [Gmin, Gmax];
                im_PH.YData = [Smin, Smax];
            end
            caxis(handles.Axes_PH, [0, MaxBin]);
            xlim(handles.Axes_PH, [Gmin, Gmax]); ylim(handles.Axes_PH, [Smin, Smax]);
            set(handles.Axes_PH,'YDir','normal')
            cmap = colormap(handles.Axes_PH,PH_cmap);
            cmap(1,:) = [1 1 1];
            colormap(handles.Axes_PH,cmap);
            set(handles.Axes_PH,'XTick',[],'YTick',[]);
            hold(handles.Axes_PH, 'on')
            theta = linspace(0, pi, 100); radius = 0.5;
            plot(handles.Axes_PH, radius*cos(theta)+0.5, radius*sin(theta), 'k', 'LineWidth', line_width);
            line(handles.Axes_PH, [0 1], [0 0], 'Color', 'k', 'LineWidth', line_width);
            hold(handles.Axes_PH, 'off')
            set(handles.Axes_PH,'DataAspectRatio',[1 1 1])
        end
        
    case 'PC'
        % update Phasor Clusters figure    
        if isfield(handles, 'Clusteridx') && isfield(handles, 'ClusterC')
            
            GS_good = handles.GSgood;
            Cluster_idx = handles.Clusteridx;
            Cluster_C = handles.ClusterC;
            K = str2double(get(handles.Edit_K, 'String'));
            cc = fun_HSVcolors(K, 1);
            Gmin = str2double(get(handles.Edit_Gmin, 'String'));
            Gmax = str2double(get(handles.Edit_Gmax, 'String'));
            Smin = str2double(get(handles.Edit_Smin, 'String'));
            Smax = str2double(get(handles.Edit_Smax, 'String'));   

            cla(handles.Axes_PC);
            hold(handles.Axes_PC, 'on')
            if size(GS_good, 1)>=K
                for iK = 1:K
                    plot(handles.Axes_PC, GS_good(Cluster_idx==iK,1),GS_good(Cluster_idx==iK,2),...
                        'Color', cc(iK, :),...
                        'LineStyle', 'none',...
                        'Marker', '.',...
                        'MarkerSize',marker_size)
                end
            end
            plot(handles.Axes_PC, Cluster_C(:,1),Cluster_C(:,2),'kx','MarkerSize',marker_size+4,'LineWidth', line_width)
            theta = linspace(0, pi, 100); radius = 0.5;
            plot(handles.Axes_PC, radius*cos(theta)+0.5, radius*sin(theta), 'k', 'LineWidth', line_width);
            line([0 1], [0 0], 'Color', 'k', 'LineWidth', line_width, 'Parent', handles.Axes_PC);
            hold(handles.Axes_PC, 'off')
            xlim(handles.Axes_PC, [Gmin, Gmax]);
            ylim(handles.Axes_PC, [Smin, Smax]);
            set(handles.Axes_PC,'DataAspectRatio',[1 1 1])
        end
        
    case 'O'
        % update Overlap figure  
        
        if isfield(handles, 'imageI')
            I_stack = handles.imageI;
            [~,~,slice_n] = size(I_stack);  

            if slice_n == 1
                slice_idx = 1;
                set(handles.Slider_O, 'visible', 'off'); set(handles.Text_OSlice, 'String', []); 
            else
                if slice_idx == -1
                    slice_idx = round(slice_n/2);
                end
                set(handles.Slider_O, 'Value', slice_idx)
                set(handles.Slider_O, 'visible', 'on');
                set(handles.Slider_O, 'Min', 1)
                set(handles.Slider_O, 'Max', slice_n)
                set(handles.Slider_O, 'SliderStep', [1/slice_n 1/slice_n])
                set(handles.Text_OSlice, 'String', ['Slice #: ',num2str(slice_idx),'/',num2str(slice_n)]);            
            end

            axes(handles.Axes_O);
            switch get(handles.Pop_OLabels, 'Value')
                case 1 % ROIs
                    I_frame = fun_calcROIoverlap(handles, slice_idx);
                    imshow(I_frame);
                    
                case 2 % Clusters
                    if isfield(handles, 'imageO') && isfield(handles, 'imageOHSV') 
                        O_stack = handles.imageO;
                        OHSV_stack = handles.imageOHSV; 
                        if get(handles.Check_isOHSV, 'Value')
                            imshow(OHSV_stack(:,:,:,slice_idx));  
                        else
                        imshow(O_stack(:,:,:,slice_idx));  
                        end
                    else
                        msgbox('Please calculate clusters first.', 'Error','error');
                    end
            end
        end
        
    otherwise
        error('Unexpected figure name')
end

axis tight equal
    
end

