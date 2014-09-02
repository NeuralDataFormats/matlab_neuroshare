function file_object = readFile(file_path)
%
%   file_object = neuroshare.readFile(file_path)
%

if nargin == 0
    %TODO: We could eventually have an enumeration of supported
    %file types ...
    [file_name,path_name] = uigetfile({'*.*','All Files (*.*)'},'Pick a file to open');
    
    if isnumeric(file_name)
        file_object = [];
    end
    file_path = fullfile(path_name,file_name);
end

file_object = neuroshare.file(file_path);

end