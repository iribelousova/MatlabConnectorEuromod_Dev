classdef DatasetInSystem < Dataset 
    properties (Access=public,Hidden=true) %(Access={?utils.redefinesparen,?utils.dict2Prop}) 
        % model
        % index (:,1) double
        % orderArr (:,1) string
        % paren struct
    end

    % properties (Constant,Hidden)
    %     tag = char(EM_XmlHandler.TAGS.SYS_DATA)
    % end

    properties (Access=public) 
        bestMatch (1,1) string
        dataID (1,1) string
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
                obj = DatasetInSystem;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = DatasetInSystem;
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
        
        function obj = DatasetInSystem(System)

            obj = obj@Dataset;

            if nargin == 0
                return;
            end

            if isempty(System)
                return;
            end

            obj.load(System);

        end

        %------------------------------------------------------------------
        function obj = load(obj, parent)

            obj = obj.load@Dataset(parent);  

            % set PieceOfInfo handler
            TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
            IDs=obj.getID();
            tagID='ID';
            parentID=obj.parent.(tagID);

            [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG,"order");

            % sobj=copy(obj.parent.getParent("SYS"));

            % % get country handler
            % if isa(parent,'Country')
            %     cobj=copy(parent);
            % else
            %     cobj=copy(parent.getParent("COUNTRY"));
            % end
            % 
            % % load super class 
            % obj = obj.load@Dataset(cobj);  
            % 
            % % set parent
            % obj.parent=copy(parent);
            % obj.parent.indexArr=obj.parent.index;
            % 
            % % set PieceOfInfo handler
            % TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(System.tag,obj.tag));
            % % parentID=obj.parent()
            % obj.getPieceOfInfo(obj.parent,TAG);
            % 
            % set index
            obj.indexArr=1:numel(obj.Info.PieceOfInfo);
            obj.index=obj.indexArr;
        end

        %------------------------------------------------------------------
        function x = getID(obj)

            % parentID = obj.parent.ID;
            [IDs,~] = utils.getInfo(obj.Info.Handler,obj.index,'ID');
            if size(IDs,2)==obj.Info.Handler.Count
                IDs=IDs';
            end
            % x = append(parentID,IDs);
            x=IDs;

            %  % [parenID,~] = utils.getInfo(m.handler,m.index,'ID');
            % % parenID=char(parenID);
            % % [IDs,~] = utils.getInfo(obj.handler,':','ID');
            % 
            % cobj=obj.getParent("COUNTRY");
            % 
            % ID1=cobj.extensions(:).ID;
            % % ID2=cobj.parent.extensions(:).ID;
            % % IDp=obj.parent.ID;
            % % if strcmp("",IDp)
            % %     IDp=obj.paren(1).ID;
            % % end
            % 
            % % x=[ID1;ID2];
            % % x=append(IDp,x);
            % x=ID1;
            % 
            % 
            % % x=utils.getInfo(obj.parent.parent.extensions.Info.Handler,':',"ID");
            % % x=[x,utils.getInfo(obj.parent.parent.parent.extensions.Info.Handler,':',"ID")];
            % % x=x';
        end

        function x=headerComment(obj,varargin)

            x=obj.headerComment_Type1({'name','bestMatch','comment'});
            x(ismember(x(:,2),"no"),2) = "";
            x(ismember(x(:,2),"yes"),2) = "best match";

            % N=size(obj,1);
            % % get object comment property value
            % x=getOtherProperties(obj,{'name','Switch','comment'},obj.index);
            % if size(x,2)==N
            %     x=x';
            % end
            % 
            % % nams=obj.getOtherProperties('name',1:N)';
            % % 
            % % middlecom =  obj.getOtherProperties('Switch',obj.index)';
            % 
            % % bk = arrayfun(@(t) numel(char(t)),com_p);
            % % bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+1,'UniformOutput',false));
            % 
            % % x = append(com_p(:,1), bk(:,1), '| ',com_p(:,2), bk(:,2), '| ',com_p(:,2), bk(:,2));
            % % 
            % % % cut text if too long
            % % l=arrayfun(@(t) numel(char(t)),x);
            % % x=arrayfun(@(t) extractBefore(x(t), min(l(t),133)),1:N)';    

        end

    end
end