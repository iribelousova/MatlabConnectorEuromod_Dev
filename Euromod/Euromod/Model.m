%% Model 
% <a href="matlab:disp('Hello World')">Hello!</a>
% Base class of the Euromod Connector.
%
%% Model Syntax:
%
%     mod = euromod(model_path);
%
%% Model Description:
%     This class instantiates the microsimulation model EUROMOD.
%
%% Model Arguments:
%     model_path - Path to the EUROMOD project.
%
%% Model Properties:
%     countries  - The Country class array with country elements.
%     extensions - The Extension class array with Model extension elements.
%     modelpath  - Path to the EUROMOD project.
%
%% Model Functions:
%     run - Run the simulation of a Euromod tax-benefit system.
%
%% See also 
% euromod, Country, Extension, System, info, run.

classdef Model < Core
    % Model - Base class of the Euromod Connector.

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
        function x=info(obj,varargin)
            error("Unrecognized method 'info' for class 'Model'.")
        end

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

            if strcmp(obj.modelpath,"") 
                x=Country;
                return;
            end

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

            if strcmp(obj.modelpath,"") 
                x=Extension;
                return;
            end

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=Extension(obj);
                x=obj.extensionsClass;
            else
                x=obj.extensionsClass;
                x.index=obj.extensionsClass.indexArr;
            end

        end
        %==================================================================
        function X = run(obj, country_id,system_id,data,data_id,NameValueArgs)
            % run - Run the simulation of a Euromod tax-benefit system.
            %
            % Syntax:
            %
            %   X = run(Model,country_id,system_id,data,data_id)
            %   X = run(___,Name,Value)
            %
            % Description:
            % X = run(Model,country_id,system_id,data,data_id) returns
            % a Simulation class with results from the simulation of a
            % EUROMOD tax-benefit system.
            % X = run(___,Name,Value) configure simulation options using  
            % one or more name-value input arguments.
            %             
            % Input Arguments:
            %   obj        - class. Can be any class of the Euromod model.
            %   country_id - (1,1) string. Two-letter country code.
            %                Required when obj is the Model class.
            %   system_id  - (1,1) string. System name. Required when obj 
            %                is the Model class or the Country class.
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
            %   mod.run('SE','SE_2021',data,'SE_2021_b1')

            arguments
                obj
                country_id (1,1) string
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

            if ~ismember(country_id,upper(obj.countries(1:end).name))
                error('Unrecognized country name %s ', country_id)                
            end

            fn=fieldnames(NameValueArgs);
            for i=1:numel(fn)
                if strcmp(NameValueArgs.(fn{i}),'switches')
                    x=NameValueArgs.(fn{i});
                    x(ismember(x,'1'))="true";
                    x(ismember(x,'0'))="false";
                    NameValueArgs.(fn{i})=x;
                end
                if strcmp(NameValueArgs.(fn{i}),'constantsToOverwrite')
                    % x=NameValueArgs.(fn{i});
                    % x(ismember(x,'1'))="true";
                    % x(ismember(x,'0'))="false";
                    % NameValueArgs.(fn{i})=x;
                end
            end

            cobj = obj.countries(country_id);
            if ~ismember(system_id,cobj.systems(1:end).name)
                error('Unrecognized system name %s ', system_id)                
            end

            Idx=cobj.index;
            countryInfoHandler = cobj.Info(Idx).Handler;

            NameValueArgsSub=cell(1,2*numel(fn));
            NameValueArgsSub(1:2:end)=fn;
            NameValueArgsSub(2:2:end)=struct2cell(NameValueArgs);
            X=runSimulation(countryInfoHandler, country_id, system_id, data, data_id, NameValueArgsSub{:});
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