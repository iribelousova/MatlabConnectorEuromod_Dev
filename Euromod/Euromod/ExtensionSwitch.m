classdef ExtensionSwitch < Core
    properties (Access=public,Hidden=true) % (Access=?utils.redefinesparen) 
        index (:,1) double
        indexArr (:,1) double
        parent
        Info struct
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.EXTENSION)
    end

    properties (Access=public) 
        baseOff (1,1) string
        extensionID (1,1) string
        name (1,1) string
        % polID (1,1) string
        shortName (1,1) string
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
        
        % function ind = end(obj,m,n)
        %     S = numel(obj.indexArr);
        %     if m < n
        %         ind = S(m);
        %     else
        %         ind = prod(S(m:end));
        %     end
        % end

        function x = getID(obj)

            cobj=copy(obj.getParent("COUNTRY"));

            ID1=cobj.extensions(1:end).ID;
            % ID2=cobj.parent.extensions(:).ID;
            % IDp=obj.parent.ID;
            % if strcmp("",IDp)
            %     IDp=obj.paren(1).ID;
            % end

            % x=[ID1;ID2];
            % x=append(IDp,x);
            x=ID1;


            % x=utils.getInfo(obj.parent.parent.extensions.Info.Handler,':',"ID");
            % x=[x,utils.getInfo(obj.parent.parent.parent.extensions.Info.Handler,':',"ID")];
            % x=x';
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = ExtensionSwitch(object)
            %  ExtensionSwitch(cc.policies(10))

            if nargin == 0
                return;
            end

            % add the dynamic property to class ExtensionSwitch
            newProp=object.tag_s_(object.tag,'ID');
            newProp=[lower(newProp(1)),newProp(2:end)];

            obj.addprop(newProp);
            % P.Validation= @(x) validateattributes(x, {'string'}); dynamic
            % props do not support validation
            obj.(newProp) = string;

            if isempty(object)
                return;
            end

            obj.load(object);

        end

        %------------------------------------------------------------------
        function obj = load(obj, parent)

            % set parent
            obj.parent=copy(parent);
            obj.parent.indexArr=obj.parent.index;
            obj.parent=obj.parent.update(obj.parent.index);

            % add the dynamic property to class ExtensionSwitch
            newProp=obj.tag_s_(parent.tag,'ID');
            newProp=[lower(newProp(1)),newProp(2:end)];
            props=string(properties(obj));
            if ~ismember(newProp,props)
                obj.addprop(newProp);
                obj.(newProp) = string;
            end
            
            % define tag 
            if isa(parent,'Policy') || isa(parent,'ReferencePolicy') || isa(parent,'PolicyInSystem')
                TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,Policy.tag));
                % obj.getPieceOfInfo(parent,TAG);
            else
                TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,parent.tag));
                % obj.getPieceOfInfo(parent,TAG);

                % cobj=obj.getParent("COUNTRY");
                % TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,parent.tag));
                % obj.getPieceOfInfo(cobj.systems,TAG);
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
            % obj.getPieceOfInfo(obj.parent,TAG);

            % set index
            if  numel(fieldnames(obj.Info.PieceOfInfo))==0
                % obj=obj.empty();
                obj=ExtensionSwitch;
            else
                obj.indexArr = 1:numel(obj.Info.PieceOfInfo);
                obj.index=obj.indexArr;

                if numel(obj.indexArr)==1
                    % [strProps,objProps] = utils.splitproperties(obj);
                    obj.update(obj.index);
                end                
            end
        end

        %------------------------------------------------------------------
        function [values,keys]=getOtherProperties(obj,name,index)

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
                    values = utils.setValueByKey(values,keys,v,k);
                catch
                end
                try
                    [v,k]=utils.getInfo(cobj.parent.extensions.Info.Handler,ID,name);
                    values = utils.setValueByKey(values,keys,v,k,i);
                catch
                end
            end

            % if any(ismember(values,""))
            %     cobj=obj.getParent('COUNTRY');
            %     % Idx = cobj.index; 
            %     try
            %         [v,k]=utils.getInfo(cobj.extensions.Info.Handler,IDs,name);
            %         % keys=[keys;k(~ismember(k,keys))];
            %         values = utils.setValueByKey(values,keys,v,k);
            %     catch
            %         [v,k]=utils.getInfo(cobj.parent.extensions.Info.Handler,IDs,name);
            %         % keys=[keys;k(~ismember(k,keys))];
            %         values = utils.setValueByKey(values,keys,v,k,i);
            %     end
            % end
            % utils.getInfo(obj.parent.parent.parent.extensions.Info.Handler,"abfb2064-9189-43e7-9f61-f3886ae327b1")


            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end

        end

        %------------------------------------------------------------------
        function x=headerComment(obj)
            % x=obj.headerComment_Type1();

            N=size(obj,1);
            x=obj.getOtherProperties({'name','baseOff','comment'},1:N)';
            % x=obj(:).baseOff;
            x(strcmp(x,'true'))='off';
            x(strcmp(x,'false'))='on';
        end

    end

end

