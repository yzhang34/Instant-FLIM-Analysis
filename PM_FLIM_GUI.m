function varargout = PM_FLIM_GUI(varargin)
% PM_FLIM_GUI MATLAB code for PM_FLIM_GUI.fig
%      PM_FLIM_GUI, by itself, creates a new PM_FLIM_GUI or raises the existing
%      singleton*.
%
%      H = PM_FLIM_GUI returns the handle to a new PM_FLIM_GUI or the handle to
%      the existing singleton*.
%
%      PM_FLIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PM_FLIM_GUI.M with the given input arguments.
%
%      PM_FLIM_GUI('Property','Value',...) creates a new PM_FLIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PM_FLIM_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PM_FLIM_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PM_FLIM_GUI

% Last Modified by GUIDE v2.5 20-May-2019 13:21:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PM_FLIM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PM_FLIM_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before PM_FLIM_GUI is made visible.
function PM_FLIM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PM_FLIM_GUI (see VARARGIN)

% Choose default command line output for PM_FLIM_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PM_FLIM_GUI wait for user response (see UIRESUME)
% uiwait(handles.Figure_PM_FLIM);


clc

addpath('./functions')

set(handles.Axes_G,'XTick',[],'YTick',[]); 
set(handles.Axes_S,'XTick',[],'YTick',[]); 
set(handles.Axes_I,'XTick',[],'YTick',[]); 
set(handles.Axes_L,'XTick',[],'YTick',[]); 
set(handles.Axes_LBar,'XTick',[],'YTick',[]); 
set(handles.Axes_PH,'XTick',[],'YTick',[]); 
set(handles.Axes_PC,'XTick',[],'YTick',[]); 
set(handles.Axes_O,'XTick',[],'YTick',[]);

set(handles.Slider_G, 'visible', 'off');
set(handles.Slider_S, 'visible', 'off');
set(handles.Slider_I, 'visible', 'off');
set(handles.Slider_L, 'visible', 'off');
set(handles.Slider_O, 'visible', 'off');

fun_colorbarHSV2RGB(handles)

cc_ROIs = fun_HSVcolors(5, 1);
set(handles.Check_ROI1, 'BackgroundColor', cc_ROIs(5,:));
set(handles.Check_ROI1, 'ForegroundColor', 'white');
set(handles.Check_ROI2, 'BackgroundColor', cc_ROIs(4,:));
set(handles.Check_ROI3, 'BackgroundColor', cc_ROIs(3,:));
set(handles.Check_ROI4, 'BackgroundColor', cc_ROIs(2,:));
set(handles.Check_ROI5, 'BackgroundColor', cc_ROIs(1,:));
set(handles.Check_ROI5, 'ForegroundColor', 'white');

% --- Outputs from this function are returned to the command line.
function varargout = PM_FLIM_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%% GUI Functions for Image Formation %%%%%%%%%%%%

function Button_LoadG_Callback(hObject, eventdata, handles)
% hObject    handle to Button_LoadG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenames, pathname] = uigetfile({'*.tif;*.tiff;*.csv'},'Select the CSV or TIF files to be imported', 'MultiSelect','on');
if iscell(filenames) % multiple selection
    if strfind(filenames{1},'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageG_backup = image_stack; % for filtering purposes
        handles.imageG = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'G');    
    else
        msgbox('Only a single TIF file (2D frame or 3D stack) can be imported.', 'Error','error');
    end
elseif ischar(filenames) % single selection
    if strfind(filenames,'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageG_backup = image_stack; % for filtering purposes
        handles.imageG = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'G');    
    else
        [image_stack, ~, ~, ~] = fun_importTIFstack(filenames, pathname);
        handles.imageG_backup = image_stack; % for filtering purposes
        handles.imageG = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'G');   
    end
end

