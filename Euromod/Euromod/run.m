function out = run(obj, varargin)

% data (pandas.DataFrame) – input dataframe passed to the EUROMOD model.
%
% dataset_id (str) – ID of the dataset.
%
% constantsToOverwrite (dict [ tuple [ str, str ], str ], optional) – A dict with constants to overwrite. Note that the key is a tuple of two strings, for which the first element is the name of the constant and the second is the groupnumber. Note that the values must be defined as strings. Default is None.
%
% verbose (bool, optional) – If True then information on the output will be printed. Default is True.
%
% outputpath (str, optional) – When the output path is provided, there will be anoutput file generated. Default is “”.
%
% addons (list [ tuple [ str, str ]], optional) – List of tuples with addons to be integrated in the spine. The first element of the tuple is the name of the addon and the second element is the name of the system in the Addon to be integrated. Default is [].
%
% switches (list [ tuple [ str, bool ]], optional) – List of tuples with extensions to be switched on or of. The first element of the tuple is the short name of the extension. The second element is a boolean Default is [].
%
% nowarnings (bool, optional) – If True, the warning messages resulting from the simulations will be suppressed. Default is False.
%
% euro (bool, optional) – If True, the monetary variables will be converted to euro for the simulation. Default value is False.
%
% public_compoments_only (bool, optional) – If True, the the model will be on with only the public compoments. Default value is False.
%
% Raises:
% Exception – Exception when simulation does not finish succesfully, i.e. without errors.
%
% Returns:
% A class containing simulation output and error messages.
%
% Return type:
% Simulation

% arguments
%     obj
%     data table
%     data_id string
%     NameValueArgs.constantsToOverwrite cell = {} %[]
%     NameValueArgs.verbose logical = true
%     NameValueArgs.outputpath string = "" % []
%     NameValueArgs.addons string = [] % []
%     NameValueArgs.switches cell = [] % []
%     NameValueArgs.nowarnings logical = false
%     NameValueArgs.euro logical = false
%     NameValueArgs.public_components_only logical = false
%
%     NameValueArgs.inputDataString string = "" % []
%     NameValueArgs.stringVars string = "" % []
%     NameValueArgs.surpressOtherOutput logical = false
%     NameValueArgs.newOutput double = []
%     NameValueArgs.requestedQueries string = "" % []
%     NameValueArgs.useLogger logical = false
%
% end

Argument=["constantsToOverwrite","verbose","outputpath","addons",...
    "switches","nowarnings","euro","public_components_only",...
    "inputDataString","stringVars","surpressOtherOutput","newOutput",...
    "requestedQueries","useLogger"];
Class=["cell","logical","string","string",...
    "string","logical","logical","logical",...
    "string","string","logical","double",...
    "string","logical"];
Size = {[0,2],[],[1,1],[1,0],...
    [1,0],[],[],[],...
    [1,0],[1,0],[],[0,0],...
    [1,0],[]};

% country, system, data, data_id, NameValueArgs,

if isa(obj,'Model')
    %..................................................................
    try
        countryName = string(varargin{1});
    catch
        error("InputArgsValue: \nInput argument 2 must be the country name of class 'string'.")
    end
    try
        systemName = string(varargin{2});
    catch
        error("InputArgsValue: \nInput argument 3 must be the system name of class 'string'.")
    end
    data = varargin{3};
    if ~istable(data)
        error("InputArgsValue: \nInput argument 4 must be the dataset of class 'table'.")
    end
    try
        dataName = string(varargin{4});
    catch
        error("InputArgsValue: \nInput argument 5 must be the dataset name of class 'string'.")
    end
    %..................................................................
    varargin=varargin(5:end);

    country = obj.countries(countryName);
    Idx=country.index;
    countryInfoHandler = country.Info(Idx).Handler;
elseif isa(obj,'Country')
    countryName = obj.name;
    %..................................................................
    try
        systemName = string(varargin{1});
    catch
        error("InputArgsValue: \nInput argument 2 must be the system name of class 'string'.")
    end
    data = varargin{2};
    if ~istable(data)
        error("InputArgsValue: \nInput argument 3 must be the dataset of class 'table'.")
    end
    try
        dataName = string(varargin{3});
    catch
        error("InputArgsValue: \nInput argument 4 must be the dataset name of class 'string'.")
    end
    %..................................................................
    varargin=varargin(4:end);

    Idx=obj.index;
    countryInfoHandler = obj.Info(Idx).Handler;
