function [values,keys]=convert1D(obj,varargin)

% if ~isa(obj,'System.Collections.Generic.Dictionary<System*String,System*String>')
%     error('Object must be of type "Dictionary<System*String,System*String>".')
% end

if nargin == 2 
    keys = string(varargin{1});
    if isempty(keys)
        d=obj.dictionary;
        keys = d.keys('cell');
        keys=cellfun(@string,keys);
    end
else
    d=obj.dictionary;
    keys = d.keys('cell');
    keys=cellfun(@string,keys);
end

% values = d.values('cell');
% values=cellfun(@string,values);

N=numel(keys);
values=strings(N,1);
for i=1:N
    try
        values(i)=string(EM_XmlHandler.XmlHelpers.RemoveCData(obj.Item(keys(i))));
    catch
        % values(i)=string;
    end
end

idx=values~="";
values=values(idx);
keys=keys(idx);



% if ~isempty(prop)
%     prop=string(prop);
%     if ~isempty(prop)
%         N=numel(prop);
%         if N==1
%             values=string(EM_XmlHandler.XmlHelpers.RemoveCData(obj.Item(prop)));
%         else
%             values=strings(N,1);
%             for i=1:N
%                 values(i)=string(EM_XmlHandler.XmlHelpers.RemoveCData(obj.Item(prop(i))));
%             end
%         end
%         keys=prop;
%     end
% 
% else
% 
%     d=obj.dictionary;
% 
%     keys = d.keys('cell');
%     keys=cellfun(@string,keys);
%     values=d.values('cell');
%     values=cellfun(@string,values);
% 
%     values = arrayfun(@(t) string(EM_XmlHandler.XmlHelpers.RemoveCData(t)),values,'UniformOutput',false);
% end
% 
% if iscell(values)
%     values=string(values);
% end

end


% 
% tic
% keys = d.keys('cell');
% keys=cellfun(@string,keys);
% values=d.values('cell');
% values=cellfun(@string,values);
% it=ismember(prop,keys);
% values=values(it);
% values = arrayfun(@(t) string(EM_XmlHandler.XmlHelpers.RemoveCData(t)),values,'UniformOutput',false);
% toc
% 
% 
% tic
% keys = d.keys('cell');
% keys=cellfun(@string,keys);
% values=strings(N,1);
% for i=1:N
%     values(i)=string(EM_XmlHandler.XmlHelpers.RemoveCData(obj.Item(prop(i))));
% end
% toc






% if nargin == 2 
%     prop = varargin{1};
% else
%     prop={};
% end
% 
% if ~isempty(prop)
%     prop=string(prop);
%     prop=prop(arrayfun(@(t) obj.ContainsKey(t), prop));
%     if ~isempty(prop)
%         if numel(prop)==1
%             out=string(obj.Item(prop));
%             out=char(EM_XmlHandler.XmlHelpers.RemoveCData(out));
%         else
%             out=struct();
%             for i=1:numel(prop)
%                 out.(prop(i))=string(obj.Item(prop(i)));
%             end
%             out = structfun(@(t) char(EM_XmlHandler.XmlHelpers.RemoveCData(t)),out,'UniformOutput',false);
%         end
%     end
% 
% else
% 
%     d=obj.dictionary;
% 
%     dk = d.keys('cell');
%     dk=cellfun(@string,dk);
%     dv=d.values('cell');
%     dv=cellstr(cellfun(@string,dv));
% 
%     out = cell2struct(dv,dk);
%     out = structfun(@(t) char(EM_XmlHandler.XmlHelpers.RemoveCData(t)),out,'UniformOutput',false);
% end