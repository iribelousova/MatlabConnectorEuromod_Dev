% mod=struct()
% mod.model=struct();
% mod.H=EM_XmlHandler.CountryInfoHandler("C:\EUROMOD_RELEASES_I6.0+", 'BE')
% mod.tag=char(EM_XmlHandler.TAGS.FUN)

% pp=Parameter(mod,'1c643eab-e4d9-4770-a115-c16693afe438')
% ID='008745fd-3c9b-4ff3-9ce2-e34ab93dae36';


classdef Parameter < Core
    properties (Access=public,Hidden) %(Access={?utils.redefinesparen,?utils.dict2Prop}) 
        index (:,1) double
        indexArr (:,1) double
        parent
        Info struct
        commentArray (:,:) string
        extensionsClass
    end

    properties (Constant,Hidden)
        % tag = char(EM_XmlHandler.ReadCountryOptions.PAR)
        tag = char(EM_XmlHandler.TAGS.PAR)
    end

    properties (Access=public) 
        comment (1,1) string
        extensions ExtensionSwitch
        funID (1,1) string
        group (1,1) string
        ID (1,1) string
        name (1,1) string
        order (1,1) string
        spineOrder (1,1) string
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
        
        function obj = Parameter(Function)
            tic

            disp('Parameter')

            if nargin == 0
                return;
            end

            if isempty(Function)
                return;
            end

            obj.load(Function);

            toc
        end

        function x=getID(obj)

            % Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            % subTag=EM_XmlHandler.TAGS.('FUN_ID');
            % id=obj.parent(1).ID;

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('FUN_ID');
            % id=obj.parent(1).ID;
            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('FUN_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end
            id=obj.parent.(tagID);

            x=obj.getPiecesOfInfo(Tag, subTag, id, [], 'ID');

            % % parenID = utils.getInfo(obj.parent.Info.Handler,obj.parent.index,'ID');
            % Tag=char(EM_XmlHandler.TAGS.([char(obj.parent.tag),'_ID']));
            % if contains(class(obj),'InSystem')
            %     parenID=obj.parent(1).([lower(Tag(1)),Tag(2:end)]);
            % else
            %     parenID=obj.parent(1).ID;
            % end
            % parenID=char(parenID);
            % 
            % % Tag=char(lower(obj.parent.tag));
            % % Tag=[upper(Tag(1)),Tag(2:end),'ID'];
            % 
            % [parenIDs,~] = utils.getInfo(obj.Info.Handler,':',Tag);
            % in = find(ismember(parenIDs,string(parenID)));
            % 
            % x=utils.getInfo(obj.Info.Handler,in,'ID');
        end

        %------------------------------------------------------------------
        function obj = load(obj, parent)

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
            % if strcmp(class(obj),'Parameter') 
            %     tagID='ID';
            % else
            %     tagID=obj.tag_s_(sobj.tag,'ID');
            %     tagID=[lower(tagID(1)),tagID(2:end)];
            % end
            tagID='ID';
            parentID=sobj.(tagID);
            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            % [obj,out]=obj.getPieceOfInfo(cobj.systems,TAG,"Order");

            % set index
            Order = str2double(string({out(:).Order}));
            [~,idxArr]=sort(Order);
            obj.indexArr=idxArr;
            obj.index=idxArr;



            % if isa(obj,'ParameterInSystemMMM')
            %     par = cobj.policies.functions.parameters;
            %     metapar=metaclass(par);
            %     metaprops=string({metapar.PropertyList(:).Name});
            %     metaprops(ismember(metaprops,'tag'))=[];
            %     for jj=1:numel(metaprops)
            %         obj.(metaprops(jj))=par.(metaprops(jj));
            %     end
            % else
            % end

        end

        function [values,keys]=getOtherProperties(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            subTag=EM_XmlHandler.TAGS.('FUN_ID');
            % id=obj.parent(1).ID;
            if contains(class(obj),'InSystem')
                tagID=char(EM_XmlHandler.TAGS.('FUN_ID'));
                tagID=[lower(tagID(1)),tagID(2:end)];
            else
                tagID='ID';
            end
            id=obj.parent.(tagID);

            % Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            % subTag=EM_XmlHandler.TAGS.('FUN_ID');
            % id=obj.parent(1).ID;

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

            % if ismember("order",name)
            % 
            %     Order=strings(1,0);
            %     Spine = strings(1,0);
            %     for i=1:numel(obj.index)
            %         i_=obj.index(i);
            %         Order(1,end+1)=string(obj.Info.PieceOfInfo(i_).Handler.Item("Order"));
            %         if ismember("spineOrder",name)
            %             obj.parent(1).spineOrder
            %             Spine(1,end+1)=string([char(obj.parent(1).spineOrder),'.',char(Order(i))]);
            % 
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

            % [values,keys]=obj.getOtherProperties_Type1(name);

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

            % name=string(name);
            % name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
            % 
            % % obj.index=obj.indexArr(index);
            % 
            % N=size(obj,1);
            % M=numel(name);
            % values=strings(M,N);
            % IDs=strings(N,1);
            % keys=name;
            % keysDrop=keys;
            % 
            % t=[char(obj.tag),'_ID'];
            % subTag=EM_XmlHandler.TAGS.(t);
            % 
            % 
            % for i=1:N
            %     i_=obj.index(i);
            %     [v,k]=utils.getInfo(obj.Info.PieceOfInfo(i_).Handler,name);
            %     IDs(i)=obj.Info.PieceOfInfo(i_).Handler.Item(subTag);
            %     if  ~isempty(v)
            %         keys=[keys;k(~ismember(k,keys))];
            %         values = utils.setValueByKey(values,keys,v,k,i);
            %         keysDrop(ismember(keysDrop,k))=[];
            % 
            %         if any(ismember("SpineOrder",name)) 
            %             if any(ismember("Order",k)) 
            %                 Order=v(ismember(k,"Order"));
            %             else
            %                 Order=string(obj.Info.PieceOfInfo(i_).Handler.Item("Order"));
            %             end
            %             values(ismember(keys,"SpineOrder"),i)=string([char(obj.parent.spineOrder),'.',char(Order)]);
            %         end
            %     end
            % end
            % 
            % if ~isempty(keysDrop)
            %     [v,k]=utils.getInfo(obj.Info.Handler,IDs,keysDrop);
            %     keys=[keys;k(~ismember(k,keys))];
            %     values = utils.setValueByKey(values,keys,v,k);
            % end
            % 
            % keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            % if any(contains(keys,'iD'))
            %     keys(contains(keys,'iD'))='ID';
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

        function x=headerComment(obj,varargin)


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