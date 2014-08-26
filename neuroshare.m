classdef neuroshare
    %
    %   Class:
    %   neuroshare
    
    properties (Constant)
        DLLS_64BIT = {
            'nsCedSon64.dll'}
        DLLS_32BIT = {
            'nsCedSon32.dll'}
    end
    
    methods (Static,Hidden)
        %TODO: Have a function that summarizes the dlls
        function autoLoadLibrary(file_path)
            %TODO: Implement this function
            %
            %    ???? - how should we link dlls into the code?
            %
            
            %TODO: This should be in the sl.os package
            is_64_bit = any(strfind(computer,'64'));
            
            [~,~,file_extension] = fileparts(file_path);
            switch file_extension
                case {'.son','.smr'}
                    if is_64_bit
                        dll_name = 'nsCedSon64.dll';
                    else
                        dll_name = 'nsCedSon32.dll';
                    end
                otherwise
                    error('File extension: %s does not currently have a dll installed',file_extension)
            end
            root_path = neuroshare.sl.stack.getMyBasePath();
            dll_path  = fullfile(root_path,'dlls',dll_name);
            
            neuroshare.setLibrary(dll_path);
        end
        function handleError(result_code)
            %
            %   neuroshare.handleError(result_code)
            
            %TODO: Implement all errors, see header
            %
            %   TODO: Allow checking if is error - perhaps via another
            %   function ...
            
            switch result_code
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
        end
    end
    
end