elseif isa(obj,'System')
    countryName = obj.parent.name;
    systemName = obj.name;
    %..................................................................
    data = varargin{1};
    if ~istable(data)
        error("InputArgsValue: \nInput argument 2 must be the dataset of class 'table'.")
    end
    try
        dataName = string(varargin{2});
    catch
        error("InputArgsValue: \nInput argument 3 must be the dataset name of type string.")
    end
    %..................................................................
    varargin=varargin(3:end);

    country=obj.parent;
    Idx=country.index;
    countryInfoHandler = country.Info(Idx).Handler;
else
    try
        system=obj.getParent("SYS");

        countryName = system.parent.name;
        systemName = system.name;
        %..................................................................
        data = varargin{1};
        if ~istable(data)
            error("InputArgsValue: \nInput argument 2 must be the dataset of class 'table'.")
        end
        try
            dataName = string(varargin{2});
        catch
            error("InputArgsValue: \nInput argument 3 must be the dataset name of class 'string'.")
        end
        %..................................................................
        varargin=varargin(3:end);

        country=system.parent;
        Idx=country.index;
        countryInfoHandler = country.Info(Idx).Handler;

    catch
        country=obj.getParent("COUNTRY");

        countryName = country.name;
        %..................................................................
        try
            systemName = string(varargin{1});
        catch
            error("InputArgsValue: \nInput argument 2 must be the system name of class 'string'.")
        end
        data = varargin{2};
        if ~istable(data)
            error("InputArgsValue: \nInput argument 3 must be the dataset of class 'table'.")
        end
        try
            dataName = string(varargin{3});
        catch
            error("InputArgsValue: \nInput argument 4 must be the dataset name of class 'string'.")
        end
        %..................................................................
        varargin=varargin(4:end);

        Idx=country.index;
        countryInfoHandler = country.Info(Idx).Handler;
    end
end

% parse Name-Value input arguments
for i=1:2:numel(varargin)
    idx=ismember(Argument,varargin{i});
    % validate name
    if sum(idx)==0
        error("InputArgsValue: \nUrecognized Name-Value input argument '%s'.",varargin{i})
    end
    % get size validator
    iSize = Size{idx};
    if ~isempty(iSize)
        s1=[repmat('N',iSize(1)==0),repmat(char(num2str(iSize(1))),iSize(1)>0)];
        s2=[repmat('M',iSize(2)==0),repmat(char(num2str(iSize(2))),iSize(2)>0)];
        vSize=['(',s1,',',s2,')'];
        S=[s1,s2];
    else
        vSize='';
    end
    % validate class
    if ~strcmp(class(varargin{i+1}),Class(idx))
        error("InputArgsValue: \nName-Value input argument '%s' must be of class '%s' and size %s.",varargin{i},Class(idx),vSize)
    end
    % validate size
    if ~isempty(iSize)
        if str2double(S(iSize~=0)) ~= size(varargin{i+1},iSize(iSize~=0))
            error("InputArgsValue: \nName-Value input argument '%s' must be of class '%s' and size %s.",varargin{i},Class(idx),vSize)
        end
    end
end

out=runSimulation(countryInfoHandler, countryName, systemName, data, dataName, varargin{:});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% args=fieldnames(NameValueArgs);
% N=numel(args);
%
% for i=1:N
%     if strcmp("",NameValueArgs.(args{i}))
%         NameValueArgs.(args{i})=[];
%     end
%     if iscell(NameValueArgs.(args{i})) && isempty(NameValueArgs.(args{i}))
%         NameValueArgs.(args{i})=[];
%     end
% end
%
% argsValues=cell(1,N*2);
% argsValues(1:2:end) = args;
% argsValues(2:2:end) = struct2cell(NameValueArgs);
%
% out=runSimulation(obj,data,data_id,argsValues{:});

end


