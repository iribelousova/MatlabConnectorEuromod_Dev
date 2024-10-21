function unitTest(flag, trueObject,testObject,NameValueArgs)

arguments
    flag
    trueObject
    testObject
    NameValueArgs.c = [] % country index
    NameValueArgs.s = [] % system index
    NameValueArgs.p = [] % policy index
    NameValueArgs.e = [] % extension index
    NameValueArgs.f = [] % function index
    NameValueArgs.d = [] % dataset index
    NameValueArgs.r = [] % parameter index
end

%{
    LOAD ELEMENTS IN STRUCTURE AND SAVE TO MAT FILE
==============================================================
testObjCountry = struct;
testObjCountry(c,p,f).obj=struct(temp);
[strProps,objProps]=utils.splitproperties(temp);
for i=1:numel(objProps)
    testObjCountry(c,p,f).obj.(objProps(i))=temp.(objProps(i)).index;
end
% save("testObjects.mat","testObjCountry")
save("testObjects.mat","testObjCountry","-append")
% load("testObjects.mat")


testObjSystem = struct;
testObjSystem(c,s,p,f).obj=struct(temp);
[strProps,objProps]=utils.splitproperties(temp);
for i=1:numel(objProps)
    testObjSystem(c,p,f).obj.(objProps(i))=temp.(objProps(i)).index;
end
% save("testObjects.mat","testObjSystem")
save("testObjects.mat","testObjSystem","-append")
% load("testObjects.mat")
%}

% me

errIDobj='IndexArrayMismatch';
errIDstr='ValueMismatch';
orderedNams=["c","s","p","f","r","e","d"];
propNams=["countries","systems","policies","functions","parameters","extensions","datasets"];

% get names and values of indices
idxVals=struct2cell(NameValueArgs);
idxNams=string(fieldnames(NameValueArgs));
% idx=~cellfun(@isempty,tempVals);
% tempNams=tempNams(idx);
% tempVals=cell2mat(tempVals(idx));
    
% order names of indices
[~,idxO]=ismember(orderedNams,idxNams);
idxO(idxO==0)=[];
idxNamsOrdered=idxNams(idxO);

% order values of indices
idxValsOrdered=idxVals(idxO);

idx=~cellfun(@isempty,idxValsOrdered);

% get properties' names
idxP=ismember(orderedNams,idxNamsOrdered(idx));
orderedPropNams=propNams(idxP);

idxValsOrdered=idxValsOrdered(idx);
invals=cell(1,numel(orderedPropNams)*2);
invals(1:2:end)=cellstr(orderedPropNams);
invals(2:2:end)=idxValsOrdered;

if flag
    % tempVals=struct2cell(NameValueArgs);
    % tempNams=string(fieldnames(NameValueArgs));
    % idx=~cellfun(@isempty,tempVals);
    % tempVals=cell2mat(tempVals(idx));
    % tempNams=tempNams(idx);
    % prop = propNams(ismember(ordered,tempNams));

    invals=invals(1:end-1);
    strMess='>In %s %d';
    for i=2:numel(orderedPropNams)-1
        strMess=[strMess,', %s %d'];
    end
    strMess=[strMess,', property %s.'];

    idxValsOrdered=idxValsOrdered(1:end-1);
    %----------------------------------------------------------------------
    assertion=isequal(trueObject(idxValsOrdered{:}).obj.(orderedPropNams(end)).index,testObject.index);
    msg=sprintf(['%s: \nArray elements mismatch.\n',strMess],errIDobj,invals{:});
    assert(assertion,msg)

    if isfield(testObject,'commentArray')
    %----------------------------------------------------------------------
        assertion=isequal(trueObject(idxValsOrdered{:}).obj.(orderedPropNams(end)).commentArray,testObject.commentArray);
        msg=sprintf(['%s: \nComment description mismatch.\n.',strMess],errIDstr,invals{:});
        assert(assertion,msg)
    end
else

    % % get names and values of indices
    % tempVals=struct2cell(NameValueArgs);
    % tempNams=string(fieldnames(NameValueArgs));
    % % idx=~cellfun(@isempty,tempVals);
    % % tempNams=tempNams(idx);
    % % tempVals=cell2mat(tempVals(idx));
    % 
    % % order names of indices
    % [~,idxO]=ismember(ordered,tempNams);
    % idxO(idxO==0)=[];
    % orderedNams=tempNams(idxO);
    % 
    % % order values of indices
    % orderedVals=tempVals(idxO);
    % 
    % idx=~cellfun(@isempty,orderedVals);
    % 
    % % get properties' names
    % idxP=ismember(ordered,orderedNams(idx));
    % orderProps=propNams(idxP);
    
    strMess='>In %s %d';
    for i=2:numel(orderedPropNams)
        strMess=[strMess,', %s %d'];
    end
    
    % message=@(errID,c,s,p,f,r,e,d,objProp)(sprintf(['%s: \n',strMess,', property "%s".'],errID,invals{:},objProp));
    
    % messageCountry=@(errID,c,p,f,objProp)(sprintf('%s: \nCountry "%d", policy "%d", function "%d", property "%s".',errID,c,p,f,objProp));
    % messageSystem=@(errID,c,s,p,f,objProp)(sprintf('%s: \nCountry "%d", system "%s", policy "%d", function "%d", property "%s".',errID,c,s,p,f,objProp));
        
    % testObject=mm.countries(c).policies(p).functions(f);
    % isequal(tr.trueObject(c,p,f).obj,struct(testObject))
    [strProps,objProps]=utils.splitproperties(testObject);
    for i=1:numel(objProps)
        if isempty(trueObject(idxValsOrdered{:}).obj.(objProps(i)))
            assert(isempty(testObject.(objProps(i))))
        else
            assertion=isequal(trueObject(idxValsOrdered{:}).obj.(objProps(i)),testObject.(objProps(i)).index);
            % msg=messageCountry(errIDobj,c,p,f,objProps(i));
            msg=sprintf(['%s: \n',strMess,', property "%s".'],errIDobj,invals{:},objProps(i));
            assert(assertion,msg)
        end
    end
    for i=1:numel(strProps)
        assertion=isequal(trueObject(idxValsOrdered{:}).obj.(strProps(i)),testObject.(strProps(i)));
        % msg=messageCountry(errIDstr,c,p,f,strProps(i));
        msg=sprintf(['%s: \n',strMess,', property "%s".'],errIDstr,invals{:},strProps(i));
        assert(assertion,msg)
    end
end

end

