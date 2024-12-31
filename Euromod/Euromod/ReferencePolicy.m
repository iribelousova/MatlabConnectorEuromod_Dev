classdef ReferencePolicy < PolicyHandle
    % ReferencePolicy - Reference policies modeled in a EUROMOD country.
    %
    % Syntax:
    %
    %     R = ReferencePolicy(Country);
    %
    % Description:
    %     This class contains the reference policies implemented in a EUROMOD
    %     country model. The class elements can be accessed by indexing the class
    %     array with an integer, or a string value of any class property
    %     (e.g. name, ID, order, etc.).
    %
    %     This class is stored in the property |policies| of the |Country| class.
    %
    %     This class stores classes of type |Extension|.
    %
    % ReferencePolicy Arguments:
    %     Country    - A class containing the EUROMOD country-specific
    %                  tax-benefit model.
    %
    % ReferencePolicy Properties:
    %     extensions - (N,1) class.  Extension class array with the reference policy extensions.
    %     ID         - (1,1) string. Identifier number of the reference policy.
    %     name       - (1,1) string. Name of the reference policy.
    %     order      - (1,1) string. Order of the reference policy in the specific spine.
    %     parent     - (1,1) class.  The parent class |Country|.
    %     refPolID   - (1,1) string. Identifier number of the policy at the Country level.
    %     spineOrder - (1,1) string. Order of the reference policy in the spine.
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

