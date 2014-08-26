classdef file < handle
    %
    %   Class:
    %   neuroshare.file
    
    properties (Hidden)
        h
    end
    
    properties
        n_entities
        dt
        file_comment
        file_datenum
        file_datestr
        file_type
        file_duration % (seconds)
        entity_info %Class: neuroshare.entity_info
    end
    
    methods
        function obj = file(file_path)
            %
            %   neuroshare.file(file_path)
            
            persistent p_file_extension
            
            if nargin == 0
               %TODO: We could eventually have an enumeration of supported
               %file types ...
               [file_name,path_name] = uigetfile({'*.*','All Files (*.*)'},'Pick a file to open'); 
               
               %TODO: We should move this to a function readFile so that we
               %don't have to return a useless object
               if isnumeric(file_name)
                   return
               end
               file_path = fullfile(path_name,file_name);
            end
            
            [~,~,file_extension] = fileparts(file_path);
            
            if ~strcmp(file_extension,p_file_extension)
               neuroshare.autoLoadLibrary(file_path);
               p_file_extension = file_extension;
            end
            
            [result_code, obj.h] = ns_OpenFile(file_path);
            
            neuroshare.handleError(result_code)
            
            [result_code, file_info] = ns_GetFileInfo(obj.h);
            
            neuroshare.handleError(result_code)
            
            %TODO: Find definition of FileInfo. What's mandatory and what's
            %optional ???? Current implementation is for the CED dll.
            
            %TODO: Check for an error
            
            obj.n_entities = file_info.EntityCount;
            obj.dt         = file_info.TimeSpan;
            obj.file_comment = file_info.FileComment;
            obj.file_type    = file_info.FileType;
            obj.file_duration = file_info.TimeSpan;
            obj.file_datenum = datenum(...
                file_info.Time_Year,...
                file_info.Time_Month,...
                file_info.Time_Day,...
                file_info.Time_Hour,...
                file_info.Time_Min,...
                file_info.Time_Sec + file_info.Time_MilliSec/1000);
            obj.file_datestr = datestr(obj.file_datenum);
            
            obj.entity_info = neuroshare.entity_info(obj.h,obj.n_entities);
            
            keyboard
            %JAH: At this point ...
            
        end
        function delete(obj)
            try %#ok<TRYNC>
                ns_CloseFile(obj.h);
            end
        end
    end
    
end

