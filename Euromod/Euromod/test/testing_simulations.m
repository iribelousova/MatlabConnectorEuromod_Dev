clear;
clc;

PATH_EUROMODFILES = "C:\EUROMOD_RELEASES_I6.0+";
% PATH_DATA = "C:\Users\iribe\WORK\EUROMOD\All countries";
PATH_DATA = "C:\EUROMOD_RELEASES_I6.0+\Input";

alignfun = @(x) num2str(110 - length(x));
rtWarnCheck = '... warning-Check OK.';
rtSimOk = '...Simulation OK.';
rtNoOutput = '... has NO output!';
err=0.9; % margin of error between the Euromod Connector output and the EUROMOD output
savefig=0;


EM=euromod(PATH_EUROMODFILES);

%***************************************************
ID_DATASET = "SE_2021_b1.txt";                    %*
data = readtable(fullfile(PATH_DATA, ID_DATASET));%*
%***************************************************

EM.countries('SE').systems('SE_2021').run(data,ID_DATASET)

EM.countries('SE').run('SE_2021',data,ID_DATASET)

EM.countries('SE').systems('SE_2021').policies(2).info()

%__________________________________________________________________________
% RUN BASE FROM SYSTEM CLASS 
try

    obj=EM.countries('SE').systems('SE_2021');

    sim_base_SE=run(obj,data, ID_DATASET);
    % ss = summaryStatistics(sim_base_SE.outputs{1}, 1);

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN BASE FROM MODEL CLASS 
try
    sim_b=run(EM,'SE','SE_2021',data, ID_DATASET);

    restest = sum(sim_b.outputs{1}{:,'ils_dispy'} - sim_base_SE.outputs{1}{:,'ils_dispy'});
    assert(restest==0)

    % ss = summaryStatistics(sim_addon_SE.outputs{1}, 1);

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN BASE FROM COUNTRY CLASS 
try
    obj=EM.countries('SE');

    sim_b=run(obj,'SE_2021',data, ID_DATASET);

    restest = sum(sim_b.outputs{1}{:,'ils_dispy'} - sim_base_SE.outputs{1}{:,'ils_dispy'});
    assert(restest==0)

    % ss = summaryStatistics(sim_addon_SE.outputs{1}, 1);

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN BASE FROM SYSTEM SUB-CLASS
try
    obj=EM.countries('SE').systems('SE_2021').policies;

    sim_b=run(obj,data, ID_DATASET);

    restest = sum(sim_b.outputs{1}{:,'ils_dispy'} - sim_base_SE.outputs{1}{:,'ils_dispy'});
    assert(restest==0)

    % ss = summaryStatistics(sim_addon_SE.outputs{1}, 1);

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN BASE FROM COUNTRY-POLICY SUB-CLASS
try
    obj=EM.countries('SE').policies(3).functions(2);

    sim_b=run(obj,'SE_2021',data, ID_DATASET);

    restest = sum(sim_b.outputs{1}{:,'ils_dispy'} - sim_base_SE.outputs{1}{:,'ils_dispy'});
    assert(restest==0)

    % ss = summaryStatistics(sim_addon_SE.outputs{1}, 1);

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN WITH constantsToOverwrite
try
    constants = {["$tinna_rate2",""],'0.4'};

    obj=EM.countries('SE').systems('SE_2021');
    sim_const_SE=run(obj, data, ID_DATASET, 'constantsToOverwrite', constants);

    restest = sum(sim_const_SE.outputs{1}{:,'ils_dispy'} - sim_base_SE.outputs{1}{:,'ils_dispy'});
    assert(restest==-1.224777476181829e+07)
    
catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN WITH addons
try
    addons = ["MTR","MTR"];

    % addons = ["LMA","LMA_SE"]; ??????????????????????????????????????

    obj=EM.countries('SE').systems('SE_2021');
    sim_addon_SE=run(obj,data, ID_DATASET, 'addons', addons);

    restest = sim_addon_SE.outputs{2}{:,'mtrpc'};
    assert(mean(restest)==19.419071885518552)

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN WITH swithces
try
    switches = ["MWA","false"];

    obj=EM.countries('SE').systems('SE_2021');
    sim_switch_SE=run(obj,data, ID_DATASET, 'switches', switches);

    restest=mean(sim_switch_SE.outputs{1}{:,'ils_ben'})-mean(sim_base_SE.outputs{1}{:,'ils_ben'});

    assert(restest==0)

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end


%***************************************************
ID_DATASET = "HR_2021_b2.txt";                    %*
data = readtable(fullfile(PATH_DATA, ID_DATASET));%*
%***************************************************

%__________________________________________________________________________
% RUN WITH constantsToOverwrite
try
    constants = {["$ANWPY",""],'1000000#m'};

    obj=EM.countries('HR').systems('HR_2023');
    sim_const=run(obj,data, ID_DATASET, 'constantsToOverwrite', constants);
    ss = summaryStatistics(sim_const.outputs{1}, 0);

    fileName = "data\hr_2023_const_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 0);

    if any(abs(cell2mat(struct2cell(ss))-cell2mat(struct2cell(ss_true))) > err)
        error('Results from "constantsToOverwrite" estimation discrepancy discrepancy > %0.3f! Check Summary Statistics in %s', err, file_const)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN BASE
try
    obj=EM.countries('HR').systems('HR_2023');
    sim_base=run(obj,data, ID_DATASET);

    fprintf('<strong>==============================================</strong>\n');
    fprintf("<strong>Country 'HR', system 'HR_2023', dataset '%s'</strong>", ID_DATASET);
    ss = summaryStatistics(sim_base.outputs{1}, 1);

    fileName = "data\hr_2023_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 0);

    if any(abs(cell2mat(struct2cell(ss))-cell2mat(struct2cell(ss_true))) > err)
        error('Results from "basline" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
    end
    % plot([ss,ss_true])

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN WITH surpressOtherOutput
try
    obj=EM.countries('HR').systems('HR_2023');
    sim=run(obj, data, ID_DATASET, 'surpressOtherOutput',true);
    ss = summaryStatistics(sim.outputs{1}, 0);

    if any(abs(cell2mat(struct2cell(ss))-cell2mat(struct2cell(ss_true))) > err)
        error('Results from "basline" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
% RUN WITH setParameter :: CHANGE PARAMETER VALUE
try
    obj=copy(EM.countries('HR').systems('HR_2023'));
    ID = "602db41d-12d6-465d-976a-973493859763";

    setParameter(obj,"HR_2023", ID, "0");
    info(obj,"parameters" ,ID)

    sim_setpar=run(obj, data, ID_DATASET);
    ss = summaryStatistics(sim_setpar.outputs{1}, 0);

    fileName = "data\hr_2023_tinref_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 0);

    if any(abs(cell2mat(struct2cell(ss))-cell2mat(struct2cell(ss_true))) > err)
        warning('Results from "discrepancy" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s', ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________

out1=sim_base.outputs{1};
out2=sim_const.outputs{1};
% varnames = {'ils_ben', 'ils_b2_penhl', 'ils_b2_bfaed', 'ils_b1_bun'};
varnames = ["ils_ben", "ils_b2_penhl", "ils_b2_bfaed", "ils_b1_bun"];
level = 'idhh';

ann_tot_sum = totalAnnualWeightedSum(out1,out2,'variables',varnames,'level',level);

%..........................................................................
pTitle={'Government expenditure on social transfers'; '(Yearly, mill. €)'};
pXlable = 'Expenditures';
pYlable = 'Millions of euros';
pXticklabel = {'Total'; 'Pensions'; 'Fam.&Educ.'; 'Soc.Ass.&House'; 'Unemp.'};
pLegend={'Baseline','Revised'};

plotBar(ann_tot_sum,'title',pTitle,'xlabel',pXlable,'ylabel',pYlable,...
    'xticklabel',pXticklabel,'legend',pLegend);

