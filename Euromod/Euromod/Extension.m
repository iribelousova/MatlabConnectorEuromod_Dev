classdef Extension < Core
    % Extension - EUROMOD extensions.
    %
    % Syntax:
    %
    %     E = Extension(Parent);
    %
    % Description:
    %     This class instantiates the EUROMOD extensions (Model and/or ...
    %     Country extensions). Class instances are automatically generated
    %     and stored in the attribute extensions of the base class Model
    %     (including the Model extensions only), as well as of the Country
    %     class (including both the Model and Country-specific extensions).
    %
    % Extension Arguments:
    %     Parent    - The Model base class or the Country class.
    %
    %  Extension Properties:
    %     ID        - Identifier number of the extension.
    %     name      - Long name of the extension.
    %     parent    - The model base class or the Country class.
    %     shortName - Short name of the extension.
    %
    %  Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     mod.('AT').extensions % displays the default model and country extensions for Austria.
    %     mod.('AT').extensions(3) % displays the specific Extension for Austria.
    %
    % See also Model, Country, ExtensionSwitch, local_extensions, info, run.

    properties (Access=public)
        % ID (1,1) string % Identifier number of the extension.
        name (1,1) string % Long name of the extension.
        parent % The model base class or the Country class.
        shortName (1,1) string % Short name of the extension.
    end

    properties (Hidden)
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        Info struct % Contains the 'Handler' field to the 'CountryInfoHandler.GetTypeInfo' output.
        tag (1,1) string

    end

    properties (Constant,Hidden)
        tagLocal = char(EM_XmlHandler.ReadCountryOptions.LOCAL_EXTENSION) % Country extension tag
    end

    methods (Static, Access = public)
        function obj = empty(varargin)
            % empty - Re-assaign an empty Extension class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Extension;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Extension;
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
        function obj = Extension(Parent)
            % Extension - EUROMOD extensions.

            if nargin == 0
                return;
            end

            if isempty(Parent)
                return;
            end

            obj.parent=copy(Parent);

            if isa(Parent,'Model')
                obj.tag = char(EM_XmlHandler.ReadModelOptions.('EXTENSIONS')); % Model extension tag

                P=obj.addprop('ID');
                P.NonCopyable = false;

                obj.Info(1).Handler = obj.parent.Info.Handler.GetModelInfo(...
                    EM_XmlHandler.ReadModelOptions.(obj.tag));

                obj.indexArr = 1:obj.Info.Handler.Count;
                obj.index=obj.indexArr;
            elseif isa(Parent,'Country')
                obj.tag = char(EM_XmlHandler.ReadModelOptions.('EXTENSIONS')); % Country extension tag
                P=obj.addprop('ID');
                P.NonCopyable = false;

                obj.parent.indexArr=obj.parent.index;
                Idx=obj.parent.index;

                % set handler
                Tag=EM_XmlHandler.ReadCountryOptions.(obj.tagLocal);
                obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(Tag);

                % set index
                obj.indexArr = 1:obj.Info.Handler.Count+obj.parent.parent.extensions.Info.Handler.Count;
                obj.index=obj.indexArr;
                if numel(obj.indexArr)==1
                    obj.update(obj.index);
                end
            else
                obj.tag = char(EM_XmlHandler.TAGS.EXTENSION); % EXTENSION Switch tag

                P=obj.addprop('baseOff');
                P.NonCopyable = false;

                P=obj.addprop('extensionID');
                P.NonCopyable = false;

                % add the dynamic property to class ExtensionSwitch
                newProp=Parent.tag_s_(Parent.tag,'ID');
                newProp=[lower(newProp(1)),newProp(2:end)];

                P=obj.addprop(newProp);
                P.NonCopyable = false;

                % set parent
                obj.parent.indexArr=obj.parent.index;
                obj.parent=obj.parent.update(obj.parent.index);

                % add the dynamic property to class ExtensionSwitch
                newProp=obj.tag_s_(Parent.tag,'ID');
                newProp=[lower(newProp(1)),newProp(2:end)];
                props=string(properties(obj));
                if ~ismember(newProp,props)
                    P=obj.addprop(newProp);
                    P.NonCopyable = false;
                    % obj.(newProp) = string;
                end

                % define tag
                if isa(Parent,'Policy') || isa(Parent,'ReferencePolicy') || isa(Parent,'PolicyInSystem')
                    TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,Policy.tag));
                else
                    TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,Parent.tag));
                end

                % get current object and parent object IDs
                IDs=obj.getID();
                if contains(class(obj.parent),'InSystem')
                    tagID=obj.tag_s_(obj.parent.tag,'ID');
                    tagID=[lower(tagID(1)),tagID(2:end)];
                else
                    tagID='ID';
                end
                parentID=obj.parent.(tagID);

                % set handler
                [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG);

                % set index
                if  numel(fieldnames(obj.Info.PieceOfInfo))==0
                    obj=Extension;
                else
                    obj.indexArr = 1:numel(obj.Info.PieceOfInfo);
                    obj.index=obj.indexArr;

                    if numel(obj.indexArr)==1
                        obj.update(obj.index);
                    end
                end
            end
        end
    end

    methods (Hidden)
        %==================================================================
        function x = getID(obj)

            cobj=copy(obj.getParent("COUNTRY"));

            ID1=cobj.extensions(1:end).ID;
            x=ID1;
        end
        %==================================================================
        function [values,keys] =getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.

            if isa(obj.parent,'Model')
                [values,keys] = obj.getOtherPropertiesModel(name,index);
            elseif isa(obj.parent,'Country')
                [values,keys] = obj.getOtherPropertiesCountry(name,index);
            else
                [values,keys]=obj.getOtherPropertiesSubClass(name,index);
            end

        end
        %==================================================================
        function [values,keys] =getOtherPropertiesModel(obj,name,index)
            % getOtherPropertiesModel - Get the properties of type string
            % from Model extensions.
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            [values,keys]=utils.getInfo(obj.Info.Handler,obj.index,name);
            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end

            values(strcmp(keys,"look"),:) = [];
            keys(strcmp(keys,"look")) = [];

        end
        %==================================================================
        function [values,keys]=getOtherPropertiesCountry(obj,name,index)
            % getOtherPropertiesCountry - Get the properties of type string
            % from Country extensions.
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            % initialize
            values=strings(numel(name),size(obj,1));
            keys=name;

            % get index for local extensions
            idx=ismember(obj.index,1:obj.Info.Handler.Count);
            if sum(idx)==obj.Info.Handler.Count
                idxLocalVal=obj.index(idx);
                idxLocal=obj.index(idx);
            elseif sum(idx)<obj.Info.Handler.Count && sum(idx)~=0
                idxLocal=obj.index(idx);
                idxLocalVal=1:sum(idx);
            elseif sum(idx)==0
                idxLocal=[];
            end

            % get index for model extensions
            idx=~ismember(obj.index,idxLocal);
            if sum(idx)==obj.parent.parent.extensions.Info.Handler.Count
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
            elseif sum(idx)<obj.parent.parent.extensions.Info.Handler.Count && sum(idx)~=0
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
                if isempty(idxLocal)
                    ini=0;
                else
                    ini=idxLocalVal;
                end
                idxModelVal=ini+1:sum(idx)+ini;
            elseif sum(idx)==0
                idxModel=[];
            end

            % try get info from country extensions
            if ~isempty(idxLocal)
                [v,k]=utils.getInfo(obj.Info.Handler,idxLocal,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxLocalVal);
            end

            % try get info from model extensions
            if ~isempty(idxModel)
                [v,k]=utils.getInfo(obj.parent.parent.extensions.Info.Handler,idxModel,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxModelVal);
            end

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end
        %==================================================================
        function [values,keys]=getOtherPropertiesSubClass(obj,name,index)

            N=size(obj,1);
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
            keys=name;
            values=strings(numel(name),N);

            IDs = strings(1,N);

            cobj=obj.getParent('COUNTRY');
            for i=1:N
                idx=obj.index(i);
                [v,k]=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,name);
                if ismember('ID',k)
                    % IDs(i)=v(ismember(k,'ID'),:);
                    ID=v(ismember(k,'ID'),:);
                else
                    % IDs(i)=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,'ExtensionID');
                    ID=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,'ExtensionID');
                end
                % keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,i);

                try
                    [v,k]=utils.getInfo(cobj.extensions.Info.Handler,ID,name);
                    values = utils.setValueByKey(values,keys,v,k,i);
                catch
                end
                try
                    [v,k]=utils.getInfo(cobj.parent.extensions.Info.Handler,ID,name);
                    values = utils.setValueByKey(values,keys,v,k,i);
                catch
                end
            end

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end
        %==================================================================
        function x=headerComment(obj)
            % headerComment - Get the comment of the class array.
            if isa(obj.parent,'Model') || isa(obj.parent,'Country')
                x=obj.headerComment_Type1(["shortName","name"]);
            else
                N=size(obj,1);
                x=obj.getOtherProperties({'name','baseOff','comment'},1:N)';
                % x=obj(:).baseOff;
                x(strcmp(x,'true'))='off';
                x(strcmp(x,'false'))='on';
            end
        end
    end
end