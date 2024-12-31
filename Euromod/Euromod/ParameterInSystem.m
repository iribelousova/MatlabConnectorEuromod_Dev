classdef ParameterInSystem < Parameter
    % ParameterInSystem - A class with the parameters set up in a function
    % for a specific system.
    %
    % Syntax:
    %
    %     P = ParameterInSystem(FunctionInSystem);
    %
    % Description:
    %     This class contains the parameters specific to a system in the
    %     EUROMOD policy function. The class elements can be accessed by
    %     indexing the class array with an integer, or a string value of any
    %     class property (e.g. name, ID, order, etc.).
    %
    %     This class is stored in the property |parameters| of the
    %     |FunctionInSystem| class.
    %
    %     This class inherits methods and properties from the superclass |Parameter|.
    %
    % ParameterInSystem Arguments:
    %     FunctionInSystem - A class containing the country-specific policy.
    %
    % ParameterInSystem Properties:
    %     comment    - (1,1) string. Comment specific to the parameter.
    %     extensions - (N,1) class.  Extension class array with parameter extensions.
    %     funID      - (1,1) string. Identifier number of the parent FunctionInSystem class.
    %     group      - (1,1) string. Group value of the parameter.
    %     ID         - (1,1) string. Identifier number of the parameter.
    %     name       - (1,1) string. Name of the parameter.
    %     order      - (1,1) string. Order of the parameter in the specific spine.
    %     parent     - (1,1) class.  The parent class |FunctionInSystem|.
    %     parID      - (1,1) string. Identifier number of the parameter at country level.
    %     spineOrder - (1,1) string. Order of the parameter in the spine.
    %     sysID      - (1,1) string. Identifier number of the parent System.
    %     value      - (1,1) string. Value of the parameter.
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