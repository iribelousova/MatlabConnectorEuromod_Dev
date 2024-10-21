function out = summaryStatistics(data, displayOutput)

if nargin < 2
    displayOutput = 1;
end

%- summary statistics baseline/reform
level = 'idhh';
weightname = 'dwt';

% longnamTMI = ["Total market incomes",...
%     "...income from (self) employment",...
%     "...other sources"]';
% longnamGR = ["Government revenue through taxes and social insurance contributions",...
%     "...direct taxes", ...
%     "...employee social insurance contributions",...
%     "...self-employed social insurance contributions",...
%     "...other social insurance contributions",...
%     "...employer social insurance contributions (not part of disposable income)"]';
% longnamCSI="Credited social insurance contributions (not part of disposable income)";
% longnamGE =["Government expenditure on social transfers",...
%     "by target group",...
%         "...unemployment benefits",...
%         "...family and education benefits",...
%         "...social assistance and housing benefits",...
%         "...pensions, health and disability benefits",...
%         "...firms",...
%     "by benefit design",...
%         "...means-tested non-pension benefits",...
%         "...non-means-tested non-pension benefits",...
%         "...pensions",...
%         "...firms subsidies"];

longname = ["________________________________________________________________________",...
    "<strong>Total market incomes</strong>",...
    "________________________________________________________________________",...
    "...income from (self) employment",...
    "...other sources",...
    "________________________________________________________________________",...
"<strong>Government revenue through taxes and social insurance contributions</strong>",...
    "...direct taxes", ...
    "...employee social insurance contributions",...
    "...self-employed social insurance contributions",...
    "...other social insurance contributions",...
    "...employer social insurance contributions (not part of disposable income)",...
    "________________________________________________________________________",...
"<strong>Credited social insurance contributions (not part of disposable income)</strong>",...
"________________________________________________________________________",...
"<strong>Government expenditure on social transfers</strong>",...
"________________________________________________________________________",...
    "by target group",...
        "...unemployment benefits",...
        "...family and education benefits",...
        "...social assistance and housing benefits",...
        "...pensions, health and disability benefits",...
        "...firms",...
    "by benefit design",...
        "...means-tested non-pension benefits",...
        "...non-means-tested non-pension benefits",...
        "...pensions",...
        "...firms subsidies"]';

varnames = ["idhh", "dwt", "ils_origy", "ils_earns", "ils_tax", "ils_sicee",...
    "ils_sicse", "ils_sicot", "ils_sicer","ils_sicct","ils_ben","ils_b1_bun",...
    "ils_b2_bfaed","ils_b2_bsaho","ils_b2_penhl", "ils_benmt", "ils_bennt", "ils_pen"];

% funGet=@(t) (data(:, varnames));
% varnamTMI=["ils_origy","ils_earns"]
% 
% Nstrl = cellfun(@numel, longnam);
% padFun = @(k) [longnam{k}, char(32*ones(1,3+max(Nstrl) - Nstrl(k)))];
% vardescrPad = arrayfun(padFun, 1:numel(longnam) , 'un', 0) ; 
% clear longnam;


% varnames = {"", "", "inc_ot", "gov_rev", "ils_tax", "ils_sicee", "ils_sicse", "ils_sicot", "ils_sicer",...
%     "ils_sicct","ils_ben","ils_b1_bun","ils_b2_bfaed","ils_b2_bsaho","ils_b2_penhl", "ils_benmt", "ils_bennt", "ils_pen"};
% vardescr = cell2struct(vardescrPad, varnames, 2);


% df_gr1 = data(:, varnames);
% % Remove columns with all zeros
% idx = varfun(@(x) all(x==0), df_gr1,"OutputFormat","uniform");
% df_gr1 = df_gr1(:,~idx);
% vardescr = rmfield(vardescr, varnames(idx));
% varnames = varnames(~idx);
% 
% % %- compute weighted sums by household groups
% % WeightedSum1 = getByGroupWeightedSum(df_gr1, level, varnames, weightname);
% % %- compute total annual sums
% % ann_tot_sum = 12*nansum(WeightedSum1,1)/1000000;

ann_tot_sum=totalAnnualWeightedSum(data,'variables',varnames,'level',level);
varnames = varnames(3:end);
ann_tot_sum = ann_tot_sum(3:end);
inc_ot = -1*diff(ann_tot_sum(contains(varnames, {'ils_earns', 'ils_origy'})));
gov_rev = sum(ann_tot_sum(contains(varnames, {'ils_tax', 'ils_sicee', 'ils_sicse', 'ils_sicot', 'ils_sicer'})));

