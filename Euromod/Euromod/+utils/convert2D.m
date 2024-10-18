function [values,keys]=convert2D(obj,varargin)
% convert2D - Convert c# dictionary of dictionary
%
% Syntax:
%
%     [values,keys]=convert2D(obj)
%     [values,keys]=convert2D(obj,index)
%     [values,keys]=convert2D(obj,index,properties)
%
% Description:
%     Convert c# object:
%     'System.Collections.Generic.Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>'.
%
% Input Arguments:
%     index     : (1,n) char,string,numeric,':'. Key(s) of the dictionary 
%                 (i.e. ID(s)), or their index.
%     properties: (1,m) string,char. Key(s) of the sub-dictionary.
%
% Oputput Arguments:
%     values    : (m,n) string. Values of the sub-dictionary.
%     keys      : (1,m) string. Keys of the sub-dictionary.
%
% See also convert1D.

if ~isa(obj,'System.Collections.Generic.Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>')
    error('Object must be of type "Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>".')
end

d=obj.dictionary;

if nargin>1
    index=varargin{1};
    if isnumeric(index)
        dk = d.keys('cell');
        dka=dk(index);
        dka=cellfun(@string,dka);
    elseif ischar(index) || isstring(index)
        if strcmp(index,':')
            dka = d.keys('cell');
            dka=cellfun(@string,dka);
        else
            dka=string(index);
        end
    end
else
    dka = d.keys('cell');
    dka=cellfun(@string,dka);
end

if nargin>2
    prop = varargin(2);
else
    prop={};
end

if ~isempty(prop) & numel(string(prop{:}))==1 & strcmp('ID',prop{:})
    values=dka';
    keys="ID";
else
    N=numel(dka);
    d=obj.Item(dka(1));
    [v,keys]=utils.convert1D(d,prop{:});
    Nk=numel(keys);
    values=strings(Nk,N);
    values(:,1)=v;
    for i=2:N
        d=obj.Item(dka(i));
        [v,k]=utils.convert1D(d,prop{:});

        [it,jt] = ismember(k,keys);
        if ~(all(it))
            temp=strings(numel(k),N);
            temp(it,:)=values(jt(it),:);
            temp(:,i)=v;
            values=temp;
            keys=k;
            clear temp
        else
            [it,jt]=ismember(keys,k);
            values(it,i) = v(jt(it));
        end
    end

    % ii=cell2mat(arrayfun(@(t) all(ismissing(values(:,t))), 1:N, 'UniformOutput', false));
    % 
    % values=values(:,~ii);



    % values=~ismissing(values)
    % ismissing(IDs)

    % out=convert1D(d,prop{:});
    % for i=2:numel(dka)
    %     d=obj.Item(dka(i));
    %     d=convert1D(d,prop{:});
    %     if isstruct(out) && isempty(prop)
    %         out=compare(d,out);
    %         d=compare(out,d);
    %     elseif ischar(out)
    %         out=string(out);
    %     end
    %     out(i)=d;
    % end
end

% if isstring(out)
%     out=out';
% end

% function S2=compare(S1,S2)
%     if ~all(ismember(fieldnames(S1),fieldnames(S2)))
%         idx=find(~ismember(fieldnames(S1),fieldnames(S2)));
%         f=fieldnames(S1);
%         v=cellstr(strings(1,numel(S2)));
%         for j=1:numel(idx)
%             [S2.(f{idx(j)})]=v{:};
%         end
%     end
% end

end














% function out=convert2D(obj,varargin)
% 
% % if ~isa(obj,'System.Collections.Generic.Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>')
% %     error('Object must be of type "Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>".')
% % end
% 
% d=obj.dictionary;
% 
% if nargin>1
%     index=varargin{1};
%     if isnumeric(index)
%         dk = d.keys('cell');
%         dka=dk(index);
%         dka=cellfun(@string,dka);
%     elseif ischar(index) || isstring(index)
%         if strcmp(index,':')
%             dka = d.keys('cell');
%             dka=cellfun(@string,dka);
%         else
%             dka=string(index);
%         end
%     end
% else
%     dka = d.keys('cell');
%     dka=cellfun(@string,dka);
% end
% 
% if nargin>2
%     prop = varargin(2);
% else
%     prop={};
% end
% 
% if numel(prop{:})==1 & ismember('ID',prop{:})
%     values=dka;
%     keys="ID";
% else
%     N=numel(dka);
%     values=strings(1,N);
%     values(:,1)
%     for i=1:N
%         d=obj.Item(dka(i));
%         [v,k]=convert1D(d,prop{:});
%     end
% 
% 
%     out=convert1D(d,prop{:});
%     for i=2:numel(dka)
%         d=obj.Item(dka(i));
%         d=convert1D(d,prop{:});
%         if isstruct(out) && isempty(prop)
%             out=compare(d,out);
%             d=compare(out,d);
%         elseif ischar(out)
%             out=string(out);
%         end
%         out(i)=d;
%     end
% end
% 
% if isstring(out)
%     out=out';
% end
% 
% function S2=compare(S1,S2)
%     if ~all(ismember(fieldnames(S1),fieldnames(S2)))
%         idx=find(~ismember(fieldnames(S1),fieldnames(S2)));
%         f=fieldnames(S1);
%         v=cellstr(strings(1,numel(S2)));
%         for j=1:numel(idx)
%             [S2.(f{idx(j)})]=v{:};
%         end
%     end
% end
% 
% end