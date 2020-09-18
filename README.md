This code contains a complete replication for the paper "REDI for Binned Data:  A Random Empirical Distribution Imputation method for estimating continuous incomes" by Molly M. King.

# Data
To replicate the REDI proof of concept, you must first download three datasets:

## American Community Survey (ACS)
1. Go to [https://usa.ipums.org/](https://usa.ipums.org/). 
2. Select sample years 2016 and 2017. Select variables: YEAR, REPWTP, PERWT, HHINCOME. See how the selection should look here: [https://osf.io/e2dtr/](https://osf.io/e2dtr/)
3. After unzipping, label the .dat file downloaded as ""usa_00008.dat".

## Current Population Survey ASEC (CPS ASEC)
1. Go to [https://cps.ipums.org/](https://cps.ipums.org/)
2. Download the variables:  Select sample years 2016 and 2017. Select variables: YEAR, ASECWTH, HHINCOME, PERNUM, SEX, RACE, HISPAN, and EDUC. See how the selection should look here: [https://osf.io/z3pcw/](https://osf.io/z3pcw/)
3. After unzipping, label the .dat file downloaded as "cps_00009.dat".

## Consumer Price Index retroactive series using current methods with all items (R-CPI-U-RS) 
1. Downloaded as a spreadsheet from the U.S. Bureau of
Labor Statistics website: [https://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm](https://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm). 
2. Code to import and use this data can be found along with the rest of the code.


# Structure File System
Now you will create a file system to keep track of data and results from the replication.

1. Create an empty file for this project. Change the directory in the  "redi00_master.do" to match this folder for code for the project:
`global redi  	"YOUR / DIRECTORY / HERE"	// where all replication .do files stored`

2. Create a new blank folder to serve as an umbrella folder for holding all data related to this replication.

3. Create a new blank folder within this data folder. All source data files downloaded above should be placed in a single file folder. Change the directory in the "redi00_master.do" file to match this directory:
`global source	"YOUR / DIRECTORY / HERE"  	// original datasets (ACS, CPS ASEC)`

4. Create another new blank folder within this data folder. This will be used for the clean but unmodified data sets extracted from these raw data sets. Change the directory in the "redi00_master.do" to match the folder on your computer:
`global extr  	"YOUR / DIRECTORY / HERE"  	// extracted datasets - a file to extract original data`

5. Create yet another new blank folder within your umbrella project folder. This will be used for modified data sets that you are actively working with. Again, change the directory in the "redi00_master.do" file:
`global deriv	"YOUR / DIRECTORY / HERE"  	// derived datasets - a file to store final data`

6. Create one final folder to hold temporary data files. Change the directory in the "redi00_master.do" file: 
`global temp	"YOUR / DIRECTORY / HERE"	// temporary datasets - an empty file to store temporary data`

Since these are global variables, you will not need to reestablish these directory connections at any other point in the code. You will, however, need to run this part of the code before running any other .do file in the project.


# Instructions
From this point forward, the code should be self-documenting. Proceed in the order laid out in the file "redi00_master.do".