function Button_LoadS_Callback(hObject, eventdata, handles)
% hObject    handle to Button_LoadS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenames, pathname] = uigetfile({'*.tif;*.tiff;*.csv'},'Select the CSV or TIF files to be imported', 'MultiSelect','on');
if iscell(filenames) % multiple selection
    if strfind(filenames{1},'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageS_backup = image_stack; % for filtering purposes
        handles.imageS = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'S');    
    else
        msgbox('Only a single TIF file (2D frame or 3D stack) can be imported.', 'Error','error');
    end
elseif ischar(filenames) % single selection
    if strfind(filenames,'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageS_backup = image_stack; % for filtering purposes
        handles.imageS = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'S');    
    else
        [image_stack, ~, ~, ~] = fun_importTIFstack(filenames, pathname);
        handles.imageS_backup = image_stack; % for filtering purposes
        handles.imageS = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'S');   
    end
end

function Button_LoadI_Callback(hObject, eventdata, handles)
% hObject    handle to Button_LoadI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenames, pathname] = uigetfile({'*.tif;*.tiff;*.csv'},'Select the CSV or TIF files to be imported', 'MultiSelect','on');
if iscell(filenames) % multiple selection
    if strfind(filenames{1},'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageI_backup = image_stack; % for filtering purposes
        handles.imageI = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'I');    
    else
        msgbox('Only a single TIF file (2D frame or 3D stack) can be imported.', 'Error','error');
    end
elseif ischar(filenames) % single selection
    if strfind(filenames,'.csv')
        [image_stack, ~, ~, ~] = fun_importCSVstack(filenames, pathname);
        handles.imageI_backup = image_stack; % for filtering purposes
        handles.imageI = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'I');    
    else
        [image_stack, ~, ~, ~] = fun_importTIFstack(filenames, pathname);
        handles.imageI_backup = image_stack; % for filtering purposes
        handles.imageI = image_stack; guidata(hObject,handles) 
        fun_updateFigures(handles, -1, 'I');   
    end
end

function Button_CalcL_Callback(hObject, eventdata, handles)
% hObject    handle to Button_CalcL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_calcLifetimes(hObject, handles);

function Button_CalcPH_Callback(hObject, eventdata, handles)
% hObject    handle to Button_CalcPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_calcPhasors(hObject, handles);

function Button_CalcPC_Callback(hObject, eventdata, handles)
% hObject    handle to Button_CalcPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_calcClusters(hObject, handles);

function Button_CalcO_Callback(hObject, eventdata, handles)
% hObject    handle to Button_CalcO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_calcOverlap(hObject, handles);

function Button_IntensityHist_Callback(hObject, eventdata, handles)
% hObject    handle to Button_IntensityHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_intensityHist(hObject, handles);

function Button_LifetimeHist_Callback(hObject, eventdata, handles)
% hObject    handle to Button_LifetimeHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_lifetimeHist(hObject, handles);


function Button_ApplyFilter_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ApplyFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_applyFilters(hObject, handles);



%%%%%%%%%%%% GUI Functions that Update Figures %%%%%%%%%%%%

function Edit_Gmin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Gmin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Gmin as a double
fun_updateFigures(handles, round(get(handles.Slider_G, 'Value')), 'G');

function Edit_Gmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Gmax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Gmax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Gmax as a double
fun_updateFigures(handles, round(get(handles.Slider_G, 'Value')), 'G');

function Edit_Gmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Smin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Smin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Smin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Smin as a double
fun_updateFigures(handles, round(get(handles.Slider_S, 'Value')), 'S');

function Edit_Smin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Smin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Smax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Smax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Smax as a double
fun_updateFigures(handles, round(get(handles.Slider_S, 'Value')), 'S');

function Edit_Smax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Imin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Imin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Imin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Imin as a double
set(handles.Check_AutoI, 'Value', false)
fun_updateLimRange(handles, 'lim2range');
fun_updateFigures(handles, round(get(handles.Slider_I, 'Value')), 'I');

