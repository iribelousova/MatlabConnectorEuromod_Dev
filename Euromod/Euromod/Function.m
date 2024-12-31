classdef Function < Core
    % Function - Class array of functions defined in a tax-benefit policy.
%
% Syntax:
%
%     F = Function(Policy);
%
% Description:
%     This class contains functions implemented in a specific tax-
%     benefit policy. The class elements can be accessed by indexing the 
%     class array with an integer, or a string value of any class property
%     (e.g. the name, the ID, the order, etc.).
%
%     This class is stored in the property |functions| of the |Policy| class. 
%
%     This class stores classes of type |Extension| and |Parameter|.
%
%     This class is the superclass of the |FunctionyInSystem| class.
%
% Input Arguments:
%     Policy     - (1,1) class. A specific tax-benefit policy.
%
% Properties:
%     comment    - (1,1) string. Comment specific to the function.
%     extensions - (N,1) class.  Extension class array with function extensions.
%     ID         - (1,1) string. Identifier number of the function.
%     name       - (1,1) string. Name of the function.
%     order      - (1,1) string. Order of the function in the spine.
%     parameters - (N,1) class.  Parameter class array with function parameters.
%     parent     - (1,1) class.  The parent class |Policy|.
%     polID      - (1,1) string. Identifier number of the parent class.
%     private    - (1,1) string. Access type.
%     spineOrder - (1,1) string. Order of the function in the policy spine.
%
% Examples:
%     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
%     % Display the default functions for policy "uprate_at":
%     mod.('AT').policies(2).functions
%     % Display the functions "Uprate" for policy "uprate_at":
%     mod.('AT').policies(2).functions("Uprate")
%
% See also Model, Country, Policy, FunctionInSystem, info, run.

    properties (Access=public)
        comment (1,1) string % Comment specific to the function.
        extensions Extension % Extension class with function extensions.
        ID (1,1) string % Identifier number of the function.
        name (1,1) string % Name of the function.
        order (1,1) string % Order of the function in the specific spine.
        parameters Parameter % Parameter class with function parameters.
        parent % A class of the country-specific policy.
        polID (1,1) string % Identifier number of the policy.
        private (1,1) string % Access type.
        spineOrder (1,1) string % Order of the function in the spine.
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
        parametersClass Parameter % Parameter class with function parameters.
        extensionsClass Extension % Extension class with function extensions.
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.FUN) % Function class tag.
    end

    methods (Static, Access = public,Hidden)
        %==================================================================
        function obj = empty(varargin)
            % empty - Re-assaign an empty Function class.
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Function;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Function;
            end

        end
    end
    methods
        %==================================================================
        function obj = Function(Policy)
            % Function - A class with the policy-specific functions.

            if nargin == 0
                return;
            end

            if isempty(Policy)
                return;
            end

            obj.load(Policy);
        end
        %==================================================================
        function x=get.extensions(varargin)
            % extensions - Get the function Extension class array.

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
        %==================================================================
        function x=get.parameters(varargin)
            % parameters - Get the function Parameter class array.

            obj=varargin{1};

            if size(obj.parametersClass,1)==0
                if strcmp(class(obj),'Function')
                    obj.parametersClass=Parameter(obj);
                elseif strcmp(class(obj),'FunctionInSystem')
                    obj.parametersClass=ParameterInSystem(obj);
                end
                x=obj.parametersClass;
            else
                if all(obj.parametersClass.parent.index == obj.index)
                    x=obj.parametersClass;
                    x.index=obj.parametersClass.indexArr;
                else
                    if strcmp(class(obj),'Function')
                        obj.parametersClass=Parameter(obj);
                    elseif strcmp(class(obj),'FunctionInSystem')
                        obj.parametersClass=ParameterInSystem(obj);
                    end
                    x=obj.parametersClass;
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
            % getID - Get the IDs of all functions.

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('POL_ID');

            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('POL_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end

            id=obj.parent.(tagID);

            x=obj.getPiecesOfInfo(Tag, subTag, id, [], 'ID');
        end
        %==================================================================
        function obj = load(obj, parent)
            % load - Load the Function class array objects.

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

            % get system class
            if contains(class(obj),'InSystem')
                sobj=copy(obj.parent.getParent("SYS"));
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

            % set handler
            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            obj.Info(1).Handler=cobj.Info(Idx).Handler.GetTypeInfo(Tag);

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));

            % get current object and parent object IDs
            IDs=obj.getID();
            tagID='ID';
            parentID=sobj.(tagID);

            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            % set index
            if isempty(out)
                return;
            else
                Order = str2double(string({out(:).Order}));
                [~,idxArr]=sort(Order);
                obj.indexArr=idxArr;
                obj.index=idxArr;
            end

        end
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            % getOtherProperties - Get the properties of type string.

            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('POL_ID');
            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('POL_ID'));
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
            if any(idxID) && isa(obj,'FunctionInSystem')
                tagID=char(EM_XmlHandler.TAGS.('SYS_ID'));
                if any(ismember(keys,tagID))
                    values(idxID,:)=append(values(ismember(keys,tagID),:),values(idxID,:));
                end
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

            idx=find(ismember(obj.indexArr,obj.index));
            if isempty(obj.commentArray)
                temp=copy(obj);
                temp.index=temp.indexArr;
                x=temp.headerComment_Type2();

                obj.commentArray = x;
                x=x(idx,:);
            else
                x=obj.commentArray(idx,:);
            end
        end
    end

end