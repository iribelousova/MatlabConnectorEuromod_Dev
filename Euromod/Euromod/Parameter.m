classdef Parameter < Core
    % Parameter - A class with the parameters set up in a function.
    %
    % Syntax:
    %
    %     F = Parameter(Function);
    %
    % Description:
    %     This class contains the function-specific parameters. It is
    %     stored in the property 'parameters' of the Function class.
    %
    %     This class contains subclasses of type Extension.
    %
    %     This class serves also as a superclass for the ParameterInSystem
    %     subclass.
    %
    % Parameter Arguments:
    %     Function     - A class containing the country-specific policy.
    %
    % Parameter Properties:
    %     comment    - Comment specific to the parameter.
    %     extensions - Extension class with parameter extensions.
    %     funID      - Identifier number of the function at country level.
    %     group      - Parameter group value.
    %     ID         - Identifier number of the parameter.
    %     name       - Name of the parameter.
    %     order      - Order of the parameter in the specific spine.
    %     parent     - A class of the policy-specific function.
    %     spineOrder - Order of the parameter in the spine.
    %
    % Example:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     % Display the default parameters for function "DefVar":
    %     mm.('AT').policies(10).functions('DefVar').parameters
    %     % Display parameter "temp_count" for function "DefVar":
    %     mm.('AT').policies(10).functions('DefVar').parameters('temp_count')
    %
    % See also Model, Country, Policy, Function, ParameterInSystem, info, run.

    properties (Access=public)
        comment (1,1) string % Comment specific to the parameter.
        extensions Extension % Extension class with parameter extensions.
        funID (1,1) string % Identifier number of the reference function at country level.
        group (1,1) string % Parameter group value.
        ID (1,1) string % Identifier number of the parameter.
        name (1,1) string % Name of the parameter.
        order (1,1) string % Order of the parameter in the specific spine.
        parent % A class of the policy-specific function.
        spineOrder (1,1) string % Order of the parameter in the spine.
    end

    properties (Hidden)
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        commentArray (:,:) string % Comment for the class header.
        % Info - Contains information from the c# objects.
        % The 'Handler' field stores the 'CountryInfoHandler.GetTypeInfo'
        % output. The 'PieceOfInfo.Handler' stores the
        % 'CountryInfoHandler.GetPieceOfInfo' output.
        Info struct
        extensionsClass Extension % Extension class with parameter extensions.
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.PAR) % Parameter class tag.
    end

    methods (Static, Access = public,Hidden)
        function obj = empty(varargin)
            % empty - Re-assaign an empty Parameter class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Parameter;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Parameter;
            end

        end
    end
    methods
        %==================================================================
        function obj = Parameter(Function)
            % Parameter - A class with the parameters set up in a function.

            if nargin == 0
                return;
            end

            if isempty(Function)
                return;
            end

            obj.load(Function);
        end
        %==================================================================
        function x=get.extensions(varargin)
            % extensions - Get the parameter Extension class array.
            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=Extension(obj);
                x=obj.extensionsClass;
            else
                if all(obj.extensionsClass.parent.index == obj.index)
                    x=obj.extensionsClass;
                    x.index=obj.extensionsClass.indexArr;
                else
                    obj.extensionsClass=Extension(obj);
                    x=obj.extensionsClass;
                end
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
        function x=getID(obj)
            % getID - Get the IDs of all parameters.

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('FUN_ID');
            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('FUN_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end
            id=obj.parent.(tagID);

            x=obj.getPiecesOfInfo(Tag, subTag, id, [], 'ID');
        end
        %==================================================================
        function obj = load(obj, parent)
            % load - Load the Parameter class array objects.

            % get country class
            if isa(parent,'Country')
                cobj=copy(parent);
            else
                cobj=copy(parent.getParent("COUNTRY"));
            end
            Idx = cobj.index;

            % get system class
            if contains(class(obj),'InSystem')
                sobj=copy(parent.getParent("SYS"));
            else
                sobj=copy(cobj.systems);
            end

            % set system object
            if size(sobj,1)>1
                sysIdx=1;
            else
                sysIdx=sobj.index;
            end
            sobj=sobj.update(sysIdx);

            % set parent
            obj.parent=copy(parent);
            obj.parent.indexArr=obj.parent.index;

            % set handler
            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            obj.Info(1).Handler=cobj.Info(Idx).Handler.GetTypeInfo(Tag);

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
            IDs=obj.getID();
            tagID='ID';
            parentID=sobj.(tagID);
            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            % set index
            Order = str2double(string({out(:).Order}));
            [~,idxArr]=sort(Order);
            obj.indexArr=idxArr;
            obj.index=idxArr;
        end
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.

            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('FUN_ID');
            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('FUN_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end
            id=obj.parent.(tagID);

            [values,keys]=obj.getPiecesOfInfo(Tag, subTag, id, obj.index, name);

            if numel(keys)<numel(name)
                newkeys=name(~ismember(lower(name),lower(keys)));
                for i=1:numel(obj.index)
                    i_=obj.index(i);
                    [v,k]=utils.getInfo(obj.Info.PieceOfInfo(i_).Handler,newkeys);
                    [values,keys]=utils.setValueByKey(values,keys,v,k,i);
                    if ismember("SpineOrder",name)
                        Order=string(obj.Info.PieceOfInfo(i_).Handler.Item("Order"));
                        spine=string([char(obj.parent(1).spineOrder),'.',char(Order)]);
                        [values,keys]=utils.setValueByKey(values,keys,spine,"SpineOrder",i);
                    end
                end
            end

            idxID=ismember(keys,'ID');
            if any(idxID) && isa(obj,'ParameterInSystem')
                tagID=char(EM_XmlHandler.TAGS.('SYS_ID'));
                values(idxID,:)=append(values(ismember(keys,tagID),:),values(idxID,:));
            end

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
            if any(contains(keys,'switch'))
                keys(contains(keys,'switch'))='Switch';
            end

            if ismember("private",keys)
                idxKey=ismember(keys,"private");
                idx = ismember(values(idxKey,:),"");
                values(idxKey,idx)="no";
            end
        end
        %==================================================================
        function x=headerComment(obj,varargin)
            % headerComment - Get the comment of the class array.

            if isempty(obj.commentArray)
                if contains(class(obj),'InSystem')
                    [x,~]=getOtherProperties(obj,["name","value","comment"]);
                else
                    [x,~]=getOtherProperties(obj,["name","comment"]);
                end
                x=x';
                obj.commentArray=x;

            else
                x=obj.commentArray();
            end
        end


    end
end