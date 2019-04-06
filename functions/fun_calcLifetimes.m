function [] = fun_calcLifetimes(hObject, handles)
%FUN_CALCLIFETIMES Summary of this function goes here
%   This function is used to calculate lifetimes

if isfield(handles, 'imageG') && isfield(handles, 'imageS')
    G_stack = handles.imageG;
    S_stack = handles.imageS;
    if isequal(size(G_stack),size(S_stack))
        ModFreq = str2double(get(handles.Edit_ModFreq, 'String'));
        % TauP=(Pos(1,2)/Pos(1,1))/(2*pi*Freq);
        % TauM=sqrt((1/(Pos(1,2)^2+Pos(1,1)^2))-1)/(2*pi*Freq);
        L_stack = S_stack./G_stack/(2*pi*ModFreq);
        MaxL = str2double(get(handles.Edit_MaxL, 'String'));
        MinL = str2double(get(handles.Edit_MinL, 'String'));
        L_stack(L_stack>MaxL) = MaxL;
        L_stack(L_stack<MinL) = MinL;
        handles.imageL = L_stack; guidata(hObject,handles) 
        if isfield(handles, 'imageI')
            I_stack = handles.imageI;
            if isequal(size(L_stack),size(I_stack))
                if get(handles.Check_AutoI, 'Value')
                    Imin = min(I_stack(:));
                    Imax = max(I_stack(:));
                else
                    Imin = str2double(get(handles.Edit_Imin, 'String'));
                    Imax = str2double(get(handles.Edit_Imax, 'String'));
                end
                RGB_Stack = fun_processHSV2RGB(I_stack, Imin, Imax, L_stack, MinL, MaxL);  
                handles.RGB_Stack = RGB_Stack; guidata(hObject,handles) 
            else
                msgbox('I and Lifetime sizes not match.', 'Error','error');
            end
        else
            msgbox('I does not exist.', 'Error','error');
        end
    else
        msgbox('G and S sizes not match.', 'Error','error');
    end
else
    msgbox('G or S do not exist.', 'Error','error');
end

fun_updateFigures(handles, -1, 'L');

end

