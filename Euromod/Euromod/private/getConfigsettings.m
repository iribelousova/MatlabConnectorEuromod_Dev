function cfs = getConfigsettings(configSettings)
% getConfigsettings Get c# configSettings.
% Private method of the TaxSystem class object.
%
%   Syntax:
%
%   cfs = getConfigsettings(configSettings)
%
%   Input Arguments:
%    configSettings - struct. Fieldnames are PATH_EUROMODFILES, PATH_DATA,
%       PATH_OUTPUT, ID_DATASET, ID_SYSTEM, COUNTRY. Values are of type
%       char or string. 
%
%   Oputput:
%    cfs - c# dictionary.
%
%   Example:
%
%    PATH_EUROMODFILES = "C:\...\EUROMOD_RELEASES_I6.0+";
%    PATH_DATA = "C:\...\All countries";
%    PATH_OUTPUT = "C:\...\EUROMOD_RELEASES_I6.0+\Output";
%    ID_DATASET = "PL_2020_b2.txt";
%    ID_SYSTEM = "PL_2022";
%    COUNTRY = "PL";   
%    confset = struct("PATH_EUROMODFILES", PATH_EUROMODFILES, ...
%                    "PATH_DATA", PATH_DATA, ...
%                    "PATH_OUTPUT", PATH_OUTPUT, ...
%                    "COUNTRY", COUNTRY, ...
%                    "ID_DATASET", ID_DATASET, ...
%                    "ID_SYSTEM", ID_SYSTEM);   
%
% See also getConstantsToOverwrite, getDataArray, getVariables, TaxSystem.

keys = fieldnames(configSettings);
m = length(keys);
cfs = NET.createGeneric('System.Collections.Generic.Dictionary',...
    {'System.String', 'System.String'});
for i = 1:m
    key = keys{i};
    value = configSettings.(keys{i});
    cfs.Add(key,value)
    % disp(configSettings.Item(key))
end

end