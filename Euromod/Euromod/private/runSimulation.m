function x = runSimulation(countryInfoHandler, countryName, systemName, data, dataName, NameValueArgs)
% function run(OBJ, data, ID_DATASET, varargin)
% Run Simulate the EUROMOD tax-benefit system.
% If the simulation is successful, the results are stored in
% the Simulation class object as a dynamic property of the
% TaxSystem object. The names of the simulations are given
% iteratively as "Sim1", "Sim2",...
%
% Syntax:
%
%  run(data,ID_DATASET)
%  run(data,ID_DATASET,Name,Value)
%
% Input Arguments:
%  data             : table. Dataset used for the simulation.
%                     The table must have valid EUROMOD
%                     VariableNames.
%  ID_DATASET       : string or char. Name of the dataset.
%
% Optional Input Arguments:
%  constantsToOverwrite : cell. Euromod model constants to modify
% Must contain (nx2) arrays of cells, where
% rows are a string arrays with the Name and
% Group number or year of the constant and
% columns are the new values of type string.
% Default: []
% Example: {["$f_pens","2021"],'72.38175'; ...
%                ["$f_pens",""],'86.8581'};
%  inputDataString  : char or string. String variables that can
%                     be passed for HHoT-simulations.
%                     Default: [].
%  stringVars       : char or string. names of the string
%                     variables that can be passed for
%                     HHoT-simulations. Default: [].
%  surpressOtherOutput: bool. Boolean that indicates if you
%                     wish to surpress the Output of the of
%                     the existing defOutput. Default: false.
%  newOutput        : Default: [].

%  requestedQueries  : list. Default: [].
%
% See also renameSimulation, Euromod, Country, Simulation

% arguments
%     mdl
%     data table
%     ID_DATASET {utils.MExcept.isCharOrString('ID_DATASET',ID_DATASET)}
%     NameValueArgs.inputDataString {utils.MExcept.isCharOrStringDefDouble('inputDataString',NameValueArgs.inputDataString)} = []
%     NameValueArgs.stringVars {utils.MExcept.isCharOrStringDefDouble('stringVars',NameValueArgs.stringVars)} = []
%     NameValueArgs.surpressOtherOutput logical = false
%     NameValueArgs.newOutput double = []
%     NameValueArgs.constants {utils.MExcept.isConstantsToOverwrite(NameValueArgs.constants)} = []
%     NameValueArgs.requestedQueries {utils.MExcept.isCellDefDouble('requestedQueries',NameValueArgs.requestedQueries)} = []
%     NameValueArgs.useLogger logical = false
%     % NameValueArgs.countryInfoHandler {utils.MExcept.isCountryInfoHandler(NameValueArgs.countryInfoHandler)} = []
% end

arguments
    countryInfoHandler
    countryName (1,1) string
    systemName (1,1) string
    data (:,:) table
    dataName (1,1) string

    NameValueArgs.outputpath = []
    NameValueArgs.nowarnings = false
    NameValueArgs.euro = false
    NameValueArgs.public_components_only = false

    NameValueArgs.constantsToOverwrite = []
    NameValueArgs.verbose = true
    NameValueArgs.addons = []
    NameValueArgs.switches = []
    NameValueArgs.inputDataString = []
    NameValueArgs.stringVars = []
    NameValueArgs.surpressOtherOutput = false
    NameValueArgs.newOutput = []
    NameValueArgs.requestedQueries = []
    NameValueArgs.useLogger = false
end

configSettings = struct;
% cobj=obj.getParent("COUNTRY");
% Idx=cobj.index;
% mobj=obj.getParent("MODEL");

if ~strcmpi(countryName,string(countryInfoHandler.country))
    error('InputValueError: Wrong input arguments "countryInfoHandler" or "countryName".')
end

configSettings.COUNTRY = char(countryName);
configSettings.ID_SYSTEM = char(systemName);

mp=string(countryInfoHandler.path);
if contains(mp,'EM3Translation')
    modelpath=split(mp,'EM3Translation');
    modelpath=modelpath{1};
else
    modelpath=split(mp,'XMLParam');
    modelpath=modelpath{1};
end
configSettings.PATH_EUROMODFILES = modelpath;

% mdl = obj(iObj);
%- Add items to configSettings
% configSettings = struct;

% if isa(mdl,'System')
%     configSettings.COUNTRY = char(mdl.country);
%     configSettings.ID_SYSTEM = char(mdl.name);
%     configSettings.PATH_EUROMODFILES = char(mdl.modelpath);
% end

