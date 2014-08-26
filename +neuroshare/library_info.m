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

%{
From V1.3

typedef struct {
uint32 dwLibVersionMaj; // Major version number of this library.
uint32 dwLibVersionMin; // Minor version number of this library.
uint32 dwAPIVersionMaj; // Major version number of API specification that library complies with
uint32 dwAPIVersionMin; // Minor version number of API specification that library complies with
char szDescription[64]; // Text description of the library.
char szCreator[64]; // Name of library creator.
uint32 dwTime_Year; // Year of last modification date
uint32 dwTime_Month; // Month (1-12; January = 1) of last modification date
uint32 dwTime_Day; // Day of the month (1-31) of last modification date
uint32 dwFlags; // Additional library flags.
uint32 dwMaxFiles // Maximum number of files library can simultaneously open.
uint32 dwFileDescCount; // Number of valid description entries in the following array.
ns_FILEDESC FileDesc[16]; // Text descriptor of files that the DLL can interpret.
} ns_LIBRARYINFO;

Remarks
Flags defined at this time are:
#define ns_LIBRARY_DEBUG 0x01 // includes debug info linkage
#define ns_LIBRARY_MODIFIED 0x02 // file was patched or modified
#define ns_LIBRARY_PRERELEASE 0x04 // pre-release or beta version
#define ns_LIBRARY_SPECIALBUILD 0x08 // different from release version
#define ns_LIBRARY_MULTITHREADED 0x10 // library is multithread safe
The dwFileDescCount and FileDesc fields provide a method for the library to describe
the file types that it is capable of opening. The ns_LIBRARYINFO structure provides
room for up to 16 file types. The number of valid ns_FILEDESC structures are reported
in dwFileDescCount. Unused ns_FILEDESC structures should be set to all zeros or not
returned.
Neural Event Files File formats that consist of pools of files in a directory that belong to a
single data set should be opened with an index file or one of the pool member files.
typedef struct {
char szDescription[32]; // Text description of the file type or file family
char szExtension[8]; // Extension used on PC, Linux, and Unix Platforms.
char szMacCodes[8]; // Application and Type Codes used on Mac Platforms.
char szMagicCode[16]; // null-terminated code used at the file beginning.
} ns_FILEDESC;

%}
