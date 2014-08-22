classdef library_info < handle
    %
    %   Class:
    %   neuroshare.library_info
    %
    %   See Also:
    %   neuroshare.setLibrary
    
    properties
        lib_loaded = false %If true indicates that a dll has been loaded
        
%     LibVersionMaj: 1
%     LibVersionMin: 7
%     APIVersionMaj: 1
%     APIVersionMin: 3
%       Description: 'Library for Spike2 data'
%           Creator: 'Cambridge Electronic Design Ltd'
%         Time_Year: 2004
%        Time_Month: 11
%          Time_Day: 24
%             Flags: 'NONE'
%          MaxFiles: 64
%     FileDescCount: 2
%          FileDesc: [2x1 struct]
%
%
%ans = 
% 
%     Description: 'PC Spike2 file'
%       Extension: 'smr'
%        MacCodes: 'SPK2SON '
%       MagicCode: ''
% 
% huh.FileDesc(2)
% 
% ans = 
% 
%     Description: 'Mac Spike2 file'
%       Extension: 'son'
%        MacCodes: 'SPK2SON '
%       MagicCode: ''

    end
    
    methods
        function obj = library_info()
            [~, code_result, info_struct] = evalc('ns_GetLibraryInfo');
            
            
            if code_result == -1
                %No library loaded
                return
            end
            
            obj.lib_loaded = true;
            
            %NOTE: Without evalc a message is printed to the command window
            %in cases in which no library has been loaded.
            
            %ns_RESULT = Call ns_SetLibrary first! Process interrupted!
            %nsLibraryInfo = 
            %huh - ""
            keyboard

            %JAH: At this point
            
        end
    end
    
end