function Edit_Imin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Imin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Imax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Imax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Imax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Imax as a double
set(handles.Check_AutoI, 'Value', false)
fun_updateLimRange(handles, 'lim2range');
fun_updateFigures(handles, round(get(handles.Slider_I, 'Value')), 'I');

function Edit_Imax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Imax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Check_AutoI_Callback(hObject, eventdata, handles)
% hObject    handle to Check_AutoI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_AutoI
fun_updateLimRange(handles, 'range2lim');
fun_updateFigures(handles, round(get(handles.Slider_I, 'Value')), 'I');

function Edit_MaxPerc_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_MaxPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_MaxPerc as text
%        str2double(get(hObject,'String')) returns contents of Edit_MaxPerc as a double
set(handles.Check_AutoI, 'Value', false)
fun_updateLimRange(handles, 'range2lim');
fun_updateFigures(handles, round(get(handles.Slider_I, 'Value')), 'I');

function Edit_MaxPerc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MaxPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_MinPerc_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_MinPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_MinPerc as text
%        str2double(get(hObject,'String')) returns contents of Edit_MinPerc as a double
set(handles.Check_AutoI, 'Value', false)
fun_updateLimRange(handles, 'range2lim');
fun_updateFigures(handles, round(get(handles.Slider_I, 'Value')), 'I');

function Edit_MinPerc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MinPerc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Check_isLHSV_Callback(hObject, eventdata, handles)
fun_updateFigures(handles, round(get(handles.Slider_L, 'Value')), 'L');

function Pop_Colormap_Callback(hObject, eventdata, handles)
fun_updateFigures(handles, -1, 'PH');

function Pop_Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pop_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_MaxBin_Callback(hObject, eventdata, handles)
MaxBin = str2double(get(hObject, 'String'));
if MaxBin < 1
    MaxBin = 1;
end
set(hObject, 'String', num2str(round(MaxBin)));
fun_updateFigures(handles, -1, 'PH');

function Edit_MaxBin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MaxBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Check_isOHSV_Callback(hObject, eventdata, handles)
% hObject    handle to Check_isOHSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_isOHSV
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Pop_OLabels_Callback(hObject, eventdata, handles)
% hObject    handle to Pop_OLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Pop_OLabels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Pop_OLabels
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Pop_OLabels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pop_OLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%% GUI Functions that Not-Update Figures %%%%%%%%%%%%

function Edit_ModFreq_Callback(hObject, eventdata, handles)
ModFreq = str2double(get(hObject, 'String'));
if ModFreq < 1
    ModFreq = 1;
end
set(hObject, 'String', num2str(round(ModFreq)));

function Edit_ModFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_ModFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_MaxL_Callback(hObject, eventdata, handles)
fun_calcLifetimes(hObject, handles);

function Edit_MaxL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MaxL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_MinL_Callback(hObject, eventdata, handles)
fun_calcLifetimes(hObject, handles);

function Edit_MinL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MinL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Grid_Callback(hObject, eventdata, handles)
GridSize = str2double(get(hObject, 'String'));
if GridSize < 1
    GridSize = 1;
end
set(hObject, 'String', num2str(round(GridSize)));

function Edit_Grid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_K_Callback(hObject, eventdata, handles)
K = str2double(get(hObject, 'String'));
if K < 1
    K = 1;
end
set(hObject, 'String', num2str(round(K)));

function Edit_K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pop_Distance_Callback(hObject, eventdata, handles)

function Pop_Distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pop_Distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Edit_Rep_Callback(hObject, eventdata, handles)
Rep = str2double(get(hObject, 'String'));
if Rep < 1
    Rep = 1;
end
set(hObject, 'String', num2str(round(Rep)));

function Edit_Rep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Rep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pop_FilterSelect_Callback(hObject, eventdata, handles)

function Pop_FilterSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pop_FilterSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Check_IntensityFilter_Callback(hObject, eventdata, handles)


