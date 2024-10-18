classdef ReferencePolicy < PolicyHandle

    % properties (Access=public,Hidden) 
    %     index (:,1) double
    %     indexArr (:,1) double
    %     % extensionsArray (:,1) cell
    % end
    % 
    % properties (Constant,Access=private)
    %     % tag = char(EM_XmlHandler.ReadCountryOptions.REFPOL)
    %     tag = char(EM_XmlHandler.TAGS.REFPOL)
    % end

    properties (Access=public) 
        % extensions ExtensionSwitch
        % ID (1,1) string
        % name (1,1) string
        % order (1,1) string
        refPolID (1,1) string
        % spineOrder (1,1) string
    end

    % properties (Access = private)
    %     functions
    % end

    methods (Static, Access = public)

        function x=tag
            x=char(EM_XmlHandler.TAGS.REFPOL);
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
                obj = ReferencePolicy;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = ReferencePolicy;
            end

        end
    end

    methods
        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end

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
        
        function obj = ReferencePolicy(parent)

            obj=obj@PolicyHandle;
            % 
            % if isa(object,'Country')
            %     obj = obj@Policy(object);   
            % end
            

            % obj = obj@Policy

            % obj.tag = char(EM_XmlHandler.TAGS.REFPOL);

            if nargin == 0
                % initialize(obj);
                return;
            end

            

            if isempty(parent)
                % initialize(obj);
                return;
            end

            % initialize(obj,super);

            obj.load(parent);

        end

        % function obj = load(obj, parent)
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
        %     % set PieceOfInfo handler
        %     TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,Policy.tag));
        %     [obj,out]=obj.getPieceOfInfo(obj.parent.("systems"),TAG,"order");
        % 
        %     % set index
        %     if isempty(out)
        %         return;
        %     else
        %         Order = str2double(string({out(:).Order}));
        %         [~,idxArr]=sort(Order);
        %         obj.indexArr=idxArr;
        %         obj.index=idxArr;
        %     end
        % 
        % end
        % 
        % function x=getID(obj)
        %     x = utils.getInfo(obj.Info.Handler,':','ID');
        % end
        % 
        % function [values,keys]=getOtherProperties(obj,name,index)
        %     name=string(name);
        %     name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
        % 
        %     idxArr=obj.index;
        %     N=size(obj,1);
        %     M=numel(name);
        %     values=strings(M,N);
        %     keys=name;
        %     keydrop=keys;
        % 
        %     % try get info from object main handler
        %     [v,k]=utils.getInfo(obj.Info.Handler,idxArr,name);
        %     if ~isempty(v)
        %         % keys=[keys;k(~ismember(k,keys))];
        %         values = utils.setValueByKey(values,keys,v,k);
        %         keydrop(ismember(keydrop,k))=[];
        %     end
        % 
        %     % try get info from Policy class handler
        %     if ~isempty(keydrop)
        %         if ismember("RefPolID",keys)
        %             IDs = values(ismember(keys,"RefPolID"),:);
        %         else
        %             [IDs,~]=utils.getInfo(obj.Info.Handler,idxArr,"RefPolID");
        %         end
        %         cobj=getParent(obj,"COUNTRY");
        %         Idx = cobj.index;
        %         for i = 1:N
        %             id = char(IDs(i));
        %             Tag=EM_XmlHandler.ReadCountryOptions.(Policy.tag);
        %             x=cobj.Info(Idx).Handler.GetPieceOfInfo(Tag,id);
        %             if x.Count>0
        %                 [v,k]=utils.getInfo(x,name);
        % 
        %                 if ismember('ID',k) && ismember('RefPolID',keys)
        %                     assert( all(ismember(v(ismember(k,'ID'),:), values(ismember(keys,'RefPolID'),:))) , "ValueError: refPolID in main handler and ID in PieceOfInfo handler mismatch")
        %                     k(ismember(k,'ID'))="RefPolID";
        %                 end
        % 
        %                 % keys=[keys;k(~ismember(k,keys))];
        %                 values = utils.setValueByKey(values,keys,v,k,i);
        % 
        %             end
        %             keydrop(ismember(keydrop,k))=[];
        %         end
        %     end
        % 
        %     % try get info from object PieceOfInfo handler
        %     if ~isempty(keydrop)
        %         for i=1:numel(idxArr)
        %             [v,k]=utils.getInfo(obj.Info.PieceOfInfo(idxArr(i)).Handler,name);
        % 
        %             if ismember('Order',k) 
        %                 Order=v(ismember(k,'Order'),:);
        %             else
        %                 if ismember('SpineOrder',name)
        %                     Order=utils.getInfo(obj.Info.PieceOfInfo(idxArr(i)).Handler,"Order");
        %                 end
        %             end
        % 
        %             % keys=[keys;k(~ismember(k,keys))];
        %             values = utils.setValueByKey(values,keys,v,k,i);
        %             if ismember('ID',keys) && ismember('PolID',keys)
        %                 assert(values(ismember(keys,'ID'),i)==values(ismember(keys,'PolID'),i), 'ReferencePolicy: mismatch ID and PolID.')
        %             end
        %         end
        %     end
        % 
        %     if ismember('SpineOrder',name)
        %         values(ismember(keys,'SpineOrder'),:)=Order;
        %         % keys(end+1,1)="SpineOrder";
        %     end
        % 
        %     % adjust values and keys
        %     values(ismissing(values))="";
        %     keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
        %     if any(contains(keys,'iD'))
        %         keys(contains(keys,'iD'))='ID';
        %     end
        %     if size(keys,1)<size(keys,2) && size(keys,1)~=0
        %         keys=keys';
        %     end
        % 
        % end
        % 
        % 
        % function x=headerComment(obj)
        %     x=obj.headerComment_Type1('name','comment');
        %     % % names=obj(:).name;
        %     % % com=repmat("Reference Policy",numel(obj.index),1);
        %     % % x=[names,com];
        % end

    end

end

