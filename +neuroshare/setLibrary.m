function setLibrary(dll_path)
%
%   neuroshare.setLibrary(dll_path)
%
%   I wanted to move this to being static for neuroshare but then
%   I can't access the private directory :/

result_code = ns_SetLibrary(dll_path);

neuroshare.handleError(result_code)
end