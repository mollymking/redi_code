capture log close redi_to_run_program
log using redi_to_run_program.log, name(redi_to_run_program) replace text
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
// # RANDOM SAMPLE OF ACS 2019 for TESTING
***--------------------------***
/*
use $deriv/redi13_ACS2019.dta, clear
gen random = runiform()
sort hhincome_acs random
by hhincome_acs: gen group = ceil(10* _n/_N)
keep if group == 1
drop random group
save $deriv/redi13_ACS2019sample.dta, replace
*/
***--------------------------***
// # RUN REDI.ADO PROGRAM ON 2016-2017 ACS data (artificially binned)
***--------------------------***

*for debugging:
noisily
*set trace on 
program drop _all
discard

use "~/Documents/SocResearch/Dissertation/data/data_derv/redi02_ACS_bins_clean.dta", clear

cd "~/Documents/SocResearch/redi/redi_code/redi_package/" // location of redi ado file
redi acs_hinc_shp year, ///
	generate(hhinccont) cpstype(household)  //inflationyear(2020)

***--------------------------***

capture log close redi_to_run_program
exit
