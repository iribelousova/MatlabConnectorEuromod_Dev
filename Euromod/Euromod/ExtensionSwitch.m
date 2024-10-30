classdef ExtensionSwitch < Core
    % ExtensionSwitch - A class containing the extension switches of an object.
    %
    % Syntax:
    %
    %     E = ExtensionSwitch(Country,info);
    %
    % Description:
    %
    %
    % ExtensionSwitch Arguments:
    %     Country        - (class) Country class.
    %     info           - (struct) Structure with fields 'ext_name',
    %                      'dataset_name','sys_name'. Provide at least one
    %                      value. Fields not used must be empty objects.
    %
    %  ExtensionSwitch Properties:
    %     dataID         - Identifier number of dataset
    %     data_name      - Name of dataset
    %     extensionID    - Identifier number of extension
    %     extension_name - Short name of extension
    %     sysID          - Identifier number of system
    %     sys_name       - Name of system
    %     value          - Switch value of extension
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     ctry=mod.AT;
    %     s = struct('sys_name','AT_2021','dataset_name','','ext_name','')
    %     E = ExtensionSwitch(ctry,s)
    %     s = struct('sys_name','AT_2021','dataset_name','AT_2020_b2','ext_name','')
    %     E = ExtensionSwitch(ctry,s)
    %     s = struct('sys_name','AT_2021','dataset_name','','ext_name','WEB')
    %     E = ExtensionSwitch(ctry,s)
    %     s = struct('sys_name','AT_2021','dataset_name','','ext_name','')
    %     E = ExtensionSwitch(ctry,s)
    %
    % See also Model, Country, Extension, local_extensions, info, run.

    properties (Access=public)
        dataID (1,1) string % Identifier number of dataset
        data_name (1,1) string % Name of dataset
        extensionID (1,1) string % Identifier number of extension
        extension_name (1,1) string % Short name of extension
        sysID (1,1) string % Identifier number of system
        sys_name (1,1) string % Name of system
        value (1,1) string % Switch value of extension
    end

    properties (Hidden=true)
        index (:,1) double
        indexArr (:,1) double
        parent
        Info struct
    end

    properties (Access=protected,Hidden)
        dataIDHidden (:,:) string
        data_nameHidden (:,:) string
        extensionIDHidden (:,:) string
        extension_nameHidden (:,:) string
        sysIDHidden (:,:) string
        sys_nameHidden (:,:) string
        valueHidden (:,:) string
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.EXTENSION)
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = ExtensionSwitch;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = ExtensionSwitch;
            end
        end
    end
    methods
        %==================================================================
        function obj = ExtensionSwitch(Country,info)

            if nargin == 0
                return;
            end

            obj.parent=copy(Country);
            Idx=Country.index;
            H=Country.Info(Idx).Handler;
            % patterns = NET.createGeneric('System.Collections.Generic.List',{'System.String'}, 1);
            % keys = NET.createGeneric('System.Collections.Generic.List',{'System.String'}, 1);

            keys=[];
            patterns=[];
            if ~isempty(info.ext_name)
                keys=[keys,string(EM_XmlHandler.TAGS.EXTENSION_ID)];
                patterns=[patterns,Country.extensions(string(info.ext_name)).ID];
            end
            if ~isempty(info.dataset_name)
                keys=[keys,string(EM_XmlHandler.TAGS.DATA_ID)];
                patterns=[patterns,Country.datasets(string(info.dataset_name)).ID];
            end
            if ~isempty(info.sys_name)
                keys=[keys,string(EM_XmlHandler.TAGS.SYS_ID)];
                patterns=[patterns,Country.systems(string(info.sys_name)).ID];
            end
            out=H.GetPiecesOfInfoInList(EM_XmlHandler.ReadCountryOptions.EXTENSION_SWITCH,keys(1),patterns(1));

            v=strings(out.Item(1).Count,out.Count);
            [v(:,1),keys]=utils.getInfo(out.Item(1));
            Nk=numel(keys);
            i=1;
            for count=1:out.Count-1
                i=i+1;
                [v1,k]=utils.getInfo(out.Item(count));
                v(1:Nk,i)=v1;
            end
            if numel(patterns)>1
                [a,b]=ismember(v,patterns(2:end));
                [a,b]=find(a);
                v=v(:,b);
            end

            N=size(v,2);

            extensionID=v(ismember(k,'ExtensionID'),:);
            extension_names=Country.extensions(extensionID).shortName;
            if ~isempty(info.ext_name)
                extension_names=repmat(extension_names,1,N);
            else
                extension_names=extension_names';
            end
            dataID=v(ismember(k,'DataID'),:);
            data_names=Country.datasets(dataID).name;
            if ~isempty(info.dataset_name)
                data_names=repmat(data_names,1,N);
            else
                data_names=data_names';

            end
            sysID=v(ismember(k,'SysID'),:);
            sys_names=Country.systems(sysID).name;
            if ~isempty(info.sys_name)
                sys_names=repmat(sys_names,1,N);
            else
                sys_names=sys_names';
            end

            obj.Info(1).Handler=out;
            obj.dataIDHidden = dataID;
            obj.data_nameHidden = data_names;
            obj.extensionIDHidden = extensionID;
            obj.extension_nameHidden = extension_names;
            obj.sysIDHidden = sysID;
            obj.sys_nameHidden = sys_names;
            obj.valueHidden = v(ismember(k,'Value'),:);
            obj.indexArr=1:N;
            obj.index=1:N;
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
        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);
            M=numel(name);
            N=size(obj,1);
            Idx=obj.index;
            values=strings(M,N);
            for i=1:M
                values(i,:)=obj.([char(name(i)),'Hidden'])(Idx);
            end
            keys=name;
        end
        %==================================================================
        function x=headerComment(obj)
            % x=obj.headerComment_Type1();

            N=size(obj,1);
            x1=obj.getOtherProperties({'extension_name','data_name','sys_name','value'},1:N)';
            x=join(x1(:,1:end-1),',  ');
            x(:,2)=x1(:,end);

        end
    end
end

