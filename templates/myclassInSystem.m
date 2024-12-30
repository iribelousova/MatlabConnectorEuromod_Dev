classdef myclassInSystem < myclass

    % this class inherits methods and properties from super class "myclass"
    % You ccan customize here these methods and properties by overriding
    % them.
  
    % CUSTOMIZE YOUR PUBLIC PROPERTIES:
    %**********************************************************************
    properties (Access=public)         
        % Define here additional public properties of this class
    end
    %********END PUBLIC PROPERTIES


    % REQUIRED STUFF:
    %**********************************************************************
    % All the public classes must contain these methods:
    % just copy and paste them in your new class (and change the name in
    % method "empty").
    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)

            if nargin == 0
                obj = myclassInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = myclassInSystem;
            end
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
    %********END REQUIRED HIDDEN PUBLIC METHODS

    % THE CLASS CONSTRUCTOR:
    %**********************************************************************
    methods
        %==================================================================
        function obj = myclassInSystem(Parent)
            % myclassInSystem - A class with the system-policy-specific  
            % functions.


            % **************
            % Copy and paste this part in your class
            obj = obj@myclass;

            if nargin == 0
                return;
            end

            if isempty(Parent)
                return;
            end
            % **End of copy and pase.*****

            % Add here new object handlers. Ovrride getOtherProperties
            % method to get information from your new handler.

        end
    end
    % *** END OF CLASS CONSTRUCTOR
end