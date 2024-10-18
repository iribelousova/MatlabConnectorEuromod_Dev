function values = convert1E(obj,varargin)
% c# of type 'System.Linq.OrderedEnumerable<System*String,System*String>'

IEnumerable = NET.explicitCast(obj,'System.Collections.IEnumerable');
IEnumerable.GetEnumerator;

x = IEnumerable.GetEnumerator;
IEnumerator = NET.explicitCast(x,'System.Collections.IEnumerator');

values = "";
while (IEnumerator.MoveNext)
    values(end+1) = string(IEnumerator.Current);
end
values=values(2:end)';

end