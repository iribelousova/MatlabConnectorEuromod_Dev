classdef PolicyInSystem < Policy
    % PolicyInSystem - Policies modeled in a EUROMOD tax-benefit system.
    %
    % Syntax:
    %
    %     P = PolicyInSystem(System);
    %
    % Description:
    %     This class contains the policy rules implemented in a EUROMOD specific
    %     tax-benefit system. The class elements can be accessed by indexing the
    %     class array with an integer, or a string value of any class property
    %     (e.g. name, ID, order, etc.).
    %
    %     This class is stored in the property |policies| of the |System| class.
    %
    %     This class stores classes of type |FunctionInSystem| and |Extension|.
    %
    %     This class inherits methods and properties from the superclass |Policy|.
    %
    % Input Arguments:
    %     System     - A class containing a EUROMOD specific tax-benefit
    %                  system.
    %
    % Properties:
    %     comment    - (1,1) string. Comment specific to the policy.
    %     extensions - (N,1) class.  Extension class array with the policy extensions.
    %     functions  - (N,1) class.  FunctionInSystem class array with the policy functions.
    %     ID         - (1,1) string. Identifier number of the policy.
    %     name       - (1,1) string. Name of the policy.
    %     order      - (1,1) string. Order of the policy in the specific spine.
    %     parent     - (1,1) class.  The parent class |System|.
    %     polID      - (1,1) string. Identifier number of the policy at country level.
    %     private    - (1,1) string. Access type.
    %     spineOrder - (1,1) string. Order of the policy in the spine.
    %     Switch     - (1,1) string. Switch value of the extension.
    %     sysID      - (1,1) string. Identifier number of the parent System
    %
    % Examples:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default policies in system "AT_2023":
    %     mod.('AT').systems(end).policies
    %     % Display the policy "IlsUDBDef_at" in system "AT_2023":
    %     mod.AT.AT_2023.policies(5)
    %
    % See also Model, Country, System, Policy, ReferencePolicy, info, run, Simulation.

    properties (Access=public)
        polID (1,1) string % Identifier number of the reference policy at country level.
        Switch (1,1) string % Policy switch action.
        sysID (1,1) string % Identifier number of the reference system.
    end

    methods (Static, Access = public,Hidden)
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
    methods (Hidden)
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
    end
end