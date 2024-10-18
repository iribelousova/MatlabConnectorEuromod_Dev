classdef DynPropHandle < dynamicprops & handle
    % DynPropHandle - Hide the methods from the class dynamicprops
    
    methods (Access=protected, Hidden, Sealed)
        function p = displayScalarHandleToDeletedObject(varargin)
            p = displayScalarHandleToDeletedObject@dynamicprops(varargin{:});
        end
        % function p = displayEmptyObject(varargin)
        %     p = displayEmptyObject@dynamicprops(varargin{:});
        % end
        % function p = displayNonScalarObject(varargin)
        %     p = displayNonScalarObject@dynamicprops(varargin{:});
        % end
    end
    methods (Hidden)
        % function p = displayEmptyObject(varargin)
        %     p = displayEmptyObject@dynamicprops(varargin{:});
        % end
        function p = addprop(varargin)
            p = addprop@dynamicprops(varargin{:});
        end
        function p = addlistener(varargin)
            p = addlistener@handle(varargin{:});
        end
        function notify(varargin)
            notify@handle(varargin{:});
        end
        function delete(varargin)
            delete@handle(varargin{:});
        end
        function p = findobj(varargin)
            p = findobj@handle(varargin{:});
        end
        function p = findprop(varargin)
            p = findprop@handle(varargin{:});
        end
        function p = eq(varargin)
            p = eq@handle(varargin{:});
        end
        function p = ne(varargin)
            p = ne@handle(varargin{:});
        end
        function p = lt(varargin)
            p = lt@handle(varargin{:});
        end
        function p = le(varargin)
            p = le@handle(varargin{:});
        end
        function p = gt(varargin)
            p = gt@handle(varargin{:});
        end
        function p = ge(varargin)
            p = ge@handle(varargin{:});
        end
        function p = listener(varargin)
            p = listener@handle(varargin{:});
        end
    end
    %    methods (Hidden = true)
    %        function p = isvalid(varargin)
    %          p = isvalid@handle(varargin{:});
    %        end
    %     end
    
end