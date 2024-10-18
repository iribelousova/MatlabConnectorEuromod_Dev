classdef FunctionInSystem < Function

    properties (Access=public)         
        funID (1,1) string
        Switch (1,1) string
        sysID (1,1) string
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
                obj = FunctionInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = FunctionInSystem;
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
        
        function obj = FunctionInSystem(PolicyInSystem)

            obj = obj@Function;

            if nargin == 0
                return;
            end

            if isempty(PolicyInSystem)
                return;
            end

            obj.load(PolicyInSystem);

        end


        %------------------------------------------------------------------
        function obj = load(obj, parent)
            % load super class 
            obj = obj.load@Function(parent);             
            
            % % set parent
            % obj.parent=copy(parent);
            % parent.indexArr=parent.index;

        end

        % function x=headerComment(obj,varargin)
        % 
        %     x=obj.headerComment_Type1();
        % 
        %     % N=size(obj,1);
        %     % % get object comment property value
        %     % x=getOtherProperties(obj,{'name','Switch','comment'},obj.index);
        %     % if size(x,2)==N
        %     %     x=x';
        %     % end
        %     % 
        %     % % nams=obj.getOtherProperties('name',1:N)';
        %     % % 
        %     % % middlecom =  obj.getOtherProperties('Switch',obj.index)';
        %     % 
        %     % % bk = arrayfun(@(t) numel(char(t)),com_p);
        %     % % bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+1,'UniformOutput',false));
        %     % 
        %     % % x = append(com_p(:,1), bk(:,1), '| ',com_p(:,2), bk(:,2), '| ',com_p(:,2), bk(:,2));
        %     % % 
        %     % % % cut text if too long
        %     % % l=arrayfun(@(t) numel(char(t)),x);
        %     % % x=arrayfun(@(t) extractBefore(x(t), min(l(t),133)),1:N)';    
        % 
        % end

    end
end