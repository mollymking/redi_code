capture log close redi03_ACS_convert
log using $redi/redi03_ACS_convert.log, name(redi03_ACS_convert) replace text

//	project:	REDI Methodology Paper

//  task:     	Convert back to continuous incomes
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

use $deriv/redi02_ACS_bins.dta, clear	
save $deriv/redi03_ACS_convert-hinc.dta, replace

local year "year"

*year of conversion factor
local conv_year = 2017 // this is set in redi01_CPI-U-RS.do
		
***--------------------------***
// # INCOME CONVERSIONS
***--------------------------***

// A) ASEC CONTINUOUS INCOME CONVERSIONS

*Converts ACS data bins (those defined by acs_hinc_shp) into continuous values, using values found in ASEC

include $redi/redi03a_categ_distrib.doi

save $deriv/redi03_ACS_convert-hinc_shp.dta, replace

	
// B) CONVERT CONTINUOUS INCOME TO `conv_year' DOLLARS

include $redi/redi03b_inflate_dollars.doi
		

***--------------------------***
// # CLEAN UP - variables brought from ASEC
***--------------------------***

keep if year == 2016 | year == 2017	
*drop asecwth cpi_avg conv_factor_2017 repwt pers_inc 

***--------------------------***
// # SAVE DATA 
***--------------------------***

label data "ACS data converted to continuous REDI-calculated values"
notes: redi03_ACS_convert-hinc_shp.dta \ ///
	ACS hinc_shp Data converted to continuous \ /// 
	redi03_ACS_convert.do  $S_DATE
compress
datasignature set, reset  

save $deriv/redi03_ACS_convert-hinc_shp.dta, replace

di in red "End of redi_inflate_dollars.doi for household and shp variables" 


***--------------------------***

log close redi03_ACS_convert
exit
