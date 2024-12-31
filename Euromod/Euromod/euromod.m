function out=euromod(varargin)
% euromod - Load the microsimulation model EUROMOD.
% 
% Syntax:
% 
%     mod = euromod(model_path);
% 
% Description:
%     Instantiates a base class |Model| with the microsimulation model 
%     EUROMOD.
% 
% Input Arguments:
%     model_path - (1,1) string. Path to the EUROMOD project.
% 
% Output Arguments:
%     mod - (1,1) class. The EUROMOD base class |Model|.
% 
% See also Model, Country, System, Policy, Function, Parameter, Simulation, 
% info, run.

NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_XmlHandler));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Common));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Executable));
 
if nargin ==0
    out=Model;
    return;
end
        
out=Model(varargin{:});

end

