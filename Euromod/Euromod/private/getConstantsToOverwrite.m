function cto = getConstantsToOverwrite(constantsToOverwrite)
% getConstantsToOverwrite Get c# dictionary.
% Private method of the TaxSystem class object.
%
%   Syntax:
%
%   cto = getConstantsToOverwrite(constantsToOverwrite)
%
%   Input Arguments:
%    constantsToOverwrite - nx2 cell. First column is 1x2 string array,
%       second column is 1x1 string or char.
%
%   Oputput:
%    cto - c# dictionary of tuples and strings.
%
%   Examples:
%    constantsToOverwrite = {'$tscsi00','0.95'}
%    constantsToOverwrite = {"$tscsi00",'0.95'}
%    constantsToOverwrite = {["$tscsi00"],'0.95'}; % HR
%    constantsToOverwrite = {["$tscsi00",""],'0.95'}; % HR
%    constantsToOverwrite = {["$tscsi00",[]],'0.95'}; % HR
%    constantsToOverwrite = {["$IncGrALim","1"],'0#m'}; % FR
%    constantsToOverwrite={["$f_h_cpi","2022"], '1000'}  % PL
%    constantsToOverwrite={["$f_pens","2022"], '86.8581';["$f_pens","2023"], '99.886815'}
%    constantsToOverwrite={["$f_pens"], '86.8581';["$f_pens",""], '99.886815'}
% See also getVariables, getDataArray, getConfigsettings, TaxSystem.

    keys = NET.GenericClass('System.Tuple','System.String', 'System.String');
    cto = NET.createGeneric('System.Collections.Generic.Dictionary', {keys, 'System.String'});

    if ~isempty(constantsToOverwrite)
        [m, n] = size(constantsToOverwrite); 

        for i = 1:m 
            try
                [key1, key2] = constantsToOverwrite{i}{:};
                if (isempty(key2)) || (sum(isspace(key2)) == length(key2))
                    key2 = "-2147483648";
                end
            catch
                try
                    key1 = constantsToOverwrite{i}{:};
                    key2 = "-2147483648";   
                catch
                    key1 = constantsToOverwrite{i,1};
                    key2 = "-2147483648";   
                end
            end
            value = constantsToOverwrite{i,2};  
            value = string(value);
            key2 = string(key2);
            csharpkey = NET.createGeneric('System.Tuple',...
                            {'System.String','System.String'}, key1,key2);
            cto.Add(csharpkey,value)
        end
    end
end