function setLibrary(dll_path)
%
%   neuroshare.setLibrary(dll_path)
%

%TODO: Move the neuroshare class as a static method

result_code = ns_SetLibrary(dll_path);

neuroshare.handleError(result_code)
end