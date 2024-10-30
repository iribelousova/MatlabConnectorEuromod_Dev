function doc(topic)

    my_topics = {
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

    for i = 1 : size(my_topics, 1)
        if strcmpi(topic, my_topics{i, 1})      
            web(my_topics{i, 2}, '-helpbrowser');
            return;
        end
    end

    % Fall back to MATLAB's doc. Note that our doc shadows MATLAB's doc.
    docs = which('doc', '-all');
    old_dir = cd();
    c = onCleanup(@() cd(old_dir));
    cd(fileparts(docs{2}));
    doc(topic); 
end