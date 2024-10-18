classdef Dataset < Core %utils.redefinesparen & utils.CustomDisplay
    properties (Access=public,Hidden=true) % (Access=?utils.redefinesparen) 
        % model
        index (:,1) double
        indexArr (:,1) double
        Info struct
        parent
    end

    properties (Constant, Hidden)
        % tag = char(EM_XmlHandler.ReadCountryOptions.DATA)
        tag = char(EM_XmlHandler.TAGS.DATA);
    end

    properties (Access=public) 
        coicopVersion (1,1) string
        comment (1,1) string
        currency (1,1) string
        decimalSign (1,1) string
        ID (1,1) string
        listStringOutVar (1,1) string
        name (1,1) string
        private (1,1) string
        readXVariables (1,1) string
        useCommonDefault (1,1) string
        yearCollection (1,1) string
        yearInc (1,1) string
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
                obj = Dataset;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Dataset;
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
        
        function obj = Dataset(Country)

            % obj.coicopVersion = 'COICOP version.';
            % obj.comment = 'Comment about the dataset.';
            % obj.currency = 'Currency of the monetary values in the dataset.';
            % obj.decimalSign = 'Decimal sign.';
            % obj.ID = 'Dataset identifier number.';
            % obj.name = 'Name of the dataset.';
            % obj.private = 'Dataset access type.';
            % obj.readXVariables = 'Read variables.';
            % obj.useCommonDefault = 'Use default.';
            % obj.yearCollection = 'Year of the dataset collection.';
            % obj.yearInc = 'Reference year for the income variables.';

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            obj.load(Country);

        end

        function obj = load(obj, parent)

            % set parent
            obj.parent=copy(parent);
            obj.parent.indexArr=obj.parent.index;

            % get country class
            if isa(obj.parent,'Country')
                cobj=copy(obj.parent);
            else
                cobj=copy(obj.parent.getParent("COUNTRY"));
            end
            Idx = cobj.index;
            
            % % get country handler
            % cobj=copy(parent.getParent("COUNTRY"));
            % Idx = cobj.index;

            % set handler
            obj.Info(1).Handler = cobj.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));
     
            % % set parent
            % obj.parent=copy(parent);
            % obj.parent.indexArr=obj.parent.index;

            % set index
            obj.indexArr = 1:obj.Info.Handler.Count;
            obj.index=obj.indexArr;
        end

        function [values,keys]=getOtherProperties(obj,name,index)
            [values,keys]=obj.getOtherProperties_Type1(name);

        end

        function x=headerComment(obj,varargin)
            N=size(obj,1);
            x=obj.getOtherProperties(["name","comment"],1:N)';
        end

    end


end