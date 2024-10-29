%% Country 
% The EUROMOD tax-benefit country models.
%
%% Syntax:
%     C = Country(Model)
%
%% Description:
%     C = Country(Model) returns a class array with the EUROMOD tax benefit
%     country models. Each country object contains properties that are classes
%     of type System, Policy, Dataset and Extension.
%
%% Input Arguments:
%     Model            - Class with the EUROMOD base model.
%
%% Properties:
%     datasets         - Dataset class with country datasets.
%     extensions       - Extension class with model and country extensions.
%     local_extensions - Extension class with country extensions.
%     name             - Two-letter country code. See the <a href="matlab: web('https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Glossary:Country_codes')">Eurostat Glossary:Country codes</a>.
%     parent           - Model base class.
%     policies         - Policy class with country policies.
%     systems          - System class with country systems.
%
%% Output Arguments:
%     C                - Country class array containing the EUROMOD country
%                        models.
%
%% Examples:
%     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
%     % Display the default countries:
%     mod.countries
%     % Display the Country class for Austria.
%     mod.countries('AT')
%
%% See also
% Model, System, Policy, Dataset, Extension, info, run.

classdef Country < Core
    % Country - The EUROMOD tax-benefit country models.

    properties (Access=public)
        datasets Dataset % Dataset class with country datasets.
        extensions Extension % Extension class with model and country extensions.
        local_extensions Extension % Extension class with country extensions.
        name (1,1) string % Two-letter country code.
        parent % Model base class.
        policies Policy % Policy class with country policies.
        systems System % System class with country systems.
    end

    properties (Hidden)
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        Info struct % Contains the 'Handler' field to the 'CountryInfoHandler'.
        systemsClass System % System class with country systems.
        datasetsClass Dataset % Dataset class with country datasets.
        extensionsClass Extension % Extension class with model and country extensions.
        policiesClass Policy % Policy class with country policies.
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.('COUNTRY')) % Country tag.
    end

    methods (Static, Access = public, Hidden)
        function obj = empty(varargin)
            % empty - Re-assaign an empty Country class.
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
    methods
        %==================================================================
        function obj = Country(model)
            % Country - Country-specific EUROMOD tax-benefit models.

            if nargin == 0
                return;
            end

            if isempty(model)
                return;
            end

            obj.parent=model;

            modelPath = model.modelpath;
            userCountries=model.defaultCountries();

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
        end

        %==================================================================
        function x=get.policies(varargin)
            % policies - Get the country Policy class array.
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

        %==================================================================
        function x=get.systems(varargin)
            % systems - Get the country System class array.

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

        %==================================================================
        function x=get.extensions(varargin)
            % extensions - Get the country and model Extension class array.

            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=Extension(obj);
                x=obj.extensionsClass;
            else
                if obj.extensionsClass.parent.index == obj.index
                    x=obj.extensionsClass;
                    x.index=obj.extensionsClass.indexArr;
                else
                    obj.extensionsClass=Extension(obj);
                    x=obj.extensionsClass;
                end
            end
        end

        %==================================================================
        function x=get.local_extensions(obj)
            % local_extensions - Get the country Extension class array.

            x=copy(obj.extensions);
            idx=1:x.Info.Handler.Count;
            x.index=idx;
            x.indexArr=idx;
        end

        %==================================================================
        function x=get.datasets(varargin)
            % datasets - Get the country Dataset class array.

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
        %==================================================================
        function X = run(obj, system_id,data,data_id,NameValueArgs)
            % run - Run the simulation of a Euromod tax-benefit system.
            %
            % Syntax:
            %
            %   X = run(Country,system_id,data,data_id)
            %   X = run(___,Name,Value)
            %
            % Description:
            % X = run(Country,system_id,data,data_id) returns
            % a Simulation class with results from the simulation of a
            % EUROMOD tax-benefit system.
            % X = run(___,Name,Value) configure simulation options using  
            % one or more name-value input arguments.
            %             
            % Input Arguments:
            %   obj        - class. The Country class of Euromod Connector.
            %   system_id  - (1,1) string. Name of the tax-benefit system.
            %   data       - table. Input dataset passed to the EUROMOD 
            %                model.
            %   data_id - (1,1) string. Name of the dataset. 
            %
            % Name-Value Input Arguments:
            %   addons               - (1,:) string. Addons to be integrated 
            %                          in the spine. The first element is 
            %                          the name of the addon and the second 
            %                          element is the name of the system 
            %                          in the Addon to be integrated. 
            %                          Default is [].
            %                          Example: ["MWA","false"]
            %   constantsToOverwrite - (:,1) cell. Constants to overwrite
            %                          in the simulation. Each cell row is
            %                          a (1,2) string where the first
            %                          element is a (1,2) string with the
            %                          name and the group of the constant, 
            %                          and the second element is the new
            %                          value. 
            %                          Default is [].
            %                          Example: {["$tinna_rate2",""],'0.4'}
            %   euro                 - logical. If true, the monetary 
            %                          variables will be converted to euro 
            %                          for the simulation. 
            %                          Default is false.
            %   nowarnings           - logical. If true, the warning 
            %                          messages resulting from the 
            %                          simulations will be suppressed. 
            %                          Default is false.
            %   outputpath           - (1,1) string. When the output path
            %                          is provided, there will be anoutput 
            %                          file generated. Default is "".
            %   public_compoments_only-logical. If true, the the model will 
            %                          be on with only the public 
            %                          compoments. Default is false.
            %   switches             - (1,:) string. Extensions to be 
            %                          switched on or of. The first element 
            %                          is the short name of the extension. 
            %                          The second element is a "on" or
            %                          "off" value.
            %                          Default is [].
            %   verbose              - logical. If true then information on 
            %                          the output will be printed. 
            %                          Default is true.
            %
            % Example:
            %   mod=euromod('C:\EUROMOD_RELEASES_I6.0+');
            %   mod.country('SE').run('SE_2021',data,'SE_2021_b1')

            arguments
                obj
                system_id (1,1) string
                data (:,:) table
                data_id (1,1) string
            
                NameValueArgs.addons (1,:) string 
                NameValueArgs.constantsToOverwrite (1,:) cell 
                NameValueArgs.euro logical = false
                NameValueArgs.nowarnings logical = false
                NameValueArgs.outputpath (1,1) string 
                NameValueArgs.public_components_only logical = false
                NameValueArgs.switches (1,:) string          
                NameValueArgs.verbose logical = true
            end

            if ~ismember(system_id,obj.systems(1:end).name)
                error('Unrecognized system name %s ', system_id)                
            end

            fn=fieldnames(NameValueArgs);
            for i=1:numel(fn)
                if strcmp(fn{i},'switches')
                    x=NameValueArgs.(fn{i});
                    x(ismember(x,'1'))="true";
                    x(ismember(x,'0'))="false";
                    NameValueArgs.(fn{i})=x;
                end
                if strcmp(fn{i},'constantsToOverwrite')
                    % x=NameValueArgs.(fn{i});
                    % x(ismember(x,'1'))="true";
                    % x(ismember(x,'0'))="false";
                    % NameValueArgs.(fn{i})=x;
                end
            end

            country_id = obj.name;
            Idx=obj.index;
            countryInfoHandler = obj.Info(Idx).Handler;

            NameValueArgsSub=cell(1,2*numel(fn));
            NameValueArgsSub(1:2:end)=fn;
            NameValueArgsSub(2:2:end)=struct2cell(NameValueArgs);
            X=runSimulation(countryInfoHandler, country_id, system_id, data, data_id, NameValueArgsSub{:});
        end
        %==================================================================
        function X = get_switch_value(obj, NameValueArgs)

            arguments
                obj
                NameValueArgs.ext_name string = []
                NameValueArgs.dataset_name string = []
                NameValueArgs.sys_name string = []
            end

            keys=string;
            patterns=string;

            if ~isempty(NameValueArgs.ext_name)
                keys=[keys,EM_XmlHandler.TAGS.EXTENSION_ID];
                patterns=[patterns,obj.extensions(string(NameValueArgs.ext_name)).ID];
            end
            if ~isempty(NameValueArgs.dataset_name)
                keys=[keys,EM_XmlHandler.TAGS.DATA_ID];
                patterns=[patterns,obj.datasets(string(NameValueArgs.dataset_name)).ID];
            end
            if ~isempty(NameValueArgs.sys_name)
                keys=[keys,EM_XmlHandler.TAGS.SYS_ID];
                patterns=[patterns,obj.systems(string(NameValueArgs.sys_name)).ID];
            end

            if isempty(keys)
                M=numel(keys);
                Idx=obj.index;
                for i=1:M
                    out=obj.Info(Idx).Handler.GetPiecesOfInfo(EM_XmlHandler.ReadCountryOptions.EXTENSION_SWITCH,keys(i),patterns(i))


                    %                     IEnumerable = NET.explicitCast(obj,'System.Collections.IEnumerable');
                    % % IEnumerable.GetEnumerator;
                    %
                    % patterns = SystemCs.Collections.Generic.List[SystemCs.String]()
                    % keys = SystemCs.Collections.Generic.List[SystemCs.String]()
                    %
                    % m = length(1);
                    % keys = NET.createGeneric('System.Collections.Generic.List',{'System.String'}, m);
                    % keys.Add(string(EM_XmlHandler.TAGS.SYS_ID))
                    % patterns = NET.createGeneric('System.Collections.Generic.List',{'System.String'}, m);
                    % patterns.Add("AT_2016")
                    %
                    % keys=string(EM_XmlHandler.TAGS.SYS_ID);
                    % patterns="AT_2016";
                    % %%%%%%%%%%%%%%%%%
                    % out=ch.GetPiecesOfInfo(EM_XmlHandler.ReadCountryOptions.EXTENSION_SWITCH,keys,patterns)
                    % IEnumerator = NET.explicitCast(out,'System.Collections.IEnumerator')
                    %
                    % IEnumerable = NET.explicitCast(out,'System.Collections.IEnumerable');
                    % x=IEnumerable.GetEnumerator
                    % x = IEnumerable.GetEnumerator;
                    % xIEnumerable = NET.explicitCast(x,'System.Collections.IEnumerable');
                    % x1=xIEnumerable.GetEnumerator;
                    %
                    % IEnumerator = NET.explicitCast(x,'System.Collections.IEnumerator');
                    % IEnumerator = NET.explicitCast(out,'System.Collections.IEnumerator');
                    % IEnumerator = NET.explicitCast(x1,'System.Collections.IEnumerator');
                    % %%%%%%
                    %
                    % % IEnumerable = NET.explicitCast(out,'System.Collections.IEnumerable');
                    % x = IEnumerable.GetEnumerator;
                    % IEnumerator = NET.explicitCast(x,'System.Collections.IEnumerator');
                    %
                    % values = "";
                    % while (IEnumerator.MoveNext)
                    %     values(end+1) = string(IEnumerator.Current);
                    % end
                    % values=values(2:end)';
                    %
                    %                     [v,k]=utils.getInfo(out)
                end
            end

        end
    end

    methods (Hidden)
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.
            name=string(name);

            values=string(arrayfun(@(t) char(obj.Info(t).Handler.country),obj.index,UniformOutput=false))';
            keys=name;
        end

        %==================================================================
        function x=headerComment(obj)
            % headerComment - Get the comment of the class array.
            x=obj.headerComment_Type1("name");
        end
    end
end