function setParameter(obj, system, id, value)
            % setSysParInfo - Modify values of EUROMOD system-parameters.
            %
            % Syntax:
            %
            %   [X, ch] = setParameter(system, id, value)
            %
            % Input Arguments:
            %   system      :string or char. Name of the system. Must  
            %                be a valid EUROMOD system name.
            %   id          :string or char. The identifier of the Euromod
            %                model parameter.
            %   value       :string or char. The new value of the parameter.
            %
            % Oputput Arguments:
            %   X           : struct. Structure with modified parameter values.
            %   ch          : C# object. The Euromod model Country handler.
            %                 Can be passed as optional Input argument to
            %                 method "run".
            %
            % Example:
            %    id = "8c6835a7-5048-4624-aa91-520479b8fe7e";
            %    SysParInfo = GetSysParInfo('HR_2023', id);
            %    %
            %    System.setParameter('HR_2023', id, '2');
            %    info(System,"parameters" ,id)
            %
            % See also getSysParInfo, getInfo, getSysYearInfo, loadSystem, 
            % TaxSystem

            % arguments
            %     OBJ
            %     system {utils.MExcept.isCharOrStringAndIsSystem(OBJ,'', 'system',system)} % char or string. The Euromod model tax-system name.
            %     id {utils.MExcept.isCharOrString('id',id)} % char or string. The Euromod model parameter identifier.
            %     value {utils.MExcept.isCharOrString('value',value)} % string or char. The new value/expression of the parameter.
            % end




            % ss=mm.countries(2).systems(8).policies(9).functions(6).parameters(3)
            % a55dc157-e398-49bc-952d-7254c6d573f8
            % setParameter(ss, "BE_2012", "a55dc157-e398-49bc-952d-7254c6d573f8", "pppppppp")

            arguments
                obj
                system (1,1) string % char or string. The Euromod model parameter identifier.
                id (1,1) string
                value (1,1) string % string or char. The new value/expression of the parameter.
            end

            %- Get country info handler
            if isa(obj,'Country')
                cobj=obj;
            else
                cobj=obj.getParent("COUNTRY");
            end
            Idx=cobj.index;
            % mod=cobj.parent;
            % modelpath=mod.modelpath;
            % %- Modify value in system par for the IDENTIFIER
            % % ch = EM_XmlHandler.CountryInfoHandler(modelpath, cobj.name);
            % 
            % % %- display original
            % % v = ch.GetSysParInfo(system, id);
            % % vStr = ch.GetInfoInString(v);
            % % disp(vStr)
            % % 
            % % % set new value
            % % ch.SetSysParValue(system, id, value);
            % % 
            % % %- display change
            % % v = ch.GetSysParInfo(system, id);
            % % vStr = ch.GetInfoInString(v);
            % % disp(vStr)
            % 
            % % setParent(obj,ch);

            %- display original
            % v = cobj.Info(Idx).Handler.GetSysParInfo(system, id);
            % vStr = cobj.Info(Idx).Handler.GetInfoInString(v);
            % disp(vStr)

            % set new value
            cobj.Info(Idx).Handler.SetSysParValue(system, id, value);

            %- display change
            % v = cobj.Info(Idx).Handler.GetSysParInfo(system, id);
            % vStr = cobj.Info(Idx).Handler.GetInfoInString(v);
            % disp(vStr)
            
            % % t=copy(obj);
            % % count='';
            % % while ~strcmp(t.tag,"COUNTRY")
            % %     t=t.parent;
            % %     count=[count,'.parent'];
            % % end
            % % eval(['obj',count,'.Info(',char(num2str(Idx)),').Handler=cobj.Info(Idx).Handler;']);
            % 
            % % obj.index
            % % obj.indexArr
            % % [strProps,objProps]=utils.splitproperties(obj);
            % % t=copy(obj);
            % % tIdx=find(ismember(t(:).order))
            % % obj.updateProperties(3,strProps,objProps);




            % % eval(['obj',count,'.Info(',char(num2str(Idx)),').Handler'])


        end