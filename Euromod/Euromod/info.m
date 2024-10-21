function s = info(obj,varargin)

% Other (optional) input arguments depend on the class of the object passed.
% For example:
% *Country class, accepts a 2nd optional input argument: 'datasets' or 'systems'.
% *System class, accepts a 2nd optional input arguments: 'datasets' or 
%       'parameters', which requires a 3rd input argument for the parameter ID, or 
%       'policies', which requires a 3rd input argument for the policy name.
% *Dataset or DatasetInSystem class, no other input arguments are required.
% *Policy class, no other input arguments are required.

if size(obj,1)>1
    error('Object array is not allowed.')
end
if isa(obj,'Country')
    cobj=copy(obj);
else
    cobj=copy(obj.getParent("COUNTRY"));
end

% get country handler
Idx=cobj.index;
H=cobj.Info(Idx).Handler;

if isa(obj,'System')
    if numel(varargin)==0
        name=obj.name; % system name
        x = H.GetSystemExpandedInfo(name);
        [values,keys]=utils.getInfo(x);
    elseif numel(varargin)>=1 && numel(varargin)<=2
        Arg=string(varargin{1});
        if ~any(ismember(Arg,["datasets","parameters","policies"]))
            error("Unrecognized input argument '%s' for class '%s'. \nAcceptable names are: %s.",...
                Arg,class(obj),join(["datasets","parameters","policies"],', '))
        end
        if strcmpi(Arg,'datasets')
            ID=obj.ID;
            x = H.GetSysYearCombinations('ID',ID); % use name or ID
            values=utils.getInfo(x);
            values(ismember(values,'no'))="";
            values(ismember(values,'yes'))="best match";
            keys=[];
        elseif strcmpi(Arg,'parameters')
            if numel(varargin)<2
                error("Not enought input arguments. Please, specify the parameter ID as a 'string'.")
            end
            parid=string(varargin{2}); % parameter ID "parID"
            name=obj.name; % system name
            % parid=mm.countries(1).systems(8).policies(1).functions(1).parameters(1).parID;
            x = H.GetSysParInfo(name,parid);
            [values,keys]=utils.getInfo(x);
        elseif strcmpi(varargin{1},'policies')
            if numel(varargin)<2
                error("Not enought input arguments. Please, specify the policy name as a 'string'.")
            end
            polName=string(varargin{2}); % policy name
            sysName=obj.name; % system name
            % polName=mm.countries(1).systems(8).policies(1).name;
            x = H.GetSysPolInfo(polName,sysName);
            [values,keys]=utils.getInfo(x);
            if any(ismember(keys,""))
                keys(ismember(keys,""))="Switch";
            end

        end
    else
        error('Too many input arguments.')
    end

elseif isa(obj,'Dataset')
    if numel(varargin)==0
        name=obj.name; % dataset name
        x = H.GetDataSetInfo(name);
        [values,keys]=utils.getInfo(x);
    else
        error('Too many input arguments.')
    end

elseif isa(obj,'Country') 
    if numel(varargin)==0
        error("Not enought input arguments. Please, specify the info type as a 'string'.\n%s %s.",...
            "Acceptable values are:",join(["datasets","systems"],', '))
    elseif numel(varargin)>1
        error('Too many input arguments.')
    end
    if strcmpi(varargin{1},'datasets')
        x=H.GetDatasets();
        values=utils.getInfo(x);
    elseif strcmpi(varargin{1},'systems')
        x= H.GetSystems();
        values=utils.getInfo(x);
    end
    keys=[];

elseif isa(obj,'Policy')
    if numel(varargin)>0
        error('Too many input arguments.')
    end
    name=obj.name; % policy name
    x = H.GetPolInfo(name);
    [values,keys]=utils.getInfo(x);
    % if ismember(keys,"")
    %     keys(ismember(keys,""))="Switch";
    % end
else
    error("The class of type '%s' is not acceptable.",class(obj))
end

if isempty(keys)
    s=values;
    return;
else
    keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
    if any(contains(keys,'iD'))
        keys(contains(keys,'iD'))='ID';
    end
    if any(contains(keys,'switch'))
        keys(contains(keys,'switch'))='Switch';
    end
    
    s=struct;
    for i=1:numel(keys)
        s.(keys(i))=values(i,:);
    end

end
end



% x = h.GetSystemInfo(mm.countries(1).systems(8).name)
% [values,keys]=utils.getInfo(x)

%{

CheckIfRecent                   GetSysYearCombinations ++++++++++++++++++        
CountryInfoHandler              GetSystemExpandedInfo ++++++++++++++++++++    
Equals                          GetSystemInfo -------------------------                  
GetDataSetInfo +++++                 GetSystems +++++++++++++++++++++++                     
GetDatasets    +++++                 GetType                         
GetHashCode                     GetTypeInfo ===========================                 
GetInfoInString  =====               GetXmlInfo                      
GetPieceOfInfo  =====                ReadCountryInfo                 
GetPiecesOfInfo  =====               SetSysParValue ++++++++++++++++++++                
GetPiecesOfInfoInList  =====         ToString ==========================                       
GetPolInfo  +++++                    UpdateElement                   
GetSysParInfo +++++                  keyHash                         
GetSysPolInfo +++++                  keyMatch                        
GetSysYearCombinationBySysInfo  

%}