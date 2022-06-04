capture log close redi04_ACS_descriptives
log using $redi/redi04_ACS_descriptives.log, name(redi04_ACS_descriptives) replace text

//	project:	REDI Methodology Paper

//  task:     	Descriptive data tables of original continuous ACS Variables (research dataset)
//  data: 		ACS, available: https://usa.ipums.org/

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

local p   "rediado"

use $deriv/redi03_ACS_convert-`p'.dta, clear
save $deriv/redi04_ACS_descriptives-`p'.dta, replace

*inflation done in redi03b_inflate_dollars.doi
local conv_year = 2017 // this is set in redi01_CPI-U-RS.do

// SURVEY WEIGHTS
*need to redo survey-set
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse
save $deriv/redi04_ACS_descriptives-`p'.dta, replace
	
***--------------------------***		
// GRAND MEAN 
***--------------------------***		

capture drop acs_hinc_cont_`conv_year'_mean
gen acs_hinc_cont_`conv_year'_mean = .
label var acs_hinc_cont_`conv_year'_mean "household (ACS) shp grand mean"

local y = year
di in red "Calculate grand mean for ACS household income for year `y'" 
svy: mean acs_hinc_cont_`conv_year' if year == 2016 // this is original variable: hhincome_asec
cap matrix X = r(table) 
	cap loc mf = X[1,1]
	di `mf'
replace acs_hinc_cont_`conv_year'_mean = `mf' if year == 2016

local y = year
di in red "Calculate grand mean for ACS household income for year `y'"
svy: mean acs_hinc_cont_`conv_year' if year == 2017 // this is original variable: hhincome_asec
cap matrix X = r(table) 
	cap loc mf = X[1,1]
	di `mf'
replace acs_hinc_cont_`conv_year'_mean = `mf' if year == 2017

save $deriv/redi04_ACS_descriptives-`p'.dta, replace
	
***--------------------------***		
// MEDIAN
***--------------------------***

// Levels of year variable to loop through years

levelsof year, local(years)
foreach y of local years { // loop through all years

	di in red "Below is the median ACS household income for `y':"

	_pctile  acs_hinc_cont_`conv_year' [pweight=perwt] if year == `y', p(50)
	return list

	
} // end loop through years

	
***--------------------------***		
// # GINI COEFFICIENT 
***--------------------------***

*use -fastgini- because allows pweights
*https://www.stata.com/statalist/archive/2008-10/msg01179.html
*fastgini varname [if] [in] [weight] [, bin(#) jk Level(#) nocheck]
foreach y of local years { // loop through all years

	use $deriv/redi04_ACS_descriptives-`p'.dta, clear
	keep if year == `y'
	
	*must have only positive numbers for Gini
	keep if acs_hinc_cont_`conv_year' != .
	replace acs_hinc_cont_`conv_year'  = 1 if  acs_hinc_cont_`conv_year'  <= 0
	
	di in red "Below is the gini of ACS household income for `y':"
	
	fastgini acs_hinc_cont_`conv_year' [pweight=perwt], nocheck
	local gini  r(gini) 
	di `gini'
	
} // end loop through years
	

***--------------------------***

log close redi04_ACS_descriptives
exit
