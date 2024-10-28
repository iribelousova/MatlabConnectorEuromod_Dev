function [values,keys] = setValueByKey(values,keys,valuesIn,keysIn,columnIndex)
% values - (m,1) string. Values to be updated
% keys - (1,m) string. Keys of the values to be updated

if isempty(keys)
    keys=strings(0,1);
else
    if size(keys,1)<size(keys,2) 
        keys=keys';
    end
end

if isempty(keysIn)
    keysIn=strings(0,1);
else
    if size(keysIn,1)<size(keysIn,2) 
        keysIn=keysIn';
    end
end

keysAdd=keysIn(~ismember(keysIn,keys));

if ~isempty(keysAdd)
    keys=[keys;keysAdd];
end
[a,b]=ismember(keys,keysIn);
b(b==0)=[];
values=[values;strings(numel(a)-size(values,1),size(values,2))];
if nargin > 4
    values(a,columnIndex)=valuesIn(b,:);
else
    values(a,:)=valuesIn(b,:);
end
end