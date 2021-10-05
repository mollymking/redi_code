capture log close redi13_REDI_state_example
log using $redi/redi13_REDI_state_example.log, name(redi13_REDI_state_example) replace text

// 	project:	REDI Methods Paper

//  task:     	Example of REDI on data from a single state in 2019
//  data:     	CPS ASEC from IPUMS, available: https://cps.ipums.org/
//				ACS from IPUMS, available: https://usa.ipums.org/

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
set seed 1

***--------------------------***
// # CREATE APPROPRIATE CPS SELECTIONS
***--------------------------***

use $deriv/redi01_ASEC-hhincome_all.dta, clear
keep if year == 2019
drop age sex race marst nchild hispan labforce educ diffmob whymove migrate1 health union ownershp month
drop serial cpsid asecflag county cpsidp
label data "Streamlined CPS ASEC data, 2019"
save $deriv/redi13_cps_state_example.dta, replace

keep if statefip == 6 // California
label data "Streamlined CPS ASEC data, CA 2019"
save $temp/redi13_cps_state_ca.dta, replace

use $deriv/redi13_REDI_state_example.dta, clear
keep if statefip == 56 // Wyoming
label data "Streamlined CPS ASEC data, WY 2019"
save $temp/redi13_cps_state_wy.dta, replace

***--------------------------***
// # PREP ACS RESEARCH DATASET
***--------------------------***

use $deriv/redi01_ACS_all.dta, clear
keep if year == 2019
* Drop extraneous variables
drop gq sample serial cbserial countyfip
label data "Streamlined ACS data, 2019"
datasignature set, reset 


*arbitrary categories invented to demonstrate flexibility of method

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
	
gen 	acs_hhinc = .
replace acs_hhinc = 1 if hhincome_acs					   	   <= 15000
replace acs_hhinc = 2 if hhincome_acs  > 15000 	& hhincome_acs <= 25000
replace acs_hhinc = 3 if hhincome_acs  > 25000 	& hhincome_acs <= 35000
replace acs_hhinc = 4 if hhincome_acs  > 35000 	& hhincome_acs <= 50000	
replace acs_hhinc = 5 if hhincome_acs  > 50000 	& hhincome_acs <= 75000	
replace acs_hhinc = 6 if hhincome_acs  > 75000 	& hhincome_acs <= 100000
replace acs_hhinc = 7 if hhincome_acs  > 100000 & hhincome_acs <= 150000 
replace acs_hhinc = 8 if hhincome_acs  > 150000 & hhincome_acs <= 200000
replace acs_hhinc = 9 if hhincome_acs  > 200000 & hhincome_acs != 9999999 
replace acs_hhinc = . if hhincome_acs == 9999999 
replace acs_hhinc = . if hhincome_acs == .

label values acs_hhinc cat_inc
label var acs_hhinc "Household Income (ACS) arbitrary categories based on hhincome_acs"
notes acs_hhinc: ACS Household Income Categories from hhincome_acs \ $S_DATE

tab acs_hhinc, m
*tab acs_hhinc, m nolab

save $deriv/redi13_ACS2019.dta, replace

***--------------------------***
// # RUN REDI.ADO PROGRAM ON 2019 California DATA
***--------------------------***
use $deriv/redi13_ACS2019.dta, clear

cd $redi/redi_package
discard
redi acs_hhinc year // newvar = ca_redi_inc19


***--------------------------***
// # RUN REDI.ADO PROGRAM ON 2019  Wyoming  DATA
***--------------------------***

local cps_reference "$temp/redi13_cps_state_wy"

cd $redi/redi_package
redi wy_redi_inc19 hhincome_acs year `cps_reference', household

***--------------------------***

capture log close redi13_REDI_state_example
exit
