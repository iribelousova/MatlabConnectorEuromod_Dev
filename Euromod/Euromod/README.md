# About Euromod

![Static Badge](https://img.shields.io/badge/BitBucket-version_1.1.2-green?style=plastic&color=green&link=https%3A%2F%2Fcitnet.tech.ec.europa.eu%2FCITnet%2Fstash%2Fprojects%2FEUROMODJRC%2Frepos%2Fconnectors%2Fbrowse%2FMatlabIntegration%3Fat%3Drefs%252Fheads%252Fdevelop)
![Static Badge](https://img.shields.io/badge/Matlab-File_Exchange-red?style=plastic&labelColor=blue&color=red&link=https%3A%2F%2Fit.mathworks.com%2Fmatlabcentral%2Ffileexchange%2F174595-euromod%3Fs_tid%3Dsrchtitle)
![Static Badge](https://img.shields.io/badge/EUROMOD-blue?style=plastic&labelColor=blue&link=https%3A%2F%2Feuromod-web.jrc.ec.europa.eu%2F)

_euromod_ is an object oriented toolbox providing user-friendly tools for easily navigating and running simulations of the tax-benefit
microsimulation model [EUROMOD](https://euromod-web.jrc.ec.europa.eu "https://euromod-web.jrc.ec.europa.eu").

See the Euromod Connector [documentation](./doc/GettingStarted.mlx) for more readings.

The hierarchical design of the _euromod_ classes mimics the **EUROMOD** model structure. 

Load EUROMOD by passing the path to the EUROMOD project to `euromod`:

```
mod =euromod("C:\EUROMOD_RELEASES_I6.0+");
mod
	1×1 Model with properties:
     
  extensions: [11×1 Extension]
   countries: [28×1 Country]
   modelpath: "C:\EUROMOD_RELEASES_I6.0+"
```

This returns a base class `Model` with default EUROMOD `countries` and
`extensions` stored in the respective class properties: 
```
mod.extensions
	11×1 Extension array:
		1: BTA      | Benefit Take-up Adjustments
		2: TCA      | Tax Compliance Adjustments
		3: FYA      | Full Year Adjustments
		4: UAA      | Uprating by Average Adjustment
		5: EPS      | Extended Policy Simulation
		6: PBE      | Parental leave benefits
		7: MWA      | Minimum Wage Adjustments
		8: HHoT_un  | HHoT unemployment extension
		9: WEB      | EUROMOD JRC-Interface
	   10: HHoT_ext | HHoT - Extended Simulation
	   11: HHoT_ncp | HHoT - Non Compulsory Payments
```

**Note:** All the class array-type objects in _euromod_ can be accessed
by indexing the object either with an integer, or with a string
defining any value of the object string-type property.

Get a specific `Country` of the model, for example Austria, with any
of the following commands:
```
% at = mod.countries(1);
% at = mod.countries('AT');
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
```

Similarly, we can get information about a policy configured for Austria:
```
% pol = at.policies(1);
% pol = at.policies('setdefault_at');
% pol = at.policies.setdefault_at;
pol = at.setdefault_at;
pol
	1×1 Policy with properties:

       comment: "DEF: SET DEFAULT VALUES"
     functions: "SetDefault, InitVars, InitVars, SetDefault, InitVars, DefVar, SetDefault"
       private: "no"
    extensions: [0×1 Extension]
            ID: "41c9d331-d155-4a39-9ff9-16c8243c50d0"
          name: "setdefault_at"
         order: "1"
        parent: [1×1 Country]
    spineOrder: "1"
```

**Note:** Indexing a class array with the value of a string-type
class property, returns all the elements that match the exact expression. Below is an example for the _income tax_:
```
% at.policies('tin_at');
% at.policies.tin_at;
at.tin_at

	3×1 Policy array:
		1: tin_at |                   | TAX: income tax (Einkommenssteuer)
		2: tin_at |  Reference policy | 
		3: tin_at |  Reference policy | 
```

```
at.tin_at(2)

	1×1 ReferencePolicy with properties:

      refPolID: "978f7d95-06d9-472f-a167-d0ae5b52d0f2"
    extensions: [0×1 Extension]
            ID: "c0c8e298-1242-439a-97b5-95ba746eebbd"
          name: "tin_at"
         order: "28"
        parent: [1×1 Country]
    spineOrder: "28"
```

We can similarly access any class array-type property in the model.
Below is another example for the Austrian tax-benefit default systems:
```
at.systems

	17×1 System array:
	 1: AT_2007
	 2: AT_2008
	 3: AT_2009
	 4: AT_2010
	 5: AT_2011
	 6: AT_2012
	 7: AT_2013
	 8: AT_2014
	 9: AT_2015
	10: AT_2016
	11: AT_2017
	12: AT_2018
	13: AT_2019
	14: AT_2020
	15: AT_2021
	16: AT_2022
	17: AT_2023
```

And if we are interested in a specific system:
```
% at.systems(15);
% at.systems('AT_2021');
% at.systems.AT_2021;
at.AT_2021

	1×1 System with properties:

    bestmatchDatasets: "AT_2021_b1"
              comment: ""
       currencyOutput: "euro"
        currencyParam: "euro"
             datasets: "training_data, AT_2019_b2, AT_2021_hhot, AT_2020_b2, AT_2021_b1"
                   ID: "ca63e8ca-db68-4f4c-9b90-b5717e7a3776"
           headDefInc: "ils_origy"
                 name: "AT_2021"
               parent: [1×1 Country]
             policies: [54×1 PolicyInSystem]
              private: "no"
                order: "16"
                 year: "2021"
```
# Simulation

Simulations of the EUROMOD tax-beneif systems can be `run`
from the `Model`, a `Country`, or a `System` class. The default 
input arguments are the country name, the system name, a table-type dataset,
and the dataset name. All are required when running simulations from the `Model`
while, for example, only the last 2 when running from a `System`. Other optional
Name-Value input arguments can set up, for example, the use of Addons, of extension
switches, or change the values of constants in the system. 

**Note:** The input datasets used in the simulations must follow the
EUROMOD configuration criteria. For more information please read the section **DATA** following
the [link](https://euromod-web.jrc.ec.europa.eu/download-euromod "https://euromod-web.jrc.ec.europa.eu/download-euromod")

In the information above, displayed for the Austrian system <i>AT_2021</i>,
we can see which datasets can be used for simulations, and which one is the best-match
for the specific system.


Let us `run` a simulation using the best-match dataset and the default simulation configuration
options: (note that the following commands are equivalent)
```
% Load the data as a table
data = readtable("AT_2021_b1.txt");

% Run simulation
% sim = mod.run('AT','AT_2021',data,'AT_2021_b1')
% sim = mod.countries('AT').run('AT_2021',data,'AT_2021_b1')
% sim = mod.countries('AT').systems('AT_2021').run(data,'AT_2021_b1')
sim = mod.AT.AT_2021.run(data, 'AT_2021_b1');
sim
	1×1 Simulation with properties:
		 outputs: {[12305×445 table]}
		settings: [1×1 struct]
		  errors: [0×1 string]
output_filenames: "at_2021_std"
```
The table-type simulation results are stored in
the property `outputs` as a cell array.


# Installation

**Download** and install the Euromod Connector toolbox from the Matlab
[File Exchange](https://it.mathworks.com/matlabcentral/fileexchange/174595-euromod?s_tid=srchtitle "https://it.mathworks.com/matlabcentral/fileexchange/174595-euromod?s_tid=srchtitle")
web page.

## Requirements
This toolbox requires the microsimulation model **EUROMOD**.
Download the latest release from 
[EUROMOD](https://euromod-web.jrc.ec.europa.eu/download-euromod "https://euromod-web.jrc.ec.europa.eu/download-euromod")


# License
©[EUPL-EUROPEAN UNION PUBLIC LICENCE v. 1.2. The European Union 2007, 2016.](Licence.txt)