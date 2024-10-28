function out=euromod(varargin)
% euromod - Load the microsimulation model EUROMOD.
% 
% Syntax:
% 
%     mod = euromod(model_path);
% 
% Description:
%     This class loads the base class Model with the microsimulation model 
%     EUROMOD.
% 
% Input Arguments:
%     model_path - (1,1) string. Path to the EUROMOD project.
% 
% Outout Arguments:
%     mod - class. Base class Model.
% 
% See also Model, Country, System, Policy, info, run.


NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_XmlHandler));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Common));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Executable));
          
out=Model(varargin{:});

end

