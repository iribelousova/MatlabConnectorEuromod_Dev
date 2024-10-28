classdef redefinesparen < matlab.mixin.indexing.RedefinesParen & matlab.mixin.indexing.RedefinesDot & utils.customdisplay & handle 
    % redefinesparen - Superclass for all the Euromod Connector main classes.
    %
    % Description:
    %     This superclass is used in all the main Euromod Connector
    %     classes. It contains functions that are common to these
    %     subclasses. 
    %
    %     This class inherits methods and properties from other Matlab
    %     built-in classes.
    %
    %  Country Properties:
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
    %     update                   - Update the values of properties of a 
    %                                specific class.
    %
    % See also Model, Country, System, Policy, Dataset, Extension.

    methods (Static, Access = public,Hidden=true)
        %==================================================================
        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end
        %==================================================================
        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end
        %==================================================================
        function cat(varargin)
            error("Model:ConcatenationNotSupported",...
                "Concatenation is not supported.");
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
    end
    methods (Static, Access=protected, Hidden)
        %==================================================================
        function [idxArr,userProp]=convertIndexOperator(indexOp)
            % convertIndexOperator - Get the values of the indices.
            %
            % Input Arguments:
            %   indexOp - matlab.indexing.IndexingOperation Class.

            if strcmp(indexOp(1).Type,'Paren')
                fn='Indices';
            else
                fn='Name';
            end

            userProp=[];

            idxArr=indexOp(1).(fn){1};
            if numel(indexOp) == 1
                if numel(indexOp(1).(fn))==2
                    userProp=string(indexOp(1).(fn){2});
                end
            elseif numel(indexOp) == 2
                if strcmp(indexOp(2).Type,'Paren')
                    fn='Indices';
                else
                    fn='Name';
                end
                userProp=indexOp(2).(fn);
            end

        end

    end
    methods (Access = protected,Hidden)
        %==================================================================
        function index = convertIndex(obj,index)
            % convertIndex - Convert string indices in numeric using the
            % 'indexArr' property of the object.

            if isnumeric(index)
                return;
            end

            if strcmp(index,':')
                index=1:numel(obj.indexArr);
                return;
            end
            
            % Transform cell values to strings
            if iscell(index)
                isNumeric=cellfun(@isnumeric,index);
                indexStr=string(index(~isNumeric));
            elseif ischar(index) || isstring(index)
                indexStr=string(index);
            end

            % Get string properties of the object
            % temp=copy(obj);
            % temp.index=temp.indexArr;
            % strProps=utils.splitproperties(temp);
            % [values,~]=temp.getOtherProperties(strProps,index);
            if isa(obj,'Country')
                values = obj.parent.defaultCountries;
            elseif isa(obj,'Policy') 
                [values,~]=utils.getInfo(obj.Info.Handler,':');
            else
                temp=copy(obj);
                temp.index=temp.indexArr;
                strProps=utils.splitproperties(temp);
                [values,~]=temp.getOtherProperties(strProps,index);
            end
            [a1,a2]=ismember(values,indexStr);

            if sum(sum(a2))==0
                error('Unrecognized property value(s) "%s".',strjoin(string(indexStr),'","'))
            end

            if size(a1,2)>1
                [~,b]=find(a1);
            else
                b=find(a1);
            end

            if isa(obj,'Policy') || isa(obj,'ReferencePolicy')
                index=find(ismember(obj.indexArr,b));
            else
                index=b;
            end

        end
        %==================================================================
        function varargout=getOutput(obj,idx,Props)

            if nargin==2
                Props=[];
            end

            if isempty(Props)
                N=1;
            else
                N=2;
            end

            idx=obj.indexArr(idx);

            if numel(idx)==1
                obj=obj.update(idx);
  
                if N==1
                    [varargout{1:nargout}]=obj;
                    return;
                elseif N==2
                    [strProps,objProps]=utils.splitproperties(obj);
                    if all(ismember(Props,strProps))
                        X=obj.getOtherProperties(Props,idx);
                        if numel(Props)==1
                            X=X';
                        end
                        % M=numel(Props);
                        % X=strings(M,1);
                        % for t=1:M
                        %     X(t)=obj.(Props(t));
                        % end

                        [varargout{1:nargout}]=X;
                        return;

                    elseif all(ismember(Props,objProps))
                        M=numel(Props);
                        if M==1
                            [varargout{1:nargout}]=obj.(Props);
                        else
                            X=struct;
                            for t=1:M
                                X.(objProps(t))=obj.(objProps(t));
                            end
                            [varargout{1:nargout}]=X;
                        end

                        return;

                    else
                        X=struct;
                        strProps=strProps(ismember(strProps,Props));
                        if ~isempty(strProps)
                            [tempX,tempK]=obj.getOtherProperties(Props,idx);
                            M=numel(tempK);
                            for t=1:M
                                X.(tempK(t))=tempX.(tempK(t));
                            end
                        end
                        objProps=objProps(ismember(objProps,Props));
                        if ~isempty(objProps)
                            M=numel(objProps);
                            for t=1:M
                                X.(objProps(t))=obj.(objProps(t));
                            end
                        end

                        [varargout{1:nargout}]=X;
                        return;
                    end
                end
            else

                obj=obj.update(idx);
                if N==1
                    [varargout{1:nargout}]=obj;
                    return;
                end

                [strProps,objProps]=utils.splitproperties(obj);
                if all(ismember(Props,strProps))
                    [v,k]=obj.getOtherProperties(Props,idx);
                    if numel(Props)==1
                        [varargout{1:nargout}]=v';

                        return;
                    else
                        X=struct;
                        for jj=1:numel(k)
                            X.(k(jj))=v(jj,:);
                        end
                        [varargout{1:nargout}]=X;
                        return;
                    end
                else
                    X=struct;
                    strProps=strProps(ismember(strProps,Props));
                    if ~isempty(strProps)
                        [v,k]=obj.getOtherProperties(strProps,idx);
                        M=numel(k);
                        for t=1:M
                            X.(k(t))=v(ismember(k,k(t)),:);
                        end
                    end
                    objProps=objProps(ismember(objProps,Props));
                    if ~isempty(objProps)
                        M=numel(objProps);
                        for s=1:numel(idx)
                            % temp=copy(obj);
                            obj=obj.update(idx(s));
                            for t=1:M
                                X.(objProps(t))(s)={obj.(objProps(t))};
                            end
                        end
                    end
                end

                [varargout{1:nargout}]=X;
                return;

            end
        end
        %==================================================================
        function varargout = parenReference(obj,indexOp)

            N=numel(indexOp);

            Ni=1;
            out=obj;
            for i=1:2:N
                if N==Ni
                    [idx,Props]=out.convertIndexOperator(indexOp(Ni));
                    idx = out.convertIndex(idx);
                    if isempty(Props)
                        out=out.getOutput(idx);
                    else
                        out=out.getOutput(idx,Props);
                    end
                elseif N>Ni
                    [idx,Props]=out.convertIndexOperator(indexOp(Ni:Ni+1));
                    idx = out.convertIndex(idx);
                    if any(ismember(Props,["run","info","setParameter"]))
                        out=out.getOutput(idx);
                        X=eval([char(Props),'(out,indexOp(Ni+2).Indices{:})']);
                        [varargout{1:nargout}]=X;
                        return;
                    end
                    objProps=properties(out);
                    if numel(Props)==1 && ~ismember(Props,objProps)
                        out=out.getOutput(idx);
                        if N>=Ni+2
                            [varargout{1:nargout}]=out.(Props).(indexOp(Ni+2:end));
                        else
                            [varargout{1:nargout}]=out.(Props);
                        end
                        return;
                    end
                    out=out.getOutput(idx,Props);
                end

                if N<=Ni+1
                    if ~isstring(out) && ~isnumeric(out) && ~isstruct(out) && ~iscell(out)
                        if numel(out.indexArr)==1
                            out=out.update(out.indexArr);
                        end

                        % Cut indexArr && commentArray if nargout == 1
                        if numel(out.index)<numel(out.indexArr) && nargout == 1
                            out_=copy(out);
                            mtOut=metaclass(out_);
                            allProps=string({mtOut.PropertyList.Name});
                            if ismember("commentArray",allProps)
                                if ~isempty(out_.commentArray)
                                    idx=find(ismember(out_.indexArr,out_.index));
                                    out_.commentArray=out_.commentArray(idx,:);
                                end
                            end
                            out_.indexArr=out_.index;
                        else
                            out_=out;
                        end
                    else
                        out_=out;
                    end

                    [varargout{1:nargout}]=out_;

                    return;
                end

                Ni=Ni+2;

            end
        end
        %==================================================================
        function obj = parenAssign(obj,indexOp,varargin)

        end
        %==================================================================
        function obj = parenDelete(obj,indexOp)
            N=numel(indexOp);
            K=1;
            [idxArr1,userProp1]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));

            if N==1
                obj(idxArr1)=[];
            elseif N==2
                obj(idxArr1).(userProp1)=[];
            end
            if N<=2
                return;
            end
            K=K+2;
            [idxArr2,userProp2]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            if N==3
                obj(idxArr1).(userProp1)(idxArr2)=[];
            elseif N==4
                obj(idxArr1).(userProp1)(idxArr2).(userProp2)=[];
            end
            if N<=4
                return;
            end
            K=K+2;
            [idxArr3,userProp3]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            if N==5
                obj(idxArr1).(userProp1)(idxArr2).(userProp2)(idxArr3)=[];
            elseif N==6
                obj(idxArr1).(userProp1)(idxArr2).(userProp2)(idxArr3).(userProp3)=[];
            end
            if N<=6
                return;
            end
            K=K+2;
            [idxArr4,userProp4]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            if N==7
                obj(idxArr1).(userProp1)(idxArr2).(userProp2)(idxArr3).(userProp3)(idxArr4)=[];
            elseif N==6
                obj(idxArr1).(userProp1)(idxArr2).(userProp2)(idxArr3).(userProp3)(idxArr4).(userProp4)=[];
            end
            if N<=8
                return;
            end
        end
        %==================================================================
        function n = parenListLength(obj,indexOp,ict)
            n=1;
        end
    end
    methods (Access=protected,Hidden)
        %==================================================================
        function varargout = dotReference(obj,indexOp)

            [strProps,objProps] = utils.splitproperties(obj);
            propOp=indexOp(1).Name;
            M=numel(indexOp);

            % take object name property
            if isa(obj,'Model')
                values='';
            else
                temp=copy(obj);
                values=temp(1:end).name;
            end

                if ismember(propOp,[strProps,objProps])
                    % case 1: index is the object property
                    a1 = 1;
                elseif ismember(propOp,values)
                    % case 4: index is the object name
                    Idx=find(ismember(values,propOp));
                    a1=4;
                elseif ismember(propOp,'parent')
                    a1=5;
                else
                    if size(obj,1)==1
                        atemp=1;
                        count=1;
                        objProps(ismember(objProps,'parent'))=[];
                        while atemp
                            values=obj.(objProps(count))(1:end).name;
                            if ismember(objProps(count),'countries')
                                values=upper(values);
                            end
                            a1=double(ismember(propOp,values));
                            % case 2: index is the property "name" of a 
                            % property of type class
                            if any(a1)
                                a1=2;
                                atemp=0;
                                propertyName=objProps(count);
                            % case 3: index is a property of a property of
                            % type class
                            else
                                a1=double(ismember(propOp,properties(objProps(count))));
                                if any(a1)
                                    a1=3;
                                    atemp=0;
                                    propertyName=objProps(count);
                                end
                            end
                            count=count+1;
                        end
                    end
                end
                
                if a1==1
                    % index is a property of the object
                    out=obj(1:end).(propOp);
                    % if isa(obj,'ExtensionSwitch')
                    %     out=obj(1:end).(propOp);
                    % else
                    %     out=obj.(propOp);
                    % end
                elseif a1==2
                    % index is the property "name" of a property of type
                    % class of the object
                    out=obj.(propertyName)(propOp);
                elseif a1==3
                    % index is a property of a property of type
                    % class of the object
                    out=obj.(propertyName).(propOp);
                elseif a1==4
                    % index is the object name
                    out=obj(propOp);
                elseif a1==5
                    % index property is "parent" property
                    out=obj.(propOp);
                    % index is a property of type string
                    % out=obj.getOtherProperties(propOp,obj.index);
                else
                    % index is something else
                    error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
                end
                if M>1
                    out=out.(indexOp(2:end));
                end
                [varargout{1:nargout}]=out;
                return;

            % if isa(obj,'Model')
            % 
            %     % take countries' names
            %     values = obj.defaultCountries;
            %     [a1,~]=ismember(values,propOp);
            % 
            %     % when index is country name
            %     if any(a1)
            %         out=obj.countries(propOp);
            %     else
            %         % when index is the Model object property
            %         if ismember(propOp,[strProps,objProps])
            %             out=obj.(propOp);
            %         else
            %             error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
            %         end
            %     end
            % 
            %     % If requested, get the system object
            %     if M>=2
            %         propOp2=indexOp(2).Name;
            % 
            %         % get systems' names
            %         values=out.systems(1:end).name;
            %         [a1,~]=ismember(values,propOp2);
            % 
            %         % when second index is system name 
            %         if any(a1)
            %             if M==2
            %                 out=out.systems(propOp2);
            %             else
            %                 out=out.systems(propOp2).(indexOp(3:end));
            %             end
            %         else
            %             % when second index is the Country object property
            %             if ismember(propOp2,properties(out))
            %                 if M==2
            %                     out=out.(propOp2);
            %                 else
            %                     [idx,~]=out.convertIndexOperator(indexOp(3));
            %                     if M==3
            %                         out=out.(propOp2)(idx);
            %                     else
            %                         out=out.(propOp2)(idx).(indexOp(4:end));
            %                     end
            %                 end
            %             else
            %                 % when second index is something else
            %                 try
            %                     if M==1
            %                         out=out.systems(propOp2);
            %                     else
            %                         out=out.systems(propOp2).(indexOp(3:end));
            %                     end
            %                 catch
            %                     error("Unrecognized method or property '%s' for object '%s'.", propOp2,class(out))
            %                 end
            %             end
            %         end
            % 
            %     end
            %     [varargout{1:nargout}]=out;
            %     return;
            % 
            % elseif isa(obj,'Country')
            % 
            %     % take systems' names
            %     % case 1: index is the Country property
            %     if ismember(propOp,[strProps,objProps])
            %         a1 = 1;
            %     else
            %     % case 2: index is the System name
            %         if size(obj,1)==1
            %             values=obj.systems(1:end).name;
            %             a1=double(ismember(propOp,values));
            %             if any(a1)
            %                 a1(a1==1)=2;
            %     % case 3: index is the System property
            %             else
            %                 a1=double(ismember(propOp,properties(obj.systems)));
            %                 a1(a1==1)=3;
            %             end
            %         else
            %     % case 4: index is the Country name
            %             values=obj(1:end).name;
            %             a1=double(ismember(propOp,values));
            %             a1(a1==1)=4;
            %         end
            %     end
            % 
            %     if a1==1
            %         % index is the Country property
            %         out=obj.(propOp);
            %     elseif a1==2
            %         % index is the System name
            %         out=obj.systems(propOp);
            %     elseif a1==3
            %         % index is the System property
            %         out=obj.systems(propOp);
            %     elseif a1==4
            %         % index is the Country name
            %         out=obj(propOp);
            %     else
            %         % index is something else
            %         error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
            %     end
            %     if M>1
            %         out=out.(indexOp(2:end));
            %     end
            % 
            %     % if any(a1)
            %     %     % when index is the system name
            %     %     if M==1
            %     %         out=obj.systems(propOp);
            %     %     else
            %     %         out=obj.systems(propOp).(indexOp(2:end));
            %     %     end
            %     % else
            %     %     % when index is the Country object property
            %     %     if ismember(propOp,[strProps,objProps])
            %     %         out=obj.(indexOp(1:end));
            %     %     % when index is the Country name
            %     %     elseif ismember(propOp,countryNames)
            %     %         out=obj(propOp);
            %     %     else
            %     %         % when index is something else
            %     %         try
            %     %             if M==1
            %     %                 out=obj.systems(propOp);
            %     %             else
            %     %                 out=obj.systems(propOp).(indexOp(2:end));
            %     %             end
            %     %         catch
            %     %             error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
            %     %         end
            %     %     end
            %     % end
            %     [varargout{1:nargout}]=out;
            %     return;
            % 
            % elseif isa(obj,'System')
            % 
            %     % take object name property
            %     values=obj(1:end).name;
            % 
            %     if ismember(propOp,[strProps,objProps])
            %         % case 1: index is the object property
            %         a1 = 1;
            %     elseif ismember(propOp,values)
            %         % case 4: index is the object name
            %         a1=4;
            %     % elseif ismember(propOp,strProps)
            %     %     a1=5;
            %     else
            %         if size(obj,1)==1
            %             atemp=1;
            %             count=1;
            %             while atemp
            %                 values=obj.(objProps(count))(1:end).name;
            %                 a1=double(ismember(propOp,values));
            %                 % case 2: index is the property "name" of a 
            %                 % property of type class
            %                 if any(a1)
            %                     a1=2;
            %                     count=0;
            %                     propertyName=objProps(count);
            %                 % case 3: index is a property of a property of
            %                 % type class
            %                 else
            %                     a1=double(ismember(propOp,properties(objProps(count))));
            %                     if any(a1)
            %                         a1=3;
            %                         count=0;
            %                         propertyName=objProps(count);
            %                     end
            %                 end
            %                 count=count+1;
            %             end
            %         end
            %     end
            % 
            %     if a1==1
            %         % index is a property of type class
            %         out=obj.(propOp);
            %     elseif a1==2
            %         % index is the System name
            %         out=obj.(propertyName)(propOp);
            %     elseif a1==3
            %         % index is the System property
            %         out=obj.(propertyName).(propOp);
            %     elseif a1==4
            %         % index is the Country name
            %         out=obj(propOp);
            %     % elseif a1==5
            %     %     % index is a property of type string
            %     %     out=obj.getOtherProperties(propOp,obj.index);
            %     else
            %         % index is something else
            %         error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
            %     end
            %     if M>1
            %         out=out.(indexOp(2:end));
            %     end
            % 
            %     % if any(a1)
            %     %     % when index is the system name
            %     %     if M==1
            %     %         out=obj.systems(propOp);
            %     %     else
            %     %         out=obj.systems(propOp).(indexOp(2:end));
            %     %     end
            %     % else
            %     %     % when index is the Country object property
            %     %     if ismember(propOp,[strProps,objProps])
            %     %         out=obj.(indexOp(1:end));
            %     %     % when index is the Country name
            %     %     elseif ismember(propOp,countryNames)
            %     %         out=obj(propOp);
            %     %     else
            %     %         % when index is something else
            %     %         try
            %     %             if M==1
            %     %                 out=obj.systems(propOp);
            %     %             else
            %     %                 out=obj.systems(propOp).(indexOp(2:end));
            %     %             end
            %     %         catch
            %     %             error("Unrecognized method or property '%s' for object '%s'.", propOp,class(obj))
            %     %         end
            %     %     end
            %     % end
            %     [varargout{1:nargout}]=out;
            %     return;
            % 
            % else
            %     if ismember(propOp,strProps)
            %         [varargout{1:nargout}]=obj.getOtherProperties(propOp,obj.index);
            %     elseif ismember(propOp,objProps)
            %         [varargout{1:nargout}]=obj.(propOp);
            %     end
            %     return;
            % 
            % end
        end
        %==================================================================
        function obj = dotAssign(obj,indexOp,varargin)
            c=0;
            % [obj.AddedFields.(indexOp)] = varargin{:};
        end
        %==================================================================
        function n = dotListLength(obj,indexOp,indexContext)
            n = 1;
            % n = listLength(obj.AddedFields,indexOp,indexContext);
        end
        %==================================================================
        function obj=update(obj,index,props)
            % update - Update the values of properties of a specific class.

            if strcmp(class(obj),'Policy')
                if all(index>obj.Info.Handler.Count)
                    cc=ReferencePolicy;
                    cc.initialize(obj);
                    obj=cc;
                end
            end
            if strcmp(class(obj),'ReferencePolicy')
                Order=zeros(1,0);
                for i=1:numel(obj.Info.PieceOfInfo)
                    Order(i)=str2double(utils.getInfo(obj.Info.PieceOfInfo(i).Handler,'Order'));
                end
                if all(index<obj.Info.Handler.Count) && all(ismember(Order,obj.indexArr))
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
    end

end
