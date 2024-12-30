classdef myclass < Core

    % CUSTOMIZE YOUR PUBLIC PROPERTIES:
    %**********************************************************************
    properties (Access=public)
        % Define here the properties accessible to the user.
        % All these properties, with exception of property "parent" must
        % have a validator class type, optionally you can indicate the size.
        %
        % Example:
        %
        comment string % property of type string. This is obtained with private method getOtherProperties.
        ID (1,1) string % property of type string. This is obtained with private method getOtherProperties.
        cassTypeProperty Sublcass % property of type class. This is obtained with public method get.
        parent
    end
    %********END PUBLIC PROPERTIES

    % REQUIRED STUFF:
    %**********************************************************************
    properties (Hidden)
        % All the public classes must contain these properties: you cna
        % simply copy and paste them.

        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        % Info - Contains information from the c# objects.
        % The 'Handler' field stores the 'CountryInfoHandler.GetTypeInfo'
        % output. The 'PieceOfInfo.Handler' stores the
        % 'CountryInfoHandler.GetPieceOfInfo' output.
        Info struct
    end

    properties (Constant,Hidden)
        % All the public classes must contain  this property:

        % Example:
        tag = char(EM_XmlHandler.TAGS.FUN) % Function class tag.
    end
    %********END REQUIRED HIDDEN PRIVATE PROPERTIES


    % REQUIRED STUFF:
    %**********************************************************************
    % All the public classes must contain these methods:
    % just copy and paste them in your new class (and change the name in
    % method "empty").

    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)

            if nargin == 0
                obj = myclass; % change the name of class here
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = myclass; % change the name of class here
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


    % OTHER REQUIRED STUFF:
    %**********************************************************************
    % All the public classes must contain these methods:  you must
    % customize them accordingly.
    methods (Hidden)
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)

            % This method is used to get the values of properties of type
            % string. Tipically it looks into the property "Info.Handler"
            % which is a C# object with all the necessary information. Some
            % classes can also contain "Info.PieceOfInfo.Handler". Or
            % define your own ones in the class constructor.
            %
            % Note that the "myclass" object passed here has an updated
            % property "index" which picks up the correct element from the
            % Handler. This update occurs inside
            % "utils.redefinesparen.update".

            % Input Arguments:
            
            % obj - this is the "myclass" object with the updated property
            % obj.index, so you can use this one to get the correct elements
            % from "Info.Handler". 
            % help yourself with the function utils.getInfo which returns
            % values and kesy that you need from the "Info.Handler".

            % name - the names of the string properties.

            % index - you can pass here the user index if you need it.

            % Output arguments:

            % values - can be a string of any size e.g. (M,N) where M is
            % the number of the of keys (or "name" or properties) and N is
            % the size of the object (or the number of elements that the
            % user wants)

            % keys - (1,M) string array with the names of the class
            % properties that the user requested.

        end
        %==================================================================
        function x=headerComment(obj,varargin)
            
            % this must return a string to be displayed in the command
            % window for objects of type class array. Most of public
            % classes use here the "customdisplay.headerComment_Type1" 
            % method.
            % 
        end
    end
    % ***** END OTHER REQUIRED STUFF



    % THE CLASS CONSTRUCTOR:
    %**********************************************************************
    methods
        %==================================================================
        function obj = myclass(Parent)
            

            % This is the main constructor of your class. The input
            % argument Parent must be a class object with all the values
            % filled in. 

            % **************
            % Copy and paste this part in your class
            if nargin == 0
                return;
            end

            if isempty(Parent)
                return;
            end

            obj.parent=copy(Parent);
            obj.parent.indexArr=obj.parent.index; 
            % **End of copy and pase.*****

            % Next, you must define here the mandatory properties:

            obj.Info.Handler % - or any other type of handler. This will be
            % typically called by method "getOtherProperties". It must
            % contain C# objects with information regarding all the
            % "myclass" elements.

            obj.indexArr % - this must be the ordered index array of the
            % elements contained in the C# main object handler 

            % Now set the obj.index which is equal to indexArr in the 
            % constructor  since the object is just loaded. So copy and
            % paste the next line in your new class
            obj.index=obj.indexArr;

        end
    end
    % *** END OF CLASS CONSTRUCTOR

    % PROPERTIES OF TYPE CLASS:
    %**********************************************************************
    methods
        %==================================================================
        function x=get.cassTypeProperty(varargin)
            
            % This method only accepts one input argument, which is the
            % "myclass" object. So use it as a parent for the other classes
            % that define the property in this class. The "myclass" object
            % has alreade the updated property "index". You do not need to
            % update it here. So the correct parent is passed to the child.

            % Example:           
            obj=varargin{1};
            x = CassTypeProperty(obj);
            x = obj.cassTypeProperty;
            
        end
    end


end