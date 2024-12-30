function mltbxcreator(soptions,options)

% Input Arguments:
%-----------------%

arguments
    soptions = struct;
end

arguments
    options.InstallToolbox logical
    options.ToolboxVersion (1,1) string
    options.ToolboxName (1,1) string

    options.AuthorName (1,1) string
    options.AuthorEmail (1,1) string
    options.AuthorCompany (1,1) string

    options.Summary (1,1) string
    options.Description (1,1) string

    options.ToolboxFolder (1,1) string
    options.OutputFile (1,1) string
    options.ToolboxGettingStartedGuide (1,1) string
    options.ToolboxImageFile (1,1) string
    options.ProjectFile (1,1) string

    options.SupportedPlatforms struct

    options.MinimumMatlabRelease (1,1) string
    options.MaximumMatlabRelease (1,1) string

    options.Identifier (1,1) string
    options.DEFAULT_FILE_EXCLUSIONS (1,:) string

    options.RequiredAdditionalSoftware struct
    options.RequiredAddons struct

end

defaultOptions = metadata;

% update "options" if user provided a structure instead of Name-Value
% argument
if numel(fieldnames(soptions))>0
    options=soptions;
end

if ~isfield(options,'InstallToolbox')
    options.InstallToolbox = defaultOptions.InstallToolbox;
end
if ~isfield(options,'ProjectFile')
    options.ProjectFile = defaultOptions.ProjectFile;
end
if ~isfield(options,'ToolboxFolder')
    options.ToolboxFolder = defaultOptions.ToolboxFolder;
end
if ~isfield(options,'Identifier')
    options.Identifier = defaultOptions.Identifier;
end
if ~isfield(options,'DEFAULT_FILE_EXCLUSIONS')
    options.DEFAULT_FILE_EXCLUSIONS=defaultOptions.DEFAULT_FILE_EXCLUSIONS;
end

%--------------------------------------------------------------------------
if exist(options.ProjectFile,'file')==2
    %-- load Project from project file
    %{
        In your .prj project file, when declaring options in "Exclude files
        and folders" tab, make sure not to leave empty lines.
    %}
    Project = matlab.addons.toolbox.ToolboxOptions(options.ProjectFile);

    %-- Update Project with user options
    f=fieldnames(options);
    % fProject=fieldnames(struct(Project));
    fProject=fieldnames(Project);
    for i=1:numel(f)
        if any(ismember(fProject,f{i})) && ~strcmp(f{i},'ToolboxFolder')...
                && ~strcmp(f{i},'Identifier')
            if ~isequal(Project.(f{i}),options.(f{i}))
                Project.(f{i})=options.(f{i});
            end
        end
    end

