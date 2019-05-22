function [state] = fun_saveHandlesVar(handles, state, varName, varType)
%FUN_SAVEHANDLESVAR Summary of this function goes here
%   Detailed explanation goes here

    if isfield(handles, varName)
        
        if ~isempty(varType)   
            eval(['state.',varName,'=get(handles.', varName,', "', varType, '");']);
        else
            eval(['state.',varName,'=handles.', varName, ';']);
        end
    end


end

