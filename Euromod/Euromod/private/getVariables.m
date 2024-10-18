function variables = getVariables(varnams)
% getVariables Get c# list of names.
% Private method of the TaxSystem class object.
%
%   Syntax:
%
%   variables = getVariables(varnams)
%
%   Input Arguments:
%    varnams - cell. Cell array with names of type string or char.
%
%   Oputput:
%    variables - c# list of strings.
%
% See also getConstantsToOverwrite, getDataArray, getConfigsettings, TaxSystem.

m = length(varnams);
variables = NET.createGeneric('System.Collections.Generic.List',{'System.String'}, m);
for i = 1:m
    variables.Add(string(varnams(i)))
    % disp(variables.Item(i))
end

end