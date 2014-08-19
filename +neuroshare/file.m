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
    end
    
    methods
        function obj = file(file_path)
            %
            %   neuroshare.file(file_path)
            %
            %
           [ns_RESULT, obj.h] = ns_OpenFile(file_path);
           
           %TODO: Pass this to an error handler ...
           %----------------------------------------
           switch ns_RESULT
               case 0
                   %ok
               case -2 %ns_TYPEERROR
                   %TODO: Expand, is this because of not setting the
                   %correct dll???
                   error('Library unable to open file type')
               case -3 %ns_FILEERROR
                   error('File access or read error')
               otherwise
                   error('Failed to open file. Additionally, error code is unrecognized')
           end
           
           [nsresult, FileInfo] = ns_GetFileInfo(obj.h);
           
           %TODO: Find definition of FileInfo. What's mandatory and what's
           %optional ????
           
           %TODO: Check for an error
           
           obj.n_entities = FileInfo.EntityCount;
           obj.dt         = FileInfo.TimeSpan;
           obj.file_comment = FileInfo.FileComment;
           obj.file_type    = FileInfo.FileType;
           obj.file_duration = FileInfo.TimeSpan;
           obj.file_datenum = datenum(...
               FileInfo.Time_Year,...
               FileInfo.Time_Month,...
               FileInfo.Time_Day,...
               FileInfo.Time_Hour,...
               FileInfo.Time_Min,...
               FileInfo.Time_Sec + FileInfo.Time_MilliSec/1000);
           obj.file_datestr = datestr(obj.file_datenum);
           
           %JAH: At this point ...
           
        end
        function delete(obj)
           try %#ok<TRYNC>
              ns_CloseFile(obj.h); 
           end
        end
    end
    
end

