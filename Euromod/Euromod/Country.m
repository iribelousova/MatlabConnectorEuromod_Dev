classdef Country < Core  % < Core  %< utils.redefinesparen & utils.CustomDisplay
    properties (Access=public,Hidden)
        % model 
        % index (:,1) double
        indexArr (:,1) double
        parent Model
        Info struct
        index (:,1) double
        systemsClass % System 
        datasetsClass % Dataset
        extensionsClass
        policiesClass
        % countryList (:,1) string
        % paren
    end

    properties (Constant,Hidden)
        % tag = char(EM_XmlHandler.TAGS.COUNTRY)
        tag = char(EM_XmlHandler.TAGS.('COUNTRY'))
    end

    properties (Access=public) 
        name (1,1) string % Two-letter country code.
        systems % System % A list of system objects.
        datasets % Dataset % A list with Dataset objects.
        extensions % LocalExtension % Extension % A list with extension objects.
        policies % Policy % A list with policy objects.
    end


    methods (Static, Access = public)
        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Country;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx(end)) = Country;
            end
        end
    end

    methods

        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end

        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end

        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        
        function obj = Country(Model)

            if nargin == 0
                return;
            end

            if isempty(Model)
                return;
            end

            obj.parent=Model;

            modelPath = Model.modelpath;
            userCountries=Model.defaultCountries();

            obj.Info(1).Handler = EM_XmlHandler.CountryInfoHandler(modelPath, userCountries(1));

            N=numel(userCountries);
            if N>1
                for i=2:N
                    obj.Info(i).Handler = EM_XmlHandler.CountryInfoHandler(modelPath, userCountries(i));
                end
                obj.indexArr=1:N;
            else
                obj.indexArr=1;
            end
            obj.index=obj.indexArr;


            % obj.load(Model);

        end

        % %------------------------------------------------------------------
        % function obj = load(obj, parent)
        % 
            % obj.parent=parent;
            % 
            % modelPath = parent.modelpath;
            % userCountries=parent.defaultCountries();
            % 
            % obj.Info(1).Handler = EM_XmlHandler.CountryInfoHandler(modelPath, userCountries(1));
            % 
            % N=numel(userCountries);
            % if N>1
            %     for i=2:N
            %         obj.Info(i).Handler = EM_XmlHandler.CountryInfoHandler(modelPath, userCountries(i));
            %     end
            %     obj.indexArr=1:N;
            % else
            %     obj.indexArr=1;
            % end
            % obj.index=obj.indexArr;
        % 
        % end

        % function set.systems(obj,value)
        % 
        %     N=obj.index;
        %     if size(obj.systems,1)==0
        %         obj.systems=System(obj);
        %         % x=obj.systemsClass;
        %     else
        %         if obj.systems.parent.index == N
        %             x=obj.systems;
        %             x.index=obj.systems.indexArr;
        %         else
        %             obj.systems=System(obj);
        %             x=obj.systems;
        %         end
        %     end
        % end

        function x=get.policies(varargin)
            obj=varargin{1};

            if size(obj.policiesClass,1)==0
                obj.policiesClass=Policy(obj);
                x=obj.policiesClass;
            else
                if all(obj.policiesClass.parent.index == obj.index)
                    x=obj.policiesClass;
                    x.index=obj.policiesClass.indexArr;
                else
                    obj.policiesClass=Policy(obj);
                    x=obj.policiesClass;
                end
            end
        end

        function x=get.systems(varargin)
            obj=varargin{1};

            if size(obj.systemsClass,1)==0
                obj.systemsClass=System(obj);
                x=obj.systemsClass;
            else
                if all(obj.systemsClass.parent.index == obj.index)
                    x=obj.systemsClass;
                    x.index=obj.systemsClass.indexArr;
                else
                    obj.systemsClass=System(obj);
                    x=obj.systemsClass;
                end
            end
        end

        function x=get.extensions(varargin)
            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=LocalExtension(obj);
                x=obj.extensionsClass;
            else
                if obj.extensionsClass.parent.index == obj.index
                    x=obj.extensionsClass;
                    x.index=obj.extensionsClass.indexArr;
                else
                    obj.extensionsClass=LocalExtension(obj);
                    x=obj.extensionsClass;
                end
            end
        end

        function x=get.datasets(varargin)
            obj=varargin{1};

            if size(obj.datasetsClass,1)==0
                obj.datasetsClass=Dataset(obj);
                x=obj.datasetsClass;
            else
                if obj.datasetsClass.parent.index == obj.index
                    x=obj.datasetsClass;
                    x.index=obj.datasetsClass.indexArr;
                else
                    obj.datasetsClass=Dataset(obj);
                    x=obj.datasetsClass;
                end
            end
        end

        %------------------------------------------------------------------
        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);

            values=string(arrayfun(@(t) char(obj.Info(t).Handler.country),obj.index,UniformOutput=false))';
            keys=name;
        end

        function x=headerComment(obj)
            x=obj.headerComment_Type1("name");
        end

    end

end