* Setup notes:
* download full "reditest" folder, including "temp", 
* and change working directory below
* to direct if different from Desktop

*cd "~/Desktop/reditest/"
*global temp		"~/Desktop/reditest/temp"

***--------------------------***

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
// # RUN REDI.ADO PROGRAM ON 2019 California DATA
***--------------------------***

use $deriv/redi13_ACS2019sample.dta, clear

*for debugging:
noisily
set trace on 
program drop _all
discard

use $deriv/redi13_ACS2019sample.dta, clear
cd $redi/redi_package/

redi acs_hhinc year, generate(ca_redi_inc19) cpstype(household)

*redi inc_research_dataset year, gen(newvarname) inflation
*if inflation is not specified, it will be 0, so then

* want to look something like:
* redi inc_var(acs_hhinc) year(year), newvar = ca_redi_inc19 inflate(2020)
* or simply:
* redi acs_hhinc year, ca_redi_inc19 2020.

***--------------------------***

capture log close redi_to_run_program
exit
