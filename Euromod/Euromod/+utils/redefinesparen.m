classdef redefinesparen < matlab.mixin.indexing.RedefinesParen & utils.customdisplay & handle  % & matlab.mixin.indexing.RedefinesDot

    % methods (Access=protected)
    %     function varargout = dotReference(obj,indexOp)
    %         [varargout{1:nargout}] = obj.(indexOp);
    %     end
    % 
    %     function obj = dotAssign(obj,indexOp,varargin)
    %         [obj.(indexOp.Name)] = varargin{:};
    %     end
    % 
    %     function n = dotListLength(obj,indexOp,indexContext)
    %         n = listLength(obj,indexOp,indexContext);
    %     end
    % end

    methods (Static, Access = public,Hidden=true)

        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end

        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end

        function cat(varargin)
            error("Model:ConcatenationNotSupported",...
                "Concatenation is not supported.");
        end

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

        %------------------------------------------------------------------
        function [idxArr,userProp]=convertIndexOperator(indexOp)
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
            % elseif numel(indexOp) == 3
            %     indexOp(1).(fn)
            end

        end

    end


    %%%--------------------------------------------------------------------
    methods (Access = protected,Hidden)

        %------------------------------------------------------------------
        function index = convertIndex(obj,index)

            if isnumeric(index)
                return;
            end

            % notNumeric=~cellfun(@isnumeric,index);
            % indexStr=index(notNumeric);

            if strcmp(index,':')
                index=1:numel(obj.indexArr);
                return;
            end

            if iscell(index)
                isNumeric=cellfun(@isnumeric,index);
                indexStr=string(index(~isNumeric));
            elseif ischar(index) || isstring(index)
                indexStr=string(index);
            end

            if isa(obj,'Country')
                values = obj.parent.defaultCountries;
            else
                [values,~]=utils.getInfo(obj.Info.Handler,':');
            end
            [a1,a2]=ismember(values,indexStr);

            a2(a2==0)=[];
            if all(size(values)>1)
                a1=sum(a1,1);
            end
            
            if numel(a2)==0
                error('Unrecognized property value(s) "%s".',strjoin(string(indexStr),'","'))
            end
            if numel(a2)~=numel(indexStr)
                indexStr(a2)=[];
                error('Unrecognized property value(s) "%s".',strjoin(string(indexStr),'","'))
            end
            if any(a1>1)
                error('Search values looking for same property "%s"',strjoin(values(a1>1),'","'));
            end
            
            index=string(index);
            [v1,v2]=sort(a2);
            a1=find(a1);
            a1=a1(v2);
            
            index(ismember(index,indexStr(v1)))=string(a1);
            index=str2double(index);
            index=sort(unique(index));

        end

        %##################################################################
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
                % if N>1
                %     % Props=indexOp(2).Name;
                %     obj=obj.update(idx,Props);
                % else
                %     obj=obj.update(idx);
                % end
                % 
                if N==1
                    [varargout{1:nargout}]=obj;
                    return;
                elseif N==2
                    [strProps,objProps]=utils.splitproperties(obj);
                    if all(ismember(Props,strProps))
                        M=numel(Props);
                        X=strings(M,1);
                        for t=1:M
                            X(t)=obj.(Props(t));
                        end

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
                            M=numel(strProps);
                            for t=1:M
                                X.(strProps(t))=obj.(strProps(t));
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
                % else
                %     Props=indexOp(2).Name;
                end

                [strProps,objProps]=utils.splitproperties(obj);
                if all(ismember(Props,strProps))
                    [v,k]=obj.getOtherProperties(Props);
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
                        [v,k]=obj.getOtherProperties(strProps);
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


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function varargout = parenReference(obj,indexOp)

            N=numel(indexOp);

            % -------------------------------------------------------------
            Ni=1;
            out=obj;
            for i=1:2:N

                if i==5
                    ff=0;
                end

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
                    out=out.getOutput(idx,Props);
                end
    
                if N<=Ni+1
                    if ~isstring(out) && ~isnumeric(out) && ~isstruct(out) && ~iscell(out)
                        if numel(out.indexArr)==1
                            out=out.update(out.indexArr);
                        end
                    end
                    [varargout{1:nargout}]=out;
                    return;
                end

                Ni=Ni+2;

            end

            % % % % -------------------------------------------------------------
            % % % Ni=Ni+2;
            % % % 
            % % % if N==Ni
            % % %     [idx,Props]=out.convertIndexOperator(indexOp(Ni));
            % % %     if isempty(Props)
            % % %         out=out.getOutput(idx);
            % % %     else
            % % %         out=out.getOutput(idx,Props);
            % % %     end
            % % % elseif N>Ni
            % % %     [idx,Props]=out.convertIndexOperator(indexOp(Ni:Ni+1));
            % % %     out=out.getOutput(idx,Props);
            % % % end
            % % % 
            % % % if N<=Ni+1
            % % %     if ~isstring(out) && ~isnumeric(out) && ~isstruct(out) && ~iscell(out)
            % % %         if numel(out.indexArr)==1
            % % %             out=out.update(out.indexArr);
            % % %         end
            % % %     end
            % % %     [varargout{1:nargout}]=out;
            % % %     return;
            % % % end

            % % % % -------------------------------------------------------------
            % % % Ni=Ni+2;
            % % % 
            % % % if N==Ni
            % % %     [idx,Props]=out.convertIndexOperator(indexOp(Ni));
            % % %     if isempty(Props)
            % % %         out=out.getOutput(idx);
            % % %     else
            % % %         out=out.getOutput(idx,Props);
            % % %     end
            % % % elseif N>Ni
            % % %     [idx,Props]=out.convertIndexOperator(indexOp(Ni:Ni+1));
            % % %     out=out.getOutput(idx,Props);
            % % % end
            % % % 
            % % % if N<=Ni+1
            % % %     if ~isstring(out) && ~isnumeric(out) && ~isstruct(out) && ~iscell(out)
            % % %         if numel(out.indexArr)==1
            % % %             out=out.update(out.indexArr);
            % % %         end
            % % %     end
            % % %     [varargout{1:nargout}]=out;
            % % %     return;
            % % % end



            % % N=numel(indexOp);

            % [idx,Props]=obj.convertIndexOperator(indexOp);
            % 
            % if isempty(Props)
            %     N=1;
            % else
            %     N=2;
            % end
            % 
            % % idx=obj.indexArr(indexOp(1).Indices{1});
            % 
            % if numel(idx)==1
            %     if N>1
            %         % Props=indexOp(2).Name;
            %         obj=obj.update(idx,Props);
            %     else
            %         obj=obj.update(idx);
            %     end
            % 
            %     if N==1
            %         [varargout{1:nargout}]=obj;
            %         return;
            %     elseif N==2
            %         [strProps,objProps]=utils.splitproperties(obj);
            %         if all(ismember(Props,strProps))
            %             M=numel(Props);
            %             X=strings(M,1);
            %             for t=1:M
            %                 X(t)=obj.(Props(t));
            %             end
            % 
            %             [varargout{1:nargout}]=X;
            %             return;
            % 
            %         elseif all(ismember(Props,objProps))
            %             M=numel(Props);
            %             if M==1
            %                 [varargout{1:nargout}]=obj.(Props);
            %             else
            %                 X=struct;
            %                 for t=1:M
            %                     X.(objProps(t))=obj.(objProps(t));
            %                 end
            %                 [varargout{1:nargout}]=X;
            %             end
            % 
            %             return;
            % 
            %         else
            %             X=struct;
            %             strProps=strProps(ismember(strProps,Props));
            %             if ~isempty(strProps)
            %                 M=numel(strProps);
            %                 for t=1:M
            %                     X.(strProps(t))=obj.(strProps(t));
            %                 end
            %             end
            %             objProps=objProps(ismember(objProps,Props));
            %             if ~isempty(objProps)
            %                 M=numel(objProps);
            %                 for t=1:M
            %                     X.(objProps(t))=obj.(objProps(t));
            %                 end
            %             end
            % 
            %             [varargout{1:nargout}]=X;
            %             return;
            % 
            %         end
            % 
            %     end
            % else
            % 
            %     obj=obj.update(idx);
            %     if N==1
            %         [varargout{1:nargout}]=obj;
            %         return;
            %     % else
            %     %     Props=indexOp(2).Name;
            %     end
            % 
            %     [strProps,objProps]=utils.splitproperties(obj);
            %     if all(ismember(Props,strProps))
            %         [v,k]=obj.getOtherProperties(Props);
            %         if numel(Props)==1
            %             [varargout{1:nargout}]=v';
            % 
            %             return;
            %         end
            %     else
            %         X=struct;
            %         strProps=strProps(ismember(strProps,Props));
            %         if ~isempty(strProps)
            %             [v,k]=obj.getOtherProperties(strProps);
            %             M=numel(k);
            %             for t=1:M
            %                 X.(k(t))=v(ismember(k,k(t)),:);
            %             end
            %         end
            %         objProps=objProps(ismember(objProps,Props));
            %         if ~isempty(objProps)
            %             M=numel(objProps);
            %             for s=1:numel(idx)
            %                 obj=obj.update(idx(s));
            %                 for t=1:M
            %                     X.(objProps(t))(s)={obj.(objProps(t))};
            %                 end
            %             end
            %         end
            %     end
            % 
            %     [varargout{1:nargout}]=X;
            %     return;
            % 
            % end


            % %--------------------------------------------------------------
            % % obj.(Props).index=indexOp(3).Indices{1};
            % out=obj.(Props);
            % 
            % idx=out.indexArr(indexOp(3).Indices{1});
            % 
            % % strProps=utils.splitproperties(out);
            % if N>3
            %     Props2=indexOp(4).Name;
            %     out=out.update(idx,Props2);
            % else
            %     out=out.update(idx);
            % end
            % % [v,k]=out.getOtherProperties(strProps);
            % % for i=1:numel(k)
            % %     out.(k(i))=v(ismember(k,k(i)));
            % % end
            % 
            % if N==3
            %     [varargout{1:nargout}]=out;
            %     return;
            % elseif N==4
            %     [varargout{1:nargout}]=out.(Props2);
            %     % if size(v,2)==1
            %     %     [varargout{1:nargout}]=out.(Props2);
            %     % else
            %     %     [varargout{1:nargout}]=v';
            %     % end
            %     return;
            % end

            %  %--------------------------------------------------------------
            % out=out.(Props2);
            % 
            % idx=out.indexArr(indexOp(5).Indices{1});
            % 
            % % strProps=utils.splitproperties(out);
            % if N>5
            %     Props3=indexOp(6).Name;
            %     out=out.update(idx,Props3);
            % else
            %     out=out.update(idx);
            % end
            % 
            % if N==5
            %     [varargout{1:nargout}]=out;
            %     return;
            % elseif N==6
            %     [varargout{1:nargout}]=out.(Props3);
            %     % if size(v,2)==1
            %     %     [varargout{1:nargout}]=out.(Props3);
            %     % else
            %     %     [varargout{1:nargout}]=v';
            %     % end
            %     return;
            % end

            % %--------------------------------------------------------------
            % % obj.(Props).index=indexOp(3).Indices{1};
            % out=out.(Props3);
            % 
            % idx=out.indexArr(indexOp(7).Indices{1});
            % 
            % % strProps=utils.splitproperties(out);
            % if N>7
            %     Props4=indexOp(8).Name;
            %     out=out.update(idx,Props4);
            % else
            %     out=out.update(idx);
            % end
            % 
            % if N==7
            %     [varargout{1:nargout}]=out;
            %     return;
            % elseif N==8
            %     [varargout{1:nargout}]=out.(Props8);
            %     % if size(v,2)==1
            %     %     [varargout{1:nargout}]=out.(Props8);
            %     % else
            %     %     [varargout{1:nargout}]=v';
            %     % end
            %     return;
            % end


            

            

            % N=numel(indexOp);
            % K=1;
            % 
            % [idxArr1,userProp1]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            % 
            % %----------------------------------------------------------
            % %----------------------------------------------------------
            % if isstring(idxArr1) || ischar(idxArr1) && ismember(idxArr1,["indexArr","tag","index"])
            %     [varargout{1:nargout}]=obj.(idxArr1);
            %     return;
            % end

            % if N<=2
            % 
            %     x1=obj.get(idxArr1,userProp1);
            %     %----------------------------------------------------------
            % 
            %     if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %         if numel(idxArr1)==numel(x1.indexArr)
            %             x1.isNew=1;
            %         else
            %             x1.isNew=0;
            %         end
            %     end
            %     if nargout==1 && isempty(userProp1)
            %         x=copy(x1);
            %         x.indexArr=x.index;
            %         x.isNew=1;
            %         x1.isNew=1;
            %     else
            %         x=x1;
            %     end
            % 
            %     % % x.isNew=1;
            %     % if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %     %     if nargout==1 % && isempty(userProp1)
            %     %         x=copy(x1);
            %     %         x.indexArr=x.index;
            %     %         x.isNew=1;
            %     %         x1.isNew=1;
            %     %     else
            %     %         x=x1;
            %     %         % x.index=x.indexArr;
            %     %     end
            %     %     % if ~isempty(userProp1)
            %     %     %     x.index=x.indexArr;
            %     %     % end
            %     % else
            %     %     x=x1;
            %     % end
            % 
            %     [varargout{1:nargout}]=x;
            % 
            %      return;
            % end
            % 
            % K=K+2;
            % [idxArr2,userProp2]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            % 
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % if N>2 && N <= 4
            % 
            %     if numel(idxArr1)>1
            %         msg= ['__countries','(',char(string(idxArr1(1))),':',char(string(idxArr1(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            % 
            %     [strProps,objProps] = utils.splitproperties(obj);
            %     obj=obj.update(idxArr1,{strProps;objProps});
            % 
            % 
            %     %----------------------------------------------------------
            %     %----------------------------------------------------------
            %     if isstring(idxArr2) || ischar(idxArr2) && ismember(idxArr2,["indexArr","tag","index"])
            %         [varargout{1:nargout}]=obj.(userProp1).(idxArr2);
            %         return;
            %     end
            % 
            %     x1=obj.(userProp1).get(idxArr2,userProp2);
            %     %----------------------------------------------------------
            % 
            %     % % % % obj(idxArr1).(userProp1)=obj.get(idxArr1,userProp1);
            % 
            %     if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %         if numel(idxArr2)==numel(x1.indexArr)
            %             x1.isNew=1;
            %         else
            %             x1.isNew=0;
            %         end
            %     end
            %     if nargout==1 && isempty(userProp2)
            %         x=copy(x1);
            %         x.indexArr=x.index;
            %         x.isNew=1;
            %         x1.isNew=1;
            %     else
            %         x=x1;
            %     end
            % 
            % 
            %     % if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %     %     if nargout==1  % && isempty(userProp2)
            %     %         x=copy(x1);
            %     %         x.indexArr=x.index;
            %     %         % x.isNew=1;
            %     %         % x1.isNew=1;
            %     %     else
            %     %         x=x1;
            %     %         % x.index=x.indexArr;
            %     %     end
            %     %     % if ~isempty(userProp2)
            %     %     %     x.index=x.indexArr;
            %     %     % end
            %     % else
            %     %     x=x1;
            %     % end
            % 
            % 
            % 
            %     % if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %     %     if numel(idxArr2)==numel(x1.indexArr)
            %     %         x1.isNew=1;
            %     %     else
            %     %         x1.isNew=0;
            %     %     end
            %     % end
            %     % if nargout==1 && isempty(userProp2)
            %     %     x=copy(x1);
            %     %     x.indexArr=x.index;
            %     %     x.isNew=1;
            %     %     x1.isNew=1;
            %     % else
            %     %     x=x1;
            %     % end
            % 
            %     [varargout{1:nargout}]=x;
            % 
            %    return;
            % end
            % 
            % K=K+2;
            % [idxArr3,userProp3]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            % 
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 
            % if N>4 && N <= 6
            % 
            %     if numel(idxArr1)>1
            %         msg= ['__countries','(',char(string(idxArr1(1))),':',char(string(idxArr1(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr2)>1
            %         msg= ['__', char(userProp1),'(',char(string(idxArr2(1))),':',char(string(idxArr2(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            % 
            %     [strProps,objProps] = utils.splitproperties(obj);
            %     % obj.update(idxArr1);
            %     % obj.updateProperties(idxArr1,strProps,objProps);
            %     obj=obj.update(idxArr1,{strProps;objProps});
            %     % obj.get(idxArr1,[strProps,objProps]);
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1));
            %     % obj.(userProp1).update(idxArr2);
            %     % obj.(userProp1).updateProperties(idxArr2,strProps,objProps);
            %     obj.(userProp1)=obj.(userProp1).update(idxArr2,{strProps;objProps});
            % 
            %     %----------------------------------------------------------
            %     %----------------------------------------------------------
            %     if isstring(userProp3) || ischar(userProp3) && ismember(userProp3,["indexArr","tag","index"])
            %         [varargout{1:nargout}]=obj.(userProp1).(userProp2).(userProp3);
            %         return;
            %     end
            % 
            %     x1=obj.(userProp1).(userProp2).get(idxArr3,userProp3);
            % 
            %     %----------------------------------------------------------
            % 
            % 
            %     if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %         if nargout==1 % && isempty(userProp3)
            %             x=copy(x1);
            %             x.indexArr=x.index;
            %             x.isNew=1;
            %             x1.isNew=1;
            %         else
            %             x=x1;
            %             % x.index=x.indexArr;
            %         end
            %         if isempty(userProp3)
            %             x.index=x.indexArr;
            %         end
            %     else
            %         x=x1;
            %     end
            % 
            % 
            % 
            %     % if ~isstring(x2) && ~isstruct(x2) && ~isnumeric(x2) 
            %     %     if numel(idxArr3)==numel(x2.indexArr)
            %     %         x2.isNew=1;
            %     %     else
            %     %         x2.isNew=0;
            %     %     end
            %     % end
            %     % if nargout==1 && isempty(userProp3)
            %     %     x=copy(x2);
            %     %     x.indexArr=x.index;
            %     %     x.isNew=1;
            %     %     x2.isNew=1;
            %     % else
            %     %     x=x2;
            %     % end
            % 
            %     [varargout{1:nargout}]=x;
            % 
            %     return;
            % end
            % 
            % K=K+2;
            % [idxArr4,userProp4]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            % 
            % 
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 
            % if N>6 && N <= 8
            % 
            %     if numel(idxArr1)>1
            %         msg= ['__countries','(',char(string(idxArr1(1))),':',char(string(idxArr1(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr2)>1
            %         msg= ['__', char(userProp1),'(',char(string(idxArr2(1))),':',char(string(idxArr2(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr3)>1
            %         msg= ['__', char(userProp2),'(',char(string(idxArr3(1))),':',char(string(idxArr3(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            % 
            %     [strProps,objProps] = utils.splitproperties(obj);
            %     % if ismember("systems",userProp1) && ismember("policies",objProps)
            %     %     objProps(ismember(objProps,"policies"))=[];
            %     % end
            %     obj=obj.update(idxArr1,{strProps;objProps});
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1));
            %     obj.(userProp1).update(idxArr2,{strProps;objProps});
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1).(userProp2));
            %     obj.(userProp1).(userProp2).update(idxArr3,{strProps;objProps});
            % 
            %     %----------------------------------------------------------
            %     %----------------------------------------------------------
            %      if isstring(idxArr4) || ischar(idxArr4) && ismember(idxArr4,["indexArr","tag","index"])
            %         [varargout{1:nargout}]=obj.(userProp1).(userProp2).(userProp3).(idxArr4);
            %         return;
            %     end
            % 
            %     x1=obj.(userProp1).(userProp2).(userProp3).get(idxArr4,userProp4);
            % 
            %     %----------------------------------------------------------
            % 
            % 
            %     if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %         if nargout==1 % && isempty(userProp4)
            %             x=copy(x1);
            %             x.indexArr=x.index;
            %             x.isNew=1;
            %             x1.isNew=1;
            %         else
            %             x=x1;
            %             % x.index=x.indexArr;
            %         end
            %         if isempty(userProp4)
            %             x.index=x.indexArr;
            %         end
            %     else
            %         x=x1;
            %     end
            % 
            % 
            % 
            %     % if ~isstring(x2) && ~isstruct(x2) && ~isnumeric(x2) 
            %     %     if numel(idxArr4)==numel(x2.indexArr)
            %     %         x2.isNew=1;
            %     %     else
            %     %         x2.isNew=0;
            %     %     end
            %     % end
            %     % if nargout==1 && isempty(userProp4)
            %     %     x=copy(x2);
            %     %     x.indexArr=x.index;
            %     %     x.isNew=1;
            %     %     x2.isNew=1;
            %     % else
            %     %     x=x2;
            %     % end
            % 
            %     [varargout{1:nargout}]=x;
            % 
            %     return;
            % end
            % 
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 
            % K=K+2;
            % [idxArr5,userProp5]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));
            % 
            % if N>8 && N <= 10
            % 
            %     if numel(idxArr1)>1
            %         msg= ['__countries','(',char(string(idxArr1(1))),':',char(string(idxArr1(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr2)>1
            %         msg= ['__', char(userProp1),'(',char(string(idxArr2(1))),':',char(string(idxArr2(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr3)>1
            %         msg= ['__', char(userProp2),'(',char(string(idxArr3(1))),':',char(string(idxArr3(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            %     if numel(idxArr4)>1
            %         msg= ['__', char(userProp2),'(',char(string(idxArr4(1))),':',char(string(idxArr4(end))),')__'];
            %         error('ValueError: %s \nMultiple indexing is not supported in this case.',msg)
            %     end
            % 
            %     [strProps,objProps] = utils.splitproperties(obj);
            %     obj.update(idxArr1,{strProps;objProps});
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1));
            %     obj.(userProp1).update(idxArr2,{strProps;objProps});
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1).(userProp2));
            %     obj.(userProp1).(userProp2).update(idxArr3,{strProps;objProps});
            % 
            %     [strProps,objProps] = utils.splitproperties(obj.(userProp1).(userProp2).(userProp3));
            %     obj.(userProp1).(userProp2).(userProp3).update(idxArr4,{strProps;objProps});
            % 
            %     %----------------------------------------------------------
            %     %----------------------------------------------------------
            %      if isstring(idxArr5) || ischar(idxArr5) && ismember(idxArr5,["indexArr","tag","index"])
            %         [varargout{1:nargout}]=obj.(userProp1).(userProp2).(userProp3).(userProp4).(idxArr5);
            %         return;
            %     end
            % 
            %     x1=obj.(userProp1).(userProp2).(userProp3).(userProp4).get(idxArr5,userProp5);
            % 
            %     %----------------------------------------------------------
            % 
            %     if ~isstring(x1) && ~isstruct(x1) && ~isnumeric(x1) 
            %         if nargout==1 % && isempty(userProp5)
            %             x=copy(x1);
            %             x.indexArr=x.index;
            %             x.isNew=1;
            %             x1.isNew=1;
            %         else
            %             x=x1;
            %             % x.index=x.indexArr;
            %         end
            %         if isempty(userProp5)
            %             x.index=x.indexArr;
            %         end
            %     else
            %         x=x1;
            %     end
            % 
            %     [varargout{1:nargout}]=x;
            % 
            %     return;
            % end

        end

        function obj = parenAssign(obj,indexOp,varargin)

            % N=numel(indexOp);
            % K=1;
            % 
            % [idxArr1,userProp1]=obj.convertIndexOperator(indexOp(K:K+1-double((K+1)>N)));


            % N=numel(indexOp);
            % K=1;
            % [idxArr1,userProp1]=convertIndexOperator(obj,indexOp(K:K+1-double((K+1)>N)));

            % obj.index=idxArr1;

            % newObj=varargin{:};
            % props=properties(newObj);
            % for i=1:numel(props)
            %     obj.(props{i})=newObj.(props{i});
            % end


            % obj.parent.('countries')(idxArr1)=varargin{:};

            % if isempty(obj)
            %     obj = varargin{1};
            % end
            % if isscalar(indexOp)
            %     assert(nargin==3);
            %     rhs = varargin{1};
            %     [props, ~] = getProperties(obj);
            %     for p =1:numel(props)
            %         if isempty(rhs.([props{p}, '_List']))
            %             value="";
            %         else
            %             value=rhs.([props{p}, '_List']);
            %         end
            %         obj.([props{p}, '_List']).(indexOp) = value;
            %     end
            %     return;
            % end
            % [obj.([char(indexOp(2).Name), '_List'])(indexOp(1).Indices{:})] = varargin{:};

        end

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

            % idx = convertKeyToIndex(obj,indexOp);
            % if keyExists
            %     obj.countryNames(idx) = [];
            %     obj.countryList(idx) = [];
            % else
            %     error("Model:DeleteNonExistentKey",...
            %         "Unable to perform deletion. The key %s does not exist.",...
            %         indexOp(1).Indices{1});
            % end
        end

        function n = parenListLength(obj,indexOp,ict)
            n=1;
        end
    end

end
