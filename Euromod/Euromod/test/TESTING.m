
% trueObj=struct(testObj);
% tag=@(name,value)([char(name),char(num2str(value))]);
% for i=1:numel(strProps)
%     try
%     catch ME
%         errors.(tag('c',c)).(tag('p',p))=ME;
%     end
% end

clear;
warning('off','MATLAB:structOnObject')

%{
    LOAD ELEMENTS IN STRUCTURE AND SAVE TO MAT FILE
==============================================================
warning('off','MATLAB:NET:UnsupportedLoad')


% CPFR = struct;
[strProps,objProps]=utils.splitproperties(temp);
strProps=[strProps,"index","indexArr","tag"];
for i=1:numel(objProps)
    CPFR(c,p).obj.(objProps(i))=temp.(objProps(i)).index;
end
for i=1:numel(strProps)
    CPFR(c,p).obj.(strProps(i))=temp.(strProps(i));
end
%%%% !!! save("deleteme.mat","CPFR") !!! 
save("testObjects.mat","CPFR","-append")
% load("testObjects.mat")

%----------------------------------------------------------
% CSPFR = struct;
% testObjSystem(c,s,p,f).obj=struct(temp);
[strProps,objProps]=utils.splitproperties(temp);
strProps=[strProps,"index","indexArr","tag"];
for i=1:numel(objProps)
    CSPFR(c,s,p).obj.(objProps(i))=temp.(objProps(i)).index;
end
for i=1:numel(strProps)
    CSPFR(c,s,p).obj.(strProps(i))=temp.(strProps(i));
end
%%%% !!! save("deleteme.mat","CSPFR") !!!
save("testObjects.mat","CSPFR","-append")

%----------------------------------------------------------
% CSD = struct;
% testObjSystem(c,s,p,f).obj=struct(temp);
[strProps,objProps]=utils.splitproperties(temp);
strProps=[strProps,"index","indexArr","tag"];
for i=1:numel(objProps)
    CSD(c,s,d).obj.(objProps(i))=temp.(objProps(i)).index;
end
for i=1:numel(strProps)
    CSD(c,s,d).obj.(strProps(i))=temp.(strProps(i));
end
%%%% !!! save("deleteme.mat","CSD") !!!
save("testObjects.mat","CSD","-append")

%----------------------------------------------------------
% CPE = struct;
% testObjSystem(c,s,p,f).obj=struct(temp);
[strProps,objProps]=utils.splitproperties(temp);
strProps=[strProps,"index","indexArr","tag"];
for i=1:numel(objProps)
    CPE(c,p,e).obj.(objProps(i))=temp.(objProps(i)).index;
end
for i=1:numel(strProps)
    CPE(c,p,e).obj.(strProps(i))=temp.(strProps(i));
end
%%%% !!! save("deleteme.mat","CPE") !!!
save("testObjects.mat","CPE","-append")

%----------------------------------------------------------
% CS = struct;
CS(c).obj.('systems').index=temp.index;
% CP(c).obj.('systems').commentArray=temp.commentArray;
%%%% !!! save("deleteme.mat","CS") !!!
save("testObjects.mat","CS","-append")

%----------------------------------------------------------
% CP = struct;
CP(c).obj.('policies').index=temp.index;
CP(c).obj.('policies').commentArray=temp.commentArray;
%%%% !!! save("deleteme.mat","CP") !!!
save("testObjects.mat","CP","-append")


%--------------------------------------------------------------
%}

% messageCountry=@(errID,c,p,f,objProp)(sprintf('%s: \nCountry "%d", policy "%d", function "%d", property "%s".',errID,c,p,f,objProp));
% messageSystem=@(errID,c,s,p,f,objProp)(sprintf('%s: \nCountry "%d", system "%s", policy "%d", function "%d", property "%s".',errID,c,s,p,f,objProp));
% errIDobj='IndexArrayMismatch';
% errIDstr='ValueMismatch';


modelPath='C:\EUROMOD_RELEASES_I6.0+';
% modelPath=[pwd,'\EUROMOD_RELEASES_I6.0+'];
mm=euromod(modelPath);
doSave=0;

%%% CHECK COUNTRY SIDE
load("data\testObjects.mat")

