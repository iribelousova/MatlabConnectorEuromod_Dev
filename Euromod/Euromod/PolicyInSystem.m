classdef PolicyInSystem < Policy 
    % PolicyInSystem - A class with the policy rules modeled in a country.
    %
    % Syntax:
    %
    %     P = PolicyInSystem(System);
    %
    % Description:
    %     This class contains the information about all the country-system
    %     policies. It is stored in the property 'policies' of the System
    %     class.
    %
    %     This class contains subclasses of type ExtensionSwitch and
    %     FunctionInSystem.
    %
    %     This class is a subclass of the Policy class.
    %
    % PolicyInSystem Arguments:
    %     System     - A class containing a EUROMOD specific tax-benefit 
    %                  system.
    %
    % PolicyInSystem Properties:
    %     comment    - Comment specific to the policy.
    %     extensions - ExtensionSwitch class with the policy extensions.
    %     functions  - Function class with the policy functions.
    %     ID         - Identifier number of the policy.
    %     name       - Name of the policy.
    %     order      - Order of the policy in the specific spine.
    %     parent     - The country-specific class.
    %     polID      - Identifier number of the policy at country level.
    %     private    - Access type.
    %     spineOrder - Order of the policy in the spine.
    %     sysID      - Identifier number of the system.
    %     Switch     - Policy switch action.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default policies in system "AT_2023":
    %     mod.('AT').systems(end).policies 
    %     % Display the policy "IlsUDBDef_at" in system "AT_2023":
    %     mod.AT.AT_2023.policies(5)
    %
    % See also Model, Country, System, Policy, ReferencePolicy, info, run.

    properties (Access=public) 
        polID (1,1) string % Identifier number of the reference policy at country level.
        Switch (1,1) string % Policy switch action.
        sysID (1,1) string % Identifier number of the reference system.
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty PolicyInSystem class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = PolicyInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = PolicyInSystem;
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
        function obj = PolicyInSystem(System)
            % PolicyInSystem - A class with the policy rules modeled in a 
            % system.

            obj = obj@Policy;

            if nargin == 0
                return;
            end

            if isempty(System)
                return;
            end

            obj.load(System);
        end
    end
end