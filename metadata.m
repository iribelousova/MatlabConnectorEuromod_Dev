function options = metadata()

%- Define Euromod Toolbox configuration options
options.ToolboxVersion= "0.0.1";
options.ToolboxName = "EuromodConnector";

options.AuthorName = "Belousova Irina; Serruys Hannes";
options.AuthorEmail = "iri.belousova@gmail.com; hannes.serruys@ec.europa.eu";
options.AuthorCompany = "JRC - European Commission";

options.Summary = "Euromod Connector Toolbox for the microsimulation model EUROMOD.";
options.Description = "EUROMOD is a tax-benefit microsimulation model for the European " + ...
    "Union that enables researchers and policy analysts to calculate, " + ...
    "in a comparable manner, the effects of taxes and benefits on household " + ...
    "incomes and work incentives for the population of each country and for " + ...
    "the EU as a whole. It is a static microsimulation model that applies " + ...
    "user-defined tax and benefit policy rules to harmonized microdata on " + ...
    "individuals and households, calculates the effects of these rules on household income.";

% toolbox folder
options.ToolboxFolder = fullfile(pwd,'euromodconnector','euromodconnector');

% toolbox .mltbx file
options.OutputFile = fullfile(pwd,'bin', options.ToolboxName + '.mltbx');

% getting started .mlx file
options.ToolboxGettingStartedGuide = fullfile(options.ToolboxFolder,"doc","GettingStarted.mlx");

% toolbox logo file
options.ToolboxImageFile = fullfile(pwd,"images","logo.jpg");

% project file
% options.projectFile = fullfile(pwd,"Euromod.prj");
options.ProjectFile = '';


% platforms
options.SupportedPlatforms.Win64 = true;
options.SupportedPlatforms.Maci64 = false;
options.SupportedPlatforms.Glnxa64 = false;
options.SupportedPlatforms.MatlabOnline = false;

% requirements
options.MinimumMatlabRelease = "R2017b";
options.MaximumMatlabRelease = "";

% options.RequiredAdditionalSoftware = ...
%     struct("Name", "EUROMOD Model", ...
%     "Platform", "win64", ...
%     "DownloadURL", "https://euromod-web.jrc.ec.europa.eu/download-euromod#section-3388", ...
%     "LicenseURL", "https://commission.europa.eu/legal-notice_en#copyright-notice");


%     options.RequiredAddons = ...
%         struct("Name", "Gui Layout Toolbox", ...
%                "Identifier", "e5af5a78-4a80-11e4-9553-005056977bd0", ...
%                "EarliestVersion", "1.0", ...
%                "LatestVersion", "4.0", ...
%                "DownloadURL", "");
%

% options.ToolboxJavaPath;

options.Identifier = "7ibfd834-0af8-40be-961c-f0813693d500";
options.DEFAULT_FILE_EXCLUSIONS = ["**/resources/project/**/*",...
    "**/*.prj", "**/.git/**/*", "**/.svn/**/*", "**/.buildtool/**/*",...
    "**/*.asv", "*/pdf", "*/Examples", "*/Documentation.pdf"];

options.InstallToolbox=0;

end

