classdef (Abstract) Core < utils.customdisplay & handle & utils.redefinesparen & matlab.mixin.Copyable & utils.DynPropHandle 

    % properties (Hidden)
    %     Info (1,:) struct % container for handler objects.
    %     isNew (1,1) double % used to display objects. If ture, updates the class index to display the full array of class elements.
    % end

    % properties (Hidden,Access=public)
    %     parent
    % end

    methods (Static)
        %------------------------------------------------------------------
        function header=commentElement(header,coms)
            % commentElement - Preappend string array of header to string
            % array of coms.
            % header : (N,1) string.
            % coms   : (N,1) string.

            NrBlanks=1;
            if ~isempty(coms) && ~all(strcmp("",coms))
                coms=arrayfun(@(t) char(EM_XmlHandler.XmlHelpers.RemoveCData(t)),coms,'UniformOutput',false);
                coms=string(coms);
                bk = arrayfun(@(t) numel(char(t)),header);
                bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+NrBlanks,'UniformOutput',false));
                header = append(header, bk, '| ',coms);
            end
        end

        function x=tag_s_(tag1,tag2)
            t=[char(tag1),'_',char(tag2)];
            x = char(EM_XmlHandler.TAGS.(t));
        end
    end

    methods %(Access=protected)

        function t=getParent(obj,tag)
            t=copy(obj);
            while ~strcmp(t.tag,tag)
                t=t.parent;
            end
        end    

        function obj=setParent(obj,ch)
            if isa(obj,'Country')
                obj.Info(obj.index).Handler=ch;
            else
                t=copy(obj);
                count='';
                while ~strcmp(t.tag,"COUNTRY")
                    t=t.parent;
                    count=[count,'.parent'];
                    Idx=t.index;
                end
                eval(['obj',count,'.Info(',char(num2str(Idx)),').Handler=ch']);
            end
        end   
    end

    methods
        function obj = Core()            
        end

        function [values,keys]=getPiecesOfInfo(obj,Tag, subTag, ID, index, keys)
            % index : (1,N) int. Order number

            if nargin <= 4
                index=[];
            %     keys_=strings(0,1);
            % elseif nargin <= 5
            %     keys_=strings(0,1);
            % else
            %     keys_=string(keys);
            end
            if nargin == 6
                userKeys=keys;
            end


            %%%%
            cobj=obj.getParent('COUNTRY'); 
            Idx=cobj.index;

            %{
            Tag=EM_XmlHandler.ReadCountryOptions.('EXTENSION_SWITCH');

            subTag=EM_XmlHandler.TAGS.('SYS_ID');
            ID=obj.parent.systems(1:end).ID;

            subTag=EM_XmlHandler.TAGS.('EXTENSION_ID');
            ID=obj.parent.extensions(1:end).ID;

            subTag=EM_XmlHandler.TAGS.('DATA_ID');
            ID=obj.parent.datasets(1:end).ID;

            % subTag=EM_XmlHandler.TAGS.('POL_ID');
            % ID=obj.parent.policies(1:end).ID;
            %}

            values=strings(1,0);
            keys=strings(1,0);
            
            out=cobj.Info(Idx).Handler.GetPiecesOfInfoInList(Tag,subTag,ID);
            if out.Count>0
                if isempty(index)
                    index=1:out.Count;
                end
                i_=0;
                for i=1:numel(index)
                    idx=index(i);
                    i_=i_+1;
                    d=out.Item(idx-1).dictionary;
                    keys_ = d.keys('cell');
                    keys_=cellfun(@string,keys_);
                    values_ = d.values('cell');
                    values_=cellfun(@string,values_);
                    values_=arrayfun(@(t) string(EM_XmlHandler.XmlHelpers.RemoveCData(t)),values_);
                    [values,keys]=utils.setValueByKey(values,keys,values_,keys_,i_);
                end
            end
            %%%%

            if nargin == 6
                % userKeys=string(userKeys);
                % userKeys = append(upper(extractBefore(userKeys,2))',extractAfter(userKeys,1)');
                values=values(ismember(keys,userKeys),:);
                keys=keys(ismember(keys,userKeys));
            end

            % keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            % if any(contains(keys,'iD'))
            %     keys(contains(keys,'iD'))='ID';
            % end
            % if any(contains(keys,'switch'))
            %     keys(contains(keys,'switch'))='Switch';
            % end


            % % get tags
            % Tag=EM_XmlHandler.ReadCountryOptions.(obj.tag);
            % t=[char(obj.parent.tag),'_ID'];
            % subTag=EM_XmlHandler.TAGS.(t);

            % % get objects
            % cobj=obj.getParent('COUNTRY');     
            % sobj = cobj.systems;

            % % get helpers
            % Idx=cobj.index;
            % sID=char(utils.getInfo(sobj.Info.Handler,1,'ID'));
            % 
            % % get other tags
            % t=[char(sobj.tag),'_',obj.tag];
            % Tag_=EM_XmlHandler.ReadCountryOptions.(t);
            % 
            % % get handler
            % out=cobj.Info(Idx).Handler.GetPiecesOfInfoInList(Tag,subTag,obj.parent.ID);
            % d=out.Item(1).dictionary;
            % 
            % % initialize 
            % keys = d.keys('cell');
            % keys=cellfun(@string,keys);
            % keys=[keys;"Order"];
            % keys=[keys;"SpineOrder"];
            % values=strings(numel(keys),out.Count);
            % 
            % for i=1:out.Count
            %     try
            %         ID=char(out.Item(i).Item('ID'));
            %         % ID=char(utils.getInfo(out.Item(i),'ID'));
            %         id = [sID,ID];
            %         [v,k]=utils.getInfo(out.Item(i));
            %         keys=[keys;k(~ismember(k,keys))];
            %         values = utils.setValueByKey(values,keys,v,k,i);
            % 
            %         Order=cobj.Info(Idx).Handler.GetPieceOfInfo(Tag_,id).Item('Order');
            %         values(ismember(keys,"Order"),i)=string(Order);
            %         values(ismember(keys,"SpineOrder"),i)=string([char(obj.parent.spineOrder),'.',char(string(Order))]);
            % 
            %     catch 
            %         warning('No outpu at index %d', i)
            %     end
            % end

        end

        %------------------------------------------------------------------
        function [values,keys]=getOtherProperties_Type1(obj,name)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            % set auxiliary attributes to redefine ID
            idxID=ismember(name,'ID');
            newname=name;
            if any(idxID)
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
            IDs=strings(N,1);
            keys=newname;
            keysDrop=keys;

            t=[char(obj.tag),'_ID'];
            subTag=EM_XmlHandler.TAGS.(t);

            % get info from PieceOfInfo handler
            % indexLoop=find(ismember(obj.indexArr,obj.index));
            indexLoop=obj.index;
            if isfield(obj.Info,'PieceOfInfo')
                for i=1:N
                    i_=indexLoop(i);
                    [v,k]=utils.getInfo(obj.Info.PieceOfInfo(i_).Handler,newname);
                    IDs(i)=obj.Info.PieceOfInfo(i_).Handler.Item(subTag);
                    if  ~isempty(v)
                        % keys=[keys;k(~ismember(k,keys))];
                        values = utils.setValueByKey(values,keys,v,k,i);
                        keysDrop(ismember(keysDrop,k))=[];
    
                        if any(ismember("SpineOrder",newname)) 
                            if any(ismember("Order",k)) 
                                Order=v(ismember(k,"Order"));
                            else
                                Order=string(obj.Info.PieceOfInfo(i_).Handler.Item("Order"));
                            end
                            values(ismember(keys,"SpineOrder"),i)=string([char(obj.parent(1).spineOrder),'.',char(Order)]);
                        end
                    end
                end
            end

            % get info from main handler
            if ~isempty(keysDrop)
                if isempty(IDs) || all(strcmp("",IDs))
                    IDs=obj.index;
                end
                [v,k]=utils.getInfo(obj.Info.Handler,IDs,keysDrop);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k);
                % remove empty string rows
                ir = arrayfun(@(t) all(strcmp("",values(t,:))), 1:size(values,1));
                if any(ir)
                    values(ir,:)=[];
                    keys(ir)=[];
                end
                % remove empty string columns
                ir = arrayfun(@(t) all(strcmp("",values(t,:))), 1:size(values,1));
                if any(ir)
                    values(:,ir)=[];
                end
            end

            % redefine the value of ID in classes of type "InSystem"
            if any(idxID)
                if contains(class(obj),'InSystem')
                    values(ismember(keys,"ID"),:)=append(values(ismember(keys,tRel),:),values(ismember(keys,tObj),:));
                end
            end

            % remove auxiliary properties  
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


        %------------------------------------------------------------------
        function [obj,values]=getPieceOfInfo(obj,ID,parentID,TAG,name)
            % getPieceOfInfo
            %
            % 
            % relative: relative object that contains part of GetPieceOfInfo
            %         IDs
            % TAG   : Tag in GetPieceOfInfo function.
            % name  : (optional), Properties names to return from 
            %         GetPieceOfInfo function.

            % Tag=EM_XmlHandler.ReadCountryOptions.FUN
            % TagA=EM_XmlHandler.TAGS.POL_ID
            % Idx=cobj.index
            % cobj.Info(Idx).Handler.GetPiecesOfInfoInList(Tag,TagA,obj.relative.ID)

            % if isempty(relative)
            %     return;
            % end

            if nargin <= 4
                name=[];
            end

            % get class objects
            cobj=obj.getParent('COUNTRY');
            Idx = cobj.index; 

            % get current object ID
            % IDs=obj.getID();
            N=numel(ID);

            % get "order" by default, if it is an object property
            [strProps,objProps]=utils.splitproperties(obj);
            if ismember("Order",strProps) && isa(obj,'Policy')
                strprops="Order";
            else
                strprops=strings(1,0);
            end
            
            % % get relative object ID
            % IDtag=obj.tag_s_(relative.tag,'ID');
            % IDtag=[lower(IDtag(1)),IDtag(2:end)];
            % [strPropsRel,~]=utils.splitproperties(relative);
            % if ~ismember(IDtag,strPropsRel) ...
            %         || ismember(IDtag,strProps) && contains(class(relative),'Policy') ...
            %         || contains(class(relative),'Data')
            %     IDtag = 'ID';
            % end
            % IDtag=string(IDtag);
            % 
            % % if contains(class(relative),'InSystem') && ~contains(class(relative),'Policy') ...
            % %         && ~contains(class(relative),'Data') ...
            % %         || isa('ExtensionSwitch')
            % %     % IDtag = char(EM_XmlHandler.TAGS.([char(relative.tag),'_ID']));
            % %     IDtag=obj.tag_s_(relative.tag,'ID');
            % %     IDtag=[lower(IDtag(1)),IDtag(2:end)];
            % % else
            % %     IDtag = 'ID';
            % % end
            % 
            % 
            % if size(relative,1)==1
            %     relative.update(relative.index,IDtag);
            %     rID=char(relative.(IDtag));
            % else
            %     rID =char(utils.getInfo(relative.Info.Handler,relative.Info.Handler.Count,IDtag));
            % end

            

            % initialize
            objprops=strings(1,0);
            values=struct([]);

            % users' properties check
            if ~isempty(name)
                name=string(name);

                strProps = append(upper(extractBefore(strProps,2))',extractAfter(strProps,1)');
                idxStr = ismember(lower(strProps),lower(name));
                if any(idxStr)
                    t_=strProps(idxStr);
                    strprops=[strprops,t_];
                end

                idxObj = ismember(lower(objProps),lower(name));
                if any(idxObj)
                    objprops=objProps(idxObj);
                    oM=numel(objprops);
                end
            else
                strprops=[];
                objprops=[];
            end

            % try get info from GetPieceOfInfo
            i__=0;
            obj.Info(1).PieceOfInfo=struct;
            for i=1:N
                id=char(ID(i));
                ID_=[char(parentID),id];
                x=cobj.Info(Idx).Handler.GetPieceOfInfo(TAG,ID_);
                if x.Count>0
                    i__=i__+1;
                    obj.Info(1).PieceOfInfo(i__).Handler=x;
                    
                    % get properties of type string
                    if ~isempty(strprops) 
                        if ~isempty(objprops) 
                            strPropsNew=strProps;
                        else
                            strPropsNew=strprops;
                        end
                        [v,k]=utils.getInfo(x,strPropsNew);
                        orderIdx=ismember(strPropsNew,"SpineOrder");
                        if any(orderIdx)
                            v(end+1,:)=v(ismember(k,"Order"));
                            k(end+1)="SpineOrder";
                        end
                        for jj=1:numel(k)
                            values(i__).(k(jj))=v(jj,:);
                        end
                    end

                    % get properties of type class
                    if ~isempty(objprops) 
                        % temp=copy(obj);
                        newindex=i__;
                        strPropsNew=strProps;

                        [v,k]=utils.getInfo(temp.Info.Handler,newindex,strPropsNew);
                        for k_i=1:numel(k)
                            values(i__).(k(k_i))=v(k_i,:);
                            if ~ismember(k(k_i),"ID")
                                k(k_i)=append(lower(extractBefore(k(k_i),2))',extractAfter(k(k_i),1)');
                            end
                            temp=copy(obj);
                            temp.(k(k_i))=v(k_i,:);
                        end
                        for n_i=1:oM
                            className = class(obj.(objprops(n_i)));
                            
                            temp=copy(obj);
                            temp.index=newindex;
                            temp.ID=id;
                            values(i__).(objprops(n_i))=eval([className,'(temp)']);
                        end
                    end
                end
            end
        end


        %==================================================================
        function x=headerComment_Type1(obj,varargin)
            N=size(obj,1);
            if nargin>1
                try
                    propertynames= cellstr(string(varargin{:}));
                catch
                    propertynames= cellstr(string(varargin));
                end
            else
                propertynames={'name','Switch','comment'};
            end               
            x=obj.getOtherProperties(propertynames,1:N);
            if size(x,2)==N
                x=x';
            end
        end

        %==================================================================
        function obj=update(obj,index,props)

            if strcmp(class(obj),'Policy')
                if all(index>obj.Info.Handler.Count)
                    cc=ReferencePolicy;
                    cc.initialize(obj);
                    obj=cc;
                end
            end
            if strcmp(class(obj),'ReferencePolicy')
                if all(index<obj.Info.Handler.Count)
                    cc=Policy;
                    cc.initialize(obj);
                    obj=cc;
                end
            end
            obj.index=index;

            if numel(index)==1
                strProps=utils.splitproperties(obj);
                if nargin>2
                    Props=props;
                else
                    Props=strProps;
                end
                Props=Props(ismember(Props,strProps));
            
                if ~isempty(Props)
                    [v,k]=obj.getOtherProperties(Props,index);
                    for i=1:numel(k)
                        obj.(k(i))=v(ismember(k,k(i)));
                    end
                end
            end
        end

        %==================================================================
        function x=headerComment_Type2(obj)
            tic

            % initialization
            N=numel(obj.index);
            middlecom=strings(N,1);
            % valueArray=cell(N,1);
            names=strings(N,1);
            comments=strings(N,1);
            namesExt=strings(N,1);
            namesSwitch=strings(N,1);
            flag=contains(class(obj),'InSystem');
            [strProps,~]=utils.splitproperties(obj);

            % get index of reference policies
            idxRefPol=obj.index>obj.Info.Handler.Count;

            % obj.getPiecesOfInfo

            % get values of parameters from main object and extensions
            % object
            % temp=copy(obj);

            temp=copy(obj);
            ss=temp(1:end,["name","comment","Switch","extensions"]);
            names=ss.name';
            comments=ss.comment';

            if isfield(ss,'Switch')
                namesSwitch=ss.Switch';
            else
                namesSwitch="";
            end

            namesExt=strings(numel(ss.extensions),1);
            N=numel(ss.extensions);
            posRefPol=find(idxRefPol);
            for jj=1:N
                if ~isempty(ss.extensions{jj}) && ~ismember(jj,posRefPol)
                    if jj==13
                        cc=0;
                    end
                    namesExtJoin=strjoin(ss.extensions{jj}(1:end).shortName',',');
                    namesExt(jj)=sprintf('(with switch set for %s)',namesExtJoin);
                end
            end

            if any(idxRefPol)
                comments(idxRefPol)="";
            end

            if any(idxRefPol) && strcmp(class(obj),'Policy') ||...
                    any(idxRefPol) && strcmp(class(obj),'ReferencePolicy')
                namesExt(idxRefPol)="Reference policy";
            end

            toc


            % for jj=1:N
            %     temp=copy(obj);
            %     temp=temp.update(obj.index(jj));
            % 
            %     % temp=update(temp,jj);
            % 
            %     % valueArray{jj}=temp.extensions(':',{'shortName','baseOff'});
            %     names(jj)=temp.name;
            % 
            %     if strcmp(class(temp),'ReferencePolicy')
            %         comments(jj)="";
            %     else
            %         comments(jj)=temp.comment;
            %     end
            % 
            %     ext=temp.extensions;
            %     if isempty(ext)
            %         namesExt(jj)="";
            %     else
            %         namesExtJoin=strjoin(ext(1:end).shortName',',');
            %         namesExt(jj)=sprintf('(with switch set for %s)',namesExtJoin);
            %         % if flag
            %         %     namesExt(jj)=sprintf('%s (with switch set for %s)',temp.Switch,namesExtJoin);
            %         %     % namesExt(jj)=['(with switch set for ',char(temp.extensions(1:end).shortName),')'];
            %         % else
            %         %     namesExt(jj)=sprintf('(with switch set for %s)',namesExtJoin);
            %         % end
            %     end
            %     if flag
            %         namesSwitch(jj)=temp.Switch;
            %         % namesExt(jj)=['(with switch set for ',char(temp.extensions(1:end).shortName),')'];
            %     else
            %         namesSwitch(jj)="";
            %     end
            %     % if flag
            %     %     middlecom(jj)=temp.Switch;
            %     %     if strcmp("",middlecom(jj))
            %     %         try
            %     %             middlecom(jj)=temp.parent.Switch;
            %     %         catch
            %     %         end
            %     %     end
            %     % end
            % end

            % 
            % % set extensions middle comment
            % idxExt =~cellfun(@isempty,valueArray);
            % extNamePol=cellfun(@(t) string({t(:).shortName})',valueArray(idxExt & ~idxRefPol),'UniformOutput',false);
            % % display at most 3 extensions short names
            % extNamePol=cellfun(@(t) strjoin(t(1:numel(t)*(numel(t)<=3)+3*(numel(t)>3)),','),extNamePol);
            % if ~isempty(extNamePol)
            %     if flag
            %         % comment array for InSystem classes
            %         extComPol=append(middlecom(idxExt & ~idxRefPol)," (with switch set for ",extNamePol,")");
            %         middlecom(idxExt & ~idxRefPol)=extComPol;
            %     else
            %         extComPol=append("(with switch set for ",extNamePol,")");
            %         middlecom(idxExt & ~idxRefPol)=extComPol;
            %     end
            % end

            % OtherProperties=obj.getOtherProperties({'name','comment'});

            % if any(idxRefPol) && strcmp(class(obj),'Policy')
            %     extComRef=repmat("Reference Policy",sum(idxRefPol),1);
            %     namesExt(idxRefPol)=extComRef;
            %     % if flag
            %     %     % extComRef=append(middlecom(idxRefPol)," (Reference policy)");
            %     %     % middlecom(idxRefPol)=extComRef;
            %     %     comments(idxRefPol)="";
            %     % else
            %     %     extComRef=repmat("Reference Policy",sum(idxRefPol),1);
            %     %     middlecom(idxRefPol)=extComRef;
            %     % end
            % % elseif any(idxRefPol) && ~strcmp(class(obj),'Policy')
            % %     comments(idxRefPol)=[];
            % end
            middlecom=append(namesSwitch,' ', namesExt);

            x=[names,middlecom,comments];

        end

        %------------------------------------------------------------------
        function header = appendComment(obj,COMM)
            % COMM : (N,M) string. First column is string of names. Second
            % column is string of middle comments. Third column is string
            % of last comments.

            [N,M]=size(COMM);
            idx=1:N;
            idx=string(num2str(idx'));
            nams=COMM(:,1);
            header = append(idx,': ',nams);
            if M>1
                coms=COMM(:,2);
                header=obj.commentElement(header,coms);
            end
            if M>2
                coms=COMM(:,3);
                header=obj.commentElement(header,coms);
            end

            % get the name of class from metaclass object
            dimStr=matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
            headerStr = [dimStr, ' ', matlab.mixin.CustomDisplay.getClassNameForHeader(obj), ' array:'];
            headerStr = string(headerStr);

            % combine name of class with header comment array
            header=[headerStr;header];
            header = sprintf('%s\n',header);
        end

    end

end