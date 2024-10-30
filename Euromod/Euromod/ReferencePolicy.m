classdef ReferencePolicy < PolicyHandle
    % ReferencePolicy - A class with the reference policy rules modeled
    % in a country.
    %
    % Syntax:
    %
    %     R = ReferencePolicy(Country);
    %
    % Description:
    %     This class contains the information about all the country
    %     reference policies. It is stored in the property policies of
    %     the Country class.
    %
    %     This class contains subclasses of type ExtensionSwitch.
    %
    % ReferencePolicy Arguments:
    %     Country    - A class containing the EUROMOD country-specific
    %                  tax-benefit model.
    %
    % ReferencePolicy Properties:
    %     extensions - ExtensionSwitch class with the reference policy extensions.
    %     ID         - Identifier number of the reference policy.
    %     name       - Name of the reference policy.
    %     order      - Order of the reference policy in the specific spine.
    %     parent     - The country-specific class.
    %     refPolID   - Identifier number of the policy at the Country level.
    %     spineOrder - Order of the reference policy in the spine.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     mod.('AT').policies % displays the default policies for Austria
    %     mod.AT.policies(27) % displays the specific reference policy for Austria.
    %
    % See also Model, Country, Policy, PolicyInSystem, PolicyHandle, info,
    %          run.

    properties (Access=public)
        refPolID (1,1) string % Identifier number of the reference policy.
    end

    methods (Static, Hidden)
        %==================================================================
        function x=tag
            % tag - get the ReferencePolicy class tag.

            x=char(EM_XmlHandler.TAGS.REFPOL);
        end
    end
    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty ReferencePolicy class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = ReferencePolicy;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = ReferencePolicy;
            end
        end
    end
    methods
        %==================================================================
        function obj = ReferencePolicy(Country)
            % ReferencePolicy - A class with the reference policy rules.

            obj=obj@PolicyHandle;

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            obj.load(Country);
        end
    end
    methods (Hidden)
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
        function initialize(obj,super)
            % initialize - Copy the objects from the super class.

            if nargin == 1
                super=Policy;
            end
            mc=metaclass(obj);
            mcSuper=metaclass(super);
            superProps=string({mcSuper.PropertyList.Name});
            props=string({mc.PropertyList.Name});
            % superProps(ismember(superProps,"functions"))=[];
            for i=1:numel(props)
                if ~strcmp('tag',props(i)) && ismember(props(i),superProps)
                    obj.(props(i)) = super.(props(i));
                end
            end
        end
    end
end

