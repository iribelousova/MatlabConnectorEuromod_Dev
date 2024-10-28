function values=convert2E(obj)
% c# class 'EM_XmlHandler.CountryInfoHandler+<GetSysYearCombinations>d__34'

% IEnumerable = NET.explicitCast(obj,'System.Collections.IEnumerable');
% IEnumerable.GetEnumerator;
IEnumerator = NET.explicitCast(obj,'System.Collections.IEnumerator');

values="";
j=1;
while (IEnumerator.MoveNext)
    Items = IEnumerator.Current;
    count=1;
    i=1;
    while count
        try
            values(j,i)=Items.(['Item',num2str(i)]);
            i=i+1;
        catch
            count=0;
        end
    end
    j=j+1;
end

end