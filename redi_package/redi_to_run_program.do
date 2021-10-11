* Setup notes:
* download full "reditest" folder, including "temp", 
* and change working directory below
* to direct if different from Desktop

cd "~/Desktop/reditest/"
global temp		"~/Desktop/reditest/temp"

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
// # REDI
***--------------------------***

use redi13_ACS2019sample.dta, clear

discard
set trace on 
redi acs_hhinc year // newvar = ca_redi_inc19

* want to look something like:
* redi inc_var(acs_hhinc) year(year), newvar = ca_redi_inc19 inflate(2020)
* or simply:
* redi acs_hhinc year, ca_redi_inc19 2020.

***--------------------------***

capture log close redi_to_run_program
exit
