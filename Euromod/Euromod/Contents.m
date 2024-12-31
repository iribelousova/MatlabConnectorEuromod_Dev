% Euromod Toolbox
% Version 11.1.0 23-Dec-2024
% 
% Methods.
%     euromod             - Get the Model class with the EUROMOD project.
%     info                - Get info about an object.
%     run                 - Simulate a tax-benefit system.
% 
% 
% Model class.
%     countries           - Class array with Model countries.
%     extensions          - Class array with Model extensions.
%     modelpath           - Path to the EUROMOD project.
% 
% 
% Country class.
%     datasets            - Class array with Country datasets.
%     extensions          - Class array with Country + Model extensions 
%     local_extensions    - Class array with Country extensions. 
%     name                - Two-letters country code.
%     parent              - The base Model class.
%     policies            - Class array with Country policies.
%     systems             - Class array with Country systems.
% 
% 
% Dataset Class.
%     coicopVersion       - COICOP version.
%     comment             - Comment about the dataset.
%     currency            - Currency of the monetary values in the dataset.
%     decimalSign         - Decimal sign.
%     ID                  - Dataset identifier number.
%     name                - Name of the dataset.
%     parent              - The Country parent class.
%     private             - Access type.
%     readXVariables      - Read variables.
%     useCommonDefault    - Use default.
%     yearCollection      - Year of the dataset collection.
%     yearInc             - Reference year for the income variables.
% 
% 
% DatasetInSystem Class.
%     bestMatch           - If yes, the current dataset is a best match for 
%                         the specific system.
%     coicopVersion       - COICOP version.
%     comment             - Comment about the dataset.
%     currency            - Currency of the monetary values in the dataset.
%     dataID              - Identifier number of the reference dataset at the 
%                         country level.
%     decimalSign         - Decimal sign.
%     ID                  - Dataset identifier number.
%     name                - Name of the dataset.
%     parent              - The country-specific class.
%     private             - Access type.
%     readXVariables      - Read variables.
%     sysID               - Identifier number of the parent system.
%     useCommonDefault    - Use default.
%     yearCollection      - Year of the dataset collection.
%     yearInc             - Reference year for the income variables.
% 
% 
% Extension Class.
%     ID                  - Extension identifier number.
%     name                - Long name of the extension.
%     parent              - The Model base class.
%     shortName           - Short name of the extension.
% 
% 
% ExtensionSwitch Class.
%     dataID              - Identifier number of dataset
%     data_name           - Name of dataset
%     extensionID         - Identifier number of extension
%     extension_name      - Short name of extension
%     sysID               - Identifier number of system
%     sys_name            - Name of system
%     value               - Switch value of extension
% 
% 
% Function Class.
%     comment             - Comment specific to the function.
%     extensions          - Class array with function extensions.
%     ID                  - Identifier number of the function.
%     name                - Name of the function.
%     order               - Order of the function in the specific spine.
%     parameters          - Class array with parameters set up in a country.
%     parent              - The Policy parent class.
%     polID               - Identifier number of the parent policy.
%     private             - Access type.
%     spineOrder          - Order of the function in the spine.
% 
% 
% FunctionInSystem Class.
%     comment             - Comment specific to the function.
%     extensions          - Class array with function extensions.
%     funID               - Identifier number of the function country level.
