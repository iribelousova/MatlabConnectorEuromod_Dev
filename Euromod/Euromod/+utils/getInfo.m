function [values,keys]=getInfo(obj,varargin)

if isa(obj,'System.Collections.Generic.Dictionary<System*String,System*Collections*Generic*Dictionary<System*String,System*String>>')
    [values,keys]=utils.convert2D(obj,varargin{:});
elseif isa(obj,'System.Collections.Generic.Dictionary<System*String,System*String>')
    [values,keys]=utils.convert1D(obj,varargin{:});
elseif isa(obj,'System.Linq.OrderedEnumerable<System*String,System*String>')
    values=utils.convert1E(obj,varargin{:});
    keys=[];
elseif contains(class(obj),'EM_XmlHandler.CountryInfoHandler+<GetSysYearCombinations>')
    values=utils.convert2E(obj,varargin{:});
    keys=[];
elseif contains(class(obj),'EM_XmlHandler.CountryInfoHandler+<GetPiecesOfInfo>')
    values=utils.convert1E(obj,varargin{:});
    keys=[];
    % [values,keys]=utils.convert2D(obj,varargin{:});
    % [values,keys]=utils.convert1D(obj,varargin{:});
    % values=utils.convert1E(obj,varargin{:});
    % keys=[];
elseif isa(obj,'System.Collections.Generic.List<System*Collections*Generic*Dictionary<System*String,System*String>>')
    values=utils.convert2E(obj,varargin{:});
    keys=[];
end

end