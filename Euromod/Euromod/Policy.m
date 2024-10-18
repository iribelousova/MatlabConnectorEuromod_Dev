% mod=struct()
% mod.model=struct();
% mod.model.CIH=EM_XmlHandler.CountryInfoHandler("C:\EUROMOD_RELEASES_I6.0+", 'BE')
% mod.tag=char(EM_XmlHandler.TAGS.COUNTRY)
% mod.orderArr='3';

% mm.countries(2).policies(19).functions(2).extensions


% pp=Policy(mod)

% modelpath= "C:\EUROMOD_RELEASES_I6.0+";
% mod = struct();
% mod.modelpath=modelpath;
% mod.modelInfoHandler = EM_XmlHandler.ModelInfoHandler(modelpath);
% mod.emCommon = EM_Common.EMPath(modelpath, true);
% cc=Country(mod,'BE')

classdef Policy < PolicyHandle % Core   %< utils.redefinesparen & utils.CustomDisplay

    properties (Access=public,Hidden) %(Access={?utils.redefinesparen,?utils.dict2Prop})
        % parent
        % Info struct
        % index (:,1) double
        % indexArr (:,1) double
        % % refPols ReferencePolicy
        % commentArray (:,:) string
        % % extensionsArray (:,1) cell
        % % functionsArray (:,1) cell
        % policyArray struct
        % extensionsClass
        functionsClass
        % indexArr
    end

    % properties (Constant,GetAccess=protected,Hidden)
    %     tag = char(EM_XmlHandler.TAGS.POL)
    %     % tagRef = char(EM_XmlHandler.TAGS.REFPOL)
    %     % tag = char(EM_XmlHandler.ReadCountryOptions.POL)
    %     % tag = char(utils.assembly.ReadCountryOptions('POL'))
    % end

    % properties (Access=private)
    %     functionsPrivate = Function;
    % end


    properties (Access=public)
        comment (1,1) string
        % extensions % ExtensionSwitch
        functions % Function
        % ID (1,1) string
        % name (1,1) string
        % order (1,1) string
        private (1,1) string
        % spineOrder (1,1) string
    end

    % properties (Hidden)
    %     polID
    % end

    % properties (Constant)%(SetAccess={?ExtensionSwitch})
    %     ExtensionParenID = "polID"
    %      % polID (1,1) string
    % end

    methods (Static, Access = public)

        % function x=ExtensionParenID()
        %     x="polID";
        % end

        function x=tag
            x=char(EM_XmlHandler.TAGS.POL);
        end

        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)
            if nargin == 0
                obj = Policy;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Policy;
            end

        end
    end


    methods

        function initialize(obj,super)

            if nargin == 1
                super=Policy;
            end
            mc=metaclass(obj);
            mcSuper=metaclass(super);
            superProps=string({mcSuper.PropertyList.Name});
            props=string({mc.PropertyList.Name});
            % superProps(ismember(superProps,"functions"))=[];
            for i=1:numel(props)
                if ~strcmp('tag',props(i)) && ismember(props(i),superProps)
                    obj.(props(i)) = super.(props(i));
                end
                % obj.addprop(newProps(i));
                % obj.(newProps(i)) = string;
            end
            

        end

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

        function obj = Policy(Country)
            disp('Policy')
            tic

            % obj.comment = 'Comment about the specific policy.';
            % obj.extensions = 'A list of policy-specific Extension objects.';
            % obj.functions = 'A list with FunctionInSystem objects specific to the system.';
            % obj.ID = 'Identifier number';
            % obj.name = 'Long name';
            % obj.order = 'Order in the policy spine.';
            % obj.private = "no";
            % obj.spineOrder = 'Order of the policy in the spine.';

            % if ~strcmp(class(obj),'ReferencePolicy')
            %     if ~ismember('functions',string(properties(obj)))
            %         if strcmp(class(obj),'Policy')
            %             obj.addprop("functions");
            %             obj.functions = Function;
            %         elseif strcmp(class(obj),'PolicyInSystem')
            %             obj.addprop("functions");
            %             obj.functions = FunctionInSystem;
            %         end
            %     end
            % end

            obj=obj@PolicyHandle;

            if nargin == 0
                return;
            end

            if isempty(Country)
                return;
            end

            obj.load(Country);

            toc

        end

        % % %------------------------------------------------------------------
        % % function [obj, index, prop]=convertObject(obj, index, prop)
        % %     if isempty(obj.refPols)
        % %         return;
        % %     end
        % %     refpols=copy(obj.refPols);
        % %     refpols.index=refpols.indexArr;
        % % 
        % %     % refPolOrder=str2double(obj.refPols.getOtherProperties("Order",1:numel(obj.refPols.indexArr)));
        % %     refPolOrder=str2double(refpols.getOtherProperties("Order",1:numel(refpols.indexArr)));
        % % 
        % %     % check if only reference policies to be returned
        % %     if all(ismember(index,refPolOrder))
        % %         % update index & properties for reference policy object
        % %         index=find(ismember(refPolOrder,index));
        % %         % if ~isempty(prop)
        % %         %     if numel(prop)==numel(properties(obj))
        % %         %         prop=string(properties(obj.refPols));
        % %         %     elseif numel(prop)<numel(properties(obj))
        % %         %         refPolProp=string(properties(obj.refPols));
        % %         %         prop1=ismember(prop,refPolProp);
        % %         %         if ~any(prop1)
        % %         %             error('Unrecognized property name(s) "%s".',strjoin(prop(~prop1),'","'))
        % %         %         end
        % %         %         prop=prop(prop1);
        % %         %     end
        % %         % else
        % %         %     prop=string(properties(obj.refPols));
        % %         % end
        % %         prop=string(properties(obj.refPols));
        % %         % reassign object to reference policy class
        % %         obj=obj.refPols;
        % %     end
        % % 
        % % end
        % 
        % function x=getID(obj)
        %     if strcmp(class(obj),'Policy')
        %         xPol = utils.getInfo(obj.Info.Handler,':','ID');
        %         xRef = utils.getInfo(obj.Info.HandlerRef,':','ID');
        %         x=[xPol,xRef];
        %     elseif strcmp(class(obj),'ReferencePolicy')
        %         x = utils.getInfo(obj.Info.HandlerRef,':','ID');
        %     end
        %     % if isempty(obj.index)
        %     %     x = utils.getInfo(obj.Info.Handler,':','ID');
        %     % else
        %     %     x = utils.getInfo(obj.Info.Handler,obj.index,'ID');
        %     % end
        % end

        % %==================================================================
        % function obj = load(obj, parent)
        % 
        %     % set parent
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        % 
        %     % get country class
        %     cobj=copy(obj.parent);
        %     Idx = cobj.index;
        % 
        %     % get system class
        %     sobj=copy(cobj.systems);
        % 
        %     % update system object
        %     sobj=sobj.update(1);
        % 
        %     % set handler
        %     Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
        %     obj.Info(1).Handler=cobj.Info(Idx).Handler.GetTypeInfo(Tag);
        % 
        %     % set handler reference policies
        %     TagRef=EM_XmlHandler.ReadCountryOptions.(ReferencePolicy.tag);
        %     obj.Info(1).HandlerRef=cobj.Info(Idx).Handler.GetTypeInfo(TagRef);
        % 
        %     % get IDs
        %     IDs=obj.getID();
        %     tagID='ID';
        %     parentID=sobj.(tagID);
        % 
        %     % set PieceOfInfo handler
        %     TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
        %     [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");
        % 
        %     obj.policyArray=out;
        % 
        %     % set index
        %     Order=string({out(:).Order});
        %     Order = str2double(Order);
        %     [~,idxArr]=sort(Order);
        %     obj.indexArr=idxArr;
        %     obj.index=idxArr;
        % 
        % end

        % %------------------------------------------------------------------
        % function obj = load(obj, parent)
        % 
        %     if ~strcmp(class(obj),'ReferencePolicy')
        %         if ~ismember('functions',string(properties(obj)))
        %             if strcmp(class(obj),'Policy')
        %                 obj.addprop("functions");
        %                 obj.("functions") = Function;
        %             elseif strcmp(class(obj),'PolicyInSystem')
        %                 obj.addprop("functions");
        %                 obj.("functions") = FunctionInSystem;
        %             end
        %         end
        %     end
        % 
        %     % get country handler
        %     if isa(parent,'Country')
        %         cobj=copy(parent);
        %     else
        %         cobj=copy(parent.getParent("COUNTRY"));
        %     end
        %     Idx = cobj.index;
        % 
        %     % set parent
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        % 
        %     % set handler
        %     obj.Info(1).Handler=cobj.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(obj.tag));
        % 
        %     % load reference policies
        %     % obj.refPols=ReferencePolicy(obj.parent);
        %     %--------------------------------------------------------------
        %     % set handler
        %     obj.Info(1).HandlerRef=cobj.Info(Idx).Handler.GetTypeInfo(EM_XmlHandler.ReadCountryOptions.(ReferencePolicy.tag));
        % 
        %     % set PieceOfInfo handler
        %     TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
        %     [obj,out]=obj.getPieceOfInfo(obj.parent.("systems"),TAG,"order");
        % 
        %     obj.policyArray=out;
        % 
        % 
        %     % % set PieceOfInfo handler
        %     % TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,Policy.tag));
        %     % [obj,out]=obj.getPieceOfInfo(obj.parent.("systems"),TAG,"order");
        %     %--------------------------------------------------------------
        % 
        %     % set index
        %     OrderPol=string({out(:).Order});
        %     OrderPol = str2double(OrderPol);
        %     % if obj.Info(1).HandlerRef.Count==0 % isempty(obj.refPols)
        %     %     OrderRef=[];
        %     % else
        %     %     OrderRef = utils.getInfo(obj.Info(1).HandlerRef,':','Order');
        %     %     % OrderRef=str2double(obj.refPols.getOtherProperties("order",obj.refPols.indexArr));
        %     % end
        %     % Order = [OrderPol,OrderRef];
        %     Order=OrderPol;
        %     [~,idxArr]=sort(Order);
        %     obj.indexArr=idxArr;
        %     obj.index=idxArr;
        % 
        %     % set extensions array
        %     % % extRef=repmat({ExtensionSwitch},1,numel(OrderRef));
        %     % extRef = obj.refPols.extensionsArray';
        %     % extPol={out.extensions};
        %     % ext=[extPol,extRef];
        %     % obj.extensionsArray=ext;
        % 
        %     % % set functions array
        %     % % funRef=repmat({Function},1,numel(OrderRef));
        %     % % funPol={out.functions};
        %     % % obj.functionsArray=[funPol,funRef];
        % 
        % end


        % %==================================================================
        % function [values,keys]=getOtherProperties(obj,name,index)
        %     name=string(name);
        %     name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
        % 
        %     % set attributes to redefine ID
        %     idxID=ismember(name,'ID');
        %     newname=name;
        %     if any(idxID) && isa(obj,'PolicyInSystem')
        %         tObj=[char(obj.tag),'_ID'];
        %         tObj=char(EM_XmlHandler.TAGS.(tObj));
        %         tRel=[char(System.tag),'_ID'];
        %         tRel=char(EM_XmlHandler.TAGS.(tRel));
        %         if ~ismember(tObj,name)
        %             newname(end+1)=tObj;
        %         end
        %         if ~ismember(tRel,name)
        %             newname(end+1)=tRel;
        %         end
        %     end
        % 
        %     N=size(obj,1);
        %     M=numel(newname);
        %     values=strings(M,N);
        %     keys=newname;
        % 
        %     % try get info from Policy object
        %     valIdx=obj.index<=obj.Info.Handler.Count;
        %     if any(valIdx)
        %         polIdx=obj.index(valIdx);
        %         valIdx=find(valIdx);
        % 
        %         % get info from main Policy handler
        %         [v,k]=utils.getInfo(obj.Info.Handler,polIdx,newname);
        %         [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx);
        %     end
        % 
        %     % try get info from ReferencePolicy object
        %     valIdx=obj.index>obj.Info.Handler.Count;
        %     % polIdxRef=obj.refPols.indexArr(polIdxRef);
        %     if any(valIdx)
        %         polIdxRef=double(obj.index(valIdx))-double(obj.Info.Handler.Count);
        %         valIdx=find(valIdx);
        %         % polIDRef="40238df3-9da1-434d-ada0-47ebb541a375";
        %         %...take info from ref pol main handler
        %         [v,k]=utils.getInfo(obj.Info.HandlerRef,polIdxRef,newname);
        %         [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx);
        % 
        %         %...take info from ref pol country handler
        %         if any(any(strcmp("",values)))
        %             if ismember("RefPolID",keys)
        %                 refIDs=values(ismember(keys,"RefPolID"),:);
        %             else
        %                 refIDs=utils.getInfo(obj.Info.HandlerRef,polIdxRef,"RefPolID");
        %             end
        %             Tag=EM_XmlHandler.ReadCountryOptions.(Policy.tag);
        %             cobj=getParent(obj,"COUNTRY");
        %             Idx = cobj.index;
        %             for ir=1:numel(refIDs)
        %                 refCountry=cobj.Info(Idx).Handler.GetPieceOfInfo(Tag,refIDs(ir));
        %                 [v,k]=utils.getInfo(refCountry,newname);
        %                 [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx(ir));
        %             end
        %         end
        %     end
        % 
        %     % get info from PieceOfInfo handler
        %     if any(strcmp("",values))
        %         for j=1:N
        %             [v,k]=utils.getInfo(obj.Info.PieceOfInfo(obj.index(j)).Handler,newname);
        %             [values,keys] = utils.setValueByKey(values,keys,v,k,j);
        % 
        %             if any(ismember("SpineOrder",newname))
        %                 if any(ismember("Order",newname))
        %                     Order=v(ismember(k,"Order"),:);
        %                 else
        %                     Order=string(obj.Info.PieceOfInfo(polIdx(j)).Handler.Item("Order"));
        %                 end
        %                 values(ismember(keys,"SpineOrder"),j)=Order;
        %             end
        % 
        %         end
        %     end
        % 
        % 
        %     if any(idxID) && isa(obj,'PolicyInSystem')
        %         values(idxID,:)=append(values(ismember(keys,tRel),:),values(ismember(keys,tObj),:));
        %     end
        % 
        %     % utils.getInfo(obj.Info.HandlerRef,polIDRef,"RefPolID")
        % 
        %     % valIdxRef=find(valIdxRef);
        %     %
        %     % propRef=string(properties(obj.refPols));
        %     % propRef = append(upper(extractBefore(propRef,2))',extractAfter(propRef,1)');
        %     %
        %     % propRef=propRef(ismember(propRef,newname));
        %     % keys=propRef';
        %     % % if M<numel(properties(obj))
        %     % %     propRef=propRef(ismember(propRef,name));
        %     % % end
        %     %
        %     % obj.refPols.index=polIdxRef;
        %     % if ~isempty(propRef)
        %     %     [v,k]=obj.refPols.getOtherProperties(propRef, polIdxRef);
        %     %     k = append(upper(extractBefore(k,2))',extractAfter(k,1)');
        %     %     % keys=[keys;k(~ismember(k,keys))'];
        %     %     [values,keys] = utils.setValueByKey(values,keys,v,k,valIdxRef);
        %     % end
        % 
        % 
        %     if ismember("Private",keys)
        %         idxKey=ismember(keys,"Private");
        %         idx = ismember(values(idxKey,:),"");
        %         values(idxKey,idx)="no";
        %     end
        % 
        %     idxDrop=~ismember(keys,name);
        %     keys(idxDrop)=[];
        %     values(idxDrop,:)=[];
        % 
        %     keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
        %     if any(contains(keys,'iD'))
        %         keys(contains(keys,'iD'))='ID';
        %     end
        %     if any(contains(keys,'switch'))
        %         keys(contains(keys,'switch'))='Switch';
        %     end
        % end
        % 
        % 
        % %==================================================================
        % function x=headerComment(obj,varargin)
        %     idx=find(ismember(obj.indexArr,obj.index));
        %     if isempty(obj.commentArray)
        %         temp=copy(obj);
        %         temp.index=temp.indexArr;
        %         x=temp.headerComment_Type2();
        % 
        %         obj.commentArray = x;
        %         x=x(idx,:);
        %     else
        %         x=obj.commentArray(idx,:);
        %         % x=obj.commentArray;
        %     end
        % end
        % 
        % %==================================================================
        % function x=get.extensions(varargin)
        %     obj=varargin{1};
        % 
        %     if size(obj.extensionsClass,1)==0
        %         obj.extensionsClass=ExtensionSwitch(obj);
        %         x=obj.extensionsClass;
        %     else
        %         if all(obj.extensionsClass.parent.index == obj.index)
        %             x=obj.extensionsClass;
        %             x.index=obj.extensionsClass.indexArr;
        %         else
        %             obj.extensionsClass=ExtensionSwitch(obj);
        %             x=obj.extensionsClass;
        %         end
        %     end
        % end

        %==================================================================
        function x=get.functions(varargin)
            obj=varargin{1};

            if strcmp(class(obj),'ReferencePolicy')
                x=obj;
                return;
            end

            if size(obj.functionsClass,1)==0
                if strcmp(class(obj),'Policy')
                    obj.functionsClass=Function(obj);
                elseif strcmp(class(obj),'PolicyInSystem')
                    obj.functionsClass=FunctionInSystem(obj);
                end
                x=obj.functionsClass;
            else
                if all(obj.functionsClass.parent.index == obj.index)
                    x=obj.functionsClass;
                    x.index=obj.functionsClass.indexArr;
                else
                    if strcmp(class(obj),'Policy')
                        obj.functionsClass=Function(obj);
                    elseif strcmp(class(obj),'PolicyInSystem')
                        obj.functionsClass=FunctionInSystem(obj);
                    end
                    x=obj.functionsClass;
                end
            end
        end


        % function x=headerComment(obj,varargin)
        % 
        %     if isempty(obj.commentArray)
        % 
        %         % initialization
        %         N=numel(obj.index);
        %         middlecom=strings(N,1);
        %         valueArray=cell(N,1);
        %         names=strings(N,1);
        %         comments=strings(N,1);
        %         flag=contains(class(obj),'InSystem');
        %         [strProps,~]=utils.splitproperties(obj);
        % 
        %         % get index of reference policies
        %         idxRefPol=obj.indexArr>obj.Info.Handler.Count;
        % 
        %         % get values of parameters from main object and extensions
        %         % object
        %         for jj=1:N
        %             temp=copy(obj);
        %             temp.update(jj,{strProps;"extensions"});
        %             valueArray{jj}=temp.extensions(':',{'shortName','baseOff'});
        %             names(jj)=temp.name;
        %             comments(jj)=temp.comment;
        %             if flag
        %                 middlecom(jj)=temp.Switch;
        %                 if strcmp("",middlecom(jj))
        %                     try
        %                         middlecom(jj)=temp.parent.Switch;
        %                     catch
        %                     end
        %                 end
        %             end
        %         end
        % 
        %         % set extensions middle comment extensions
        %         idxExt =~cellfun(@isempty,valueArray);
        %         extNamePol=cellfun(@(t) string({t(:).shortName})',valueArray(idxExt & ~idxRefPol),'UniformOutput',false);
        %         % display at most 3 extensions short names
        %         extNamePol=cellfun(@(t) strjoin(t(1:numel(t)*(numel(t)<=3)+3*(numel(t)>3)),','),extNamePol);
        %         if ~isempty(extNamePol)
        %             if flag
        %                 % comment array for InSystem classes
        %                 extComPol=append(middlecom(idxExt & ~idxRefPol)," (with switch set for ",extNamePol,")");
        %                 middlecom(idxExt & ~idxRefPol)=extComPol;
        %             else
        %                 extComPol=append("(with switch set for ",extNamePol,")");
        %                 middlecom(idxExt & ~idxRefPol)=extComPol;
        %             end
        %         end
        % 
        %         OtherProperties=obj.getOtherProperties({'name','comment'});
        % 
        %         if any(idxRefPol) && ~flag
        %             middlecom(idxRefPol)='Reference Policy';
        %         end
        % 
        %         % if any(idxRefPol)
        %         %     if flag
        %         %         extComRef=append(middlecom(idxRefPol)," (Reference policy)");
        %         %         middlecom(idxRefPol)=extComRef;
        %         %     else
        %         %         extComRef=repmat("Reference Policy",size(obj.refPols,1));
        %         %         middlecom(idxRefPol)=extComRef;
        %         %     end
        %         % end
        % 
        %         x=[OtherProperties(1,:)',middlecom,OtherProperties(2,:)'];
        % 
        %         obj.commentArray = x;
        % 
        %     else
        %         x=obj.commentArray;
        %     end
        % end

    end
end