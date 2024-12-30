euromod is an object oriented toolbox providing user-friendly tools for easily navigating and running simulations of the tax-benefit microsimulation model EUROMOD.
The hierarchical design of the euromod classes mimics the EUROMOD model structure. 
Load EUROMOD by passing the path to the EUROMOD project to euromod:
mod =euromod("C:\EUROMOD_RELEASES_I6.0+");
mod
	1×1 Model with properties:
     
  extensions: [11×1 Extension]
   countries: [28×1 Country]
   modelpath: "C:\EUROMOD_RELEASES_I6.0+"
Display the model countries:
mod.countries(1:6)
    6×1 Country array:
     1: AT
     2: BE
     3: BG
     4: CY
     5: CZ
     6: DE
Display information for Austria:
at = mod.AT;
at
	1×1 Country with properties:
            datasets: [27×1 Dataset]
          extensions: [13×1 Extension]
    local_extensions: [2×1 Extension]
                name: "AT"
              parent: [1×1 Model]
            policies: [54×1 Policy]
             systems: [17×1 System]
Run simulation on the Austrian system "AT_2021" using the dataset "AT_2021_b1":
% load the data
data = readtable("AT_2021_b1.txt");
% run simulation
sim = mod.AT.AT_2021.run(data, 'AT_2021_b1');
sim
    1×1 Simulation with properties:
		     outputs: {[12305×445 table]}
		    settings: [1×1 struct]
		      errors: [0×1 string]
    output_filenames: "at_2021_std"
©EUPL-EUROPEAN UNION PUBLIC LICENCE v. 1.2. The European Union 2007, 2016.
Cita come
Irina Belousova, Serruys Hannes (2024). Matlab Connector Euromod (https://it.mathworks.com/matlabcentral/fileexchange/174595-euromod?s_tid=srchtitle), MATLAB Central File Exchange. Retrieved October 28, 2024