% c=12;
% p=51;
% f=1;
% temp=mm.countries(c).policies(p).functions(f);
% unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)
% sprintf('COUNTRY %d, POLICY %d, FUNCTION %d: Done',c,p,f)
% 
% c=2;
% s=8;
% p=6;
% f=3;
% temp=mm.countries(c).systems(s).policies(p).functions(f);
% unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p,'f',f)
% sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTION %d: Done',c,s,p,f)
% 
% c=2;
% p=9;
% f=3;
% temp=mm.countries(c).policies(p).functions(f);
% unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)
% sprintf('COUNTRY %d, POLICY %d, FUNCTION %d: Done',c,p,f)

if doSave
    CPFR=struct([]);
    CSPFR=struct([]);
    CSPFR_=struct([]);
    CPE=struct([]);
    CPF=struct([]);
    C=struct([]);
    CD=struct([]);
    CS=struct([]);
    CP=struct([]);
    CSD=struct([]);
    CSP=struct([]);
    CSPF=struct([]);
end

c=1;
p=30;
temp=mm.countries(c).policies(p);
if doSave
    % CPFR=struct([]);
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p);
    if doSave
        save("testObjects.mat","CPFR")
    else
        save("testObjects.mat","CPFR","-append")
    end
end
unitTest(0,CPFR,temp,'c',c,'p',p)
sprintf('COUNTRY %d, POLICY %d: Done',c,p)
temp=mm.('AT').policies(p);
unitTest(0,CPFR,temp,'c',c,'p',p)


c=1;
p=44;
temp=mm.countries(c).policies(p);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p)
% save("testObjects.mat","CPFR","-append")
sprintf('COUNTRY %d, POLICY %d: Done',c,p)
temp=mm.('AT').policies(p);
unitTest(0,CPFR,temp,'c',c,'p',p)

c=1;
p=30;
temp=mm.countries(c).policies(p);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p)
% save("testObjects.mat","CPFR","-append")
sprintf('COUNTRY %d, POLICY %d: Done',c,p)
temp=mm.('AT').policies(p);
unitTest(0,CPFR,temp,'c',c,'p',p)

c=1;
p=43;
temp=mm.countries(c).policies(p);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p)
sprintf('COUNTRY %d, POLICY %d: Done',c,p)
temp=mm.('AT').policies(p);
unitTest(0,CPFR,temp,'c',c,'p',p)

c=9;
p=3;
temp=mm.countries(c).policies(p);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p)
sprintf('COUNTRY %d, POLICY %d: Done',c,p)
temp=mm.('EL').policies(p);
unitTest(0,CPFR,temp,'c',c,'p',p)

c=1;
s=8;
p=2;
temp=mm.countries(c).systems(s).policies(p);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s,'p',p);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d: Done',c,s,p)
temp=mm.('AT').('AT_2014').policies(p);
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)

c=1;
p=2;
f=1;
temp=mm.countries(c).policies(p).functions(f);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p,'f',f);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d: Done',c,p,f)
temp=mm.('AT').policies(p).functions(f);
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)

c=1;
s=17;
p=39;
temp=mm.countries(c).systems(s).policies(p);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s,'p',p);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d: Done',c,s,p)
temp=mm.('AT').('AT_2023').policies(p);
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)

c=2;
p=7;
f=11;
temp=mm.countries(c).policies(p).functions(f);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p,'f',f);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d: Done',c,p,f)
temp=mm.('BE').policies(p).functions(f);
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)

c=5;
s=15;
p=32;
f=0;
temp=mm.countries(c).systems(s).policies(p).functions;
if doSave
    CSP(c,s,p).obj.('functions').index=temp.index;
    CSP(c,s,p).obj.('functions').commentArray=temp.commentArray;
    save("testObjects.mat","CSP","-append")
end
unitTest(1,CSP,temp,'c',c,'s',s,'p',p,'f',f)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTIONS: Done',c,s,p)
temp=mm.('CZ').('CZ_2019').policies(p).functions;
unitTest(1,CSP,temp,'c',c,'s',s,'p',p,'f',f)

c=2;
p=7;
f=0;
temp=mm.countries(c).policies(p).functions;
if doSave
    CP(c,p).obj.('functions').index=temp.index;
    CP(c,p).obj.('functions').commentArray=temp.commentArray;
    save("testObjects.mat","CP","-append")
end
unitTest(1,CP,temp,'c',c,'p',p,'f',f)
sprintf('COUNTRY %d, POLICY %d, FUNCTIONS: Done',c,p)
temp=mm.('BE').policies(p).functions;
unitTest(1,CP,temp,'c',c,'p',p,'f',f)

c=1;
p=10;
e=1;
temp=mm.countries(c).policies(p).extensions(e);
if doSave
    CPE=assignTestValues(CPE,temp,'c',c,'p',p,'e',e);
    save("testObjects.mat","CPE","-append")
