% mod=struct()
% mod.model=struct();
% mod.model.CIH=EM_XmlHandler.CountryInfoHandler("C:\EUROMOD_RELEASES_I6.0+", 'BE')
% mod.tag=char(EM_XmlHandler.TAGS.POL)
% ff=Function(mod,'ba790a98-7346-4ab3-806b-d944ca5ca77e')
% ID='008745fd-3c9b-4ff3-9ce2-e34ab93dae36';

% modelpath= "C:\EUROMOD_RELEASES_I6.0+";
% mod = struct();
% mod.modelpath=modelpath;
% mod.modelInfoHandler = EM_XmlHandler.ModelInfoHandler(modelpath);
% mod.emCommon = EM_Common.EMPath(modelpath, true);
% cc=Country(mod,'BE')

classdef Extension < Core 
    properties (Access=public,Hidden) %(Access={?utils.redefinesparen,?utils.dict2Prop}) 
        % model
        index (:,1) double
        indexArr (:,1) double
        parent 
        Info struct

    end

    properties (Constant,Hidden) 
        % tag = char(EM_XmlHandler.ReadModelOptions.EXTENSIONS)
        tag = char(EM_XmlHandler.ReadModelOptions.('EXTENSIONS'))
        tagLocal = char(EM_XmlHandler.ReadCountryOptions.LOCAL_EXTENSION)
    end

    properties (Access=public) 
        ID (1,1) string
        name (1,1) string
        shortName (1,1) string
    end

    methods (Static, Access = public)
        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = Extension;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = Extension;
            end

        end
    end


    methods

        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end

        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end

        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        
        function obj = Extension(Parent)

            % obj.comment = 'Comment about the specific policy.';
            % obj.extensions = 'A list of policy-specific Extension objects.';
            % % obj.parameters = 'A list with FunctionInSystem objects specific to the system.';
            % obj.ID = 'Identifier number';
            % obj.name = 'Long name';
            % obj.order = 'Order in the policy spine.';
            % obj.polID = 'Short name';
            % obj.spineOrder = 'Order of the policy in the spine.';


            if nargin == 0
                return;
            end

            if isempty(Parent)
                return;
            end

            obj.parent=copy(Parent);

            if isa(Parent,'Model')
                obj.Info(1).Handler = obj.parent.Info.Handler.GetModelInfo(...
                    EM_XmlHandler.ReadModelOptions.(obj.tag));
    
                obj.indexArr = 1:obj.Info.Handler.Count;
                obj.index=obj.indexArr;
            elseif isa(Parent,'Country')
                obj.parent.indexArr=obj.parent.index;
                Idx=obj.parent.index;
    
                % set handler
                Tag=EM_XmlHandler.ReadCountryOptions.(obj.tagLocal);
                obj.Info(1).Handler = obj.parent.Info(Idx).Handler.GetTypeInfo(Tag);
         
                % set index
                obj.indexArr = 1:obj.Info.Handler.Count+obj.parent.parent.extensions.Info.Handler.Count;
                obj.index=obj.indexArr;
            end

            % obj.load(Model);

        end


        % function obj = load(obj, parent)
        % 
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        % 
        %     obj.Info(1).Handler = obj.parent.Info.Handler.GetModelInfo(...
        %         EM_XmlHandler.ReadModelOptions.(obj.tag));
        % 
        %     obj.indexArr = 1:obj.Info.Handler.Count;
        %     obj.index=obj.indexArr;
        % end

        function [values,keys] =getOtherProperties(obj,name,index)

            if isa(obj.parent,'Model')
                [values,keys] = obj.getOtherPropertiesModel(name,index);
            elseif isa(obj.parent,'Country')
                [values,keys] = obj.getOtherPropertiesCountry(name,index);
            end

        end

        function [values,keys] =getOtherPropertiesModel(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            [values,keys]=utils.getInfo(obj.Info.Handler,obj.index,name);
            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end

            values(strcmp(keys,"look"),:) = [];
            keys(strcmp(keys,"look")) = [];

        end

        function [values,keys]=getOtherPropertiesCountry(obj,name,index)
            name=string(name);
            name = append(upper(extractBefore(name,2))',extractAfter(name,1)');

            values=strings(numel(name),size(obj,1));
            keys=name;

            % get index for local extensions
            idx=ismember(obj.index,1:obj.Info.Handler.Count);
            if sum(idx)==obj.Info.Handler.Count
                idxLocalVal=obj.index(idx);
                idxLocal=obj.index(idx);
            elseif sum(idx)<obj.Info.Handler.Count && sum(idx)~=0
                idxLocal=obj.index(idx);
                idxLocalVal=1:sum(idx);
            elseif sum(idx)==0
                idxLocal=[];
            end

            % get index for model extensions
            idx=~ismember(obj.index,idxLocal);
            if sum(idx)==obj.parent.parent.extensions.Info.Handler.Count
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
            elseif sum(idx)<obj.parent.parent.extensions.Info.Handler.Count && sum(idx)~=0
                idxModelVal=obj.index(idx);
                idxModel=idxModelVal-double(obj.Info.Handler.Count);
                if isempty(idxLocal)
                    ini=0;
                else
                    ini=idxLocalVal;
                end
                idxModelVal=ini+1:sum(idx)+ini;
            elseif sum(idx)==0
                idxModel=[];
            end

            % try get info from country extensions
            if ~isempty(idxLocal)
                [v,k]=utils.getInfo(obj.Info.Handler,idxLocal,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxLocalVal);
            end

            % try get info from model extensions
            if ~isempty(idxModel)
                [v,k]=utils.getInfo(obj.parent.parent.extensions.Info.Handler,idxModel,name);
                keys=[keys;k(~ismember(k,keys))];
                values = utils.setValueByKey(values,keys,v,k,idxModelVal);
            end

            keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
            if any(contains(keys,'iD'))
                keys(contains(keys,'iD'))='ID';
            end
        end


        function x=headerComment(obj)
            x=obj.headerComment_Type1(["shortName","name"]);
        end

        % function x=headerComment(obj)
        %     x=obj.headerComment_Type1();
        % end

       
    end

end