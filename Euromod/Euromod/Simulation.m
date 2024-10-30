classdef (ConstructOnLoad)  Simulation < utils.customdisplay
    % Simulation - Class storing the EUROMOD simulation results.
    %
    % Syntax:
    %
    %     S = Simulation();
    %
    % Description:
    %     This is a class containing the results from the simulation run()
    %     method and other configuration information.
    %
    %     This class is returned by the method run() and should not be used by
    %     the user as a stand-alone tool.
    %
    %  Simulation Properties:
    %     outputs          - A cell array with the table-type simulation results.
    %     settings         - The user-defined settings (i.e. addons, constantsToOverwrite, extensions,..).
    %     output_filenames - File-names of simulation output.
    %     errors           - Errors and warnings from the simulation run.
    %
    %  Example:
    %     % Load the Euromod model and the data:
    %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
    %     ID_DATASET = "SE_2021_b1.txt";
    %     data = readtable(ID_DATASET);
    %     % Run the default simulation on system "SE_2021":
    %     sim=mod.countries('SE').systems('SE_2021').run(data,ID_DATASET)
    %
    % See also Model, Country, System, info, run.

    properties (Constant,Hidden)
        indexArr =1
    end

    properties (Hidden)
        index =1
    end

    properties (SetAccess=private)
        outputs (1,:) cell % A cell array with the table-type simulation results.
        settings struct % The user-defined settings (i.e. addons, constantsToOverwrite, extensions,..).
        output_filenames (1,:) string % File-names of simulation output.
        errors (:,1) string % Errors and warnings from the simulation run.
    end

    %======================================================================
    methods (Static, Sealed, Hidden)
        function S = load(S, obj, settings)
            % load - Load simulation results in the class.
            %
            % Syntax:
            %
            %     S = load(obj, settings);
            %
            % Description:
            %     Returns the Simulation class populated with simulation
            %     output from run().
            %
            % load Input Arguments:
            %     obj      - A c# object returned from the simulation.
            %     settings - A struct with the simulation configuration settings.
            % 
            % load Output Arguments:
            %     S        - Simulation class.
            %
            %  Example:
            %     % Load the Euromod model and the data:
            %     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
            %     ID_DATASET = "SE_2021_b1.txt";
            %     data = readtable(ID_DATASET);
            %     % Run the default simulation on system "SE_2021":
            %     sim=mod.countries('SE').systems('SE_2021').run(data,ID_DATASET)
            %
            % See also Model, Country, System, info, run.

            if nargin == 0
                return
            end

            % get csharp errors
            errEnum = obj.Item4().GetEnumerator;
            errorsArr = strings( obj.Item4().Count,1);

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

            % get keys
            idx = 1;
            while keysEnum.MoveNext

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

                idx = idx +1;
            end

            % get errors
            idx=1;
            while errEnum.MoveNext
                if ~isempty(errEnum.Current)
                    errEnum_ = errEnum.Current;
                    errID = char(errEnum_.runTimeErrorId);
                    errMess = char(errEnum_.message);
                    if errEnum_.isWarning
                        errStr='WarningId';
                    else
                        errStr='ErrorId';
                    end
                    if isempty(errID)
                        errStr='';
                    end
                    errStr = sprintf('%s: %s\n%s\n',errStr,errID, errMess);
                    errorsArr(idx)=errStr;
                    idx=idx+1;

                    % warning([errStr,' \n> Simulation %s, system %s, dataset %s, country %s.\n'],key_,settings.ID_SYSTEM,settings.ID_DATASET,settings.COUNTRY)
                end
            end
            if idx>1
                warning(sprintf('%s',errorsArr))
            end

            S.outputs = outputsArr;
            S.settings = settings;
            S.errors = errorsArr;
            S.output_filenames = output_filenamesArr;
        end
    end
    % methods (Static, Access = public,Hidden=true)
    %     %==================================================================
    %     function varargout = size(obj,varargin)
    %         [varargout{1:nargout}] = size(obj.index,varargin{:});
    %     end
    %     %==================================================================
    %     function varargout = ndims(obj,varargin)
    %         [varargout{1:nargout}] = ndims(obj.index,varargin{:});
    %     end
    %     %==================================================================
    %     function ind = end(obj,m,n)
    %         S = numel(obj.indexArr);
    %         if m < n
    %             ind = S(m);
    %         else
    %             ind = prod(S(m:end));
    %         end
    %     end
    % end
end