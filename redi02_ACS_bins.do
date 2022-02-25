capture log close redi02_ACS_bins
log using $redi/redi02_ACS_bins.log, name(redi02_ACS_bins) replace text

//	project:	REDI Methodology Paper

//  task:     	Create artificial data bins
//  data: 		ACS
//				available: https://usa.ipums.org/

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King

display "$S_DATE  $S_TIME"

***--------------------------***
// # PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off

use $deriv/redi01_ACS.dta, clear
save $deriv/redi02_ACS_bins.dta, replace

***--------------------------***
// # CREATE SHARP CATEGORY BOUNDS 
***--------------------------***

label define cat_inc	 				///
	1	"Less than $15000"	 			///
	2	"15000 to less than 25000" 		///
	3	"25000 to less than 35000" 		///
	4	"35000 to less than 50000" 		///
	5	"50000 to less than 75000" 		///
	6	"75000 to less than 100000" 	///
	7	"100000 to less than 150000" 	///
	8	"150000 to less than 200000" 	///
	9	"200000 or more" 				//

*arbitrary categories invented to demonstrate flexibility of method
gen 	acs_hinc_shp = .
replace acs_hinc_shp = 1 if hhincome_acs			 		  	   <= 15000
replace acs_hinc_shp = 2 if hhincome_acs  > 15000 	& hhincome_acs <= 25000
replace acs_hinc_shp = 3 if hhincome_acs  > 25000 	& hhincome_acs <= 35000
replace acs_hinc_shp = 4 if hhincome_acs  > 35000 	& hhincome_acs <= 50000	
replace acs_hinc_shp = 5 if hhincome_acs  > 50000 	& hhincome_acs <= 75000	
replace acs_hinc_shp = 6 if hhincome_acs  > 75000 	& hhincome_acs <= 100000
replace acs_hinc_shp = 7 if hhincome_acs  > 100000 & hhincome_acs <= 150000 
replace acs_hinc_shp = 8 if hhincome_acs  > 150000 & hhincome_acs <= 200000
replace acs_hinc_shp = 9 if hhincome_acs  > 200000 & hhincome_acs != 9999999 
replace acs_hinc_shp = . if hhincome_acs == 9999999 // dataset of new incomes will now be smaller as a result
replace acs_hinc_shp = . if hhincome_acs == .

label values acs_hinc_shp cat_inc
label var acs_hinc_shp "Household Income (ACS) sharp categories based on hhincome"
notes acs_hinc_shp: ACS Household Income Sharp Categories from  hhincome \ $S_DATE

*tab acs_hinc_shp, m
*tab acs_hinc_shp, m nolab

save $deriv/redi02_ACS_bins.dta, replace

* version for troubleshooting ado program
drop repwt* cluster strata perwt hhwt   pernum  adjust // for debugging, simplify
drop migrate1* labforce hispan* marst_acs race* sex_acs diffmob_acs  owner* countyfip statefip cbserial serial sample gq educ*

save $deriv/redi02_ACS_bins_clean.dta, replace

***--------------------------***

log close redi02_ACS_bins
exit
