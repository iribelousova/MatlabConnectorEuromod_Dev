function doc(varargin)

if nargin == 0
    allTopics={};
else
    allTopics = {
        'Model', 'doc/euromod/cla/Euromod.html'
        'Country', 'doc/euromod/cla/Country.html'
        'Dataset', 'doc/euromod/cla/Dataset.html'
        'DatasetInSystem', 'doc/euromod/cla/DatasetInSystem.html'
        'Extension', 'doc/euromod/cla/Extension.html'
        'ExtensionSwitch', 'doc/euromod/cla/ExtensionSwitch.html'
        'Function', 'doc/euromod/cla/Function.html'
        'FunctionInSystem', 'doc/euromod/cla/FunctionInSystem.html'
        'Parameter', 'doc/euromod/cla/Parameter.html'
        'ParameterInSystem', 'doc/euromod/cla/ParameterInSystem.html'
        'Policy', 'doc/euromod/cla/Policy.html'
        'PolicyInSystem', 'doc/euromod/cla/PolicyInSystem.html'
        'ReferencePolicy', 'doc/euromod/cla/ReferencePolicy.html'
        'Simulation', 'doc/euromod/cla/Simulation.html'
        'System', 'doc/euromod/cla/System.html'
        'info', 'doc/euromod/cla/info.html'
        'run', 'doc/euromod/cla/run.html'
        };
end

for i = 1 : size(allTopics, 1)
    if strcmpi(varargin{:}, allTopics{i, 1})
        web(allTopics{i, 2}, '-helpbrowser');
        return;
    end
end

docs = which('doc', '-all');
cleanDir = cd();
c = onCleanup(@() cd(cleanDir));
cd(fileparts(docs{2}));
doc(varargin{:});
end