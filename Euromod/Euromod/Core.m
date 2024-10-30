classdef (Abstract) Core < utils.redefinesparen %utils.customdisplay & handle & utils.DynPropHandle
    % Core - Superclass for all the Euromod Connector main classes.
    %
    % Description:
    %     This superclass is used in all the main Euromod Connector
    %     classes. It contains functions that are common to these
    %     subclasses.
    %
    %     This class inherits methods and properties from other Matlab
    %     built-in classes.
    %
    %  Core Methods (Access=public):
    %     info                     - Get information about an object.
    %     run                      - Run Euromod simulation.
    %
    %  Core Methods (Access=protected,Hidden):
    %     getOtherProperties_Type1 - Retrieve infos from the main object
    %                                handler and from the
    %                                'obj.Info.PieceOfInfo.Handler'.
    %     getParent                - Get a specific class object.
    %     getPieceOfInfo           - Get info from the c# function
    %                                'CountryInfoHandler.GetPieceOfInfo'
    %                                and append the handler to
    %                                'obj.Info.PieceOfInfo.Handler'.
    %     getPiecesOfInfo          - Get info from the c# function
    %                                'CountryInfoHandler.getPiecesOfInfo'.
    %     setParent                - Set the new 'obj.Info.Handler' in the
    %                                Country class.
    %     tag_s_                   - Get a composed tag name.
    %
    % See also Model, Country, System, Policy, Dataset, Extension.

    methods
        function obj = Core()
            % Core - Superclass for all the Euromod Connector main classes.
        end
    end
    methods (Access=public)
        %==================================================================
        function s = info(obj,varargin)
            % info - Information about a Euromod object.
            %
            % Syntax:
            %
            %   s = info(obj)
            %   s = info(obj,Prop)
            %   s = info(obj,Prop,Value)
            %
            % Description:
            % s = info(obj) returns information about the configuration of
            % a Euromod object.
            %             
            % Input Arguments:
            %   obj   - class. Can be any of the Country, Policy, System or
            %           Dataset classes or a their subclass.
            %   Prop  - (1,1) string. Property name of the obj.
            %           This input argument is required when obj is the 
            %           Country class (accepting 'datasets' or 'systems' as 
            %           value), and is optional when obj is the System class  
            %           (accepting 'datasets', 'policies', or 'parameters' 
            %           as value).
            %   Value - (1,1) string. Parameter ID or policy name. This
            %           input argument is required when obj is the System
            %           class and Prop is either 'parameters' or
            %           'policies'.
            %
            % Example:
            %   mod=euromod('C:\EUROMOD_RELEASES_I6.0+');
            %   % Get information about policy "uprate_se":
            %   mod.countries('SE').systems('SE_2021').policies(2).info()
            %   mod.countries('SE').systems('SE_2021').info('policies','uprate_se')
            %   mod.countries('SE').info('systems')

            if size(obj,1)>1
                error('Object array is not allowed.')
            end
            if isa(obj,'Country')
                cobj=copy(obj);
            else
                cobj=copy(obj.getParent("COUNTRY"));
            end

            % get country handler
            Idx=cobj.index;
            H=cobj.Info(Idx).Handler;

            if isa(obj,'System')
                if numel(varargin)==0
                    name=obj.name; % system name
                    x = H.GetSystemExpandedInfo(name);
                    [values,keys]=utils.getInfo(x);
                elseif numel(varargin)>=1 && numel(varargin)<=2
                    Arg=string(varargin{1});
                    if ~any(ismember(Arg,["datasets","parameters","policies"]))
                        error("Unrecognized input argument '%s' for class '%s'. \nAcceptable names are: %s.",...
                            Arg,class(obj),join(["datasets","parameters","policies"],', '))
                    end
                    if strcmpi(Arg,'datasets')
                        ID=obj.ID;
                        x = H.GetSysYearCombinations('ID',ID); % use name or ID
                        values=utils.getInfo(x);
                        values(ismember(values,'no'))="";
                        values(ismember(values,'yes'))="best match";
                        keys=[];
                    elseif strcmpi(Arg,'parameters')
                        if numel(varargin)<2
                            error("Not enought input arguments. Please, specify the parameter ID as a 'string'.")
                        end
                        parid=string(varargin{2}); % parameter ID "parID"
                        name=obj.name; % system name
                        x = H.GetSysParInfo(name,parid);
                        [values,keys]=utils.getInfo(x);
                    elseif strcmpi(varargin{1},'policies')
                        if numel(varargin)<2
                            error("Not enought input arguments. Please, specify the policy name as a 'string'.")
                        end
                        polName=string(varargin{2}); % policy name
                        sysName=obj.name; % system name
                        x = H.GetSysPolInfo(polName,sysName);
                        [values,keys]=utils.getInfo(x);
                        if any(ismember(keys,""))
                            keys(ismember(keys,""))="Switch";
                        end

                    end
                else
                    error('Too many input arguments.')
                end

            elseif isa(obj,'Dataset')
                if numel(varargin)==0
                    name=obj.name; % dataset name
                    x = H.GetDataSetInfo(name);
                    [values,keys]=utils.getInfo(x);
                else
                    error('Too many input arguments.')
                end

            elseif isa(obj,'Country')
                if numel(varargin)==0
                    error("Not enought input arguments. Please, specify the info type as a 'string'.\n%s %s.",...
                        "Acceptable values are:",join(["datasets","systems"],', '))
                elseif numel(varargin)>1
                    error('Too many input arguments.')
                end
                if strcmpi(varargin{1},'datasets')
                    x=H.GetDatasets();
                    values=utils.getInfo(x);
                elseif strcmpi(varargin{1},'systems')
                    x= H.GetSystems();
                    values=utils.getInfo(x);
                end
                keys=[];

            elseif isa(obj,'Policy')
                if numel(varargin)>0
                    error('Too many input arguments.')
                end
                name=obj.name; % policy name
                x = H.GetPolInfo(name);
                [values,keys]=utils.getInfo(x);
            else
                error("The class of type '%s' is not acceptable.",class(obj))
            end

            if isempty(keys)
                s=values;
                return;
            else
                keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
                if any(contains(keys,'iD'))
                    keys(contains(keys,'iD'))='ID';
                end
                if any(contains(keys,'switch'))
                    keys(contains(keys,'switch'))='Switch';
                end

                s=struct;
                for i=1:numel(keys)
                    s.(keys(i))=values(i,:);
                end

            end
        end
    end
    methods (Static,Access=protected,Hidden)
        %==================================================================
        function x=tag_s_(tag1,tag2)
            % tag_s_ - Get a composed tag name.

            t=[char(tag1),'_',char(tag2)];
            x = char(EM_XmlHandler.TAGS.(t));
        end
    end
    methods (Access=protected,Hidden)
        %==================================================================
        function [values,keys]=getOtherProperties_Type1(obj,name)
            % getOtherProperties_Type1 - Retrieve infos from the main
            % object handler and from the obj.Info.PieceOfInfo.Handler.

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
            indexLoop=obj.index;
            if isfield(obj.Info,'PieceOfInfo')
                for i=1:N
                    i_=indexLoop(i);
                    [v,k]=utils.getInfo(obj.Info.PieceOfInfo(i_).Handler,newname);
                    IDs(i)=obj.Info.PieceOfInfo(i_).Handler.Item(subTag);
                    if  ~isempty(v)
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
        %==================================================================
        function [obj,values]=getPieceOfInfo(obj,ID,parentID,TAG,name)
            % getPieceOfInfo - Get info from the c# function
            % 'CountryInfoHandler.GetPieceOfInfo' and append the handler to
            % obj.Info.PieceOfInfo.Handler.

            if nargin <= 4
                name=[];
            end

            % get class objects
            cobj=obj.getParent('COUNTRY');
            Idx = cobj.index;

            % get current object ID
            N=numel(ID);

            % get "order" by default, if it is an object property
            [strProps,objProps]=utils.splitproperties(obj);
            if ismember("Order",strProps) && isa(obj,'Policy')
                strprops="Order";
            else
                strprops=strings(1,0);
            end

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
                        strPropsNew=strProps;
                        % if ~isempty(objprops)
                        %     strPropsNew=strProps;
                        % else
                        %     strPropsNew=strprops;
                        % end
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
                        temp=copy(obj);
                        newindex=i__;
                        strPropsNew=strProps;

                        [v,k]=utils.getInfo(temp.Info.Handler,newindex,strPropsNew);
                        for k_i=1:numel(k)
                            % values(i__).(k(k_i))=v(k_i,:);
                            if ~ismember(k(k_i),"ID")
                                k(k_i)=append(lower(extractBefore(k(k_i),2))',extractAfter(k(k_i),1)');
                            end
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
        function [values,keys]=getPiecesOfInfo(obj,Tag, subTag, ID, index, keys)
            % getPiecesOfInfo - Get info from the c# function
            % 'CountryInfoHandler.getPiecesOfInfo'.

            if nargin <= 4
                index=[];
            end
            if nargin == 6
                userKeys=keys;
            end

            cobj=obj.getParent('COUNTRY');
            Idx=cobj.index;

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

            if nargin == 6
                values=values(ismember(keys,userKeys),:);
                keys=keys(ismember(keys,userKeys));
            end
        end
    end
end