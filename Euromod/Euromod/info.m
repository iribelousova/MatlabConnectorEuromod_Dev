function s = info(obj,varargin)
if size(obj,1)>1
    error('Object array is not allowed.')
end
if isa(obj,'Country')
    cobj=copy(obj);
else
    cobj=copy(obj.getParent("COUNTRY"));
end
mod=cobj.parent;
Idx=cobj.index;

if isa(obj,'System')
    if numel(varargin)==0
        name=obj.name; % system name
        x = cobj.Info(Idx).Handler.GetSystemExpandedInfo(name);
        [values,keys]=utils.getInfo(x);
    else
        if strcmpi(varargin{1},'datasets')
            ID=obj.ID;
            x = cobj.Info(Idx).Handler.GetSysYearCombinations('ID',ID); % use name or ID
            values=utils.getInfo(x);
            keys=[];
        elseif strcmpi(varargin{1},'parameters')
            name=obj.name; % system name
            % parid=mm.countries(1).systems(8).policies(1).functions(1).parameters(1).parID;
            parid=varargin{2}; % parameter ID "parID"
            x = cobj.Info(Idx).Handler.GetSysParInfo(name,parid);
            [values,keys]=utils.getInfo(x);
        elseif strcmpi(varargin{1},'policies')
            sysName=obj.name; % system name
            % polName=mm.countries(1).systems(8).policies(1).name;
            polName=varargin{2}; % policy name
            x = cobj.Info(Idx).Handler.GetSysPolInfo(polName,sysName);
            [values,keys]=utils.getInfo(x);

        end
    end
end

if strcmp(class(obj),'Dataset')
    if numel(varargin)==0
        name=obj.name; % dataset name
        x = cobj.Info(Idx).Handler.GetDataSetInfo(name);
        [values,keys]=utils.getInfo(x);
    end
end

if isa(obj,'Country') && numel(varargin)>0
    if strcmpi(varargin{1},'datasets')
        x=cobj.Info(Idx).Handler.GetDatasets();
        values=utils.getInfo(x);
    elseif strcmpi(varargin{1},'systems')
        x= cobj.Info(Idx).Handler.GetSystems();
        values=utils.getInfo(x);
    end
    keys=[];
end

if isa(obj,'Policy')
    name=obj.name; % policy name
    x = cobj.Info(Idx).Handler.GetPolInfo(name);
    [values,keys]=utils.getInfo(x);
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