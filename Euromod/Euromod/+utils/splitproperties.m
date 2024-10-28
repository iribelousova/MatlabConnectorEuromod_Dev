function [strProps,objProps]=splitproperties(obj)

% defaultProps=string(properties(obj));
strProps=strings(1,0);
objProps=strings(1,0);
% userProp=defaultProps;

meta=metaclass(obj);
% hidden=cell2mat({meta.PropertyList.Hidden});
% 
% Names={meta.PropertyList(~hidden).Name};
% Validation={meta.PropertyList(~hidden).Validation};
% idx=~arrayfun(@(t) isempty(Validation{t}),1:numel(Validation));
% Validation = Validation(idx);
% Names = Names(idx);
% 
% ip=find(ismember(Names,defaultProps));
% Names=Names(ip);
% Validation=Validation(ip);
% N=numel(Names);

% 
% % inull = ~cellfun(@isempty, Validation);
% % ip=ip(inull);
% try
%     classname=arrayfun(@(t) char(Validation{t}.Class.Name),1:N,'UniformOutput',false);
% catch
%     error("InvalidParameter: ")
% end
% 
% for i=1:N
% 
%     cl=classname{i};
% 
%     if strcmp(cl,'string')
%         strProps=[strProps,string(Names{i})];
%     elseif strcmp(cl(1),upper(cl(1))) && ~strcmp(cl,'double')
%         objProps=[objProps,string(Names{i})];
%     end
% 
% end
allprops=unique([string({meta.PropertyList.Name}),string(properties(obj))']);
allobjprops=["systems","policies","datasets","extensions","parameters",...
    "local_extensions","parent","countries","functions","bestmatchDatasets"];
for i=1:numel(allprops)
    m = findprop(obj,allprops(i));
    if ~m.Hidden
        if isempty(m.Validation) 
            if ismember(m.Name,allobjprops)
                objProps=[objProps,string(m.Name)];
            else
                strProps=[strProps,string(m.Name)];
            end
            % if contains(m.Name,"ID")
            %     strProps=[strProps,string(m.Name)];
            % else
            %     objProps=[objProps,string(m.Name)];
            % end
        else
            if strcmp("string",m.Validation.Class.Name)
                strProps=[strProps,string(m.Name)];
            elseif ~strcmp("string",m.Validation.Class.Name) && ~strcmp("struct",m.Validation.Class.Name)...
                    && ~strcmp("double",m.Validation.Class.Name) && ~strcmp("cell",m.Validation.Class.Name)
                objProps=[objProps,string(m.Name)];
            end
        end
    end
end

end