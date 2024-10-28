classdef System < Core
    % System - A class with the EUROMOD tax-benefit systems.
    %
    % Syntax:
    %
    %     C = System(Country);
    %
    % Description:
    %     This class represents the EUROMOD tax systems. An instance of this
    %     class is generated when loading the EUROMOD base model. It is
    %     stored in the property systems of the Country.
    %
    %     This class contains subclasses of type PolicyInSystem and
    %     DatasetInSystem.
    %
    % System Arguments:
    %     Country           - A class containing the EUROMOD country-specific
    %                         tax-benefit model.
    %
    % System Properties:
    %     bestmatchDatasets - DatasetInSystem class with system best-match datasets.
    %     comment           - Comment specific to the system.
    %     currencyOutput    - Currency of the simulation results.
    %     currencyParam     - Currency of the monetary parameters in the system.
    %     datasets          - DatasetInSystem class with system datasets.
    %     ID                - Identifier number of the system.
    %     headDefInc        - Main income definition.
    %     name              - Name of the system.
    %     parent            - The country-specific class.
    %     policies          - PolicyInSystem class with system policies.
    %     private           - Access type.
    %     order             - Order of a system in the spine.
    %     year              - Year of a system.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     mod.('AT').systems % displays the default systems for Austria
    %     mod.('AT').systems('AT_2020') % displays the specific System for Austria.
    %
    % See also Model, Country, PolicyInSystem, DatasetInSystem, info, run.

    properties (Access=public)
        bestmatchDatasets DatasetInSystem % DatasetInSystem class with system best-match datasets.
        comment (1,1) string % Comment specific to the system.
        currencyOutput (1,1) string % Currency of the simulation results.
        currencyParam (1,1) string % Currency of the monetary parameters in the system.
        datasets DatasetInSystem % DatasetInSystem class with system datasets.
        ID (1,1) string % Identifier number of the system.
        headDefInc (1,1) string % Main income definition.
        name (1,1) string % Name of the system.
        parent % The country-specific class.
        policies PolicyInSystem % PolicyInSystem class with system policies.
        private (1,1) string % Access type.
        order (1,1) string % Order of a system in the spine.
        year (1,1) string % Year of a system.
    end

    properties (Hidden)
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        Info struct % Contains the 'Handler' field to the 'CountryInfoHandler.GetTypeInfo' output.
        policiesClass PolicyInSystem % PolicyInSystem class with system policies.
        datasetsClass DatasetInSystem % DatasetInSystem class with system datasets.
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.SYS) % System class tag.
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty System class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = System;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = System;
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
        function obj = System(Country)
            % System - A class with the EUROMOD tax-benefit systems.

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            % set parent
            obj.parent=copy(Country);
            obj.parent.indexArr=obj.parent.index;
            Idx=obj.parent.index;

            % set handler
            obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));

            % set index
            obj.indexArr = 1:obj.Info.Handler.Count;
            obj.index = obj.indexArr;
        end
        %==================================================================
        function x=get.bestmatchDatasets(obj)
            % bestmatchDatasets - Get the system best-match Dataset class array.

            bm=obj.datasets(1:end).bestMatch;
            bm=find(ismember(bm,"yes"));
            x= copy(obj.datasets);
            x=x(bm);
            x.indexArr=bm;
        end
        %==================================================================
        function x=get.policies(varargin)
            % policies - Get the system Policy class array.
            obj=varargin{1};

            if size(obj.policiesClass,1)==0
                obj.policiesClass=PolicyInSystem(obj);
                x=obj.policiesClass;
            else
                if all(obj.policiesClass.parent.index == obj.index)
                    x=obj.policiesClass;
                    x.index=obj.policiesClass.indexArr;
                else
                    obj.policiesClass=PolicyInSystem(obj);
                    x=obj.policiesClass;
                end
            end
        end
        %==================================================================
        function x=get.datasets(varargin)
            % datasets - Get the system Dataset class array.
            obj=varargin{1};

            if size(obj.datasetsClass,1)==0
                obj.datasetsClass=DatasetInSystem(obj);
                x=obj.datasetsClass;
            else
                if obj.datasetsClass.parent.index == obj.index
                    x=obj.datasetsClass;
                    x.index=obj.datasetsClass.indexArr;
                else
                    obj.datasetsClass=DatasetInSystem(obj);
                    x=obj.datasetsClass;
                end
            end
        end
    end
    methods (Hidden)
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.

            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            [values,keys]=utils.getInfo(obj.Info.Handler,obj.index,name);
            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end
        %==================================================================
        function x=headerComment(obj,varargin)
            % headerComment - Get the comment of the class array.
            N=size(obj,1);
            x=obj.getOtherProperties(["name","comment"],1:N)';
        end
    end
end