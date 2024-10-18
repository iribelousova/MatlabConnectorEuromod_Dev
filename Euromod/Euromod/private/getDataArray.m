function dataArr = getDataArray(df)
% getDataArray Get c# data.
% Private method of the TaxSystem class object.
%
%   Syntax:
%
%   dataArr = getDataArray(df)
%
%   Input Arguments:
%    df - table. The dataset to be transformed.
%
%   Oputput:
%    dataArr - c# array of doubles.
%
% See also getConstantsToOverwrite, getConfigsettings, getVariables, TaxSystem.

data = table2array(df);
data = transpose(data);
dataArr = NET.convertArray(data, 'System.Double');

end