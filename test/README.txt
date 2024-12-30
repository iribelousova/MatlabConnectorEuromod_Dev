How to run tests:

- Store data files for simulation testing in subfolder /test/data. 

- test_objects.m : testing objects of classes. 

  
- testing_simulations.m : testing different types of simulations. That is, a default one, modifying constants, including addons, including switches, as well as simulations run from different objects. For this test the following has been used:
	* model version: EUROMOD_RELEASES_I6.0+
	* country: "HR", data: "HR_2021_b2", system "HR_2023"
	* data/hr_2023_std.txt  - for the baseline model
	* data/hr_2023_const_std.txt  - for modified constant  :: $ANWPY = '1000000#m'
	* data/hr_2023_tinref_std.txt  - for modified parameter :: "602db41d-12d6-465d-976a-973493859763" = 0

- functions : folder with auxiliary functions and classes for testing. 




 
