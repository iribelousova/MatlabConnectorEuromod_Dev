

% modelpath= "C:\EUROMOD_RELEASES_I6.0+";
% mod = struct();
% mod.modelpath=modelpath;
% mod.modelInfoHandler = EM_XmlHandler.ModelInfoHandler(modelpath);
% mod.emCommon = EM_Common.EMPath(modelpath, true);
% cc=Country(mod,'BE')

classdef PolicyInSystem < Policy % < utils.redefinesparen
    properties (Access=public,Hidden=true) %(Access={?utils.redefinesparen,?utils.dict2Prop}) 
        % comment_List (:,1) string
        % extensions_List (:,1) string
        % % functions_List (:,1) string
        % ID_List (:,1) string
        % name_List (:,1) string
        % order_List (:,1) string
        % private_List (:,1) string
        % orderArr (1,1) string
    end

    % properties (Access=private)
    %     functionsPrivate = FunctionInSystem;
    % end

    properties (Constant,Hidden)
        % tag = char(EM_XmlHandler.ReadCountryOptions.POL)
    end

    properties (Access=public) 
        % comment (1,1) string
        % % extensions ExtensionSwitch
        % % functions FunctionInSystem
        % ID (1,1) string
        % name (1,1) string
        % order (1,1) string
        % private (1,1) string
        % spineOrder (1,1) string
        
        % functions FunctionInSystem
        polID (1,1) string
        Switch (1,1) string
        sysID (1,1) string
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
                obj = PolicyInSystem;
                % obj.functions = FunctionInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = PolicyInSystem;
                % obj(idx).functions = FunctionInSystem;
            end


            % obj = varargin{1};
            % mc=metaclass(obj);
            % if nargin == 1
            %     obj = eval(mc.Name);
            %     return;
            % end
            % 
            % if nargin == 2
            %     idx = varargin{2};
            %     obj(idx) = eval(mc.Name);
            %     return;
            % end
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
        
        function obj = PolicyInSystem(System)

            % modelpath = "C:\EUROMOD_RELEASES_I6.0+";

            % obj.comment = 'Comment about the specific policy.';
            % obj.extensions = 'A list of policy-specific Extension objects.';
            % obj.functions = 'A list with FunctionInSystem objects specific to the system.';
            % obj.ID = 'Identifier number';
            % obj.name = 'Long name';
            % obj.order = 'Order in the policy spine.';
            % polID
            % obj.private = 'Short name';
            % obj.spineOrder = 'Order of the policy in the spine.';
            % switch_
            % sysID

            % if nargin == 0
            %     return;
            % end
            % 
            % if isempty(Country)
            %     return;
            % end


            % obj.load(System);

            % 

            obj = obj@Policy;
            % obj.functions = FunctionInSystem;

            if nargin == 0
                return;
            end

            if isempty(System)
                return;
            end

            obj.load(System);

            % obj = obj@Policy(varargin{:});
            % m=varargin{1};
            % 
            % obj.paren(1).index=m.index;
            % obj.paren(1).tag=m.tag;
            % obj.paren(1).paren=m.paren;
            % 
            % if numel(obj.index)==1
            %     obj=obj.get();
            % end

        end


        % %------------------------------------------------------------------
        % function obj = load(obj, parent)
        %     % get country handler
        %     % if isa(parent,'Country')
        %     %     cobj=copy(parent);
        %     % else
        %     %     cobj=copy(parent.getParent("COUNTRY"));
        %     % end
        % 
        %     % % set parent
        %     % obj.parent=copy(parent);
        %     % obj.parent.indexArr=obj.parent.index;
        % 
        %     % load super class 
        %     obj = obj.load@Policy(parent);
        % 
        %     % % set parent
        %     % obj.parent=copy(parent);
        %     % obj.parent.indexArr=obj.parent.index;
        % 
        % end

        %------------------------------------------------------------------
        % function [values,keys]=getOtherProperties(obj,name,index)
        %     name=string(name);
        %     name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
        % 
        %     N=size(obj,1);
        %     M=numel(name);
        %     values=strings(M,N);
        %     keys=name;
        % 
        %     % try get info from Policy object
        %     valIdx=obj.index<=obj.Info.Handler.Count;
        %     polIdx=obj.index(valIdx);
        %     if ~isempty(polIdx)
        % 
        %         valIdx=find(valIdx);
        % 
        %         % get info from main Policy handler
        %         [v,k]=utils.getInfo(obj.Info.Handler,polIdx,name);
        %         [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx);
        % 
        %         % get info from Plocy PieceOfInfo handler
        %         if size(v,1)<size(values,1)
        %             for j=1:numel(polIdx)
        %                 [v,k]=utils.getInfo(obj.Info.PieceOfInfo(polIdx(j)).Handler,name);
        %                 [values,keys] = utils.setValueByKey(values,keys,v,k,valIdx(j));
        % 
        %                 if any(ismember("SpineOrder",name)) 
        %                     if any(ismember("Order",name)) 
        %                         Order=v(ismember(k,"Order"),:);
        %                     else
        %                         Order=string(obj.Info.PieceOfInfo(polIdx(j)).Handler.Item("Order"));
        %                     end
        %                     values(ismember(keys,"SpineOrder"),valIdx(j))=Order;
        %                 end
        % 
        %             end
        %         end
        %     end
        % 
        %     % try get info from ReferencePolicy object
        %     valIdxRef=obj.index>obj.Info.Handler.Count;
        %     polIdxRef=double(obj.index(valIdxRef))-double(obj.Info.Handler.Count);
        %     polIdxRef=obj.refPols.indexArr(polIdxRef);
        %     if ~isempty(polIdxRef)
        %         valIdxRef=find(valIdxRef);
        % 
        %         propRef=string(properties(obj.refPols));
        %         propRef = append(upper(extractBefore(propRef,2))',extractAfter(propRef,1)');
        % 
        %         propRef=propRef(ismember(propRef,name));
        %         keys=propRef';
        %         % if M<numel(properties(obj))
        %         %     propRef=propRef(ismember(propRef,name));
        %         % end
        % 
        %         obj.refPols.index=polIdxRef;
        %         if ~isempty(propRef)
        %             [v,k]=obj.refPols.getOtherProperties(propRef, polIdxRef);
        %             k = append(upper(extractBefore(k,2))',extractAfter(k,1)');
        %             % keys=[keys;k(~ismember(k,keys))'];
        %             [values,keys] = utils.setValueByKey(values,keys,v,k,valIdxRef);
        %         end
        %     end
        % 
        % 
        %     if ismember("Private",keys)
        %         idxKey=ismember(keys,"Private");
        %         idx = ismember(values(idxKey,:),"");
        %         values(idxKey,idx)="no";
        %     end
        % 
        %     keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
        %     if any(contains(keys,'iD'))
        %         keys(contains(keys,'iD'))='ID';
        %     end
        % 
        % end

        % %------------------------------------------------------------------
        % function x=headerComment(obj,varargin)
        % 
        %     % extcom=cellfun(@(z) z.shortName,{values.extensions});
        % 
        %     N=size(obj,1);
        %     % get object comment property value
        %     com_p=getOtherProperties(obj,'comment',1:N);
        %     if size(com_p,2)==N
        %         com_p=com_p';
        %     end
        % 
        %     % create the middle comment
        %     middlecom=strings(N,1);
        % 
        %     % extensions switch middle comment
        %     % if nargin > 1
        %     %     ext=varargin{1};
        %     %     extArr=struct2cell(ext);
        %     %     extArr=arrayfun(@(t) extArr{t}.baseOff,1:numel(extArr));
        %     %     % notRefPol=find(ismember(middlecom,""));
        %     %     % for jj=1:numel(notRefPol)
        %     %     %     j=notRefPol(jj);
        %     %     %     temp=copy(obj);
        %     %     %     % temp.update(index,prop)
        %     %     %     ext=temp.get(j,'extensions');
        %     %     %     if ~isempty(ext)
        %     %     %         middlecom(j,1)=['(with switch set for ', char(ext.shortName()), ')'];
        %     %     %     end
        %     %     % end
        %     % end
        % 
        % 
        %     % extensions switch middle comment
        %     % valIdx=obj.index<=obj.Info.Handler.Count;
        %     % polIdx=ismember(obj.indexArr,obj.index);
        % 
        %     ext=obj.extensionsArray(obj.index);
        %     extBaseOff=cellfun(@(t) t.baseOff,ext);
        %     extName = cellfun(@(t) t.shortName,ext);
        %     % polOrder = cellfun(@(t) t.parent.order,ext1)
        %     idxExt=~strcmp(extBaseOff,"");
        %     extCom=append("(with switch set for ",extName(idxExt),")");
        %     extBaseOff(idxExt)=extCom;
        %     % idxInArr = obj.indexArr(obj.indexArr<obj.Info.Handler.Count);
        %     middlecom=extBaseOff;
        %     % middlecom=extBaseOff(obj.index);
        % 
        %     % reference policy middle comment
        %     idxRefPol=obj.index>obj.Info.Handler.Count;
        %     if any(idxRefPol)
        %         refPolCom=obj.refPols.headerComment();
        %         middlecom(idxRefPol)=refPolCom;
        %     end
        % 
        % 
        %     bk = arrayfun(@(t) numel(char(t)),middlecom);
        %     bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+3,'UniformOutput',false));
        % 
        %     x = append(middlecom, bk, '| ',com_p);
        % 
        %     % cut text if too long
        %     l=arrayfun(@(t) numel(char(t)),x);
        %     x=arrayfun(@(t) extractBefore(x(t), min(l(t),136)),1:N)';            
        % end

    end
end