classdef neuroshare
    %
    %   Class:
    %   neuroshare
    
    properties
    end
    
    methods (Static,Hidden)
        function autoLoadLibrary(file_path)
            %TODO: Implement this function
            %
            %    ???? - how should we link dlls into the code?
            %    
            
            [~,~,file_extension] = fileparts(file_path);
            switch file_extension
                case 'son'
                    dll_path = '';
            end
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

