% Euromod Toolbox
% Version 0.1 (R2023a) 30-Nov-2024
%
% Methods.
% setParameter               - Set new value for system parameter.
% info                       - Get info about the object.
% run                        - Simulate the tax-benefit system.
%
%
% Model class.
%   model_path               - Path to the EUROMOD project.
%   countries                - Container with Country objects.
%   extensions               - Container with Model extensions.
%
%
% Country class.
%   name                     - Two-letters country code.
%   parent                   - The base Model object.
%   datasets                 - Container with Dataset objects.
%   extensions               - Container with country + model Extension 
%                              objects. 
%   local_extensions         - Container with country Extension objects. 
%   policies                 - Container with Policy objects.
%   systems                  - Container with System objects.
%
%
% Dataset Class.
%   ID                  - Dataset identifier number.
%   coicopVersion       - COICOP version.
%   comment             - Comment about the dataset.
%   currency            - Currency of the monetary values in the dataset.
%   decimalSign         - Decimal sign.
%   name                - Name of the dataset.
%   parent              - The country-specific class.
%   private             - Access type.
%   readXVariables      - Read variables.
%   useCommonDefault    - Use default.
%   yearCollection      - Year of the dataset collection.
%   yearInc             - Reference year for the income variables.
%
%
% DatasetInSystem Class.
%   ID                  - Dataset identifier number.
%   coicopVersion       - COICOP version.
%   comment             - Comment about the dataset.
%   currency            - Currency of the monetary values in the dataset.
%   decimalSign         - Decimal sign.
%   name                - Name of the dataset.
%   parent              - The country-specific class.
%   private             - Access type.
%   readXVariables      - Read variables.
%   useCommonDefault    - Use default.
%   yearCollection      - Year of the dataset collection.
%   yearInc             - Reference year for the income variables.
%   bestMatch           - If yes, the current dataset is a best match for 
%                         the specific system.
%   dataID              - Identifier number of the reference dataset at the 
%                         country level.
%   sysID               - Identifier number of the reference system.
%
%
% Extension Class.
%   name                - Long name of the extension.
%   parent              - The model base class.
%   shortName           - Short name of the extension.
%
%
% ExtensionSwitch Class.
%   name                - Long name of the extension.
%   parent              - The class loading the extension. 
%   shortName           - Short name of the extension.
%   value               - Value of the switch as configured in EUROOMOD.
%   data_name           - Name of the applicable dataset.
%   extension_name      - Short name of the extension.
%   sys_name            - Name of the applicable system.
%
%
% Function Class.
%   ID                  - Identifier number of the function.
%   name                - Name of the function.
%   comment             - Comment specific to the function.
%   parent              - The policy-specific class.
%   private             - Access type.
%   polID               - Identifier number of the respective policy.
%   order               - Order of the function in the specific spine.
%   spineOrder          - Order of the function in the spine.
%   extensions          - Container with country extensions.
%   parameters          - Container with Parameter objects in a country.
%
%
% FunctionInSystem Class.
%   ID                  - Identifier number of the function.
%   name                - Name of the function.
%   comment             - Comment specific to the function.
%   parent              - The policy-specific class.
%   private             - Access type.
%   sysID               - Identifier number of the respective system.
%   polID               - Identifier number of the respective policy.
%   funID               - Identifier number of the respective function in 
%                         country class.
%   Switch              - Policy switch action.
%   order               - Order of the function in the specific spine.
%   spineOrder          - Order of the function in the spine.
%   extensions          - Container of Extension objects in a system.
%   parameters          - Container with ParameterInSystem objects.
%
%
% Copyright 1990-2022 The MathWorks, Inc.
