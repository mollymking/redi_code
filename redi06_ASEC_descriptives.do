capture log close redi06_ASEC_descriptives
log using $redi/redi06_ASEC_descriptives.log, name(redi06_ASEC_descriptives) replace text

// 	project:	REDI Methods Paper

//  task:     	Descriptive data tables of ORIGINAL continuous ASEC Variables - before conversion to BINCONT
//  data:     	CPS ASEC from IPUMS, available: https://cps.ipums.org/

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

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do

use $deriv/redi05_ASEC_bins-hinc.dta, clear
save $deriv/redi06_ASEC_descriptives-hinc.dta, replace
	
***--------------------------***
// INFLATION
***--------------------------***		

merge m:1 year using $deriv/redi01_CPI-U-RS.dta
keep if _merge == 3 // keep only matches - not matched where different years
drop _merge
svyset [iweight=asecwth]
save $deriv/redi06_ASEC_descriptives-hinc.dta, replace


*original income variable, adjusted for inflation
local inflated_reference_var "asec_hinc_cont_`conv_year'"
gen asec_hinc_cont_`conv_year' = asec_hinc_cont / conv_factor
format asec_hinc_cont_`conv_year' %6.0fc
label var asec_hinc_cont_`conv_year' "Inflation-adjusted household income (ASEC), `conv_year' dollars"
		
	
***--------------------------***		
// GRAND MEAN 
***--------------------------***		
		
capture drop asec_hinc_cont_`conv_year'_mean
gen asec_hinc_cont_`conv_year'_mean = .
label var asec_hinc_cont_`conv_year'_mean "ASEC household grand mean"

levelsof year, local(years)
foreach y of local years { // loop through all years
 
	di in red "Calculate grand mean for ASEC household income for year `y'"
	svy: mean asec_hinc_cont_`conv_year' if year == `y' // 
	cap matrix X = r(table) 
		cap loc mf = X[1,1]
		di `mf'
	replace asec_hinc_cont_`conv_year'_mean = `mf' if year == `y'

} // end loop through years

save $deriv/redi06_ASEC_descriptives-hinc.dta, replace

***--------------------------***		
// MEDIAN
***--------------------------***

// Levels of year variable to loop through years

foreach y of local years { // loop through all years

	di in red "Below is the median for ASEC household income for `y':"

	_pctile  asec_hinc_cont_`conv_year' [pweight=asecwth] if year == `y', p(50)
	return list

} // end loop through years

***--------------------------***		
// # GINI COEFFICIENT }
***--------------------------***

*use -fastgini- because allows pweights
*https://www.stata.com/statalist/archive/2008-10/msg01179.html
*fastgini varname [if] [in] [weight] [, bin(#) jk Level(#) nocheck]

foreach y of local years { // loop through all years

	use $deriv/redi06_ASEC_descriptives-hinc.dta, clear
	keep if year == `y'
	
	di in red "Below is the gini for ASEC household income for `y':"
	
	fastgini asec_hinc_cont_`conv_year', nocheck
	local gini  r(gini) 
	di `gini'
	
} // end loop through years

***--------------------------***
// CLEAN UP
***--------------------------***

log close redi06_ASEC_descriptives
exit
