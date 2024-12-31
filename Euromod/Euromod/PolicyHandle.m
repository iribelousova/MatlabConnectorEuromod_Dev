classdef PolicyHandle < Core
    % PolicyHandle - Superclass of the Policy and the ReferencePolicy
    % classes.
    %
    % Syntax:
    %
    %     PH = PolicyHandle();
    %
    % Description:
    %     This is a superclass implemented in the Policy and ReferencePolicy
    %     subclasses. The Policy class is, in its turn, a superclass for the
    %     PolicyInSystem subclass.
    %
    %     This class contains a subclass of type Extension.
    %
    % PolicyHandle Properties:
    %     extensions - Extension class with the policy extensions.
    %     ID         - Identifier number of the policy.
    %     name       - Name of the policy.
    %     order      - Order of the policy in the specific spine.
    %     parent     - The country-specific class.
    %     spineOrder - Order of the policy in the spine.
    %
    % See also Model, Country, Policy, PolicyInSystem.

    properties (Access=public)
        extensions Extension % Extension class with the policy extensions.
        ID (1,1) string % Identifier number of the policy.
        name (1,1) string % Name of the policy.
        order (1,1) string % Order of the policy in the specific spine.
        parent % The country-specific class.
        spineOrder (1,1) string % Order of the policy in the spine.
    end

    properties (Hidden)
        indexArr (:,1) double % Index array of the class.
        index (:,1) double % Index of the element in the class.
        % Info - Contains information from the c# objects.
        % The 'Handler' field stores the 'CountryInfoHandler.GetTypeInfo'
        % output. The 'PieceOfInfo.Handler' stores the
        % 'CountryInfoHandler.GetPieceOfInfo' output.
        Info struct
        commentArray (:,:) string % Comment for the class header.
        policyArray struct % Infos about all the country policies.
        extensionsClass Extension % Extension class with the policy extensions.
    end

    methods
        %==================================================================
        function obj = PolicyHandle()
            % PolicyHandle - Superclass of the Policy and the ReferencePolicy

            % Set property "private"
            if ismember("private",properties(obj))
                obj.private = "no";
            end
        end
        %==================================================================
        function x=get.extensions(varargin)
            % extensions - Get the policy Extension class array.

            obj=varargin{1};

            if strcmp(class(obj),"ReferencePolicy")
                x=Extension;
                return;
            end

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
            % getID - Get the IDs of all policies.

            if strcmp(class(obj),'Policy') || strcmp(class(obj),'PolicyInSystem')
                xPol = utils.getInfo(obj.Info.Handler,':','ID');
                xRef = utils.getInfo(obj.Info.HandlerRef,':','ID');
                x=[xPol,xRef];
            elseif strcmp(class(obj),'ReferencePolicy')
                x = utils.getInfo(obj.Info.HandlerRef,':','ID');
            end
        end

        %==================================================================
        function obj = load(obj, parent)
            % load - Load the Policy class array objects.

            % set parent
            obj.parent=copy(parent);
            obj.parent.indexArr=obj.parent.index;

            if isa(parent,'Country')
                % get country class
                cobj=copy(obj.parent);
                Idx = cobj.index;

                % get system class
                sobj=copy(cobj.systems);

                % update system object
                sobj=sobj.update(1);
            elseif isa(parent,'System')
                obj.parent=obj.parent.update(obj.parent.index);

                % get system class
                sobj=copy(obj.parent);

                % get country class
                cobj=copy(sobj.parent);
                Idx = cobj.index;
            end

            % set handler
            Tag=EM_XmlHandler.ReadCountryOptions.(Policy.tag);
            obj.Info(1).Handler=cobj.Info(Idx).Handler.GetTypeInfo(Tag);

            % set handler reference policies
            TagRef=EM_XmlHandler.ReadCountryOptions.(ReferencePolicy.tag);
            obj.Info(1).HandlerRef=cobj.Info(Idx).Handler.GetTypeInfo(TagRef);

            % get IDs
            IDs=obj.getID();
            tagID='ID';
            parentID=sobj.(tagID);

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,Policy.tag));
            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            obj.policyArray=out;

            % set index
            if isempty(out)
                return;
            else
                Order=string({out(:).Order});
                Order = str2double(Order);
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

            % set attributes to redefine the ID value
            idxID=ismember(name,'ID');
            newname=name;
            if any(idxID) && isa(obj,'PolicyInSystem')
                tObj=[char(obj.tag),'_ID'];
                tObj=char(EM_XmlHandler.TAGS.(tObj));
                tRel=[char(System.tag),'_ID'];
                tRel=char(EM_XmlHandler.TAGS.(tRel));
                if ~ismember(tObj,name)
                    newname(end+1)=tObj;
                end
                if ~ismember(tRel,name)
                    newname(end+1)=tRel;
                end
            end

            N=size(obj,1);
            M=numel(newname);
            values=strings(M,N);
            keys=newname;

            Order=zeros(1,0);
            for i=1:numel(obj.Info.PieceOfInfo)
                [v,k]=utils.getInfo(obj.Info.PieceOfInfo(i).Handler);
                Order(i)=str2double(v(ismember(k,'Order'),:));
            end

            if strcmp(class(obj),'ReferencePolicy') && all(obj.indexArr<=obj.Info.HandlerRef.Count)
                %...take info from ref pol main handler
                [v,k]=utils.getInfo(obj.Info.HandlerRef,obj.index,newname);
                [values,keys] = utils.setValueByKey(values,keys,v,k);   
                % try get info from Policy object
                RefPolID=utils.getInfo(obj.Info.HandlerRef,obj.index,"RefPolID");
                [v,k]=utils.getInfo(obj.Info.Handler,RefPolID,newname);
                [values,keys] = utils.setValueByKey(values,keys,v,k);
            else


                % try get info from Policy object
                valIdx=obj.index<=obj.Info.Handler.Count;
                if any(valIdx)
                    polIdx=obj.index(valIdx);
                    valIdx=find(valIdx);
    
                    % get info from main Policy handler
                    [v,k]=utils.getInfo(obj.Info.Handler,polIdx,newname);
                    [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx);
                end
    
                % try get info from ReferencePolicy object
                valIdx=obj.index>obj.Info.Handler.Count;
                if any(valIdx)
                    polIdxRef=double(obj.index(valIdx))-double(obj.Info.Handler.Count);
                    valIdx=find(valIdx);
                    %...take info from ref pol main handler
                    [v,k]=utils.getInfo(obj.Info.HandlerRef,polIdxRef,newname);
                    [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx);
    
                    %...take info from ref pol country handler
                    if any(any(strcmp("",values)))
                        if ismember("RefPolID",keys)
                            refIDs=values(ismember(keys,"RefPolID"),:);
                        else
                            refIDs=utils.getInfo(obj.Info.HandlerRef,polIdxRef,"RefPolID");
                        end
                        Tag=EM_XmlHandler.ReadCountryOptions.(Policy.tag);
                        cobj=getParent(obj,"COUNTRY");
                        Idx = cobj.index;
                        for ir=1:numel(refIDs)
                            refCountry=cobj.Info(Idx).Handler.GetPieceOfInfo(Tag,refIDs(ir));
                            [v,k]=utils.getInfo(refCountry,newname);
                            if ismember("ID",k)
                                k(ismember(k,"ID"))="RefPolID";
                            end
                            [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx(ir));
                        end
                    end
                end
            end

            % get info from PieceOfInfo handler
            if any(strcmp("",values))
                for j=1:N
                    [v,k]=utils.getInfo(obj.Info.PieceOfInfo(obj.index(j)).Handler,newname);
                    [values,keys] = utils.setValueByKey(values,keys,v,k,j);

                    if any(ismember("SpineOrder",newname))
                        if any(ismember("Order",newname))
                            Order=v(ismember(k,"Order"),:);
                        else
                            Order=string(obj.Info.PieceOfInfo(polIdx(j)).Handler.Item("Order"));
                        end
                        values(ismember(keys,"SpineOrder"),j)=Order;
                    end

                end
            end

            % set the ID value
            if any(idxID) && isa(obj,'PolicyInSystem')
                values(idxID,:)=append(values(ismember(keys,tRel),:),values(ismember(keys,tObj),:));
            end

            % Set the default value for property "private"
            if ismember("Private",keys)
                idxKey=ismember(keys,"Private");
                idx = ismember(values(idxKey,:),"");
                values(idxKey,idx)="no";
            end

            % remove not requested properties
            idxDrop=~ismember(keys,name);
            keys(idxDrop)=[];
            values(idxDrop,:)=[];

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
            if any(contains(keys,'switch'))
                keys(contains(keys,'switch'))='Switch';
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