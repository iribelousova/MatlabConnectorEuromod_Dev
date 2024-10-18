classdef (ConstructOnLoad)  Simulation < utils.customdisplay
    %SIMULATION class stores the results from a simulation run of the
    % microsimulation model EUROMOD.
    %
    % A Simulation object is created after a successful simulation run of a
    % tax-benefit EUROMOD system. It contains tables with output results,
    % configuration settings and other simulation-specific options.
    %  
    % NOTE: the Simulation is the base class for Euromod Connector. It is
    % preferred to create instances of its subclass Euromod, instead of
    % using the TaxSystem constructor directly.
    %
    % Simulation properties:
    % name     - name of the simulation.
    % output   - tables with simmulation results. 
    % settings - structure containing simulation configuration information.
    % 
    % Simulation methods:
    % Simulation - create a Simulation object.
    %
    % See also EUROMOD, COUNTRY, TAXSYSTEM

    properties (Hidden)
        indexArr =1
        index =1
        isNew=0
    end

    properties 
        %name     string specifying the name of the object. 
        % name
    end

    properties (SetAccess=private)
        %output   cell array with result tables from successful simulations.
        %settings structure with simulation configuration information.
        outputs
        settings struct
        output_filenames (:,1) string
        errors (:,1) string
    end

    %======================================================================
    % PUBLIC METHODS
    %======================================================================
    methods
        function S = Simulation(obj, settings)
            %SIMULATION construct a Simulation object
            %
            % S = Simulation(obj, settings) creates a Simulation object
            % after a successful simulation run of a EUROMOD tax-benefit
            % system. Stores the output results in a cell array of tables
            % configuration settings, and other simulation options.
            %
            % Input Arguments:
            % obj       - C# dictionary. Output from the simulation run.
            % settings  - struct. Simulation configuration and other options.
            %
            % See also EUROMOD/EUROMOD, COUNTRY/COUNTRY, TAXSYSTEM/TAXSYSTEM

            % arguments
            %     obj
            %     settings struct 
            % end

            if nargin == 0
                return
            end

            % get csharp errors
            errEnum = obj.Item4().GetEnumerator;
            errorsArr = strings( obj.Item4().Count,1);

            % % check error messages
            % count = 1;
            % idx = 1;
            % while count
            %     count=errEnum.MoveNext;
            %     if ~isempty(errEnum.Current)
            %         errEnum_ = errEnum.Current;
            %         errID = char(errEnum_.runTimeErrorId);
            %         errMess = char(errEnum_.message);
            %         if errEnum_.isWarning
            %             errStr='WarningId';
            %         else
            %             errStr='ErrorId';
            %         end
            %         errStr = sprintf('%s: %s\n%s',errStr,errID, errMess);
            %         errorsArr(idx)=errStr;
            %     end
            % end



            % get csharp simulation names (input dataset names)
            keysNet=obj.Item2().Keys;
            keysEnum = keysNet.GetEnumerator;

            % get csharp variables names
            varsNet = obj.Item3().Values;
            varsEnum = varsNet.GetEnumerator;

            % get csharp data (input dataset names)
            outNet = obj.Item2().Values;
            outEnum = outNet.GetEnumerator;

            % Initialize 
            outputsArr = cell(obj.Item2().Count,1);
            output_filenamesArr = strings( obj.Item2().Count,1);

            count = 1;
            idx = 1;
            while count
                count = keysEnum.MoveNext;

                % get current simulation results
                if count

                    % get simulation name
                    key = char(keysEnum.Current);

                    % set names of variables
                    varsEnum.MoveNext;
                    outputvars = varsEnum.Current;
                    outputvars = cell(outputvars.ToArray);

                    % set simulation result
                    outEnum.MoveNext;
                    df_temp = outEnum.Current;
                    df_temp = df_temp.double;
                    outputsArr{idx} = array2table(df_temp, "VariableNames",outputvars);
                    outputsArr{idx}.Properties.Description = key;

                    % set output file names
                    key_=split(key,'.');
                    key_=string(key_{1});
                    output_filenamesArr(idx)=key_;

                    % set errors
                    errEnum.MoveNext;
                    if ~isempty(errEnum.Current)
                        errEnum_ = errEnum.Current;
                        errID = char(errEnum_.runTimeErrorId);
                        errMess = char(errEnum_.message);
                        if errEnum_.isWarning
                            errStr='WarningId';
                        else
                            errStr='ErrorId';
                        end
                        errStr = sprintf('%s %s\n%s',errStr,errID, errMess);
                        errorsArr(idx)=errStr;

                        warning([errStr,' \n> Simulation %s, system %s, dataset %s, country %s.'],key_,settings.ID_SYSTEM,settings.ID_DATASET,settings.COUNTRY)
                    end

                    idx = idx +1;
                end
            end

            % fprintf("\nSimulation %s, System %s, Data %s   .. %.2d sec!   \n", ...
            %     output_filenamesArr, settings.ID_SYSTEM,settings.ID_DATASET)

            % c = utils.class_counter(false);
            % S.name = ['Sim' num2str(c)];
            S.outputs = outputsArr;
            S.settings = settings;
            S.errors = errorsArr;
            S.output_filenames = output_filenamesArr;
        end
    end

    %======================================================================
    methods (Access = protected, Hidden, Sealed)

        % function header = getHeader(S)
        %     % header = utils.CustomDisplay.get_header(S);
        %     header = '';
        %     % for i= numel(S)
        %     %     header = utils.CustomDisplay.get_header(S(i));
        %     % end
        % 
        %     % if ~isscalar(S)
        %     %     header = getHeader@matlab.mixin.CustomDisplay(S);
        %     % else
        %     %     headerStr = matlab.mixin.CustomDisplay.getClassNameForHeader(S);
        %     %     headerStr = [headerStr,' Info'];
        %     %     header = sprintf('%s\n',headerStr);
        %     % end
        % end
        %------------------------------------------------------------------
        % function footer = getFooter(S)
        % 
        %     if numel(S)>10
        %         dimStr = matlab.mixin.CustomDisplay.convertDimensionsToString(mdl);
        %         cName = matlab.mixin.CustomDisplay.getClassNameForHeader(mdl);
        %         headerStr = [dimStr,' ',cName,' array with properties:'];
        %         disp(headerStr)
        %         propnam = cellstr(properties(S(i)));
        %         propgrp = matlab.mixin.util.PropertyGroup(propnam);
        %         disp(propgrp)
        %     else
        %         for i= 1:numel(S)
        %             headerStr = matlab.mixin.CustomDisplay.getClassNameForHeader(S);
        %             headerStr = [headerStr,' with properties'];
        %             disp(headerStr)
        %             propnam = cellstr(properties(S(i)));
        %                 propgrp = matlab.mixin.util.PropertyGroup(propnam);
        %                 matlab.mixin.CustomDisplay.displayPropertyGroups(S(i),propgrp);
        %         footer = utils.CustomDisplay.get_footer(S(i));
        %         end
        %     end
        % 
        %     % keys = fieldnames(S.settings);
        %     % footerStr = cell(length(keys),1);
        %     % for i = 1:length(keys)
        %     %     key = keys{i};
        %     %     if ~isempty(S.settings.(key))
        %     % 
        %     %         if strcmp(key, 'constants')
        %     %             temp = cellfun(@(x,y) ([x, string(y)]),...
        %     %                 S.constants(:,1), ...
        %     %                 S.constants(:,2), 'UniformOutput', false);
        %     %             temp = cellfun(@(x) (['   ', char(x(1)), ' ', char(x(2)), ' = ', char(x(3))]), temp, 'UniformOutput', false);
        %     % 
        %     %             footerStr{i,1} = 'constants:';
        %     %             footerStr = [footerStr; temp];
        %     %         else
        %     %             footerStr{i,1} = [key, ': ',char(S.settings.(key))];
        %     %         end
        %     % 
        %     %     end
        %     % end
        %     % 
        %     % for i = 1:length(S.output)
        %     %     out = S.output{i}(1:6,1:10);
        %     %     titles = @(x) fprintf('%10s %10s %10s %10s %11s %10s %14s %5s %5s %5s\n', x);
        %     %     values = @(x) fprintf('%10d %9d %10d %8d %12d %10d %13d %8d %4d %5d\n',x);
        %     %     fprintf('output %d : [%dx%d table]\n', i, size(S.output{i},1), size(S.output{i},2));
        %     %     titles(string(out.Properties.VariableNames'));
        %     %     values(out.Variables');
        %     %     fprintf('%9s', '...')
        %     % end
        %     % 
        %     % fprintf(1, '\n')
        %     % footer = fprintf(1, '%s\n',footerStr{:});
        %     % fprintf(1, '\n')
        % 
        % end
    end % end Private methods

end