function c = class_counter(flag)
% class_counter - Count the number of times a class object is called.
%   Used in Euromod.m and Simulation.m to create iterative simulation names.
%
% Input Arguments:
%   flag - bool. Use "true" to initialize counting (e.g. in Euromod.m), use
%     "false" to count the number of times a class (e.g. Simulation.m) is 
%     called.
%
% Output Arguments:
%   c - double. Number of times a class object (e.g. Simulation) is called.
%
% See also assembly, configuration, Country, TaxSystem, Simulation

persistent class_count

if flag
    class_count = -1;
elseif isempty(class_count)
    class_count = 0;
end
class_count = class_count + 1;
c = class_count;

end