end
unitTest(0,CPE,temp,'c',c,'p',p,'e',e)
sprintf('COUNTRY %d, POLICY %d, EXTENSION %d: Done',c,p,e)
temp=mm.('AT').policies(p).extensions(e);
unitTest(0,CPE,temp,'c',c,'p',p,'e',e)

c=1;
s=17;
p=39;
temp=mm.countries('AT').systems('AT_2023').policies('bcc00_at');
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s,'p',p);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d: Done',c,s,p)
temp=mm.('AT').('AT_2023').policies(p);
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)

c=1;
d=0;
temp=mm.countries(c).datasets;
if doSave
    CD(c).obj.('datasets').index=temp.index;
    save("testObjects.mat","CD","-append")
end
unitTest(1,CD,temp,'c',c,'d',d)
sprintf('COUNTRY %d, DATASETS: Done',c)
temp=mm.('AT').datasets;
unitTest(1,CD,temp,'c',c,'d',d)

c=25;
s=16;
d=4;
temp=mm.countries(c).systems(s).datasets(d);
if doSave
    CSD=assignTestValues(CSD,temp,'c',c,'s',s,'d',d);
    save("testObjects.mat","CSD","-append")
end
unitTest(0,CSD,temp,'c',c,'s',s,'d',d)
sprintf('COUNTRY %d, SYSTEM %d, DATASET %d: Done',c,s,d)
temp=mm.('SE').('SE_2021').datasets(d);
unitTest(0,CSD,temp,'c',c,'s',s,'d',d)

c=10;
d=0;
temp=mm.countries('ES').datasets;
if doSave
    C(c).obj.('datasets').index=temp.index;
    save("testObjects.mat","C","-append")
end
unitTest(1,C,temp,'c',c,'d',d)
sprintf('COUNTRY %d, DATASETS: Done',c)
temp=mm.('ES').datasets;
unitTest(1,C,temp,'c',c,'d',d)

c=10;
d=7;
temp=mm.countries(c).datasets(d);
if doSave
    CD=assignTestValues(CD,temp,'c',c,'d',d);
    save("testObjects.mat","CD","-append")
end
unitTest(0,CD,temp,'c',c,'d',d)
sprintf('COUNTRY %d, DATASET %d: Done',c,d)
temp=mm.('ES').datasets(d);
unitTest(0,CD,temp,'c',c,'d',d)

c=3;
s=7;
d=0;
temp=mm.countries(c).systems(s).datasets;
if doSave
    CS(c,s).obj.('datasets').index=temp.index;
    save("testObjects.mat","CS","-append")
end
unitTest(1,CS,temp,'c',c,'s',s,'d',d)
sprintf('COUNTRY %d, SYSTEM %d, DATASETS: Done',c,s)
temp=mm.('BG').("BG_2013").datasets;
unitTest(1,CS,temp,'c',c,'s',s,'d',d)


c=1;
p=2;
f=1;
temp=mm.countries(c).policies(p).functions(f);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p,'f',f);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d: Done',c,p,f)
temp=mm.('AT').policies(p).functions(f);
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f)

c=1;
s=8;
p=0;
temp=mm.countries(c).systems(s).policies;
if doSave
    CS(c,s).obj.('policies').index=temp.index;
    CS(c,s).obj.('policies').commentArray=temp.commentArray;
    save("testObjects.mat","CS","-append")
end
unitTest(1,CS,temp,'c',c,'s',s,'p',p)
temp=mm.('AT').('AT_2014').policies;
unitTest(1,CS,temp,'c',c,'s',s,'p',p)

c=25;
s=0;
temp=mm.countries(c).systems;
if doSave
    % C=assignTestValues(C,temp,'c',c);
    C(c).obj.('systems').index=temp.index;
    save("testObjects.mat","C","-append")
end
unitTest(1,C,temp,'c',c,'s',0)
sprintf('COUNTRY %d, SYSTEMS: Done',c)
temp=mm.('SE').systems;
unitTest(1,C,temp,'c',c,'s',0)

c=1;
p=0;
temp=mm.countries(c).policies;
if doSave
    C(c).obj.('policies').index=temp.index;
    C(c).obj.('policies').commentArray=temp.commentArray;
    % CP=assignTestValues(CP,temp,'c',c,'p',p);
    save("testObjects.mat","C","-append")
