capture log close redi01_ASEC_import
log using $redi/redi01_ASEC_import.log, name(redi01_ASEC_import) replace text


//	project:	REDI Methodology Paper

//  task:     	Create Income Distribution for Overlay
//  data:     	CPS ASEC from IPUMS, available: https://cps.ipums.org/

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King


display "$S_DATE  $S_TIME"

***--------------------------***

// #0 PROGRAM SETUP
version 13 // keeps program consistent for future replications
set linesize 80
clear all
set more off

***--------------------------***
// EXTRACT DATA
***--------------------------***

// Code to extract is from IPUMS CPS ASEC do file for importing data - 
// just have to change working directory to redirect to where store original data
// and change name of .do file to match below

cd $source/00_CPS_ASEC/
// this is code provided by IPUMS - ACS to import data:
do $redi/cps_00010.do // original dataset used for tables 4 and 5 in paper


// SAVE
label data "Imported original CPS ASEC data from IPUMS"
notes: redi01b_ASEC-extr.dta \ Extracted CPS ASEC Data from IPUMS \ redi01b_ASEC-extr.do mmk $DATE
compress
datasignature set, reset
save $extr/redi01_ASEC-extr.dta, replace


// CLEAN VERSION FOR DEBUGGING ADO PROGRAM
keep year hhincome  pernum asecwth
save $redi/redi_package/cps_reference.dta, replace

***--------------------------***
// HOUSEHOLD INCOME
***--------------------------***

use $extr/redi01_ASEC-extr.dta, clear

// SURVEY WEIGHT INFO
// svyset [iweight=hwtsupp] 
	// household weight for hhincome
	
*sum hhincome

*histogram hhincome, frequency kdensity

keep if pernum == 1
svyset [pweight=asecwth]
compress

// RENAME to avoid confusion with ACS
rename hhincome asec_hinc_cont


// SAVE ALL YEARS

label data "CPS ASEC data - Household Income - 2016, 2017, 2019"
notes: redi01_ASEC-hhincome_all.dta \ CPS ASEC Data - Household Income 2016-2017, 2019 \ redi01_ASEC.do
datasignature set, reset
save $deriv/redi01_ASEC-hhincome_all.dta, replace


// SAVE YEARS 2016-2017

keep if year == 2016 | year == 2017 

label data "CPS ASEC data - Household Income - 2016-2017"
notes: redi01_ASEC-hhincome.dta \ CPS ASEC Data - Household Income 2016-2017 \ redi01_ASEC.do
datasignature set, reset
save $deriv/redi01_ASEC-hhincome.dta, replace


***--------------------------***
log close redi01_ASEC_import
exit
