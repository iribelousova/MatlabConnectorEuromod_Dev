function [values,keys]=getInfo(obj,varargin)

if isa(obj,'System.Collections.Generic.Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>')
    [values,keys]=utils.convert2D(obj,varargin{:});
elseif isa(obj,'System.Collections.Generic.Dictionary<System*String,System*String>')
    [values,keys]=utils.convert1D(obj,varargin{:});
elseif isa(obj,'System.Linq.OrderedEnumerable<System*String,System*String>')
    values=utils.convert1E(obj,varargin{:});
    keys=[];
elseif isa(obj,'EM_XmlHandler.CountryInfoHandler+<GetSysYearCombinations>d__34')
    values=utils.convert2E(obj,varargin{:});
    keys=[];
end

end