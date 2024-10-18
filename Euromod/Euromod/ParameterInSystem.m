classdef ParameterInSystem < Parameter

    properties (Access=public)         
        parID (1,1) string
        value (1,1) string
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
                obj = ParameterInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = ParameterInSystem;
            end

        end
    end


    methods
        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        
        function obj = ParameterInSystem(FunctionInSystem)

            obj = obj@Parameter;

            if nargin == 0
                return;
            end

            if isempty(FunctionInSystem)
                return;
            end

            obj.load(FunctionInSystem);

        end


        %------------------------------------------------------------------
        function obj = load(obj, parent)
            % load super class 
            obj = obj.load@Parameter(parent);   

            % % set parent
            % obj.parent=copy(parent);
            % parent.indexArr=parent.index;

        end

        function x=headerComment(obj,varargin)

            propertynames=["name","value","comment"];
            x=headerComment_Type1(obj,propertynames);

            % N=size(obj,1);
            % % get object comment property value
            % com_p=getOtherProperties(obj,'comment',1:N);
            % if size(com_p,2)==N
            %     com_p=com_p';
            % end
            % 
            % middlecom =  obj.getOtherProperties('Switch',obj.index)';
            % 
            % bk = arrayfun(@(t) numel(char(t)),middlecom);
            % bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+1,'UniformOutput',false));
            % 
            % x = append(middlecom, bk, '| ',com_p);
            % 
            % % cut text if too long
            % l=arrayfun(@(t) numel(char(t)),x);
            % x=arrayfun(@(t) extractBefore(x(t), min(l(t),133)),1:N)';    

        end

    end
end