end
unitTest(1,C,temp,'c',c,'p',p)
sprintf('COUNTRY %d, POLICIES: Done',c)
temp=mm.('AT').policies;
unitTest(1,C,temp,'c',c,'p',p)

c=1;
s=8;
p=2;
temp=mm.countries(c).systems(s).policies(p);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s,'p',p);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d: Done',c,s,p)
temp=mm.('AT').('AT_2014').policies(2);
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p)

c=25;
s=14;
temp=mm.countries(c).systems(s);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s)
sprintf('COUNTRY %d, SYSTEM %d: Done',c,s)
temp=mm.('SE').('SE_2019');
unitTest(0,CSPFR,temp,'c',c,'s',s)

c=20;
s=14;
temp=mm.countries(c).systems(s);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s)
sprintf('COUNTRY %d, SYSTEM %d: Done',c,s)
temp=mm.('MT').('MT_2020');
unitTest(0,CSPFR,temp,'c',c,'s',s)

c=2;
p=7;
f=11;
e=2;
temp=mm.countries(c).policies(p).functions(f).extensions(e);
if doSave
    CPFE=assignTestValues(CPFE,temp,'c',c,'p',p,'f',f,'e',e);
    save("testObjects.mat","CPFE","-append")
end
unitTest(0,CPFE,temp,'c',c,'p',p,'f',f,'e',e)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d, EXTENSION %d: Done',c,p,f,e)
temp=mm.('BE').policies(p).functions(f).extensions(e);
unitTest(0,CPFE,temp,'c',c,'p',p,'f',f,'e',e)

c=7;
p=15;
f=6;
r=4;
temp=mm.countries(c).policies(p).functions(f).parameters(r);
if doSave
    CPFR=assignTestValues(CPFR,temp,'c',c,'p',p,'f',f,'r',r);
    save("testObjects.mat","CPFR","-append")
end
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f,'r',r)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d, PARAMETER %d: Done',c,p,f,r)
temp=mm.('DK').policies(p).functions(f).parameters(r);
unitTest(0,CPFR,temp,'c',c,'p',p,'f',f,'r',r)

c=7;
s=17;
p=26;
f=4;
temp=mm.countries(c).systems(s).policies(p).functions(4);
if doSave
    CSPFR=assignTestValues(CSPFR,temp,'c',c,'s',s,'p',p,'f',f);
    save("testObjects.mat","CSPFR","-append")
end
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p,'f',f)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTION %d: Done',c,s,p,f)
temp=mm.('DK').('DK_2023').policies(p).functions(f);
unitTest(0,CSPFR,temp,'c',c,'s',s,'p',p,'f',f)

c=9;
s=7;
p=0;
temp=mm.countries(c).systems(s).policies;
if doSave
    CS(c,s).obj.('policies').index=temp.index;
    CS(c,s).obj.('policies').commentArray=temp.commentArray;
    save("testObjects.mat","CS","-append")
end
unitTest(1,CS,temp,'c',c,'s',s,'p',p)
sprintf('COUNTRY %d, SYSTEM %d, POLICIES: done',c,s)
temp=mm.('EL').('EL_2011').policies;
unitTest(1,CS,temp,'c',c,'s',s,'p',p)

c=7;
s=9;
p=15;
f=6;
r=0;
temp=mm.countries(c).systems(s).policies(p).functions(f).parameters;
if doSave
    CSPF(c,s,p,f).obj.('parameters').index=temp.index;
    save("testObjects.mat","CSPF","-append")
end
unitTest(1,CSPF,temp,'c',c,'s',s,'p',p,'f',f,'r',r)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d, PARAMETERS: Done',c,s,p,f)
temp=mm.('DK').('DK_2015').policies(p).functions(f).parameters;
unitTest(1,CSPF,temp,'c',c,'s',s,'p',p,'f',f,'r',r)

c=9;
s=7;
p=51;
f=0;
temp=mm.countries(c).systems(s).policies(p).functions;
if doSave
    CSP(c,s,p).obj.('functions').index=temp.index;
    CSP(c,s,p).obj.('functions').commentArray=temp.commentArray;
    save("testObjects.mat","CSP","-append")
end
unitTest(1,CSP,temp,'c',c,'s',s,'p',p,'f',f)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTIONS: done',c,s,p)
temp=mm.('EL').('EL_2011').policies(p).functions;
unitTest(1,CSP,temp,'c',c,'s',s,'p',p,'f',f)

c=7;
p=15;
f=6;
r=0;
temp=mm.countries(c).policies(p).functions(f).parameters;
if doSave
    CPF(c,p,f).obj.('parameters').index=temp.index;
    save("testObjects.mat","CPF","-append")
