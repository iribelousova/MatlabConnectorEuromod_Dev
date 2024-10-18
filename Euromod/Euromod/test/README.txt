test_fancy.m   
============
Run this script for checking functionality of several functions of the connector, test the errors throws when User provides wrong inputs, test simulations with different options. Check the results from the simulations against the EUROMOD model output.

____________
Testing data: .txt files with simulation results from the EUROMOD model. Must be located in folder "data" on the same path with the main script "test_fancy.m".

	Country: "HR", Data: "HR_2021_b2", System "HR_2023":
	___________________________________________________
	- hr_2023_std.txt         :: baseline model
	- hr_2023_const_std.txt   :: modified constant  :: $ANWPY = '1000000#m'
	- hr_2023_tinref_std.txt  :: modified parameter :: "602db41d-12d6-465d-976a-973493859763" = 0

___________________
Auxiliary functions:
	- getByGroupWeightedSum.m
	- summaryStatistics.m


Note: 

 