else
    % load Project from toolbox repository
    Project = matlab.addons.toolbox.ToolboxOptions(options.ToolboxFolder, options.Identifier);

    %-- Update Project with user options
    % fProject=fieldnames(struct(Project));
    fProject=fieldnames(Project);
    for i=1:numel(fProject)
        if ~strcmp(fProject{i},'ToolboxFolder')...
                && ~strcmp(fProject{i},'Identifier')
            if isfield(options,fProject{i})
                op=options.(fProject{i});
            elseif isfield(defaultOptions,fProject{i})
                op=defaultOptions.(fProject{i});
            else
                op=Project.(fProject{i});
            end
            if ~isequal(Project.(fProject{i}),op)
                Project.(fProject{i})=op;
            end
        end
    end

    for i=1:numel(options.DEFAULT_FILE_EXCLUSIONS)
        rm = strrep(options.DEFAULT_FILE_EXCLUSIONS(i),'*','');
        rm=strrep(rm,'/','\');
        idx=contains(Project.ToolboxFiles,rm);
        if any(idx)
            Project.ToolboxFiles = Project.ToolboxFiles(~idx);
        end
        idx=contains(Project.ToolboxMatlabPath,rm);
        if any(idx)
            Project.ToolboxMatlabPath = Project.ToolboxMatlabPath(~idx);
        end
    end

end

if ~isfield(options,'OutputFile')
    Project.OutputFile = fullfile(pwd,'bin', Project.ToolboxName+'.mltbx');
end

%-- set paths & files
docFolder = fileparts(Project.ToolboxGettingStartedGuide);
outputFolder = fileparts(Project.OutputFile);
ContentsdotmFile=fullfile(Project.ToolboxFolder, 'Contents.m');
%
% %--- CHECK THE TOOLBOX REPOSITORY EXISTS ---%
% % it is assumed that the toolbox directory is a sub-sub-repository of the
% % project root folder. Example: C:\...\MY_PROJECT\MY_TOOLBOX\MY_TOOLBOX
if ~exist(Project.ToolboxFolder,'dir') == 7
    p=input('Please, provide the name of the toolbox repository: \n');
    if ~ischar(p) && ~isstring(p)
        error('The name of toolbox repository must be of type "char" or "string".')
    end
    p = fullfile(pwd,p,p);
    if ~exist(p,'dir') == 7
        error('The toolbox repository must be a subdirectory of the project root repository.')
    end
    Project.ToolboxFolder = p;
end
%
% %--- CHECK THE OUTPUT TOOLBOX REPOSITORY EXISTS ---%
if ~exist(outputFolder,'dir') == 7
    mkdir(outputFolder)
end

%
% %--- CHECK THE TOOLBOX DOCUMENTATION REPOSITORY EXISTS ---%
if ~exist(docFolder,'dir') == 7
    p=input('Please, provide the name of the toolbox documentation repository: \n');
    if ~ischar(p) && ~isstring(p)
        error('The name of documentation repository must be of type "char" or "string".')
    end
    p = fullfile(Project.ToolboxFolder,p);
    if ~exist(p,'dir') == 7
        error('The documentation repository must be a subdirectory of the toolbox repository.')
    end
    docFolder = p;
end

%--------------------------------------------------------------------------
%--- Get list of paths in SYSPATH
s = pathsep;
pathStr = split([path, s], s);

%--------------------------------------------------------------------------
%--- Refresh paths on SYSPATH
if any(strcmp(Project.ToolboxFolder, pathStr))
    rmpath(Project.ToolboxFolder)
end
addpath(Project.ToolboxFolder)

if any(strcmp(docFolder, pathStr))
    rmpath(docFolder)
end
addpath(docFolder)

%--------------------------------------------------------------------------
%--- Get current Matlab version
MatlabVersion = version;
MatlabVersion = [MatlabVersion(end-5:end-2) , '.', MatlabVersion(end-1)];
MatlabVersion = str2double(strrep(strrep(MatlabVersion,'a','1'),'b','2'));

%--------------------------------------------------------------------------
%--- CHECK FOR OLD BUILT VERSION OF TOOLBOX
if exist(Project.OutputFile,'file')==2
    mltbxold=dir(Project.OutputFile);
else
    mltbxold.datenum = 0;
end

%--------------------------------------------------------------------------
%%%- UPDATE toolbox version IN Content.m
% it is displayed when the user calls 'help euromodconnector'
%----------------------------
updatecontentsdotm(ContentsdotmFile,Project.ToolboxVersion)

% -------------------------------------------------------------------------
%--- Create documentation
% % Specify the file or files to include in the documentation
% fileToPublish = 'Euromod/Euromod/@Euromod/Euromod.m';
% % Specify the output format and directory
% outputFormat = 'html';
% outputDir = 'help/euromod/output';
% % Generate the documentation
% publish(fileToPublish, 'format', outputFormat, 'outputDir', outputDir);

%--------------------------------------------------------------------------
%%%- Add Search database to enable searching in the HTML help files
%{
    - Make sure you have the info.xml file in the package folder
    - Make sure you have all the .html files and the helptoc.xml file in 
    a subdirectory, for example /html.
    - In the info.xml file, make reference to the subdirectory containing all 
    the .html files and the helptoc.xml file.
%}
builddocsearchdb(docFolder);

%--------------------------------------------------------------------------
%%%- Update metadata & build
if MatlabVersion >= 2023

    matlab.addons.toolbox.packageToolbox(Project);

else
    %%% For Matlab versions prior to 2023:
    %---------------------------------------------

    % pathInstalledToolbox=getPathInstalledToolbox(varargin)
    % readAddonsCoreXml(pathInstalledToolbox)

    % BUILD mltbx
    matlab.addons.toolbox.packageToolbox(ProjectFile, Project.OutputFile)

end


%--------------------------------------------------------------------------
% Check the new toolbox in /bin
if exist(Project.OutputFile,'file')==2
    mltbx=dir(Project.OutputFile);
    if isstruct(mltbx)
        if mltbx.datenum>mltbxold.datenum
            fprintf(['Successfully built toolbox ' mltbx.name ' on ' mltbx.date '\n'])
        else
            warning(['Toolbox build failed! \nLatest version of ' mltbx.name ' created on ' mltbx.date '\n'])
        end
    else
        fprintf(['Successfully built toolbox ' mltbx.name ' on ' mltbx.date '\n'])
    end

end

%--------------------------------------------------------------------------
%--- New installation Euromod Toolbox

if options.InstallToolbox
    % uninstall previous version of toolbox and install the new version
    installtoolbox(Project.OutputFile);
end

end


%**************************************************************************
%********* FUNCTIONS **********%

function installtoolbox(OutputFile)

[~,ToolboxName]=fileparts(OutputFile);

%- Get currently installed Toolboxes in Matlab
installedToolbox = matlab.addons.toolbox.installedToolboxes;
is_installed = strcmp(ToolboxName,{installedToolbox.Name});
installedToolbox=installedToolbox(is_installed);

%--- Uninstall Euromod Toolbox
if any(is_installed)

    %- Get path of installed toolbox
    % pathInstalledToolbox=getPathInstalledToolbox(ToolboxName,pathStr);

    %- uninstall old version
    fprintf(['Uninstalling toolbox ', installedToolbox.Name, ' Version ', installedToolbox.Version, '.\n'])
    matlab.addons.toolbox.uninstallToolbox(installedToolbox)
end

% install
newInstallToolbox = matlab.addons.toolbox.installToolbox(OutputFile);
fprintf(['Successfully installed toolbox ',newInstallToolbox.Name, ' Version ', newInstallToolbox.Version, '.\n'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updatecontentsdotm(ContentsdotmFile,ToolboxVersion)
%--------------------------------------------------------------------------
%%%- UPDATE VERSION IN Content.m
% it is displayed when the user calls 'help euromodconnector'
%----------------------------
% get string wih toolbox version from Content.m
fileID = fopen(ContentsdotmFile, 'r');
% Check if the file was opened successfully
if fileID == -1
    error('File could not be opened. Check the file path and try again.');
end
A = {[]};
i=1;
while ~feof(fileID)
    % take the string containing toolbox version
    docline = fgetl(fileID);
    A{i}=docline;
    if contains(docline, ' Version ')
        disp(strrep(docline,'%','Last toolbox built: '));

        % overwrite the string with new version
        A{i} = ['% Version ' char(ToolboxVersion) ' ' char(datetime('now','Format','dd-MMM-yyyy'))];
    end
    i=i+1;
end
fclose(fileID);

% overwrite Content.m file
fileID = fopen(ContentsdotmFile, 'w');
for i=1:length(A)-1
    fprintf(fileID,['%s',char([13,10])],A{i});
end
fclose(fileID);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pathInstalledToolbox=getPathInstalledToolbox(varargin)
ToolboxName=varargin{1};
if nargin == 2
    pathStr=varargin{2};
else
    s = pathsep;
    pathStr = split([path, s], s);
end
% getInstallationPath - Get path of installed toolbox from Matlab SYSPATH.
i_paths=contains(pathStr,'Roaming') & endsWith(pathStr,ToolboxName);
if sum(i_paths)==0
    i_paths=endsWith(pathStr,ToolboxName);
end
if sum(i_paths)>1
    error('Detected more paths for toolbox.')
end
pathInstalledToolbox=pathStr{i_paths};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readAddonsCoreXml(pathInstalledToolbox)
if isfolder(fullfile(pathInstalledToolbox, "resources"))
    xmlAddOnsFile = [pathInstalledToolbox filesep 'resources' filesep 'addons_core.xml'];
    EMInfo = xml2struct(xmlAddOnsFile);
    for i = 1:length(EMInfo.Children)
        if strcmpi(EMInfo.Children(i).Name, 'label')
            TlbxName = EMInfo.Children(i).Children.Data;
        elseif strcmpi(EMInfo.Children(i).Name, 'createdBy')
            AthrName = EMInfo.Children(i).Attributes.Name;
        end
    end
end
end
