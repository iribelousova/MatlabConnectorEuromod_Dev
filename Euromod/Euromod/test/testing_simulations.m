PATH_EUROMODFILES = "C:\EUROMOD_RELEASES_I6.0+";
% PATH_DATA = "C:\Users\iribe\WORK\EUROMOD\All countries";
PATH_DATA = "C:\EUROMOD_RELEASES_I6.0+\Input\All countries";
ID_DATASET = "HR_2021_b2.txt";

data = readtable(fullfile(PATH_DATA, ID_DATASET));

alignfun = @(x) num2str(110 - length(x));
rtWarnCheck = '... warning-Check OK.';
rtSimOk = '...Simulation OK.';
rtNoOutput = '... has NO output!';
err=0.9; % margin of error between the Euromod Connector output and the EUROMOD output
savefig=0;

%__________________________________________________________________________
try
    constants = {["$ANWPY",""],'1000000#m'};

    obj=EM.countries('HR').systems('HR_2023');
    sim_const=run(obj,data, ID_DATASET, 'constants', constants);
    ss = summaryStatistics(sim_const.outputs{1}, 0);

    fileName = "data\hr_2023_const_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 0);

    if any(abs(ss-ss_true) > err)
        error('Results from "constantsToOverwrite" estimation discrepancy discrepancy > %0.3f! Check Summary Statistics in %s', err, file_const)
    else
        fprintf([lt, ' %', alignfun(lt), 's\n'], rtSimOk)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s\n %s', lt, ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
try
    obj=EM.countries('HR').systems('HR_2023');
    sim_base=run(obj,data, ID_DATASET);
    ss = summaryStatistics(sim_base.outputs{1}, 1);

    fileName = "data\hr_2023_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 1);

    if any(abs(ss-ss_true) > err)
        error('Results from "basline" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
        % else
        %     fprintf([lt, ' %', alignfun(lt), 's\n'], rtSimOk)
    end
    % plot([ss,ss_true])

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s\n %s', lt, ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
try
    obj=EM.countries('HR').systems('HR_2023');
    sim=run(obj, data, ID_DATASET, 'surpressOtherOutput',true);
    ss = summaryStatistics(sim.outputs{1}, 1);

    if any(abs(ss-ss_true) > err)
        error('Results from "basline" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
        % else
        %     fprintf([lt, ' %', alignfun(lt), 's\n'], rtSimOk)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s\n %s', lt, ME.message), ...
        'stack', ME.stack);
    error(errStruct)
end

%__________________________________________________________________________
try
    obj=copy(EM.countries('HR').systems('HR_2023'));

    setParameter(obj,"HR_2023", ID, "0");
    sim_setpar=run(obj, data, ID_DATASET);
    ss = summaryStatistics(sim_setpar.outputs{1}, 0);

    fileName = "data\hr_2023_tinref_std.txt";
    tru = readtable(fileName);
    ss_true = summaryStatistics(tru, 0);

    if any(abs(ss-ss_true) > err)
        warning('Results from "discrepancy" estimation discrepancy > %0.3f! Check Summary Statistics in %s', err, fileName)
    % else
    %     fprintf([lt, ' %', alignfun(lt), 's\n'], rtSimOk)
    end

catch ME
    errStruct = struct('identifier', ME.identifier, ...
        'message', sprintf('%s\n %s', lt, ME.message), ...
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

% level = 'idhh';
% 
% % weighted sum formula
% wsum = @(x,w) sum(x.*w);
% 
% % expenditeure side
% varnames = {'ils_ben', 'ils_b2_penhl', 'ils_b2_bfaed', 'ils_b1_bun'};
% legendnam = {'Total'; 'Pensions'; 'Fam.&Educ.'; 'Soc.Ass.&House'; 'Unemp.'};
% ann_tot_sum = zeros(length(varnames),2);
% 
% out1=sim_base.outputs{1};
% out2=sim_const.outputs{1};
% 
% % df2_ = out1(:,[level,varnames, "dwt"]);
% % idxT=df2(:,varnames)>0
% % df2_pos_ = df2(df2(:,varnames)>0,:);
% 
% for i = 1:length(varnames)
%     varname = varnames{i};
% 
%     % take positive data
%     df2 = out1(:,[level,varname, "dwt"]);
%     df2_pos = df2(df2.(varname)>0,:);
% 
%     df1 = out2(:,[level,varname, "dwt"]);
%     df1_pos = df1(df1.(varname)>0,:);
% 
%     % compute annual weighted total sums
%     G = findgroups(df2_pos.(level));
%     sumWeight2 = 12*sum(splitapply(wsum, df2_pos.(varname), df2_pos.dwt, G))/1000000;
% 
%     [G,varGroup] = findgroups(df1_pos.(level));
%     sumWeight1 = 12*sum(splitapply(wsum, df1_pos.(varname), df1_pos.dwt, G))/1000000;
% 
%     % store all
%     ann_tot_sum(i,:) = [sumWeight2, sumWeight1];
% end

% compute percent diffs
% ann_perc_diff = 100*(ann_tot_sum(:,2)-ann_tot_sum(:,1))./ann_tot_sum(:,1);


% ann_perc_diff = precentDifference(ann_tot_sum);

% legendnam = {'Total'; 'Pensions'; 'Fam.&Educ.'; 'Soc.Ass.&House'; 'Unemp.'};

%..........................................................................
pTitle={'Government expenditure on social transfers'; '(Yearly, mill. €)'};
pXlable = 'Expenditures';
pYlable = 'Millions of euros';
pXticklabel = {'Total'; 'Pensions'; 'Fam.&Educ.'; 'Soc.Ass.&House'; 'Unemp.'};
pLegend={'Baseline','Revised'};

plotBar(ann_tot_sum,'title',pTitle,'xlabel',pXlable,'ylabel',pYlable,...
    'xticklabel',pXticklabel,'legend',pLegend);

% fig = figure;
% hb = bar(ann_tot_sum);
% for i =1:size(ann_tot_sum,1)
%     text(i-0.25, max(ann_tot_sum(i,:)) + max(max(ann_tot_sum))*0.044,...
%         ['\Delta',num2str(round(ann_perc_diff(i),2)),'%'], ...
%         'FontWeight', 'bold', 'FontSize', 15)
% end
% title({'Government expenditure on social transfers'; '(Yearly, mill. €)'}, 'FontSize', 16)
% xlabel('Expenditures', 'FontSize', 13)
% ylabel('Millions of euros', 'FontSize', 13)
% hb(1).FaceColor = 'b';
% hb(2).FaceColor = 'y';
% set(gca,'xticklabel',legendnam, 'fontsize', 14, 'color', 'w', 'box','off')
% currentLabels = get(gca, 'XTickLabel');
% set(gca, 'XTickLabel', cellfun(@(a) ['\bf{' a '}'], currentLabels, 'UniformOutput',false));
% legend('Baseline','Revised')
% fig.Position = [100 100 800 500];
% if savefig
%     saveas(gcf,'GovExp.png')
% end