patharr = split(string(dataName),'\');
configSettings.(char(EM_XmlHandler.TAGS.CONFIG_ID_DATA)) = patharr{end};
if numel(patharr)>1
    configSettings.(char(EM_XmlHandler.TAGS.CONFIG_PATH_DATA)) = char(join(patharr(1:end-1),'\'));
else
    configSettings.(char(EM_XmlHandler.TAGS.CONFIG_PATH_DATA)) ='';
end
configSettings.(char(EM_XmlHandler.TAGS.CONFIG_PATH_OUTPUT)) = '';


count=0;
if ~isempty(NameValueArgs.switches)
    NameValueArgs.switches = string(NameValueArgs.switches);
    for i=1:2:numel(NameValueArgs.switches)
        count=count+1;
        switchesfield = [char(EM_XmlHandler.TAGS.CONFIG_EXTENSION_SWITCH), num2str(count)];
        try
            if strcmp(NameValueArgs.switches(i+1),"true"),status = 'on'; else, status = 'off'; end
            configSettings.(switchesfield) = [char(NameValueArgs.switches(i)), '=',  status];
        catch MEx
            if contains(MEx.message,["No appropriate method, property, or field", switchesfield," for class 'System.Collections.Generic.Dictionary<System*String,System*String>'"])
                error('Parameter "switches" must be NameValue pair arguments (Example: addons=["BTA","on","TCA","off"]).')
            else
                throw(MEx)
            end
        end
    end
end

count=0;
if ~isempty(NameValueArgs.addons)
    NameValueArgs.addons = string(NameValueArgs.addons);
    for i=1:2:numel(NameValueArgs.addons)
        count=count+1;
        addonfield = [char(EM_XmlHandler.TAGS.CONFIG_ADDON), num2str(count)];
        try
            configSettings.(addonfield) = [char(NameValueArgs.addons(i)), '|',  char(NameValueArgs.addons(i+1))];
        catch MEx
            if contains(MEx.message,["No appropriate method, property, or field", addonfield," for class 'System.Collections.Generic.Dictionary<System*String,System*String>'"])
                error('Parameter "addons" must be NameValue pair arguments (Example: addons=["LMA","LMA_PL","MTR","MTR_PL"]).')
            else
                throw(MEx)
            end
        end
    end
end

%%% get Csharp objects
% data = readtable(ID_DATASET);
dataArr = getDataArray(data);
configSettingsArr = getConfigsettings(configSettings);
variables = getVariables(data.Properties.VariableNames);
constantsArr = getConstantsToOverwrite(NameValueArgs.constantsToOverwrite);

%- run simulation
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Executable));
Control = EM_Executable.Control;
try
    ts = tic;
    out= Control.RunFromPython(configSettingsArr, dataArr, variables, NameValueArgs.inputDataString,...
        NameValueArgs.stringVars, NameValueArgs.surpressOtherOutput, NameValueArgs.newOutput, constantsArr,...
        NameValueArgs.requestedQueries, NameValueArgs.useLogger, countryInfoHandler);
    tf = toc(ts);

catch ME
    if contains(ME.message, 'with matching signature found')
        baseException = MException('MATLAB:incorrectType',...
            [errID, ': Invalid input argument.', ' Please, check that all the Input arguments are correctly specified.']);
        throw(baseException);
    else
        % errorStruct
        throw(ME);
    end
end

if out.Item1
    if ~isempty(NameValueArgs.constantsToOverwrite)
        configSettings.constantsToOverwrite=NameValueArgs.constantsToOverwrite;
    end
    x = Simulation(out, configSettings);
    fprintf("\nSimulation %s, system %s, data %s, country %s finished.\n", ...
        x.output_filenames, configSettings.ID_SYSTEM,configSettings.ID_DATASET, configSettings.COUNTRY)
else
    % header = ['> In ',matlab.mixin.CustomDisplay.getClassNameForHeader(obj)];
    error('\nNo output was produced from simulation of system %s, dataset %s, country %s.\n',configSettings.ID_SYSTEM,configSettings.ID_DATASET,configSettings.COUNTRY)
end

% % get warnings/errors
% Enumerator=out.Item4.GetEnumerator;
% errStr = '';
% warnStr = '';
% while Enumerator.MoveNext
%     if Enumerator.Current.isWarning
%         warnStr = sprintf('%s\nWarningId: %s\n%s',warnStr,Enumerator.Current.runTimeErrorId, Enumerator.Current.message);
%
%     else
%         errStr = sprintf('%sErrorId: %s\n%s',errStr,Enumerator.Current.runTimeErrorId, Enumerator.Current.message);
%
%     end
% end
%
% % return output
% if  ~out.Item1
%     if ~isempty(warnStr)
%         warning(warnStr)
%     end
%     if ~isempty(errStr)
%         error(errStr)
%     end
% else
%     if ~isempty(warnStr)
%         warning(warnStr)
%         configSettings.warnings = warnStr;
%     end
%
%     sim = Simulation(out, configSettings);
%
%     fprintf("\nSimulation %s, System %s, Data %s   .. %.2d sec!   \n", ...
%         sim.name, configSettings.ID_SYSTEM,configSettings.ID_DATASET, round(tf,2))
%
% end


end