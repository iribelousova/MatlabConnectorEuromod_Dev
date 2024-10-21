function x = precentDifference(data)

% data : (N,2) double. Where rows N stand for variables and columns N stand
% for datasets .

x = 100*(data(:,2)-data(:,1))./data(:,1);

end