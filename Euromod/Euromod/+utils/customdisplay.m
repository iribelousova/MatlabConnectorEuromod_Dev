classdef customdisplay < matlab.mixin.CustomDisplay & handle
    methods (Hidden, Sealed, Access = protected)

        function header = getHeader(obj)
            % callerIsBaseWorkspace = length(dbstack) == 1;
            % if callerIsBaseWorkspace && obj.isNew
            %     obj.index=obj.indexArr;
            % end
            % sprintf('"%s"',strjoin(string(obj.index),'","'))
            % obj.update(1);
            % if isa(obj,'Model')
            %     header = obj;
            %     return;
            % end
            % if isa(obj,'Simulation')
            %     header = obj;
            %     return;
            % end

            N=size(obj,1);
            if N>1 && ~isa(obj,'Simulation') && ~isa(obj,'Model') % || N==1 && numel(obj.indexArr)==1
                % if isa(obj,'Country') || isa(obj,'DatasetInSystem') ||...
                %         isa(obj,'Extension') || isa(obj,'ExtensionSwitch') ||...
                %         isa(obj,'Function') || isa(obj,'FunctionInSystem') || ...
                %         isa(obj,'LocalExtension') || isa(obj,'ParameterInSystem') ||...
                %         isa(obj,'Policy') || isa(obj,'ReferencePolicy') ||...
                %         isa(obj,'System') 
                % 
                %     comm=obj.headerComment();
                % 
                % else
                %     % % Dataset, parameter, PolicyInSystem, System
                %     % [v,k]=obj.getOtherProperties({'name','comment'},1:N);
                %     % nams=v(ismember(k,'name'),:)';
                %     % coms=v(ismember(k,'comment'),:)';
                %     % if size(coms,2)==N
                %     %     coms=coms';
                %     % end
                %     % comm=[nams,coms];
                %     % % coms(ismember(coms,""))=[];
                %     % 
                %     % if isa(obj,'DatasetInSystem')
                %     %     [bm,k]=obj.getOtherProperties('bestMatch',1:N);
                %     %     % bm= obj(:).bestMatch';
                %     %     % coms(strcmp(coms,"no"))="";
                %     %     coms(strcmp(bm,"yes"))="best match";
                %     % end
                % end

                comm=obj.headerComment();

                header = obj.appendComment(comm);
                % idx=1:numel(nams);
                % idx=string(num2str(idx'));
                % if size(nams,2)==N
                %     nams=nams';
                % end
                % header = append(idx,': ',nams);
                % if ~isempty(coms) && ~all(strcmp("",coms))
                %     coms=arrayfun(@(t) char(EM_XmlHandler.XmlHelpers.RemoveCData(t)),coms,'UniformOutput',false);
                %     coms=string(coms);
                %     bk = arrayfun(@(t) numel(char(t)),header);
                %     bk=string(arrayfun(@(t) blanks(t), max(bk)-bk+1,'UniformOutput',false));
                %     header = append(header, bk, '| ',coms);
                % end
                % 
                % dimStr=matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
                % headerStr = [dimStr, ' ', matlab.mixin.CustomDisplay.getClassNameForHeader(obj), ' array:'];
                % headerStr = string(headerStr);
                % header=[headerStr;header];
                % header = sprintf('%s\n',header);
            else
                dimStr=matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
                header = [dimStr, ' ', matlab.mixin.CustomDisplay.getClassNameForHeader(obj), ' with properties:'];
                header = string(header);
                header = sprintf('%s\n',header);
            end
        end

        %------------------------------------------------------------------

        function propgrp = getPropertyGroups(obj)
            % callerIsBaseWorkspace = length(dbstack) == 1;
            % if callerIsBaseWorkspace && obj.isNew
            %     obj.index=obj.indexArr;
            % end
            if numel(obj.index)>1
                propgrp='';
            else
                % [~,objProps]=utils.splitproperties(obj);
                % for i=1:numel(objProps)
                %     obj.(objProps(i)).index=obj.(objProps(i)).indexArr;
                % end
                
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
                % if isfield(propgrp.PropertyList,propName)
                %     N=size(propgrp.PropertyList.(propName),1);
                %     if N<=maxDisp && N>0
                %         namNum='%s';
                %         for i=2:N
                %             namNum=[namNum,', %s'];
                %         end
                %         propgrp.PropertyList.(propName)=string(sprintf(namNum,propgrp.PropertyList.(propName)(1:end).name'));
                %     end
                % end
            end

            % obj.isNew=1;
        end

        function propgrp=customExtensionDisplay(obj,propgrp,propName,maxDisp)
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

        function propgrp=customPropertyDisplay(obj,propgrp,propName,maxDisp)
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

        % function displayNonScalarObject(obj)
        %     for i=1:numel(obj)
        %         disp(get_header(obj(i)))
        %         disp(get_footer(obj(i)))
        %     end
        % end

        function footer = getFooter(obj)

            footer='';
            if isa(obj,'Simulation')
                if numel(obj)>10
                    
                    % dimStr = matlab.mixin.CustomDisplay.convertDimensionsToString(mdl);
                    % cName = matlab.mixin.CustomDisplay.getClassNameForHeader(mdl);
                    % headerStr = [dimStr,' ',cName,' array with properties:'];
                    % disp(header)
                else
                    for iObj = 1 %:numel(obj)
                        mdl=obj(iObj);
        
                        % propnam = cellstr(properties(mdl));
                        % propgrp = matlab.mixin.util.PropertyGroup(propnam);
                        % matlab.mixin.CustomDisplay.displayPropertyGroups(mdl,propgrp);
                        
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
                        % disp(mdl.settings)
                    end
                end                
            end


        end
    end

end

