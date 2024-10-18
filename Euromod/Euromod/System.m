classdef System < Core% < utils.redefinesparen & utils.CustomDisplay
    properties (Access=public,Hidden=true) % (Access=?utils.redefinesparen) 
        % model
        % index (:,1) double
        % orderArr (:,1) string
        % indexArr (:,1) double
        % paren struct

        indexArr (:,1) double
        parent Country
        Info struct
        index (:,1) double
        policiesClass
        datasetsClass
        % datasetsClass System 
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.SYS)
    end

    properties (Access=public) 
        % index (:,1) double
        bestmatchDatasets % DatasetInSystem
        comment (1,1) string
        currencyOutput (1,1) string
        currencyParam (1,1) string
        datasets % DatasetInSystem
        ID (1,1) string
        headDefInc (1,1) string
        name (1,1) string
        policies % PolicyInSystem
        private (1,1) string
        order (1,1) string
        year (1,1) string
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
                obj = System;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = System;
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
        
        function obj = System(Country)

            % obj.bestmatchDatasets = 'System datasets with best match.';
            % obj.comment = 'Comment about the system.';
            % obj.currencyOutput = 'Currency of the simulation output.';
            % obj.currencyParam = 'Currency of the model parameters.';
            % obj.datasets = 'System datasets.';
            % obj.ID = 'System identifier number.';
            % obj.headDefInc = 'Main income definition.';
            % obj.name = 'Name of the system.';
            % obj.policies = 'System policies.';
            % obj.private = 'System access type.';
            % obj.order = 'System order number/year.';
            % obj.year = 'System year.';


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
            obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));
     
            % set index
            obj.indexArr = 1:obj.Info.Handler.Count;
            % obj.orderArr=string(obj.indexArr);
            obj.index = obj.indexArr;

            % obj.load(Country);


        end

        function set.index(obj,value)
            obj.index=value;
        end

        function x=get.index(obj)
            x=obj.index;
        end

        % function obj = load(obj, parent)
        %     % set parent
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        %     Idx=obj.parent.index;
        % 
        %     % set handler
        %     obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));
        % 
        %     % set index
        %     obj.indexArr = 1:obj.Info.Handler.Count;
        %     obj.orderArr=string(obj.indexArr);
        %     obj.index = obj.indexArr;
        % end

        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
            
            [values,keys]=utils.getInfo(obj.Info.Handler,obj.index,name);
            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end

        function x=get.bestmatchDatasets(obj)
            % if isempty(obj.datasets)
            %     x=obj.datasets;
            %     return;
            % end
            bm=obj.datasets(1:end).bestMatch;
            bm=find(ismember(bm,"yes"));
            x= copy(obj.datasets);
            x=x(bm);
            x.indexArr=bm;
        end

        %==================================================================
        function x=get.policies(varargin)
            obj=varargin{1};

            if size(obj.policiesClass,1)==0
                obj.policiesClass=PolicyInSystem(obj);
                x=obj.policiesClass;
            else
                if all(obj.policiesClass.parent.index == obj.index)
                    x=obj.policiesClass;
                    x.index=obj.policiesClass.indexArr;
                else
                    obj.policiesClass=PolicyInSystem(obj);
                    x=obj.policiesClass;
                end
            end
        end

        %==================================================================
        function x=get.datasets(varargin)
            obj=varargin{1};

            if size(obj.datasetsClass,1)==0
                obj.datasetsClass=DatasetInSystem(obj);
                x=obj.datasetsClass;
            else
                if obj.datasetsClass.parent.index == obj.index
                    x=obj.datasetsClass;
                    x.index=obj.datasetsClass.indexArr;
                else
                    obj.datasetsClass=DatasetInSystem(obj);
                    x=obj.datasetsClass;
                end
            end
        end

        %==================================================================
        function x=headerComment(obj,varargin)
            N=size(obj,1);
            x=obj.getOtherProperties(["name","comment"],1:N)';
        end

    end

end