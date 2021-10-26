capture log close redi14_REDI_state_dataprep
log using $redi/redi14_REDI_state_dataprep.log, name(redi14_REDI_state_dataprep) replace text

// 	project:	REDI Methods Paper

//  task:     	Creating state samples and REDI income for state example
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
// # CREATE CPS-ASEC STATE SELECTIONS
***--------------------------***

use $deriv/redi01_ASEC-hhincome_all.dta, clear
keep if year == 2019
drop serial county
label data "Streamlined CPS ASEC data, 2019"
save $temp/redi14_cps_state_example.dta, replace

keep if statefip == 6 // California
label data "Streamlined CPS ASEC data, CA 2019"
save $temp/redi14_cps_state_ca.dta, replace

use $temp/redi14_cps_state_example.dta, clear
keep if statefip == 56 // Wyoming
label data "Streamlined CPS ASEC data, WY 2019"
save $temp/redi14_cps_state_wy.dta, replace


***--------------------------***
// # PREP ACS RESEARCH DATASET
***--------------------------***

use $deriv/redi13_REDI_state_demvars.dta, clear
keep if year == 2019
* Drop extraneous variables
label data "Streamlined ACS data, 2019"
datasignature set, reset 

*arbitrary categories invented to demonstrate flexibility of method
label define cat_inc				///
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

save $temp/redi14_ACS2019.dta, replace

***--------------------------***
// # CREATE ACS STATE SELECTIONS
***--------------------------***

use $temp/redi14_ACS2019.dta, clear
keep if statefip == 6 // California
label data "ACS data with artificial bins, CA 2019"
save $temp/redi14_ACS2019CA.dta, replace

use $temp/redi14_ACS2019.dta, clear
keep if statefip == 56 // Wyoming
label data "ACS data with artificial bins, WY 2019"
save $temp/redi14_ACS2019WY.dta, replace


***--------------------------***
// # COMPLETE REDI CONVERSIONS ON 2019 Wyoming  DATA
***--------------------------***
* cps_reference "$temp/redi14_cps_state_wy"
* change line 125 in redi03a_categ_distrib to "use $temp/redi13_cps_state_wy.dta, clear"

*year of conversion factor
local year "year"

use $temp/redi14_ACS2019WY.dta, clear

// Income Conversions
rename acs_hhinc acs_hinc_shp
include $redi/redi03a_categ_distrib.doi

// Clean Up
keep if year == 2019
drop gq sample serial cbserial countyfip age nchild whymove union  month
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

rename hhincome_asec redi_hinc 
rename acs_hinc_shp acs_hinc
order acs_hinc redi_hinc hhincome_acs acs_hinc_shp_lb acs_hinc_shp_ub 


// CREATE NATURAL LOG INCOME VARIABLES
gen redi_hinc_ln = ln(redi_hinc)
replace redi_hinc_ln = 0 if redi_hinc == 0

gen acs_hinc_ln = ln(hhincome_acs)
replace acs_hinc_ln = 0 if hhincome_acs == 0

// Save Data 
label data "Wyoming 2019 ACS data converted to continuous REDI-calculated values"
notes: redi13_REDI_Wy2019.dta \ ///
	ACS hinc_shp Data converted to continuous REDI \ /// 
	redi13_REDI_state_example.do  $S_DATE

compress
datasignature set, reset  
save $deriv/redi14_REDI_Wy2019.dta, replace

di in red "Completed REDI conversions for Wyoming 2019 data" 

***--------------------------***
// # COMPLETE REDI CONVERSIONS ON 2019 California  DATA
***--------------------------***
* cps_reference "$temp/redi14_cps_state_ca"
* change line 125 in redi03a_categ_distrib to "use $temp/redi13_cps_state_ca.dta, clear"

*year of conversion factor
local year "year"

use $temp/redi14_ACS2019CA.dta, clear

// Income Conversions
rename acs_hhinc acs_hinc_shp
include $redi/redi03a_categ_distrib.doi

// Clean Up
keep if year == 2019
drop gq sample serial cbserial countyfip age nchild whymove union  month
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

rename  hhincome_asec redi_hinc 
rename acs_hinc_shp acs_hinc
order acs_hinc redi_hinc hhincome_acs acs_hinc_shp_lb acs_hinc_shp_ub 

// CREATE NATURAL LOG INCOME VARIABLES
gen redi_hinc_ln = ln(redi_hinc)
replace redi_hinc_ln = 0 if redi_hinc == 0

gen acs_hinc_ln = ln(hhincome_acs)
replace acs_hinc_ln = 0 if hhincome_acs <= 0

// Save Data 
label data "California 2019 ACS data converted to continuous REDI-calculated values"
notes: redi13_REDI_Ca2019.dta \ ///
	ACS hinc_shp Data converted to continuous REDI \ /// 
	redi13_REDI_state_example.do  $S_DATE
compress
datasignature set, reset  
save $deriv/redi14_REDI_Ca2019.dta, replace

di in red "Completed REDI conversions for California 2019 data" 


***--------------------------***

capture log close redi14_REDI_state_dataprep
exit
