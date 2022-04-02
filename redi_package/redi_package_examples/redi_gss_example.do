// change to location where all files are stored, including downloaded data
cd  "~/Documents/SocResearch/redi/redi_code/redi_package/redi_package_examples"

capture log close redi_gss_example
log using redi_gss_example.log, name(redi_gss_example) replace text
display "$S_DATE  $S_TIME"

***--------------------------***
// # PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off
set seed 1
prog drop _all

***--------------------------***
// # IMPORT CPS ASEC with ALL INCOME TYPES
***--------------------------***

do cps_00016.do

// SAVE
label data "Imported original CPS ASEC data from IPUMS"
notes: CPS_ASEC_allInc.dta \ Extracted CPS ASEC Data from IPUMS \ redi_gss_example.do mmk $DATE
compress
keep year hhincome ftotval inctot pernum asecwth
datasignature set, reset
save cps_reference.dta, replace

***--------------------------***
// # IMPORT GSS
***--------------------------***

*use sample GSS dataset from UW website: 
* https://www.ssc.wisc.edu/sscc/pubs/sfs/sfs-files.htm
use gss_sample.dta, clear

// SAVE
label data "Sample GSS data from https://www.ssc.wisc.edu/sscc/pubs/sfs/sfs-files.htm"
notes: GSS.dta \ Sample GSS from UW - year and income \ redi_gss_example.do mmk $DATE
compress
keep year rincome income
datasignature set, reset
save GSS.dta, replace

***--------------------------***
// # RUN REDI on GSS
***--------------------------***

prog drop _all

use GSS.dta, clear

// family income example
redi income year, ///
	generate(finc_continuous) cpstype(family) 

use GSS.dta, clear	
	
// individual income example
redi rincome year, ///
	generate(rinc_continuous) cpstype(respondent)  inflationyear(2020)
	
***--------------------------***

capture log close redi_gss_example
exit
