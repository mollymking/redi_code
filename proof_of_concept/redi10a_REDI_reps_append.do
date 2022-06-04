capture log close redi10a_REDI_reps_append
log using $redi/redi10a_REDI_reps_append.log, name(redi10a_REDI_reps_append) replace text

// 	project:	REDI Methods Paper
//  task:     	Append x replications of data produced in redi10 - only for proof-of-concept

//  data: 		REDI means, medians, Ginis produced in computer cluster
//					using redi10_REDI_mean_distribution.do
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

local inc_var_short_list "hinc"  // finc
local inc_types "shp" // other option "perc"
local conv_year = 2017 // this is set in ki11_redi00_CPI-U-RS.do

***--------------------------***
// APPEND
***--------------------------***

use $deriv/redi10_REDI_summary_stats_$n_replications_1.dta
save $deriv/redi10a_REDI_reps_append.dta, replace

local run = 5 // last run number on cpu	

forvalues n=2(1)`run' {
	
	use $deriv/redi10_REDI_summary_stats_$n_replications_1.dta, replace
	
	append using $deriv/redi10_REDI_summary_stats_$n_replications_`run'.dta

	save $deriv/redi10a_REDI_reps_append.dta, replace

} // end of loop through runs


***--------------------------***
// # SAVE DATA
***--------------------------*** 

label data "REDI mean and median distribution replications - from WAVE cluster"
notes: redi10a_REDI_reps_append.dta \ REDI mean and median and gini distribution replications - from WAVE cluster  \ /// 
redi10a_REDI_reps_append.do mmk  $S_DATE
compress
datasignature set, reset  
save $deriv/redi10a_REDI_reps_append.dta, replace


***--------------------------***		
// MEDIAN & MEAN & GINI
***--------------------------***

//Levels of year variable to loop through years

levelsof year, local(years)
foreach y of local years { // loop through all years

	use  $deriv/redi10a_REDI_reps_append.dta, clear
	
	di in red "median for year `y'"  
	centile redi_hinc_cont_inf2017_median  if year == `y', centile(5 50 95) 
	centile redi_hinc_cont_inf2017_median  if year == `y', centile(5 50 95) meansd 
	// meansd option  causes the centile and confidence interval to be calculated based on the sample mean and standard deviation, 
	 //and it assumes normality.

} // end loop through years


di in red "grand mean for year `y'" 

egen grand_mean = mean(redi_hinc_cont_inf2017_mean), by(year)


di in red "grand gini for year `y'" 

egen grand_gini = mean(redi_hinc_cont_inf2017_gini), by(year)

		
***--------------------------***

log close redi10a_REDI_reps_append
exit

