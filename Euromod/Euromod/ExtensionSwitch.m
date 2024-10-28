classdef ExtensionSwitch < Core
% ExtensionSwitch - A class containing the extension switches of an object.
% 
% Syntax:
% 
%     E = ExtensionSwitch(Parent);
% 
% Description:
%     This class instantiates the EUROMOD extensions (Model and/or ...
%     Country extensions). Class instances are automatically generated
%     and stored in the attribute extensions of the base class Model
%     (including the Model extensions only), as well as of the Country
%     class (including both the Model and Country-specific extensions).
% 
% ExtensionSwitch Arguments:
%     Parent    - The Country class or any other class containing the
%                 'extensions' attribute with information about the 
%                 switches (i.e. Policy, Function, Parameter, 
%                 PolicyInSystem, FunctionInSystem, ParameterInSystem).
% 
%  ExtensionSwitch Properties:
%   ... when the parent object is the Country class:
%     ID        - Identifier number of the extension.
%     name      - Long name of the extension.
%     parent    - The model base class or the Country class.
%     shortName - Short name of the extension.
% 
%  Example:
%     mod = euromod('C:\EUROMOD_RELEASES_I6.0+');
%     mod.('AT').extensions % displays the default model and country extensions for Austria.
%     mod.('AT').extensions(3) % displays the specific Extension for Austria.
% 
% See also Model, Country, Extension, local_extensions, info, run.

    properties (Access=public) 
        % baseOff (1,1) string
        extensionID (1,1) string
        % name (1,1) string
        % shortName (1,1) string
    end

    properties (Hidden=true) 
        index (:,1) double
        indexArr (:,1) double
        parent
        Info struct
    end

    properties (Constant,Hidden)
        tag = char(EM_XmlHandler.TAGS.EXTENSION)
    end

    methods (Static, Access = public)
        %==================================================================
        function obj = empty(varargin)
            %
            % Example:
            %
            % Empty the second element in the object
            % obj(2)=obj(2).empty
            % Empty the third element in the object
            % obj = obj.empty(3)

            if nargin == 0
                obj = ExtensionSwitch;
                return;
            end

            if nargin >= 1
                idx = [varargin{:}];
                obj(idx) = ExtensionSwitch;
            end
        end
    end
    methods
        %==================================================================
        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = size(obj.index,varargin{:});
        end
        %==================================================================
        function varargout = ndims(obj,varargin)
            [varargout{1:nargout}] = ndims(obj.index,varargin{:});
        end
        %==================================================================
        function ind = end(obj,m,n)
            S = numel(obj.indexArr);
            if m < n
                ind = S(m);
            else
                ind = prod(S(m:end));
            end
        end
        %==================================================================
        function x = getID(obj)

            cobj=copy(obj.getParent("COUNTRY"));

            ID1=cobj.extensions(1:end).ID;
            x=ID1;
        end
        %==================================================================
        function obj = ExtensionSwitch(Parent)

            if nargin == 0
                return;
            end

            if isa(Parent,'Country')
                P=obj.addprop('dataID');
                P.NonCopyable = false;

                P=obj.addprop('data_name');
                P.NonCopyable = false;

                P=obj.addprop('extension_name');
                P.NonCopyable = false;

                P=obj.addprop('sysID');
                P.NonCopyable = false;

                P=obj.addprop('sys_name');
                P.NonCopyable = false;

                P=obj.addprop('value');
                P.NonCopyable = false;
            else
                % P=obj.addprop('baseOff');
                % P.NonCopyable = false;
                % 
                % P=obj.addprop('name');
                % P.NonCopyable = false;
                % 
                % P=obj.addprop('shortName');
                % P.NonCopyable = false;
                % 
                % % add the dynamic property to class ExtensionSwitch
                % newProp=Parent.tag_s_(Parent.tag,'ID');
                % newProp=[lower(newProp(1)),newProp(2:end)];
                % 
                % P=obj.addprop(newProp);
                % P.NonCopyable = false;
                % 
                % % props do not support validation
                % % obj.(newProp) = string;
            end

            if isempty(Parent)
                return;
            end

            obj.load(Parent);
        end
        %==================================================================
        function obj = load(obj, parent)
            if isa(parent,'Country')
                obj.loadFromCountryClass(parent);
            else
                obj.loadFromSubClass(parent);
            end
        end
        %==================================================================
        function [values,keys]=getOtherProperties(obj,name,index)
            if isa(obj.parent,'Country')
                [values,keys]=obj.getOtherPropertiesCountry(name,index);
            else
                [values,keys]=obj.getOtherPropertiesSubClass(name,index);
            end
        end
        %==================================================================
        function x=headerComment(obj)
            if isa(obj.parent,'Country')
                x=obj.headerCommentCountry();
            else
                x=obj.headerCommentSubClass();
            end
        end
        %==================================================================
        function obj = loadFromCountryClass(obj, parent)
        end
        %==================================================================
        function [values,keys]=getOtherPropertiesCountry(obj,name,index)
        end
        %==================================================================
        function obj = headerCommentCountry(obj, parent)
        end
        % %==================================================================
        % function obj = loadFromSubClass(obj, parent)
        % 
        %     % set parent
        %     obj.parent=copy(parent);
        %     obj.parent.indexArr=obj.parent.index;
        %     obj.parent=obj.parent.update(obj.parent.index);
        % 
        %     % add the dynamic property to class ExtensionSwitch
        %     newProp=obj.tag_s_(parent.tag,'ID');
        %     newProp=[lower(newProp(1)),newProp(2:end)];
        %     props=string(properties(obj));
        %     if ~ismember(newProp,props)
        %         P=obj.addprop(newProp);
        %         P.NonCopyable = false;
        %         % obj.(newProp) = string;
        %     end
        % 
        %     % define tag 
        %     if isa(parent,'Policy') || isa(parent,'ReferencePolicy') || isa(parent,'PolicyInSystem')
        %         TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,Policy.tag));
        %     else
        %         TAG=EM_XmlHandler.ReadCountryOptions.(obj.tag_s_(obj.tag,parent.tag));
        %     end
        % 
        %     % get current object and parent object IDs
        %     IDs=obj.getID();
        %     if contains(class(obj.parent),'InSystem')
        %         tagID=obj.tag_s_(obj.parent.tag,'ID');
        %         tagID=[lower(tagID(1)),tagID(2:end)];
        %     else
        %         tagID='ID';
        %     end
        %     parentID=obj.parent.(tagID);
        % 
        %     % set handler
        %     [obj,out]=obj.getPieceOfInfo(IDs,parentID,TAG);
        % 
        %     % set index
        %     if  numel(fieldnames(obj.Info.PieceOfInfo))==0
        %         obj=ExtensionSwitch;
        %     else
        %         obj.indexArr = 1:numel(obj.Info.PieceOfInfo);
        %         obj.index=obj.indexArr;
        % 
        %         if numel(obj.indexArr)==1
        %             obj.update(obj.index);
        %         end                
        %     end
        % end
        % %==================================================================
        % function [values,keys]=getOtherPropertiesSubClass(obj,name,index)
        % 
        %     N=size(obj,1);
        %     name=string(name);
        %     name = append(upper(extractBefore(name,2))',extractAfter(name,1)');
        %     keys=name;
        %     values=strings(numel(name),N);
        % 
        %     IDs = strings(1,N);
        % 
        %     cobj=obj.getParent('COUNTRY');
        %     for i=1:N
        %         idx=obj.index(i);
        %         [v,k]=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,name);
        %         if ismember('ID',k)
        %             % IDs(i)=v(ismember(k,'ID'),:);
        %             ID=v(ismember(k,'ID'),:);
        %         else
        %             % IDs(i)=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,'ExtensionID');
        %             ID=utils.getInfo(obj.Info.PieceOfInfo(idx).Handler,'ExtensionID');
        %         end
        %         % keys=[keys;k(~ismember(k,keys))];
        %         values = utils.setValueByKey(values,keys,v,k,i);
        % 
        %         try
        %             [v,k]=utils.getInfo(cobj.extensions.Info.Handler,ID,name);
        %             values = utils.setValueByKey(values,keys,v,k);
        %         catch
        %         end
        %         try
        %             [v,k]=utils.getInfo(cobj.parent.extensions.Info.Handler,ID,name);
        %             values = utils.setValueByKey(values,keys,v,k,i);
        %         catch
        %         end
        %     end
        % 
        %     keys = append(lower(extractBefore(keys,2))',extractAfter(keys,1)');
        %     if any(contains(keys,'iD'))
        %         keys(contains(keys,'iD'))='ID';
        %     end
        % end
        %==================================================================
        function x=headerCommentSubClass(obj)
            % x=obj.headerComment_Type1();

            N=size(obj,1);
            x=obj.getOtherProperties({'name','baseOff','comment'},1:N)';
            % x=obj(:).baseOff;
            x(strcmp(x,'true'))='off';
            x(strcmp(x,'false'))='on';
        end
    end
end

