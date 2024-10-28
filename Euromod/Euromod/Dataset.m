classdef Dataset < Core
    % Dataset - Datasets available in a country model.
    %
    % Syntax:
    %
    %     D = Dataset(Country);
    %
    % Description:
    %     This class contains the relevant information about the country-
    %     specific datasets.
    %
    %     This class is also implemented as a superclass for the
    %     DatasetInSystem class.
    %
    % Dataset Arguments:
    %     Country          - A country-specific class.
    %
    %  Dataset Properties:
    %     coicopVersion    - COICOP version.
    %     comment          - Comment about the dataset.
    %     currency         - Currency of the monetary values in the dataset.
    %     decimalSign      - Decimal delimiter.
    %     ID               - Dataset identifier number.
    %     listStringOutVar - Names of
    %     name             - Name of the dataset.
    %     parent           - The country-specific class.
    %     private          - Access type.
    %     readXVariables   - Read variables.
    %     useCommonDefault - Use default.
    %     yearCollection   - Year of the dataset collection.
    %     yearInc          - Reference year for the income variables.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     mod.('AT').datasets % displays the default datasets for Austria.
    %     mod.('AT').datasets(3) % displays the specific dataset for Austria.
    %
    % See also Model, Country, DatasetInSystem, bestmatchDatasets, info, run.

    properties (Access=public)
        coicopVersion (1,1) string % COICOP version.
        comment (1,1) string % Comment about the dataset.
        currency (1,1) string % Currency of the monetary values in the dataset.
        decimalSign (1,1) string % Decimal delimiter.
        ID (1,1) string % Dataset identifier number.
        listStringOutVar (1,1) string % Names of
        name (1,1) string % Name of the dataset.
        parent % The country-specific class.
        private (1,1) string % Access type.
        readXVariables (1,1) string % Read variables.
        useCommonDefault (1,1) string % Use default.
        yearCollection (1,1) string % Year of the dataset collection.
        yearInc (1,1) string % Reference year for the income variables.
    end

    properties (Access=public,Hidden=true) 
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        % Info - Contains information from the c# objects.
        % In the Dataset class, the 'Handler' field stores the 
        % 'CountryInfoHandler.GetTypeInfo' % output. In the The DatasetInSystem
        % class, it also contains the 'PieceOfInfo.Handler' field which 
        % stores the 'CountryInfoHandler.GetPieceOfInfo' output.
        Info struct
    end

    properties (Constant, Hidden)
        tag = char(EM_XmlHandler.TAGS.DATA); % Dataset class tag.
    end

    methods (Static, Access = public)
        function obj = empty(varargin)
            % empty - Re-assaign an empty Dataset class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Dataset;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Dataset;
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
        function obj = Dataset(Country)
            % Dataset - Datasets available in a country model.

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
        function obj = load(obj, parent)
            % load - Load the Dataset class array objects.

            % set parent
            obj.parent=copy(parent);
            obj.parent.indexArr=obj.parent.index;

            % get country class
            if isa(obj.parent,'Country')
                cobj=copy(obj.parent);
            else
                cobj=copy(obj.parent.getParent("COUNTRY"));
            end
            Idx = cobj.index;

            % set handler
            obj.Info(1).Handler = cobj.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));

            % set index
            obj.indexArr = 1:obj.Info.Handler.Count;
            obj.index=obj.indexArr;
        end
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.
            [values,keys]=obj.getOtherProperties_Type1(name);

        end
        %==================================================================
        function x=headerComment(obj,varargin)
            % headerComment - Get the comment of the class array.
            N=size(obj,1);
            x=obj.getOtherProperties(["name","comment"],1:N)';
        end

    end


end