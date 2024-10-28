classdef Policy < PolicyHandle
    % Policy - A class with the policy rules modeled in a country.
    %
    % Syntax:
    %
    %     P = Policy(Country);
    %
    % Description:
    %     This class contains the information about all the country policies.
    %     It is stored in the property policies of the Country class.
    %
    %     This class contains subclasses of type ExtensionSwitch and
    %     Function.
    %
    %     This class serves also as a superclass for the PolicyInSystem
    %     subclass.
    %
    % Policy Arguments:
    %     Country    - A class containing the EUROMOD country-specific
    %                  tax-benefit model.
    %
    % Policy Properties:
    %     comment    - Comment specific to the policy.
    %     extensions - ExtensionSwitch class with the policy extensions.
    %     functions  - Function class with the policy functions.
    %     ID         - Identifier number of the policy.
    %     name       - Name of the policy.
    %     order      - Order of the policy in the specific spine.
    %     parent     - The country-specific class.
    %     private    - Access type.
    %     spineOrder - Order of the policy in the spine.
    %
    %  Example:
    %         mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %         mod.('AT').policies % displays the default policies for Austria
    %         mod.('AT').policies(5) % displays the specific policy for Austria.
    %
    % See also Model, Country, ReferencePolicy, PolicyInSystem,
    %          PolicyHandle, info, run.

    properties (Access=public)
        comment (1,1) string % Comment specific to the policy.
        functions Function % Function class with the policy functions.
        private (1,1) string % Access type.
    end

    properties (Hidden)
        functionsClass Function % Function class with the policy functions.
    end

    methods (Static, Hidden)
        %==================================================================
        function x=tag
            % tag - get the Policy class tag.
            x=char(EM_XmlHandler.TAGS.POL);
        end
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty Policy class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)
            if nargin == 0
                obj = Policy;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Policy;
            end

        end
    end
    methods
        %==================================================================
        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end
        %==================================================================
        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end
        %==================================================================
        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        %==================================================================
        function obj = Policy(Country)
            % Policy - A class with the policy rules modeled in a country.

            obj=obj@PolicyHandle;

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            obj.load(Country);

        end
        %==================================================================
        function x=get.functions(varargin)
            % functions - Get the policy Function class array.
            
            obj=varargin{1};

            % Reference policies do not have the 'functions' property.
            if strcmp(class(obj),'ReferencePolicy')
                x=obj;
                return;
            end

            if size(obj.functionsClass,1)==0
                if strcmp(class(obj),'Policy')
                    obj.functionsClass=Function(obj);
                elseif strcmp(class(obj),'PolicyInSystem')
                    obj.functionsClass=FunctionInSystem(obj);
                end
                x=obj.functionsClass;
            else
                if all(obj.functionsClass.parent.index == obj.index)
                    x=obj.functionsClass;
                    x.index=obj.functionsClass.indexArr;
                else
                    if strcmp(class(obj),'Policy')
                        obj.functionsClass=Function(obj);
                    elseif strcmp(class(obj),'PolicyInSystem')
                        obj.functionsClass=FunctionInSystem(obj);
                    end
                    x=obj.functionsClass;
                end
            end
        end
    end
    methods (Hidden)
        %==================================================================
        function initialize(obj,super)
            % initialize - Copy the objects from the super class.
            if nargin == 1
                super=Policy;
            end
            mc=metaclass(obj);
            mcSuper=metaclass(super);
            superProps=string({mcSuper.PropertyList.Name});
            props=string({mc.PropertyList.Name});
            for i=1:numel(props)
                if ~strcmp('tag',props(i)) && ismember(props(i),superProps)
                    obj.(props(i)) = super.(props(i));
                end
            end
        end
    end
end