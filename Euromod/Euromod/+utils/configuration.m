classdef configuration < handle %< utils.DynPropHandle 
    % assembly Load the Euromod model DLL assemblies. All the methods return c#
    % objects.
    % Static class.
    %
    % Properties:
    %   DLL_PATH - char or string. Full path to folder with DLLs.
    %
    %   DLL_Common - char or string. Name (with dll extension).
    %
    %   DLL_XmlHandler - char or string. Name (with dll extension).
    %
    %   DLL_Executable - char or string. Name (with dll extension).
    %
    % See also assembly, Country, TaxSystem, Simulation

    properties (Constant, Hidden)
        DLL_PATH = fullfile(fileparts(fileparts(mfilename('fullpath'))), "libs");
        DLL_Common = "EM_Common.dll" ;
        DLL_XmlHandler = "EM_XmlHandler.dll";
        DLL_Executable = "EM_Executable.dll" ;
    end

end

