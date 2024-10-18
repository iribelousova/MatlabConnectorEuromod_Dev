classdef Model < Core 

    properties
        extensions 
        countries 
        modelpath (1,1) string
        
        % model
    end

    properties (Dependent=true)
         
    end

    properties (Hidden)
        Info
        countryClass 
        extensionsClass 
        % userCountries (:,1) string
        % defaultCountries
    end

    properties (Constant)
        tag = 'MODEL'
        indexArr = 1
        index = 1
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
        
        function obj=Model(modelPath)

            % mm=Model("C:\EUROMOD_RELEASES_I6.0+", {'BE',"AT"});

            if nargin == 0
                return;
            end

            % obj.load(varargin{:});

            % user Model Path
            modelPath=string(modelPath);
            obj.Info(1).Handler = EM_XmlHandler.ModelInfoHandler(modelPath);
            obj.modelpath=modelPath;

            % % user Model Countires
            % countryNames = varargin{2};
            % if ~isstring(countryNames)
            %     countryNames=string(countryNames);
            % end
            % countryNames=sort(countryNames);
            % countryNames=upper(countryNames);
            % 
            % % check the country exists in EUROMOD 
            % notCountry = ~contains(countryNames,obj.defaultCountries);
            % if any(notCountry)
            %     ME=struct();
            %     ME.message=sprintf('Unrecognized country name(s) .. "%s".',strjoin(countryNames(notCountry),'","'));
            %     ME.indetifier='MATLAB:ValueError';
            %     error(ME)
            % else
            %     obj.userCountries=countryNames;
            % end
            

            % 
            % obj(1);

            % if nargin == 0
            %     return;
            % end
            % 
            % % user inputs
            % modelPath=string(varargin{1});
            % countryNames = varargin{2};
            % 
            % 
            % if ~isstring(countryNames)
            %     countryNames=string(countryNames);
            % end
            % countryNames=sort(countryNames);
            % countryNames=upper(countryNames);
            % 
            % % set model handler
            % obj.Info(1).Handler = EM_XmlHandler.ModelInfoHandler(modelPath);
            % 
            % % set public attributes
            % obj.modelpath=string(modelPath);
            % obj.extensions=Extension(obj);
            % 
            % notCountry = ~contains(countryNames,obj.defaultCountries);
            % if any(notCountry)
            %     ME=struct();
            %     ME.message=sprintf('Unrecognized country name(s) .. "%s".',strjoin(countryNames(notCountry),'","'));
            %     ME.indetifier='MATLAB:ValueError';
            %     error(ME)
            % else
            %     obj.userCountries=countryNames;
            % end
            % obj.countries=Country(obj);
            
        end

        % %------------------------------------------------------------------
        % function obj = load(obj, varargin)
        % 
        %     % obj.parent=[];
        % 
        %     % % user inputs
        %     % modelPath=string(varargin{1});
        %     % countryNames = varargin{2};
        %     % 
        %     % 
        %     % if ~isstring(countryNames)
        %     %     countryNames=string(countryNames);
        %     % end
        %     % countryNames=sort(countryNames);
        %     % countryNames=upper(countryNames);
        % 
        %     % set model handler
        %     % obj.Info(1).Handler = EM_XmlHandler.ModelInfoHandler(obj.modelPath);
        % 
        %     % % check the country exists in EUROMOD 
        %     % notCountry = ~contains(countryNames,obj.defaultCountries);
        %     % if any(notCountry)
        %     %     ME=struct();
        %     %     ME.message=sprintf('Unrecognized country name(s) .. "%s".',strjoin(countryNames(notCountry),'","'));
        %     %     ME.indetifier='MATLAB:ValueError';
        %     %     error(ME)
        %     % else
        %     %     obj.userCountries=countryNames;
        %     % end
        % 
        %     % set public properties
        %     % obj.modelpath=string(modelPath);
        %     % obj.extensions=Extension(obj);
        %     % obj.countries=Country(obj);
        % 
        % end

        % function [values,keys]=getOtherProperties(obj,name,index)
        %     name=string(name);
        % 
        %     if strcmp("modelpath",name)
        %         values=obj.modelpath;
        %     else
        %         error('AttributeError: Unrecognized property name "%s".', name)
        %     end
        %     % values=string(arrayfun(@(t) char(obj.Info(t).Handler.country),obj.index,UniformOutput=false))';
        %     keys=name;
        % end

        % 
        function x=defaultCountries(varargin)
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

        function x=get.countries(varargin)
            obj=varargin{1};

            if size(obj.countryClass,1)==0
                obj.countryClass=Country(obj);
                x=obj.countryClass;
            else
                x=obj.countryClass;
                x.index=obj.countryClass.indexArr;
            end

            % x=obj.defaultCountries;
            % idxArr=1:obj.Info.Handler.countries.Count;
            % if nargin==1
            %     idx=1:obj.Info.Handler.countries.Count;
            % else
            %     idx=varargin{2};
            % end
            % x=copy(obj.countryClass);
            % x.index=idx;
        end

        function x=get.extensions(varargin)
            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=Extension(obj);
                x=obj.extensionsClass;
            else
                x=obj.extensionsClass;
                x.index=obj.extensionsClass.indexArr;
            end

        end


        % function set(obj,prop,value)
        %     obj.(prop) = value;
        % end

        % function x = get(obj,prop,index)
        % 
        %     % obj.(prop).load(obj);
        % 
        %     if nargin == 2
        %         x = obj.(prop);
        %     elseif nargin == 3
        %         objIdx = obj.(prop).index;
        %         if all(ismember(index,objIdx)) && numel(objIdx) == numel(index)
        %             x = obj.(prop)(index);
        %         else
        %             obj.(prop).index = obj.(prop).index(index);
        %             % obj.(prop).update();
        %             x = obj.(prop)(index);
        %         end
        %     end
        % end

        % function x = get.extensions(obj)
        %     if isempty(obj.extensions)
        %         obj.extensions.load(obj);
        %     end
        % 
        %     obj.extensions.index = obj.extensions.indexArr;
        %     x = obj.extensions;
        % end
        % 
        % function x = get.countries(obj)
        %     if isempty(obj.countries)
        %         obj.countries.load(obj);
        %     end
        % 
        %     obj.countries.index = obj.countries.indexArr;
        %     x = obj.countries;
        % end


    end




end