classdef Model < Core
    % Model - Base class of the Euromod Connector.
    %
    % Syntax:
    %
    %     mod = euromod(model_path);
    %
    % Description:
    %     This class instantiates the microsimulation model EUROMOD.
    %
    % Model Arguments:
    %     model_path - Path to the EUROMOD project.
    %
    % Model Properties:
    %     countries  - The Country class array with country elements.
    %     extensions - The Extension class array with Model extension elements.
    %     modelpath  - Path to the EUROMOD project.
    %
    % See also Country, Extension, info, run.

    properties (Access=public) 
        extensions Extension % The Extension class with Model extension elements.
        countries Country % The Country class with country elements.
        modelpath (1,1) string % Path to the EUROMOD project.

        % model
    end

    properties (Hidden)
        Info struct % Contains the 'Handler' field to the 'ModelInfoHandler'.
        countryClass Country % The Country class with country elements.
        extensionsClass Extension % The Extension class with Model extension elements.
    end

    properties (Constant,Hidden)
        tag = 'MODEL'
        indexArr = 1
        index = 1
    end

    methods (Static, Access = public,Hidden)
        function obj = empty(varargin)
            % empty - Re-assaign an empty Model class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Model;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Model;
            end

        end
    end

    methods

        function obj=Model(model_path)
            % Base class of the Euromod Connector.

            if nargin == 0
                return;
            end

            % user Model Path
            model_path=string(model_path);
            obj.Info(1).Handler = EM_XmlHandler.ModelInfoHandler(model_path);
            obj.modelpath=model_path;
        end

        function x=get.countries(varargin)
            % countries - Get the model Country class array.
            obj=varargin{1};

            if size(obj.countryClass,1)==0
                obj.countryClass=Country(obj);
                x=obj.countryClass;
            else
                x=obj.countryClass;
                x.index=obj.countryClass.indexArr;
            end
        end

        function x=get.extensions(varargin)
            % extensions - Get the model Extension class array.
            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=Extension(obj);
                x=obj.extensionsClass;
            else
                x=obj.extensionsClass;
                x.index=obj.extensionsClass.indexArr;
            end

        end

    end

    methods (Hidden)
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.
            name=string(name);

            if ismember('modelpath',name)
                values=obj.modelpath;
            else
                error('Unrecognized property or function for class Model.')
            end

            keys=name;
        end
        function x=defaultCountries(varargin)
            % defaultCountries - Get the Model default countries.
            obj=varargin{1};
            if nargin==1
                idx=1:obj.Info.Handler.countries.Count;
                N=obj.Info.Handler.countries.Count;
            else
                idx=varargin{2};
                N=numel(varargin{2});
            end
            x=strings(N,1);
            for i=idx
                x(i) = char(obj.Info.Handler.countries.Item(i-1));
            end
        end
    end

end