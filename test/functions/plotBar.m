function plotBar(data,varargin)

% title (1,M) string, cell. Title of the plot.
% xlable (1,M) string, cell. Label of the X axis
% ylable (1,M) string, cell. Label of the Y axis
% xticklabel (1,M) string, cell. Labels of the ticks on the X axis
% legend (1,M) string. Labels of the legend.
% saves (1,1) string. Name of saving figure file (with extension).

% pTitle={'Government expenditure on social transfers'; '(Yearly, mill. €)'};
% pXlable = 'Expenditures';
% pYlable = 'Millions of euros';
% pXticklabel = {'Total'; 'Pensions'; 'Fam.&Educ.'; 'Soc.Ass.&House'; 'Unemp.'};
% pLegend=string({'Baseline','Revised'});


idx=cellfun(@(t) isstring(t) || ischar(t) || iscell(t), varargin);
optArgs=varargin(idx);

pTitle = "";
pXlable = "";
pYlable = "";
pXticklabel="";
pLegend="";
savefig=0;

idx=cellfun(@(t) contains('title',t),optArgs);
if any(idx)
    pTitle = optArgs{find(idx)+1};
end
idx=cellfun(@(t) contains('xlabel',t),optArgs);
if any(idx)
    pXlable = optArgs{find(idx)+1};
end
idx=cellfun(@(t) contains('ylabel',t),optArgs);
if any(idx)
    pYlable = optArgs{find(idx)+1};
end
idx=cellfun(@(t) contains('xticklabel',t),optArgs);
if any(idx)
    pXticklabel = optArgs{find(idx)+1};
end
idx=cellfun(@(t) contains('legend',t),optArgs);
if any(idx)
    pLegend = string(optArgs{find(idx)+1});
end
idx=cellfun(@(t) contains('saveas',t),optArgs);
if any(idx)
    pSaveName = string(optArgs{find(idx)+1});
    savefig=1;
end

perDiff = precentDifference(data);

fig = figure;
hb = bar(data);
for i =1:size(data,1)
    text(i-0.25, max(data(i,:)) + max(max(data))*0.044,...
        ['\Delta',num2str(round(perDiff(i),2)),'%'], ...
        'FontWeight', 'bold', 'FontSize', 15)
end
title(pTitle, 'FontSize', 16)
xlabel(pXlable, 'FontSize', 13)
ylabel(pYlable, 'FontSize', 13)
hb(1).FaceColor = 'b';
hb(2).FaceColor = 'y';
set(gca,'xticklabel',pXticklabel, 'fontsize', 14, 'color', 'w', 'box','off')
currentLabels = get(gca, 'XTickLabel');
set(gca, 'XTickLabel', cellfun(@(a) ['\bf{' a '}'], currentLabels, 'UniformOutput',false));
legend(pLegend)
fig.Position = [100 100 800 500];
if savefig
    saveas(gcf,pSaveName)
end

end