%%%%%%%%%%%% GUI Functions for Sliders %%%%%%%%%%%%

function Slider_G_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice_idx = round(get(hObject, 'Value'));
fun_updateFigures(handles, slice_idx, 'G');

function Slider_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Slider_S_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice_idx = round(get(hObject, 'Value'));
fun_updateFigures(handles, slice_idx, 'S');

function Slider_S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Slider_I_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice_idx = round(get(hObject, 'Value'));
fun_updateFigures(handles, slice_idx, 'I');

function Slider_I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Slider_L_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice_idx = round(get(hObject, 'Value'));
fun_updateFigures(handles, slice_idx, 'L');

function Slider_L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Slider_O_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice_idx = round(get(hObject, 'Value'));
fun_updateFigures(handles, slice_idx, 'O');

function Slider_O_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%%%%%%%%%%%% GUI Functions for Exporting Image Data %%%%%%%%%%%%

function Button_ExportG_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'G');

function Button_ExportS_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'S');

function Button_ExportI_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'I');

function Button_ExportL_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'L');

function Button_ExportPH_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'PH');

function Button_ExportPC_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'PC');

function Button_ExportO_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'O');

function Button_ExportSummary_Callback(hObject, eventdata, handles)
% hObject    handle to Button_ExportSummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun_exportFigures(handles, 'Summary');

%%%%%%%%%%%% GUI Functions for Plotting ROIs %%%%%%%%%%%%

function Radio_None_Callback(hObject, eventdata, handles)

function Radio_ROI1_Callback(hObject, eventdata, handles)

function Radio_ROI2_Callback(hObject, eventdata, handles)

function Radio_ROI3_Callback(hObject, eventdata, handles)

function Radio_ROI4_Callback(hObject, eventdata, handles)

function Radio_ROI5_Callback(hObject, eventdata, handles)

function Check_ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_ROI1
if isfield(handles, 'ROI1')
    if get(hObject, 'Value')
        handles.ROI1.Visible = 'on';
    else
        handles.ROI1.Visible = 'off';
    end
end
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Check_ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_ROI2
if isfield(handles, 'ROI2')
    if get(hObject, 'Value')
        handles.ROI2.Visible = 'on';
    else
        handles.ROI2.Visible = 'off';
    end
end
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Check_ROI3_Callback(hObject, eventdata, handles)
% hObject    handle to Check_ROI3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_ROI3
if isfield(handles, 'ROI3')
    if get(hObject, 'Value')
        handles.ROI3.Visible = 'on';
    else
        handles.ROI3.Visible = 'off';
    end
end
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Check_ROI4_Callback(hObject, eventdata, handles)
% hObject    handle to Check_ROI4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_ROI4
if isfield(handles, 'ROI1')
    if get(hObject, 'Value')
        handles.ROI4.Visible = 'on';
    else
        handles.ROI4.Visible = 'off';
    end
end
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');

function Check_ROI5_Callback(hObject, eventdata, handles)
% hObject    handle to Check_ROI5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_ROI5
if isfield(handles, 'ROI1')
    if get(hObject, 'Value')
        handles.ROI5.Visible = 'on';
    else
        handles.ROI5.Visible = 'off';
    end
end
fun_updateFigures(handles, round(get(handles.Slider_O, 'Value')), 'O');



%%%%%%%%%%%% GUI Functions for Mouse Operations %%%%%%%%%%%%

