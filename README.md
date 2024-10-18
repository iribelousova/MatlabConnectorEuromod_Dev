# Installation

## Requirements
This package requires that the microsimulation model **EUROMOD** is installed on your computer.
Download the latest releases from 
[EUROMOD](https://euromod-web.jrc.ec.europa.eu/download-euromod "https://euromod-web.jrc.ec.europa.eu/download-euromod")

**Download** and install the _Euromod Connector_ package for Python using _pip_:
```
pip install euromod
```

**Import** the module _euromod_:
```
from euromod import Euromod
```

**Note:** If the module _euromod_ is not found, 
add to %SYSTEMPATH the root folder where the _euromod_ package is installed (for example, `r"C:\Users\YOUR_USER_NAME\AppData\Roaming\Python\PythonXXX\site-packages"`) then retry:
```
import sys
sys.path.insert(0, ROOT_PATH_TO_EUROMOD_PACKAGE)
```

**Note:** If you encope in an error from the _clr_ module for a missing Attribute, probably a different _clr_ package installed on your device conflicts with the _clr_ module from the _pythonnet_ package. 
Uninstall _clr_ package then retry:
```
pip uninstall clr
```

If necessary, re-install the _pythonnet_ package:
```
pip install pythonnet
```

Equivalent commands in **cmd**:
```
pip install euromod
py -m euromod
set PATH=%PATH%; "C:\...\AppData\Roaming\Python\PythonXXX\site-packages"
py -m pip uninstall clr
py -m pip install pythonnet
```

**Note:** On multiple import runs the _clr_ module from _pythonnet_ can crash. The error message looks like:
```
RuntimeError: Failed to initialize Python.Runtime.dll

Failed to initialize pythonnet: System.InvalidOperationException: This property must be set before runtime is initialized
   at Python.Runtime.Runtime.set_PythonDLL(String value)
   at Python.Runtime.Loader.Initialize(IntPtr data, Int32 size)
   at Python.Runtime.Runtime.set_PythonDLL(String value)
   at Python.Runtime.Loader.Initialize(IntPtr data, Int32 size)
```
For a one-time solution start a new console window. 
To solve the problem temporarely (or permanently) for a specific console, disable the option **User Module Reloader (UMR)** in the `Tools` bar 
(this prevents python/spyder from automatically reloading modules whenever they are re-imported).
Depending on Python/Spyder editor version, go to:
 * Tools -> Preferences -> Python Interpreter, OR
 * Tools -> Console -> Advaned setting
 
 Disable the User Module Reloader (UMR) option then press `Apply` and `Ok`. Start a new Console window. Note: this console will load properly the _clr_ module even if the UMR option has been reactivated in the meantime. However, if you open a new console the UMR option must be again disabled and the console re-stared.

# Simulation
In order to simulate the _euromod_ model:

1. Load the **EUROMOD Connector**. The first Input, of type _char_ or _str_, is the  full path to the root directory where the [EUROMOD](https://euromod-web.jrc.ec.europa.eu/download-euromod "https://euromod-web.jrc.ec.europa.eu/download-euromod") model is located. The second Input is optional of type _char_, _str_, or _list_, and represents the two-digits country codes. 
```
PATH_EUROMODFILES = r"C:\...\EUROMOD_RELEASES_I6.0+"
EM =Euromod(PATH_EUROMODFILES, countries = 'PL')
```
_Note_: If the second Input is omitted, the **EUROMOD Connector** uploads all the available countries from the **Euromod** model into the `Country` class objects. These objects can be accessed using either notation `EM['PL']` or `EM.countries['PL']`. Display the **Euromod** model countries using command `EM.countries`.

2. Load the **Euromod** model country-specific systems into the `System` class objects of the **EUROMOD Connector** using the method `load_system`. The method takes on one Input, the name(s) of the **Euromod** model system(s), as a _char_, _str_, or _list_.
```
EM['PL'].load_system(['PL_2021', 'PL_2022'])
```
The `System` objects can be accessed using either notation `EM['PL']['PL_2022']` or `EM['PL'].systems['PL_2022']`. To display all the systems loaded in the **EUROMOD Connector** use `EM['PL'].systems`.

3. Run the simulations of the **Euromod** model systems using the method `run`, which requires two inputs: **Input 1** is the dataset of type _pandas.DataFrame_ and **Input 2**, of type _char_ or _str_, is the name (with extension) of this dataset. _Note_ that the name of the dataset must be a valid **Euromod** model name (i.e. `"training_data.txt"` or, for example for Poland,`"PL_2019_b3.txt"`).
```
import pandas as pd

df = pd.read_csv("PL_2019_b3.txt", sep="\t")

EM['PL']['PL_2022'].run(df, "PL_2019_b3.txt")
```
The simulation results are stored into the `simulations` class objects with _default_ names _Sim1_, _Sim2_,... . In order to rename the simulations, use the method `rename_simulations` either with one Input of type _dict_ (**keys** are old names, **values** are new names), or with two Inputs of type _char_ or _str_ (**first** input is oldname, **second** input is new name). 
```
print(EM['PL']['PL_2022'].simulations.keys())
EM['PL']['PL_2022'].rename_simulations('Sim1', 'mySim')

print(EM['PL']['PL_2022'].simulations.keys())
EM['PL']['PL_2022'].rename_simulations({'mySim':'yourSim'})

print(EM['PL']['PL_2022'].simulations['yourSim'])
```

The `simulations` class objects contain the following information:
 * `name` of type _char_ : name of the simulation,
 * `configSettings` of type _dict_ : configuration settings specific to the simulation run,
 * `output` of type _dict_ : **keys** are the names of the _Input datasets_, **values** are the datasets resulting from the simulation run,
 * `constantsToOverwrite`of type _dict_ : only if the _User_ modified any values of the **Euromod** model constants.
```
sim_PL_2022 = list(EM.countries['PL'].systems['PL_2022'].simulations.values())[-1]
print(sim_PL_2022)
print(list(sim_PL_2022.output.values())[-1])
``` 

4. In order to change the values of constants in the **Euromod** model, use the _optional_ Input argument `constantsToOverwrite` in the method `run`:
```
EM.countries['PL'].systems['PL_2022'].run(df, "PL_2019_b3.txt", constantsToOverwrite = {("$f_h_cpi","2022"):'1000'})
```




# License
&copy;European Union, Institute for Social and Economic Research, University of Essex

The EUROMOD model is licensed under the Creative Commons Attribution 4.0 International 
(CC BY 4.0) [licence](https://creativecommons.org/licenses/by/4.0/ "https://creativecommons.org/licenses/by/4.0/"). Reuse is allowed provided appropriate credit is given and any changes are indicated. 

We kindly ask you to acknowledge the use of EUROMOD in any publications or other outputs
(such as conference presentations). A recommended wording for acknowledgement is provided below: 

	'The results presented here are based on EUROMOD version I5.0+. Originally 
	maintained, developed and managed by the Institute for Social and Economic
	Research (ISER), since 2021 EUROMOD is maintained, developed and managed by
	the Joint Research Centre (JRC) of the European Commission, in collaboration
	with EUROSTAT and national teams from the EU countries. We are indebted to the
	many people who have contributed to the development of EUROMOD. The results
	and their interpretation are the author’s(’) responsibility'

This package includes one icon ('\XMLParam\AddOns\MTR\MTR.png'),
adapted from [LibreICONS](https://diemendesign.github.io/LibreICONS/, "https://diemendesign.github.io/LibreICONS/"), under : 

	MIT License

	Copyright (c) 2018 Diemen Design

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.