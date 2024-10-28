classdef customdisplay < matlab.mixin.CustomDisplay & handle
    % customdisplay - Superclass of the Core class.
    %
    % Description:
    %     This superclass is used in all the main Euromod Connector
    %     classes. It contains functions that are common to these
    %     subclasses.
    %
    %  Country Properties:
    %     appendComment            - Create a uniform string array of 
    %                                comments.
    %     commentElement           - Create a uniform comment row appending
    %                                header to comment.
    %     customExtensionDisplay   - Customize the display of the 
    %                                Extension class array.
    %     customPropertyDisplay    - Customize the display of specific
    %                                property of a class.
    %     getHeader                - Matlab built-in function customizing 
    %                                the display of the header of a class.
    %     getFooter                - Matlab built-in function customizing
    %                                the display of the footer of a class.
    %     getPropertyGroups        - Matlab built-in function retrieving 
    %                                the class specific properties for 
    %                                custom display.
    %     headerComment_Type1      - Create header comment for classes.
    %     headerComment_Type2      - Create header comments for classes
    %                                that display the extension switches.
    %
    % See also Model, Country, System, Policy, Dataset, Extension.

    methods (Static,Sealed,Access=protected,Hidden)
        %==================================================================
        function header=commentElement(header,coms)
            % commentElement - Create a uniform comment row appending
            % header to comment.

            NrBlanks=1;
            if ~isempty(coms) && ~all(strcmp("",coms))
                coms=arrayfun(@(t) char(EM_XmlHandler.XmlHelpers.RemoveCData(t)),coms,'UniformOutput',false);
                coms=string(coms);
                bk = arrayfun(@(t) numel(char(t)),header);
                bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+NrBlanks,'UniformOutput',false));
                header = append(header, bk, '| ',coms);
            end
        end
    end
    methods (Sealed,Access=protected,Hidden)
        %==================================================================
        function header = appendComment(obj,COMM)
            % appendComment - Create a uniform string array of comments.
            %
            % Description:
            %   This function is used to create the header of a class
            %   array.
            %
            % Input Arguments:
            %   COMM -(N,M) string. First column is string of names. Second
            %         column is string of middle comments. Third column is
            %         string of last comments.

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
        %==================================================================
        function propgrp=customExtensionDisplay(obj,propgrp,propName,maxDisp)
            % customExtensionDisplay - Customize the display of the
            % Extension class array.

            if isfield(propgrp.PropertyList,propName)
                
                N=size(propgrp.PropertyList.(propName),1);
                if N<=maxDisp && N>0
                    BaseOff=obj.(propName)(1:end).baseOff;
                    BaseOff(ismember(BaseOff,"true"))="off";
                    BaseOff(ismember(BaseOff,"false"))="on";
                    Name=propgrp.PropertyList.(propName)(1:end).name';
                    fullName=strings(1,2*numel(Name));
                    fullName(1:2:end)=Name';
                    fullName(2:2:end)=BaseOff';
                    namNum='%s: %s';
                    for i=2:N
                        namNum=[namNum,', %s: %s'];
                    end
                    propgrp.PropertyList.(propName)=string(sprintf(namNum,fullName));
                end
            end
        end
        %==================================================================
        function propgrp=customPropertyDisplay(obj,propgrp,propName,maxDisp)
            % customPropertyDisplay - Customize the display of specific
            % property of a class.
            if isfield(propgrp.PropertyList,propName)
                N=size(propgrp.PropertyList.(propName),1);
                if N<=maxDisp && N>0
                    namNum='%s';
                    for i=2:N
                        namNum=[namNum,', %s'];
                    end
                    propgrp.PropertyList.(propName)=string(sprintf(namNum,propgrp.PropertyList.(propName)(1:end).name'));
                end
            end
        end
        %==================================================================
        function header = getHeader(obj)
            % getHeader - Matlab built-in function customizing the display 
            % of the header of a class.

            N=size(obj,1);
            if N>1 && ~isa(obj,'Simulation') && ~isa(obj,'Model') 
                comm=obj.headerComment();
                header = obj.appendComment(comm);
            else
                dimStr=matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
                header = [dimStr, ' ', matlab.mixin.CustomDisplay.getClassNameForHeader(obj), ' with properties:'];
                header = string(header);
                header = sprintf('%s\n',header);
            end
        end
        %==================================================================
        function footer = getFooter(obj)
            % getFooter - Matlab built-in function customizing the display 
            % of the footer of a class.
            % 
            % This function is used for the Simulation class only.
            
            footer='';
            if isa(obj,'Simulation')
                if numel(obj)>10
                else
                    for iObj = 1
                        mdl=obj(iObj);                        
                        N=length(mdl.outputs)*(length(mdl.outputs)<=2)+2*(length(mdl.outputs)>2);
                        for i = 1:N
                            out = mdl.outputs{i}(1:6,1:10);
                            titles = @(x) fprintf('%10s %10s %10s %10s %11s %10s %14s %5s %5s %5s\n', x);
                            values = @(x) fprintf('%10d %9d %10d %8d %12d %10d %13d %8d %4d %5d\n',x);
                            fprintf('output %d : [%dx%d table]\n', i, size(mdl.outputs{i},1), size(mdl.outputs{i},2));
                            titles(string(out.Properties.VariableNames'));
                            values(out.Variables');
                            fprintf('%9s', '...')
                            fprintf(1, '\n')
                        end
                        fprintf(1, '\n')
                    end
                end                
            end


        end
        %==================================================================
        function propgrp = getPropertyGroups(obj)
            % getPropertyGroups - Matlab built-in function retrieving the 
            % class specific properties for custom display.
            
            if numel(obj.index)>1
                propgrp='';
            else                
                propgrp = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                maxDisp=7;
                propName="parameters";
                propgrp=obj.customPropertyDisplay(propgrp,propName,maxDisp);
                propName="functions";
                propgrp=obj.customPropertyDisplay(propgrp,propName,maxDisp);
                propName="policies";
                propgrp=obj.customPropertyDisplay(propgrp,propName,maxDisp);
                propName="datasets";
                propgrp=obj.customPropertyDisplay(propgrp,propName,maxDisp);
                propName="bestmatchDatasets";
                propgrp=obj.customPropertyDisplay(propgrp,propName,maxDisp);
                maxDisp=2;
                propName="extensions";
                propgrp=obj.customExtensionDisplay(propgrp,propName,maxDisp);
            end
            obj.index=obj.indexArr;
        end
        %==================================================================
        function x=headerComment_Type1(obj,varargin)
            % headerComment_Type1 - Create header comment for classes.

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
        function x=headerComment_Type2(obj)
            % headerComment_Type2 - Create the header comments for classes
            % that show the extension switches.

            N=size(obj,1);

            % get index of reference policies
            idxRefPol=obj.index>obj.Info.Handler.Count;

            temp=copy(obj);
            temp.index=temp.indexArr;
            if contains(class(obj),'InSystem')
            [ss,keys]=temp.getOtherProperties(["name","comment","Switch"],temp.index);
            else
                [ss,keys]=temp.getOtherProperties(["name","comment"],temp.index);
            end
            % ss=temp(1:end,["name","comment","Switch","extensions"]);
            names=ss(ismember(keys,'name'),:)';
            if any(ismember(keys,'comment') )
                comments=ss(ismember(keys,'comment'),:)';
            else
                comments=strings(N,1);
            end
            if any(ismember(keys,'Switch')) 
                namesSwitch=ss(ismember(keys,'Switch'),:)';
            else
                namesSwitch=strings(N,1);
            end

            %%%............................................................
            %%% GET POLICIES EXTENSIONS FOR PRINTING
            % get tags
            eTAG=char(EM_XmlHandler.TAGS.EXTENSION);
            if strcmp(class(obj),'Policy') || strcmp(class(obj),'ReferencePolicy') || strcmp(class(obj),'PolicyInSystem')
                objTag=Policy.tag;
            else
                objTag=obj.tag;
            end
            t=[char(eTAG),'_',char(objTag)];
            x = char(EM_XmlHandler.TAGS.(t));
            pTAG=EM_XmlHandler.ReadCountryOptions.(x);
            if contains(class(obj),'InSystem')
                tagID=[char(lower(objTag)),'ID'];
            else
                tagID='ID';
            end

            % get IDs
            pIDs=obj(1:end).(tagID);
            pIDs=pIDs.(tagID)';
            cobj=copy(obj);
            while ~strcmp(cobj.tag,"COUNTRY")
                cobj=cobj.parent;
            end
            Idx=cobj.index;
            eInfo=cobj.extensions(1:end,{'ID','shortName'});
            eIDs=eInfo.ID';
            eNames=eInfo.shortName';

            tic
            posRefPol=find(idxRefPol);
            
            Ne=numel(eIDs);
            Np=numel(pIDs);
            namesExt=cell(Np,1);
            for i=1:Np
                if ~ismember(i,posRefPol)
                    pID=char(pIDs(i));
                    for j=1:Ne
                        eID=char(eIDs(j));
                        ID_=[pID,eID];
                        x=cobj.Info(Idx).Handler.GetPieceOfInfo(pTAG,ID_);
                        count_=0;
                        if x.Count>0
                            count_=count_+1;
                            if count_<=3
                                namesExt{i,1}= strjoin([namesExt{i,1},eNames(j)],', ');
                            elseif count_==4
                                namesExt{i,1}= strjoin(namesExt{i,1},'...');
                            elseif count_>4
                                continue;
                            end
                        end
                    end
                    if isempty(namesExt{i,1})
                        namesExt{i,1}='';
                    else
                        namesExt{i,1}=['(with switch set for ',char(namesExt{i,1}),')'];
                    end
                else
                    namesExt{i,1}='';
                end
            end
            namesExt=string(namesExt);
            %%%............................................................

            % 
            % 
            % 
            % tic
            % ss=obj(1:end,'extensions');
            % toc
            % 

            % namesExt=strings(numel(ss.extensions),1);
            % posRefPol=find(idxRefPol);
            % for jj=1:N
            %     if ~isempty(ss.extensions{jj}) && ~ismember(jj,posRefPol)
            %         namesExtJoin=strjoin(ss.extensions{jj}(1:end).shortName',',');
            %         namesExt(jj)=sprintf('(with switch set for %s)',namesExtJoin);
            %     end
            % end

            if any(idxRefPol)
                comments(idxRefPol)="";
            end

            if any(idxRefPol) && strcmp(class(obj),'Policy') ||...
                    any(idxRefPol) && strcmp(class(obj),'ReferencePolicy')
                namesExt(idxRefPol)="Reference policy";
            end

            middlecom=append(namesSwitch,' ', namesExt);
            if all(strcmp(middlecom," "))
                x=[names,comments];
            else
                x=[names,middlecom,comments];
            end
        end
    end

end

