function OUT=assignTestValues(OUT,obj,NameValueArgs)

arguments
    OUT
    obj
    NameValueArgs.c = [] % country index
    NameValueArgs.s = [] % system index
    NameValueArgs.p = [] % policy index
    NameValueArgs.e = [] % extension index
    NameValueArgs.f = [] % function index
    NameValueArgs.d = [] % dataset index
    NameValueArgs.r = [] % parameter index
end

orderedNams=["c","s","p","f","r","e","d"];

idxVals=struct2cell(NameValueArgs);
idxNams=string(fieldnames(NameValueArgs));

[~,idxO]=ismember(orderedNams,idxNams);
idxO(idxO==0)=[];
idxValsOrdered=idxVals(idxO);
idx=~cellfun(@isempty,idxValsOrdered);
idxValsOrdered=idxValsOrdered(idx);

[strProps,objProps]=utils.splitproperties(obj);
strProps=[strProps,"index","indexArr","tag"];
for i=1:numel(objProps)
    if size(obj.(objProps(i)),1)==0
        OUT(idxValsOrdered{:}).obj.(objProps(i))=[];
    else
        OUT(idxValsOrdered{:}).obj.(objProps(i))=obj.(objProps(i)).index;
    end
    % OUT(idxValsOrdered{:}).obj.(objProps(i))=obj.(objProps(i)).index;
end
for i=1:numel(strProps)
    OUT(idxValsOrdered{:}).obj.(strProps(i))=obj.(strProps(i));
end


end