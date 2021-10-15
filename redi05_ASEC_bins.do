capture log close redi05_ASEC_bins
log using $redi/redi05_ASEC_bins.log, name(redi05_ASEC_bins) replace text

// 	project:	REDI Methods Paper

//  task:     	Creating bins for CPS ASEC
//  data: 		CPS ASEC

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King

display "$S_DATE  $S_TIME"

***--------------------------***
// # PROGRAM SETUP
***--------------------------***

version 13 // keeps program consistent for future replications
set linesize 80
clear all
set more off
	
use $deriv/redi01_ASEC-hhincome.dta, clear
save $deriv/redi05_ASEC_bins-hinc.dta, replace

***--------------------------***
// # CREATE SHARP CATEGORY BOUNDS - HOUSEHOLD
***--------------------------***

label define  cat_inc	 				///
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
gen 	asec_hinc_shp = .
replace asec_hinc_shp = 1 if hhincome_asec	<= 15000
replace asec_hinc_shp = 2 if hhincome_asec  > 15000 	& hhincome_asec <= 25000
replace asec_hinc_shp = 3 if hhincome_asec  > 25000 	& hhincome_asec <= 35000
replace asec_hinc_shp = 4 if hhincome_asec  > 35000 	& hhincome_asec <= 50000	
replace asec_hinc_shp = 5 if hhincome_asec  > 50000 	& hhincome_asec <= 75000	
replace asec_hinc_shp = 6 if hhincome_asec  > 75000 	& hhincome_asec <= 100000
replace asec_hinc_shp = 7 if hhincome_asec  > 100000 	& hhincome_asec <= 150000 
replace asec_hinc_shp = 8 if hhincome_asec  > 150000 	& hhincome_asec <= 200000
replace asec_hinc_shp = 9 if hhincome_asec  > 200000 	& hhincome_asec != 9999999 
replace asec_hinc_shp = . if hhincome_asec == 9999999 
replace asec_hinc_shp = . if hhincome_asec == .

label values asec_hinc_shp cat_inc

tab asec_hinc_shp, m
tab asec_hinc_shp, m nolab

* SAVE SHARP INCOME VARIABLE
label var asec_hinc_shp "household Income (ASEC) sharp categories based on hhincome_asec"
notes asec_hinc_shp: ASEC household Income Sharp Categories from hhincome_asec \  mmk $S_DATE

save $deriv/redi05_ASEC_bins-hinc.dta, replace

***--------------------------***
// # COUNT NUMBER OF CASES IN EACH BIN
***--------------------------***

* COUNT BY SHARP BINS

use $deriv/redi05_ASEC_bins-hinc.dta, clear

gen id = _n
egen asec_hinc_shp_n = count(id), by(asec_hinc_shp year)
label var asec_hinc_shp_n "Count of cases of household Income (ASEC) sharp within year (count of asec_hinc_shp by year)"

save $deriv/redi05_ASEC_bins-hinc_shp.dta, replace  // for use in redi10_ASEC_regressions

duplicates drop year asec_hinc_shp asec_hinc_shp_n, force
rename asec_hinc_shp hinc_shp

keep year hinc_shp asec_hinc_shp_n 

save $deriv/redi05_ASEC_bins-hinc_shp-nodups.dta, replace  // this is for merge in redi08_ACS_ASEC_distrib_match

***--------------------------***

log close redi05_ASEC_bins
exit
