capture log close
log using $redi/redi07_REDI_descriptives_redi.log, replace text

// 	project:	REDI Methods Paper
//  task:     	Descriptive data tables of continuous REDI-created Variables
//  data: 		ACS, available: https://usa.ipums.org/
//  github:   	dissertation_code
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

* References:
*https://www.stata.com/support/faqs/statistics/percentiles-for-survey-data/
*https://www.statalist.org/forums/forum/general-stata-discussion/general/19394-using-svy-and-computing-medians

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do

local p "longform" // alt:  "rediado"

use $deriv/redi03_ACS_convert-`p'.dta, clear

// SURVEY WEIGHTS
*need to redo survey-set
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

save $deriv/redi07_redi_descriptives-`p'.dta, replace


***--------------------------***		
// MEDIAN
***--------------------------***

//Levels of year variable to loop through years

levelsof year, local(years)
foreach y of local years { // loop through all years

	use $deriv/redi07_REDI_descriptives-`p'.dta, clear
	keep if redi_hinc_cont_inf`conv_year' != .
	
	di in red "Calculate REDI median household income for `y':"

	*https://www.stata.com/statalist/archive/2011-05/msg00148.html
	*_pctile  redi_hinc_cont_inf`conv_year' [pweight=perwt] if year == `y', p(50)
	*return list
	
	*https://www.stata.com/statalist/archive/2011-05/msg00148.html
	*epctile varname [if] [in] [weight] , percentiles(numlist) [options]
	 epctile redi_hinc_cont_inf`conv_year', percentiles(50) svy subpop(if year == `y')
	 return list
	 matrix list r(table)
	 cap matrix M = r(table)
	 
	 cap scalar med`y' = M[1,1]
	 
} // end loop through years

capture drop  	redi_hinc_cont_inf`conv_year'_median
gen 			redi_hinc_cont_inf`conv_year'_median = .
replace 		redi_hinc_cont_inf`conv_year'_median = med2016 if year == 2016
replace 		redi_hinc_cont_inf`conv_year'_median = med2017 if year == 2017

***--------------------------***		
// GRAND MEAN 
***--------------------------***

use $deriv/redi07_REDI_descriptives-`p'.dta, clear

keep if redi_hinc_cont_inf`conv_year' != .

capture drop redi_hinc_cont_inf`conv_year'_mean
gen redi_hinc_cont_inf`conv_year'_mean = .
label var redi_hinc_cont_inf`conv_year'_mean "REDI household income `conv_year' grand mean"

* convert 2016 values to 2017 dollars
di in red "Calculate grand means for REDI household income for both years" 
svy: mean redi_hinc_cont_inf`conv_year', over(year)
cap matrix X = r(table) 

*year 2016  REDI 
cap scalar mn16 = X[1,1]		
di in blue "The inflation-adjusted 2016 REDI grand mean of household income in 2017 dollars is:"
di mn16 
replace redi_hinc_cont_inf`conv_year'_mean = mn16 if year == 2016

*year 2017  REDI 
cap scalar mn17 = X[1,2]
di in blue "The inflation-adjusted 2017 REDI grand mean of household income in 2017 dollars is:"
di mn17
replace redi_hinc_cont_inf`conv_year'_mean = mn17 if year == 2017

*calculate standard deviation 
*the -by()- option defines groups within which SD is calculated. 
egen redi_hinc_cont_inf`conv_year'_sd = sd(redi_hinc_cont_inf`conv_year'), by(year)

save $deriv/redi07_REDI_descriptives-`p'.dta, replace

***--------------------------***
// # GINI COEFFICIENT 
***--------------------------***

*use -fastgini- because allows pweights
*https://www.stata.com/statalist/archive/2008-10/msg01179.html
*fastgini varname [if] [in] [weight] [, bin(#) jk Level(#) nocheck]

foreach y of local years { // loop through all years

	use $deriv/redi07_REDI_descriptives-`p'.dta, clear
	keep if year == `y'	

	replace redi_hinc_cont_inf`conv_year'  = 1 if  redi_hinc_cont_inf`conv_year'  <= 0

	di in red "Below is the gini for REDI-calculated household income for `y':"
	
	fastgini  redi_hinc_cont_inf`conv_year' [pweight=perwt]
	
	local gini = r(gini) 
	di `gini'
	
} // end loop through years

***--------------------------***

log close 
exit
