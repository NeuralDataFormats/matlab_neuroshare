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
        entity_info     %neuroshare.entity_info
        analog_entities
        neural_entities
        event_entities
        segment_entities
    end
    
    methods
        function obj = file(file_path)
            %
            %   neuroshare.file(file_path)
            
            %TODO: Can we use ns_GetLibraryInfo to get away from
            %not needing to recompile code
            
            persistent p_file_extension

            [~,~,file_extension] = fileparts(file_path);
            
            if ~strcmp(file_extension,p_file_extension)
               neuroshare.autoLoadLibrary(file_path);
               p_file_extension = file_extension;
            else
               fprintf(2,'Not loading dll\n');
            end
            
            [result_code, obj.h] = ns_OpenFile(file_path);
            
            neuroshare.handleError(result_code)
            
            [result_code, file_info] = ns_GetFileInfo(obj.h);
            
            neuroshare.handleError(result_code)
            
            %TODO: Find definition of FileInfo. What's mandatory and what's
            %optional ???? Current implementation is for the CED dll.
                        
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
            
            obj.entity_info = neuroshare.entity_info(file_path,obj.h,obj.n_entities);
            
            obj.analog_entities  = obj.entity_info.getAnalogEntities();
            
            %TODO: JAH: At this point ...
            %{
            obj.neural_entities  = obj.entity_info.getNeuralEntities(); 
            
            obj.event_entities   = obj.entity_info.getEventEntities();
            
            obj.segment_entities = obj.entity_info.getSegmentEntities();
            %}
        end
        function delete(obj)
            try %#ok<TRYNC>
                %fprintf(2,'Deleting handle\n');
                ns_CloseFile(obj.h);
                %fprintf(2,'Deleted file\n');
                
                %These were coming before the mlock on the mex was put in
                %place
                %Input arguments must be a double scalar.
                %Call ns_SetLibrary first! Process interrupted!
            end
        end
    end
    
end

