% mod=struct()
% mod.model=struct();
% mod.model.CIH=EM_XmlHandler.CountryInfoHandler("C:\EUROMOD_RELEASES_I6.0+", 'BE')
% mod.tag=char(EM_XmlHandler.TAGS.POL)
% ff=Function(mod,'ba790a98-7346-4ab3-806b-d944ca5ca77e')
% ID='008745fd-3c9b-4ff3-9ce2-e34ab93dae36';

% modelpath= "C:\EUROMOD_RELEASES_I6.0+";
% mod = struct();
% mod.modelpath=modelpath;
% mod.modelInfoHandler = EM_XmlHandler.ModelInfoHandler(modelpath);
% mod.emCommon = EM_Common.EMPath(modelpath, true);
% cc=Country(mod,'BE')

classdef Function < Core
    properties (Access=public,Hidden) %(Access={?utils.redefinesparen,?utils.dict2Prop}) 
        index (:,1) double
        indexArr (:,1) double
        commentArray (:,:) string
        parent 
        Info struct
        parametersClass
        extensionsClass
    end

    properties (Constant,Hidden)
        % tag = char(EM_XmlHandler.ReadCountryOptions.FUN)
        tag = char(EM_XmlHandler.TAGS.FUN)
    end

    properties (Access=public) 
        comment (1,1) string
        extensions ExtensionSwitch
        ID (1,1) string
        name (1,1) string
        order (1,1) string
        parameters 
        polID (1,1) string
        private (1,1) string
        spineOrder (1,1) string
    end

    % properties (GetAccess={?ExtensionSwitch})
    %     funID (1,1) string
    % end

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
        
        function obj = Function(Policy)

            % modelpath = "C:\EUROMOD_RELEASES_I6.0+";

            % obj.comment = 'Comment about the specific policy.';
            % obj.extensions = 'A list of policy-specific Extension objects.';
            % % obj.parameters = 'A list with FunctionInSystem objects specific to the system.';
            % obj.ID = 'Identifier number';
            % obj.name = 'Long name';
            % obj.order = 'Order in the policy spine.';
            % obj.polID = 'Short name';
            % obj.spineOrder = 'Order of the policy in the spine.';

            if nargin == 0
                return;
            end

            if isempty(Policy)
                return;
            end

            obj.load(Policy);

            disp('Function')
        end

        function x=getID(obj)
            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('POL_ID');

            if contains(class(obj),'InSystem')
                % tagID=obj.tag_s_(obj.tag,'ID');
                % tagID=[lower(tagID(1)),tagID(2:end)];
                tagID=char(EM_XmlHandler.TAGS.('POL_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end

            % obj.parent=obj.parent.update(obj.parent.index)

            id=obj.parent.(tagID);

            x=obj.getPiecesOfInfo(Tag, subTag, id, [], 'ID');

            % % parenID = utils.getInfo(obj.parent.Info.Handler,obj.parent.index,'ID');
            % parenID=obj.parent.getID;
            % parenID=char(parenID(obj.parent.index));
            % 
            % % Tag=char(lower(obj.parent.tag));
            % Tag=[obj.parent.tag,'_ID'];
            % Tag=char(EM_XmlHandler.TAGS.(Tag));
            % 
            % [parenIDs,~] = utils.getInfo(obj.Info.Handler,':',Tag);
            % in = find(ismember(parenIDs,string(parenID)));
            % 
            % x=utils.getInfo(obj.Info.Handler,in,'ID');
        end

        %------------------------------------------------------------------
        function obj = load(obj, parent)

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

            % subTag=EM_XmlHandler.TAGS.('POL_ID');
            % id=obj.parent(1).ID;
            % obj.Info(1).PiecesOfInfo
            % [v,k]=obj.getPiecesOfInfo(Tag,subTag,id)
            % out=cobj.Info(Idx).Handler.GetPiecesOfInfoInList(Tag,subTag,id);

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));

            % get current object and parent object IDs
            IDs=obj.getID();
            % if contains(class(obj.parent),'InSystem')
            %     tagID=obj.tag_s_(obj.parent.tag,'ID');
            %     tagID=[lower(tagID(1)),tagID(2:end)];
            % else
            %     tagID='ID';
            % end
            tagID='ID';
            parentID=sobj.(tagID);

            % if strcmp(class(obj),'Function') 
            %     tagID='ID';
            % else
            %     tagID=obj.tag_s_(sobj.tag,'ID');
            %     tagID=[lower(tagID(1)),tagID(2:end)];
            % end
            % tagID='ID';
            
            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");
            % [obj,out]=obj.getPieceOfInfo(cobj.systems,TAG,"Order");

            % set index
            Order = str2double(string({out(:).Order}));
            [~,idxArr]=sort(Order);
            obj.indexArr=idxArr;
            obj.index=idxArr;

        end

        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');


            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('POL_ID');
            % id=obj.parent(1).ID;
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
                values(idxID,:)=append(values(ismember(keys,tagID),:),values(idxID,:));
            end

            % if ismember("order",name)
            %     % orn="order";
            %     % if ismember("spineOrder",name)
            %     %     orn(end+1)="spineOrder";
            %     % end
            %     % TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
            % 
            %     Order=strings(1,0);
            %     Spine = strings(1,0);
            %     for i=1:numel(obj.index)
            %         i_=obj.index(i);
            %         Order(1,end+1)=string(obj.Info.PieceOfInfo(i_).Handler.Item("Order"));
            %         if ismember("spineOrder",name)
            %             Spine(1,end+1)=string([char(obj.parent(1).spineOrder),'.',char(Order(i))]);
            %         end
            %     end
            % 
            %     keys(end+1)="order";
            %     values(end+1,:)=Order;
            %     if ismember("spineOrder",name)
            %         keys(end+1)="spineOrder";
            %         values(end+1,:)=Spine;
            %     end
            % end

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
            
            % [values,keys]=obj.getOtherProperties_Type1(name);
        end

        function x=headerComment(obj,varargin)

            idx=find(ismember(obj.indexArr,obj.index));
            if isempty(obj.commentArray)
                temp=copy(obj);
                temp.index=temp.indexArr;
                x=temp.headerComment_Type2();

                obj.commentArray = x;
                x=x(idx,:);
            else
                x=obj.commentArray(idx,:);
                % x=obj.commentArray;
            end

            % % idx=ismember(obj.indexArr,obj.index);
            % 
            % if isempty(obj.commentArray)
            % 
            % 
            % 
            %     % % x=obj.headerComment_Type2();
            %     % 
            %     % [x,~]=getOtherProperties(obj,["name","comment"]);
            %     % x=x';
            %     % obj.commentArray=x;
            % 
            %     % [~,b]=sort(obj.indexArr);
            %     % obj.commentArray=x(b,:);
            %     % 
            %     % x=x(b,:);
            %     % x=x(idx,:);
            % 
            %     % N=numel(obj.indexArr);
            %     % middlecom=strings(N,1);
            %     % 
            %     % idxRefPol=obj.indexArr>obj.Info.Handler.Count;
            %     % 
            %     % temp=copy(obj);
            %     % [strProps,~]=utils.splitproperties(temp);
            %     % comel=cell(N,1);
            %     % names=strings(N,1);
            %     % comm=strings(N,1);
            %     % for jj=1:N
            %     %     temp.update(jj,{strProps;"extensions"});
            %     %     comel{jj}=temp.extensions(':',{'shortName','baseOff'});
            %     %     names(jj)=temp.name;
            %     %     comm(jj)=temp.comment;
            %     % end
            %     % 
            %     % idxExt =~cellfun(@isempty,comel);
            %     % extName=cellfun(@(t) string({t(:).shortName})',comel(idxExt),'UniformOutput',false);
            %     % extName=cellfun(@(t) strjoin(t(1:numel(t)*(numel(t)<=3)+3*(numel(t)>3)),','),extName);
            %     % 
            %     % if ~isempty(extName)
            %     %     extCom=append("(with switch set for ",extName,")");
            %     %     middlecom(idxExt)=extCom;
            %     % end
            %     % 
            %     % % reference policy middle comment
            %     % if any(idxRefPol)
            %     %     refPolCom=obj.refPols.headerComment();
            %     %     middlecom(idxRefPol)=refPolCom;
            %     % end
            %     % 
            %     % x=[names,middlecom,comm];
            %     % 
            %     % [~,b]=sort(obj.indexArr);
            %     % obj.commentArray=x(b,:);
            %     % 
            %     % x=x(b,:);
            %     % x=x(obj.index,:);
            % else
            %     x=obj.commentArray();
            % end
        end

        function x=get.extensions(varargin)
            obj=varargin{1};

            if size(obj.extensionsClass,1)==0
                obj.extensionsClass=ExtensionSwitch(obj);
                x=obj.extensionsClass;
            else
                if all(obj.extensionsClass.parent.index == obj.index)
                    x=obj.extensionsClass;
                    x.index=obj.extensionsClass.indexArr;
                else
                    obj.extensionsClass=ExtensionSwitch(obj);
                    x=obj.extensionsClass;
                end
            end
        end

        function x=get.parameters(varargin)
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

end