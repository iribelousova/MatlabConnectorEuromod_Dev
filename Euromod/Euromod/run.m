function out = run(obj, data, data_id, NameValueArgs)

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

arguments
    obj
    data table
    data_id string
    NameValueArgs.constantsToOverwrite cell = {} %[]
    NameValueArgs.verbose logical = true
    NameValueArgs.outputpath string = "" % []
    NameValueArgs.addons cell = {} % []
    NameValueArgs.switches cell = {} % []
    NameValueArgs.nowarnings logical = false
    NameValueArgs.euro logical = false
    NameValueArgs.public_components_only logical = false

    NameValueArgs.inputDataString string = "" % []
    NameValueArgs.stringVars string = "" % []
    NameValueArgs.surpressOtherOutput logical = false
    NameValueArgs.newOutput double = []
    NameValueArgs.requestedQueries string = "" % []
    NameValueArgs.useLogger logical = false

end

args=fieldnames(NameValueArgs);
N=numel(args);

for i=1:N
    if strcmp("",NameValueArgs.(args{i})) 
        NameValueArgs.(args{i})=[];
    end
    if iscell(NameValueArgs.(args{i})) && isempty(NameValueArgs.(args{i}))
        NameValueArgs.(args{i})=[];
    end
end

argsValues=cell(1,N*2);
argsValues(1:2:end) = args;
argsValues(2:2:end) = struct2cell(NameValueArgs);

out=runSimulation(obj,data,data_id,argsValues{:});

end