end
unitTest(1,CPF,temp,'c',c,'p',p,'f',f,'r',r)
sprintf('COUNTRY %d, POLICY %d, FUNCTION %d, PARAMETERS: Done',c,p,f)
temp=mm.('DK').policies(p).functions(f).parameters;
unitTest(1,CPF,temp,'c',c,'p',p,'f',f,'r',r)

c=1;
s=8;
p=2;
f=1;
temp=mm.countries(c).systems(s).policies(p).functions(f);
if doSave
    CSPFR_=assignTestValues(CSPFR_,temp,'c',c,'s',s,'p',p,'f',f);
    save("testObjects.mat","CSPFR_","-append")
end
unitTest(0,CSPFR_,temp,'c',c,'s',s,'p',p,'f',f)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTION %d: Done',c,s,p,f)
temp=mm.('AT').systems('AT_2014').policies(p).functions;
unitTest(0,CSPFR_,temp,'c',c,'s',s,'p',p,'f',f)

c=25;
s=16;
p=19;
f=3;
r=2;
temp=mm.countries(c).systems(s).policies(p).functions(f).parameters(r);
if doSave
    CSPFR_=assignTestValues(CSPFR_,temp,'c',c,'s',s,'p',p,'f',f,'r',r);
    save("testObjects.mat","CSPFR_","-append")
end
unitTest(0,CSPFR_,temp,'c',c,'s',s,'p',p,'f',f,'r',r)
sprintf('COUNTRY %d, SYSTEM %d, POLICY %d, FUNCTION %d, PARAMETER %d: Done',c,s,p,f,r)
temp=mm.countries('SE').('SE_2021').policies(p).functions(f).parameters(r);
unitTest(0,CSPFR_,temp,'c',c,'s',s,'p',p,'f',f,'r',r)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;







%-------------------------------
% c=1;
% s=8;
% temp=mm.countries(c).systems(s).policies
% unitTest(1,CS,temp,'c',c,'s',s,'p',0)
% 
% %-------------------------------
% c=1;
% temp=mm.countries(c).policies
% % unitTest(1,CS,temp,'c',c,'p',0)
% %-------------------------------
% 
% c=9;
% temp=mm.countries(c).policies


% % isequal(tr.testObjCountry(c,p,f).obj,struct(temp))
% [strProps,objProps]=utils.splitproperties(temp);
% for i=1:numel(objProps)
%     if isempty(testObjCountry(c,p,f).obj.(objProps(i)))
%         assert(isempty(temp.(objProps(i))))
%     else
%         assertion=isequal(testObjCountry(c,p,f).obj.(objProps(i)),temp.(objProps(i)).index);
%         msg=messageCountry(errIDobj,c,p,f,objProps(i));
%         assert(assertion,msg)
%     end
% end
% for i=1:numel(strProps)
%     assertion=isequal(testObjCountry(c,p,f).obj.(strProps(i)),temp.(strProps(i)));
%     msg=messageCountry(errIDstr,c,p,f,strProps(i));
%     assert(assertion,message)
% end


%%% CHECK POLICY SIDE
% temp=mm.countries(2).systems(8).policies(6).functions(3)


% TODO : not displaying funID
% temp=mm.countries(2).systems(8).policies(9).functions(6).extensions(2);
% 
% 
% 
% mm.countries(6).policies(24)
% mm.countries(12).policies(end).functions(3)
% mm.countries(12).policies(end)
% mm.countries(12).policies
% 
% mm.countries(6).systems(end).policies
% mm.countries(2).systems(end).policies(9).functions(3)
% mm.countries(12).systems(10)
% 
% mm.countries(20).systems(10).datasets
% mm.countries(22).systems(4).bestmatchDatasets
% mm.countries(15).systems(9).bestmatchDatasets(1).name
% 
% mm.countries(20).systems(6).policies
% 
% mm.countries(14).systems(6).policies(9)
% 
% mm.countries(2).systems(3).policies(9).functions
% mm.countries(2).systems(19).policies(9).functions
% 
% mm.countries(25).systems(16).policies(19).functions(3).parameters(6)
% ss=mm.countries(25).systems(16)
% 
% 
% ss=mm.countries(25).systems(16)
% 
% mm.countries(25).systems(16).datasets(4).name
% ss=mm.countries(25).systems(16)
% 
% ss=mm.countries(2).systems(8).policies(9).functions(6).parameters(3)
% ss.parent.parent
