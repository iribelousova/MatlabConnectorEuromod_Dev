classdef DatasetInSystem < Dataset
    % DatasetInSystem - Datasets available in a EUROMOD tax-benefit system.
    %
    % Syntax:
    %
    %     D = DatasetInSystem(System);
    %
    % Description:
    %     This class contains the datasets modelled in a EUROMOD system.
    %     The class elements can be accessed by indexing the class array with
    %     an integer, or a string value of any class property (e.g. name, ID,
    %     bestMatch, etc.).
    %
    %     This class is stored in the property |datasets| of the |System|
    %     class.
    %
    %     This class inherits methods and properties from the superclass |Dataset|.
    %
    % Dataset Arguments:
    %     System          - (1,1) class. A system-specific class.
    %
    %  Dataset Properties:
    %     bestMatch        - (1,1) string. If yes, the current dataset is a best match for the specific system.
    %     coicopVersion    - (1,1) string. COICOP version.
    %     comment          - (1,1) string. Comment about the dataset.
    %     currency         - (1,1) string. Currency of the monetary values in the dataset.
    %     dataID           - (1,1) string. Identifier number of the dataset at the country level.
    %     decimalSign      - (1,1) string. Decimal delimiter.
    %     ID               - (1,1) string. Dataset identifier number.
    %     listStringOutVar - (1,1) string. Names of variables.
    %     name             - (1,1) string. Name of the dataset.
    %     parent           - (1,1) class.  The System parent class.
    %     private          - (1,1) string. Access type.
    %     readXVariables   - (1,1) string. Read variables.
    %     sysID            - (1,1) string. Identifier number of the parent System class.
    %     useCommonDefault - (1,1) string. Use default.
    %     yearCollection   - (1,1) string. Year of the dataset collection.
    %     yearInc          - (1,1) string. Reference year for the income variables.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default datasets in system "AT_2023".
    %     mod.('AT').systems(end).datasets
    %     % Display the dataset "AT_2021_b1" in system "AT_2023".
    %     mod.AT.AT_2023.datasets(3)
    %
    % See also Model, Country, DatasetInSystem, bestmatchDatasets, info, run.

    properties (Access=public)
        bestMatch (1,1) string % If yes, the current dataset is a best match for the specific system.
        dataID (1,1) string % Identifier number of the reference dataset at the country level.
        sysID (1,1) string % Identifier number of the reference system.
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty DatasetInSystem class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = DatasetInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = DatasetInSystem;
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
        %==================================================================
        function x = getID(obj)
            % getID - Get the IDs of all datasets in the system.

            [IDs,~] = utils.getInfo(obj.Info.Handler,obj.index,'ID');
            if size(IDs,2)==obj.Info.Handler.Count
                IDs=IDs';
            end
            x=IDs;
        end
        %==================================================================
        function x=headerComment(obj,varargin)
            % headerComment - Get the comment of the class array.

            x=obj.headerComment_Type1({'name','bestMatch','comment'});
            x(ismember(x(:,2),"no"),2) = "";
            x(ismember(x(:,2),"yes"),2) = "best match";
        end
        %==================================================================
        function obj = load(obj, parent)
            % load - Load the DatasetInSystem class array objects.

            obj = obj.load@Dataset(parent);

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
            IDs=obj.getID();
            tagID='ID';
            parentID=obj.parent.(tagID);

            [obj,~]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            obj.indexArr=1:numel(obj.Info.PieceOfInfo);
            obj.index=obj.indexArr;
        end
    end
    methods
        %==================================================================
        function obj = DatasetInSystem(System)
            % DatasetInSystem - Datasets available in a system model.

            obj = obj@Dataset;

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