function Figure_PM_FLIM_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Figure_PM_FLIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
seltype = hObject.SelectionType;
if strcmp(seltype,'normal')
    Gmin = str2double(get(handles.Edit_Gmin, 'String'));
    Gmax = str2double(get(handles.Edit_Gmax, 'String'));
    Smin = str2double(get(handles.Edit_Smin, 'String'));
    Smax = str2double(get(handles.Edit_Smax, 'String'));   
    mouse_pos = handles.Axes_PH.CurrentPoint(1, 1:2);
    if mouse_pos(1)>Gmin && mouse_pos(1)<Gmax &&...
            mouse_pos(2)>Smin && mouse_pos(2)<Smax
        if get(handles.Radio_ROI1, 'value')
            fun_interactROIs(hObject, handles, 1, mouse_pos, 'Down')
        elseif get(handles.Radio_ROI2, 'value')
            fun_interactROIs(hObject, handles, 2, mouse_pos, 'Down')
        elseif get(handles.Radio_ROI3, 'value')
            fun_interactROIs(hObject, handles, 3, mouse_pos, 'Down')
        elseif get(handles.Radio_ROI4, 'value')
            fun_interactROIs(hObject, handles, 4, mouse_pos, 'Down')
        elseif get(handles.Radio_ROI5, 'value')
            fun_interactROIs(hObject, handles, 5, mouse_pos, 'Down')
        end
    end
end

function Figure_PM_FLIM_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Figure_PM_FLIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Gmin = str2double(get(handles.Edit_Gmin, 'String'));
Gmax = str2double(get(handles.Edit_Gmax, 'String'));
Smin = str2double(get(handles.Edit_Smin, 'String'));
Smax = str2double(get(handles.Edit_Smax, 'String'));   
mouse_pos = handles.Axes_PH.CurrentPoint(1, 1:2);
if mouse_pos(1)>Gmin && mouse_pos(1)<Gmax &&...
        mouse_pos(2)>Smin && mouse_pos(2)<Smax
    if ~get(handles.Radio_None, 'value')
        hObject.Pointer = 'crosshair';
    end 
    if get(handles.Radio_ROI1, 'value')
        fun_interactROIs(hObject, handles, 1, mouse_pos, 'Motion')
    elseif get(handles.Radio_ROI2, 'value')
        fun_interactROIs(hObject, handles, 2, mouse_pos, 'Motion')
    elseif get(handles.Radio_ROI3, 'value')
        fun_interactROIs(hObject, handles, 3, mouse_pos, 'Motion')
    elseif get(handles.Radio_ROI4, 'value')
        fun_interactROIs(hObject, handles, 4, mouse_pos, 'Motion')
    elseif get(handles.Radio_ROI5, 'value')
        fun_interactROIs(hObject, handles, 5, mouse_pos, 'Motion')
    end
else
    hObject.Pointer = 'arrow';
end

function Figure_PM_FLIM_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to Figure_PM_FLIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Gmin = str2double(get(handles.Edit_Gmin, 'String'));
Gmax = str2double(get(handles.Edit_Gmax, 'String'));
Smin = str2double(get(handles.Edit_Smin, 'String'));
Smax = str2double(get(handles.Edit_Smax, 'String'));   
mouse_pos = handles.Axes_PH.CurrentPoint(1, 1:2);
if mouse_pos(1)>Gmin && mouse_pos(1)<Gmax &&...
        mouse_pos(2)>Smin && mouse_pos(2)<Smax
    if get(handles.Radio_ROI1, 'value')
        fun_interactROIs(hObject, handles, 1, mouse_pos, 'Up')
    elseif get(handles.Radio_ROI2, 'value')
        fun_interactROIs(hObject, handles, 2, mouse_pos, 'Up')
    elseif get(handles.Radio_ROI3, 'value')
        fun_interactROIs(hObject, handles, 3, mouse_pos, 'Up')
    elseif get(handles.Radio_ROI4, 'value')
        fun_interactROIs(hObject, handles, 4, mouse_pos, 'Up')
    elseif get(handles.Radio_ROI5, 'value')
        fun_interactROIs(hObject, handles, 5, mouse_pos, 'Up')
    end
end







%%%%%%%%%%%% Custom Functions %%%%%%%%%%%%
function Button_Custom_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_function(hObject, handles);



function Edit_GSscale_Callback(hObject, eventdata, handles)
fun_applyGSscale(hObject, handles);


function Edit_GSscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_GSscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