ann_tot_sum_=string(num2str(round(ann_tot_sum,2)));
vals=strings(size(longname,1),1);
vals(2)=ann_tot_sum_(ismember(varnames,"ils_origy"));
vals(4)=ann_tot_sum_(ismember(varnames,"ils_earns"));
vals(5)=string(num2str(round(inc_ot,2)));
vals(7)=string(num2str(round(gov_rev,2)));
vals(8:12)=ann_tot_sum_(ismember(varnames,["ils_tax", "ils_sicee",...
    "ils_sicse", "ils_sicot", "ils_sicer"]));
vals(14)=ann_tot_sum_(ismember(varnames,"ils_origy"));
vals(16)=ann_tot_sum_(ismember(varnames,"ils_ben"));
vals(19:22)=ann_tot_sum_(ismember(varnames,["ils_b1_bun",...
    "ils_b2_bfaed","ils_b2_bsaho","ils_b2_penhl"]));
vals(23)='0.00';
vals(25:27)=ann_tot_sum_(ismember(varnames,["ils_benmt", "ils_bennt", "ils_pen"]));
vals(28)='0.00';

if displayOutput
    longname_=arrayfun(@(t) regexprep(t,'</strong>',''),longname);
    longname_=arrayfun(@(t) regexprep(t,'<strong>',''),longname_);
    sLN = arrayfun(@(t) numel(char(t)),longname_);
    sVL = arrayfun(@(t) numel(char(t)),vals);
    sTT=max(sLN+sVL+1);
    bk=arrayfun(@(t) char(32*ones(1,sTT-sLN(t)-sVL(t))),1:numel(sLN),'UniformOutput',false)';
    idx=contains(longname,'_________________');
    longname(idx)=repmat('_',sum(idx),sTT);
    
    printTable=append(longname,bk,vals);
    
    fprintf('\nSummary Statistics - Default:\n%s\n',repmat('=',sTT,1))
    descr='Yearly, mill., currency as defined in EM output';
    fprintf('%s%s<strong>Amounts</strong>\n',descr, char(32*ones(1,sTT-numel(descr)-numel('Amounts'))))
    fprintf('%s<strong>(annual)</strong>\n', char(32*ones(1,sTT-numel('(Annual)'))))
    fprintf('%s\n',printTable)
end

out = cell2struct(num2cell(ann_tot_sum), varnames);
out.('inc_ot')=inc_ot;
out.('gov_rev')=gov_rev;

% Put in Table. Note: taking from 3rd variable on because removing 'idhh',
% and 'dwt'.
% varnames = varnames(3:end);
% ann_tot_sum = ann_tot_sum(3:end);

% inc_ot = -1*diff(ann_tot_sum(contains(varnames, {'ils_earns', 'ils_origy'})));
% ann_tot_sum = cell2struct(num2cell(ann_tot_sum), varnames);

% fprintf('\nSummary Statistics (total annual amounts):\n')
% disp('==============================================')
% fields = fieldnames(vardescr);
% out = nan(length(fields),1);
% for i = 1:length(fields)
%     if strcmp(fields{i},'inc_ot')
%         fprintf('  %s%0.2f\n', vardescr.inc_ot, inc_ot);
%         out(i,1) = inc_ot;
%     elseif strcmp(fields{i}, 'gov_rev')
%         fprintf('<strong>%s%0.2f</strong>\n', vardescr.gov_rev, gov_rev);
%         out(i,1) = gov_rev;
%     elseif any(contains({'ils_origy', 'ils_sicct', 'ils_ben'}, fields{i}))
%         fprintf('<strong>%s%0.2f</strong>\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
%         out(i,1) = ann_tot_sum.(fields{i});
%     else
%         fprintf('  %s%0.2f\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
%         out(i,1) = ann_tot_sum.(fields{i});
%     end
% end

% fields = fieldnames(vardescr);
% out = nan(length(fields),1);
% for i = 1:length(fields)
%     if strcmp(fields{i},'inc_ot')
%         out(i,1) = inc_ot;
%     elseif strcmp(fields{i}, 'gov_rev')
%         out(i,1) = gov_rev;
%     elseif any(contains({'ils_origy', 'ils_sicct', 'ils_ben'}, fields{i}))
%         out(i,1) = ann_tot_sum.(fields{i});
%     else
%         out(i,1) = ann_tot_sum.(fields{i});
%     end
% end
% 
% 
% 
% if displayOutput
%     fprintf('\nSummary Statistics (total annual amounts):\n')
%     disp('==============================================')
%     for i = 1:length(fields)
%         if strcmp(fields{i},'inc_ot')
%             fprintf('  %s%0.2f\n', vardescr.inc_ot, inc_ot);
%         elseif strcmp(fields{i}, 'gov_rev')
%             fprintf('<strong>%s%0.2f</strong>\n', vardescr.gov_rev, gov_rev);
%         elseif any(contains({'ils_origy', 'ils_sicct', 'ils_ben'}, fields{i}))
%             fprintf('<strong>%s%0.2f</strong>\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
%         else
%             fprintf('  ...%s%0.2f\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
%         end
%     end
% end

end