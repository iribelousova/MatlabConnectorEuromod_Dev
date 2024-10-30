classdef ParameterInSystem < Parameter
    % ParameterInSystem - A class with the parameters set up in a function
    % for a specific system.
    %
    % Syntax:
    %
    %     P = ParameterInSystem(FunctionInSystem);
    %
    % Description:
    %     This class contains the function parameters specific to a system. 
    %     It is stored in the property 'parameters' of the FunctionInSystem
    %     class.
    %
    %     This class is a subclass of the Parameter class.
    %
    % ParameterInSystem Arguments:
    %     FunctionInSystem - A class containing the country-specific policy.
    %
    % ParameterInSystem Properties:
    %     comment    - Comment specific to the parameter.
    %     extensions - ExtensionSwitch class with parameter extensions.
    %     funID      - Identifier number of the reference function at country level.
    %     group      - Parameter group value.
    %     ID         - Identifier number of the parameter.
    %     name       - Name of the parameter.
    %     order      - Order of the parameter in the specific spine.
    %     parent     - A class of the policy-specific function.
    %     parID      - Identifier number of the parameter at country level.
    %     spineOrder - Order of the parameter in the spine.
    %     sysID      - Identifier number of the system.
    %     value      - Value of the parameter.
    %
    % Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default parameters for function "DefVar" in system "AT_2023":
    %     mod.('AT').('AT_2023').policies(10).functions('DefVar').parameters
    %     % Display parameter "temp_count" for function "DefVar" in system "AT_2023":
    %     mod.AT.AT_2023.policies(10).functions('DefVar').parameters('temp_count')
    %
    % See also Model, Country, System, PolicyInSystem, FunctionInSystem, 
    % Parameter, info, run.

    properties (Access=public)         
        parID (1,1) string % Identifier number of the reference parameter at country level.
        value (1,1) string % Value of the parameter.
        sysID (1,1) string % Identifier number of the reference system.
    end

    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty ParameterInSystem class.
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
        %==================================================================
        function obj = ParameterInSystem(FunctionInSystem)
            % ParameterInSystem - A class with the system-policy-function-
            % specific parameters.

            obj = obj@Parameter;

            if nargin == 0
                return;
            end

            if isempty(FunctionInSystem)
                return;
            end

            obj.load(FunctionInSystem);
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
        function obj = load(obj, parent)
            % load - Load the ParameterInSystem class array objects.

            % load super class 
            obj = obj.load@Parameter(parent);   
        end
        % %==================================================================
        % function x=headerComment(obj,varargin)
        %     % headerComment - Get the comment of the class array.
        % 
        %     if isempty(obj.commentArray)
        %         propertynames=["name","value","comment"];
        %         x=headerComment_Type1(obj,propertynames);
        % end
    end
end