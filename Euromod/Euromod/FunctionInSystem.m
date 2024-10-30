classdef FunctionInSystem < Function
    % FunctionInSystem - A class with the functions implemented in a policy 
    % for a specific system.
    %
    % Syntax:
    %
    %     F = FunctionInSystem(PolicyInSystem);
    %
    % Description:
    %     This class contains the policy-specific functions in a given 
    %     system. It is stored in the property 'functions' of the 
    %     PolicyInSystem class.
    %
    %     This class contains subclasses of type ParameterInSystem.
    %
    %     This class is a subclass of the Function class.
    %
    % FunctionInSystem Arguments:
    %     PolicyInSystem - A class containing a system-specific policy.
    %
    % FunctionInSystem Properties:
    %     comment    - Comment specific to the function.
    %     extensions - ExtensionSwitch class with function extensions.
    %     funID      - Identifier number of the reference function at country level.
    %     ID         - Identifier number of the function.
    %     name       - Name of the function.
    %     order      - Order of the function in the specific spine.
    %     parameters - Parameter class with function parameters.
    %     parent     - A class of the country-specific policy.
    %     polID      - Identifier number of the policy.
    %     private    - Access type.
    %     spineOrder - Order of the function in the spine.
    %     sysID      - Identifier number of the system.
    %     Switch     - Policy switch action.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default functions for policy "uprate_at" in system "AT_2023":
    %     mod.('AT').systems(end).policies(2).functions
    %     % Display the functions "Uprate" for policy "uprate_at" in system "AT_2023":
    %     mod.AT.AT_2023.policies(2).functions("Uprate")
    %
    % See also Model, Country, System, PolicyInSystem, Function, info, run.

    properties (Access=public)         
        funID (1,1) string % Identifier number of the reference function at country level.
        Switch (1,1) string % Policy switch action.
        sysID (1,1) string % Identifier number of the reference policy.
    end

    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty FunctionInSystem class.
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
        %==================================================================
        function obj = FunctionInSystem(PolicyInSystem)
            % FunctionInSystem - A class with the system-policy-specific  
            % functions.

            obj = obj@Function;

            if nargin == 0
                return;
            end

            if isempty(PolicyInSystem)
                return;
            end

            obj.load(PolicyInSystem);
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
        %==================================================================
        function obj = load(obj, parent)
            % load - Load the FunctionInSystem class array objects.

            % load super class 
            obj = obj.load@Function(parent);             
        end
    end
end