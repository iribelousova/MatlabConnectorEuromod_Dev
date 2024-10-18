function x=totalAnnualWeightedSum(varargin)
% out1=sim_base.outputs{1};
% out2=sim_const.outputs{1};
%
% Example:
% variables = {'ils_ben', 'ils_b2_penhl', 'ils_b2_bfaed', 'ils_b1_bun'};
% level = 'idhh';
% x=weightedSum(table1, table2, table3,..., 'variables',variables,'level',level)

% arguments (Repeating)
%     data (:,:) table
% end
%
% arguments
%     variables (1,:) string
% end


idx=cellfun(@istable, varargin);
datasets=varargin(idx);
N=numel(datasets);

idx=cellfun(@(t) isstring(t) || ischar(t) || iscell(t), varargin);
optArgs=varargin(idx);

idx=cellfun(@(t) contains('variables',t),optArgs);
if any(idx)
    variables = string(optArgs{find(idx)+1});
else
    variables = [];
end

idx=cellfun(@(t) contains('level',t),optArgs);
% idx=ismember(optArgs,'level');
if any(idx)
    level = string(optArgs{find(idx)+1});
else
    level = 'idhh';
end


% weighted sum formula
wsum = @(x,w) sum(x.*w);

x = zeros(length(variables),N);
for i = 1:length(variables)
    varname = variables{i};

    for j=1:N

        % take positive data
        df = datasets{j}(:,[level,varname, "dwt"]);
        df_pos = df(df.(varname)>0,:);

        % compute weighted total sums
        G = findgroups(df_pos.(level));
        sumWeight = 12*sum(splitapply(wsum, df_pos.(varname), df_pos.dwt, G))/1000000;

        % store all
        x(i,j) = sumWeight;

    end
end

end