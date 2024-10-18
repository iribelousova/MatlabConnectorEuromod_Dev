
%- Define Euromod Toolbox configuration options
prjFileName = "EuromodDev";
ToolboxName = "Euromod";
lang = 'en';

%--------------------------------------------------------------------------
%%%- DEFINE PATHS and FILES
%- Paths on SYSPATH
s = pathsep;
pathStr = split([path, s], s);

projectFolder = fullfile(pwd,"Euromod","Euromod");
rootProjectFolder = fileparts(fileparts(projectFolder));
docProjectFolder = fullfile(projectFolder,"docs", lang);
htmlProjectFolder = fullfile(docProjectFolder,"html");
mltbxProjectFile = fullfile(pwd,"bin", ToolboxName + '.mltbx');
prjProjectFile = fullfile(pwd,"bin",  prjFileName + '.prj');

%--------------------------------------------------------------------------
%%%- DEFINE VERSIONS
%- Euromod Toolbox version
% VERSION
EMversion = str2double(matlab.addons.toolbox.toolboxVersion(mltbxProjectFile));

%- Get current Matlab version
MLversion = version;
MLversion = [MLversion(end-5:end-2) , '.', MLversion(end-1)];
MLversion = str2double(strrep(strrep(MLversion,'a','1'),'b','2'));

%- Get currently installed Toolboxes in Matlab
installedToolboxList = matlab.addons.toolbox.installedToolboxes;
installedToolboxList = struct2table(installedToolboxList);


%--------------------------------------------------------------------------
%%%- MANAGE PATHS
%%%- Check if project folder is on SYSPATH
if ~any(strcmp(projectFolder, pathStr)) 
    addpath(projectFolder)
end
if ~any(strcmp(htmlProjectFolder, pathStr)) 
    addpath(htmlProjectFolder)
end

%%%- Check if Euromod Toolbox is installed
if any(strcmp(installedToolboxList.Name,  'Euromod'))
    installedToolboxList = installedToolboxList(contains(installedToolboxList.Name,'Euromod'),:);
    toolboxFolder = pathStr(contains(pathStr, "\Euromod"));
    mltbxToolboxFile = fullfile(toolboxFolder, 'Euromod Info');
       
    if length(toolboxFolder) > 1
        if MLversion < 2023.2
            %- Get version of the installed Toolbox
            EMversionOld = installedToolboxList.Version{1};
            
            %- first, check if toolbox is installed in Program Files
%             toolboxFolder = toolboxdir('euromod');
            isInProgFiles = contains(toolboxFolder,'Program Files') +...
                                ~contains(toolboxFolder,'AppData\Roaming')==2;
            %- if not, check if toolbox is installed in Program Files
            isInAppFiles = ~contains(toolboxFolder,'AppData\Roaming') +...
                                contains(toolboxFolder,'AppData\Roaming')==2;
            idxFlag = logical(isInProgFiles + isInAppFiles);
            
            toolboxFolder = toolboxFolder(idxFlag);
            
        else
%             EMversionOld = matlab.addons.toolbox.toolboxVersion(mltbxToolboxFile);
%             toolboxFolder
        end
    end
    toolboxFolder = toolboxFolder{:};
        
else
    EMversionOld = 'abc';
end

if MLversion >= 2023
    
    opts = matlab.addons.toolbox.ToolboxOptions(projectFolder, prjFileName);

    opts.ToolboxName = ToolboxName;

    opts.SupportedPlatforms.Win64 = true;
    opts.SupportedPlatforms.Maci64 = false;
    opts.SupportedPlatforms.Glnxa64 = false;
    opts.SupportedPlatforms.MatlabOnline = false;

    opts.MinimumMatlabRelease = "R2017b";
    opts.MaximumMatlabRelease = "";

%     opts.RequiredAddons = ...
%         struct("Name", "Gui Layout Toolbox", ...
%                "Identifier", "e5af5a78-4a80-11e4-9553-005056977bd0", ...
%                "EarliestVersion", "1.0", ...
%                "LatestVersion", "4.0", ...
%                "DownloadURL", "");
% 
%     opts.RequiredAdditionalSoftware = ...
%         struct("Name", "Dataset", ...
%                "Platform", "common", ...
%                "DownloadURL", "https://github.com/myusername/myproject/data.zip", ...
%                "LicenseURL", "https://github.com/myusername/myproject/LICENSE");

    matlab.addons.toolbox.packageToolbox(opts);

else
    
    if 2==3
        
        if EMversionOld == currentVersion
            matlab.addons.toolbox.uninstallToolbox(mltbxProjectFile)
        end

        if isfolder(fullfile(toolboxFolder, "resources"))
            xmlAddOnsFile = [toolboxFolder filesep 'resources' filesep 'addons_core.xml']; 
            EMInfo = xml2struct(xmlAddOnsFile); 
            struct2table(EMInfo.Children)
            for i = 1:length(EMInfo.Children)
                if strcmpi(EMInfo.Children(i).Name, 'label') % searches for token "version"
                    ToolboxName = EMInfo.Children(i).Children.Data; 
                elseif strcmpi(EMInfo.Children(i).Name, 'createdBy') % searches for token "version"
                    AuthorName = EMInfo.Children(i).Attributes.Name; 
                end
            end
        end

        matlab.addons.toolbox.packageToolbox(prjFileName + '.prj', ToolboxName + '.mltbx')
    
    end

end


%%%- Add Search database to enable searching in the HTML help files
%{
    - Make sure you have the info.xml file in the package folder
    - Make sure you have all the .html files and the helptoc.xml file in 
    a subdirectory, for example /html.
    - In the info.xml file, make reference to the subdirectory containing all 
    the .html files and the helptoc.xml file.
%}
%%%- Add and remove from SYSPATH, to re-freash 
p = rmpath(htmlProjectFolder);
path(p)
htmlProjectFolder = "C:\Users\iribe\EUROMOD_CONNECTOR\connector\Connectors\MatlabIntegration\Euromod\Euromod\doc\help\euromod";
builddocsearchdb(htmlProjectFolder);


%==========================================================================
% Specify the file or files to include in the documentation
fileToPublish = 'Euromod/Euromod/@Euromod/Euromod.m';
% Specify the output format and directory
outputFormat = 'html';
outputDir = 'help/euromod/output';
% Generate the documentation
publish(fileToPublish, 'format', outputFormat, 'outputDir', outputDir);


