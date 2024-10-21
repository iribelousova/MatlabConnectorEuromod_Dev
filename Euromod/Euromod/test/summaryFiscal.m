function summaryFiscal

function out = summaryStatistics(data, displayOutput)

if nargin < 2
    displayOutput = 1;
end

%- summary statistics baseline/reform
level = 'idhh';
weightname = 'dwt';

longnam = {'Total market incomes', 'Income from (self) employment', 'Other market incomes',...
    'Government revenue through taxes and social insurance contributions',...
    'Direct taxes', 'Employee social insurance contributions',...
    'Self-employed social insurance contributions', 'Other social insurance contributions', ...
    'Employer social insurance contributions', 'Credited social insurance contributions',...
    'Government expenditure on social transfers', 'Unemployment benefits', 'Family and education benefits',...
    'Social assistance and housing benefits', 'Pensions, health and disability benefits', 'Means-tested non-pension benefits',...
    'Non-means-tested non-pension benefits', 'Pensions'};

Nstrl = cellfun(@numel, longnam);
padFun = @(k) [longnam{k}, char(32*ones(1,3+max(Nstrl) - Nstrl(k)))];
vardescrPad = arrayfun(padFun, 1:numel(longnam) , 'un', 0) ; 
clear longnam;


varnames = {'ils_origy', 'ils_earns', 'inc_ot', 'gov_rev', 'ils_tax', 'ils_sicee', 'ils_sicse', 'ils_sicot', 'ils_sicer',...
    'ils_sicct','ils_ben','ils_b1_bun','ils_b2_bfaed','ils_b2_bsaho','ils_b2_penhl', 'ils_benmt', 'ils_bennt', 'ils_pen'};
vardescr = cell2struct(vardescrPad, varnames, 2);

varnames = {'idhh', 'dwt', 'ils_origy', 'ils_earns', 'ils_tax', 'ils_sicee', 'ils_sicse', 'ils_sicot', 'ils_sicer',...
    'ils_sicct','ils_ben','ils_b1_bun','ils_b2_bfaed','ils_b2_bsaho','ils_b2_penhl', 'ils_benmt', 'ils_bennt', 'ils_pen'};

df_gr1 = data(:, varnames);
% Remove columns with all zeros
idx = varfun(@(x) all(x==0), df_gr1,"OutputFormat","uniform");
df_gr1 = df_gr1(:,~idx);
vardescr = rmfield(vardescr, varnames(idx));
varnames = varnames(~idx);

% %- compute weighted sums by household groups
% WeightedSum1 = getByGroupWeightedSum(df_gr1, level, varnames, weightname);
% %- compute total annual sums
% ann_tot_sum = 12*nansum(WeightedSum1,1)/1000000;

ann_tot_sum=totalAnnualWeightedSum(df_gr1,'variables',varnames,'level',level);

% Put in Table. Note: taking from 3rd variable on because removing 'idhh',
% and 'dwt'.
varnames = varnames(3:end);
ann_tot_sum = ann_tot_sum(3:end);
gov_rev = sum(ann_tot_sum(contains(varnames, {'ils_tax', 'ils_sicee', 'ils_sicse', 'ils_sicot', 'ils_sicer'})));
inc_ot = -1*diff(ann_tot_sum(contains(varnames, {'ils_earns', 'ils_origy'})));
ann_tot_sum = cell2struct(num2cell(ann_tot_sum), varnames);

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

fields = fieldnames(vardescr);
out = nan(length(fields),1);
for i = 1:length(fields)
    if strcmp(fields{i},'inc_ot')
        out(i,1) = inc_ot;
    elseif strcmp(fields{i}, 'gov_rev')
        out(i,1) = gov_rev;
    elseif any(contains({'ils_origy', 'ils_sicct', 'ils_ben'}, fields{i}))
        out(i,1) = ann_tot_sum.(fields{i});
    else
        out(i,1) = ann_tot_sum.(fields{i});
    end
end



if displayOutput
    fprintf('\nSummary Statistics (total annual amounts):\n')
    disp('==============================================')
    for i = 1:length(fields)
        if strcmp(fields{i},'inc_ot')
            fprintf('  %s%0.2f\n', vardescr.inc_ot, inc_ot);
        elseif strcmp(fields{i}, 'gov_rev')
            fprintf('<strong>%s%0.2f</strong>\n', vardescr.gov_rev, gov_rev);
        elseif any(contains({'ils_origy', 'ils_sicct', 'ils_ben'}, fields{i}))
            fprintf('<strong>%s%0.2f</strong>\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
        else
            fprintf('  ...%s%0.2f\n', vardescr.(fields{i}), ann_tot_sum.(fields{i}));
        end
    end
end

end

end