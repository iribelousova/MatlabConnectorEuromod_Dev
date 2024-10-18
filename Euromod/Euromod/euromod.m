% TODOS:
% - return properties when mixed (some props and some elements)
% - update obejct array with updated indexArr when nargout is 1 == DONE
% - call elements by names and IDs
% - define proprty of parent ID dynamically in class ExtensionsSwitch ==
% DONE
% - update country handler when setting values of parameters
% - set value of Switch for example in mm.countries(2).systems(8).policies(9).functions(6)
% - ss.parent.parent from:
% ss=mm.countries(2).systems(8).policies(9).functions(6).parameters(3)
% -->returns array of elements
% - ID in PolicyInSystem element



function out=euromod(varargin)

% mm=runmodel("C:\EUROMOD_RELEASES_I6.0+", {'BE',"PL"});

% mm=runmodel("C:\EUROMOD_RELEASES_I6.0+", {"PL","SE"});
% x=runSimulation(mm.countries(2).systems("PL_2020"),"C:\EUROMOD_RELEASES_I6.0+\Input\PL_2020_b2.txt")
% x=runSimulation(mm.countries(2).systems("SE_2021"),"C:\EUROMOD_RELEASES_I6.0+\Input\SE_2021_b1.txt")

%{
mm.countries(25).systems(16).policies(3).functions(4).parameters(1)
ss=mm.countries(25).systems(16)
const={["$ImputedWage","2021"],'100000000'}
x=run(ss,data,"C:\EUROMOD_RELEASES_I6.0+\Input\SE_2021_b1.txt",'constantsToOverwrite',const)




const={["$f_pens","2021"],'72.38175'; ...
               ["$f_pens",""],'86.8581'}
const={["$c","2021"],'72.38175'}
x=run(mm.countries(25).systems("SE_2021"),data,"C:\EUROMOD_RELEASES_I6.0+\Input\SE_2021_b1.txt",'constantsToOverwrite',const)
data = readtable("C:\EUROMOD_RELEASES_I6.0+\Input\SE_2021_b1.txt");
%}

%{
mm=euromod("C:\EUROMOD_RELEASES_I6.0+")
mm.countries(1).policies(2)
mm.countries(6).policies(24)
mm.countries(2).policies(9).functions(3)
mm.countries(12).policies(end).functions(3)
mm.countries(12).policies(end)
mm.countries(12).policies
mm.countries(12).policies(32).name

mm.countries(1).systems(8).policies(2)
mm.countries(6).systems(end).policies
mm.countries(2).systems(end).policies(9).functions(3)
mm.countries(12).systems(10)

mm.countries(20).systems(10).datasets
mm.countries(22).systems(4).bestmatchDatasets
mm.countries(15).systems(9).bestmatchDatasets(1).name

mm.countries(20).systems(6).policies

mm.countries(14).systems(6).policies(9)
mm.countries(11).systems(6).policies(9)

mm.countries(2).systems(3).policies(9).functions
mm.countries(2).systems(19).policies(9).functions

mm.countries(25).systems(16).policies(19).functions(3).parameters(6)

mm.countries(25).systems(16).policies(19).functions(3).parameters(6)
ss=mm.countries(25).systems(16)

mm.countries(25).systems(16).datasets(4)
ss=mm.countries(25).systems(16)

mm.countries(25).systems(16).datasets(4).name
ss=mm.countries(25).systems(16)

ss=mm.countries(2).systems(8).policies(9).functions(6).parameters(3)
ss.parent.parent
%}

NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_XmlHandler));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Common));
NET.addAssembly(fullfile(utils.configuration.DLL_PATH, utils.configuration.DLL_Executable));
          
out=Model(varargin{:});

end

% tempArr=cell(1,54);
% for i=1:54
%     temp=copy(pp);
%     tempArr{i}=temp(i);
% end