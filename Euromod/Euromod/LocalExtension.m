classdef LocalExtension < Core % < utils.redefinesparen & utils.CustomDisplay
    properties (Access=public,Hidden=true) % (Access=?utils.redefinesparen) 
        % model
        % index (:,1) double
        % orderArr (:,1) string
        % indexArr (:,1) double

        indexArr (:,1) double
        parent 
        Info struct
        index (:,1) double
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.ReadCountryOptions.LOCAL_EXTENSION)
        % tag = char(EM_XmlHandler.TAGS.LOCAL_EXTENSION)
    end

    properties (Access=public) 
        ID (1,1) string
        name (1,1) string
        shortName (1,1) string
    end

    methods (Static, Access = public)
        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = LocalExtension;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = LocalExtension;
            end
        end
    end

    methods
        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end

        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end
        
        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        
        function obj = LocalExtension(Country)

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            % set parent
            obj.parent=copy(Country);
            obj.parent.indexArr=obj.parent.index;
            Idx=obj.parent.index;

            % set handler
            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(Tag);
     
            % set index
            obj.indexArr = 1:obj.Info.Handler.Count+obj.parent.parent.extensions.Info.Handler.Count;
            obj.index=obj.indexArr;

            % obj.load(Country);


        end

        % function obj = load(obj, parent)
        %     % set parent
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        %     Idx=obj.parent.index;
        % 
        %     % set handler
        %     Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
        %     obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(Tag);
        % 
        %     % set index
        %     obj.indexArr = 1:obj.Info.Handler.Count+obj.parent.parent.extensions.Info.Handler.Count;
        %     obj.index=obj.indexArr;
        % end

        % function x=handler(obj)
        %     [Idx,pobj]=getParenIndex(obj,"COUNTRY");
        %     x=pobj.model(Idx).H.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));
        % end

        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            values=strings(numel(name),size(obj,1));
            keys=name;

            % get index for local extensions
            idx=ismember(obj.index,1:obj.Info.Handler.Count);
            if sum(idx)==obj.Info.Handler.Count
                idxLocalVal=obj.index(idx);
                idxLocal=obj.index(idx);
            elseif sum(idx)<obj.Info.Handler.Count && sum(idx)~=0
                idxLocal=obj.index(idx);
                idxLocalVal=1:sum(idx);
            elseif sum(idx)==0
                idxLocal=[];
            end

            % get index for model extensions
            idx=~ismember(obj.index,idxLocal);
            if sum(idx)==obj.parent.parent.extensions.Info.Handler.Count
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
            elseif sum(idx)<obj.parent.parent.extensions.Info.Handler.Count && sum(idx)~=0
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
                if isempty(idxLocal)
                    ini=0;
                else
                    ini=idxLocalVal;
                end
                idxModelVal=ini+1:sum(idx)+ini;
            elseif sum(idx)==0
                idxModel=[];
            end

            % try get info from country extensions
            if ~isempty(idxLocal)
                [v,k]=utils.getInfo(obj.Info.Handler,idxLocal,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxLocalVal);
            end

            % try get info from model extensions
            if ~isempty(idxModel)
                [v,k]=utils.getInfo(obj.parent.parent.extensions.Info.Handler,idxModel,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxModelVal);
            end

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end

        %------------------------------------------------------------------
        function x=headerComment(obj)
            x=obj.headerComment_Type1("name");
        end

    end

end