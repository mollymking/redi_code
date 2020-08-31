capture log close redi21_ACS_cdf
log using $redi/redi21_ACS_cdf.log, name(redi21_ACS_cdf) replace text

// 	project:	REDI Methodology Paper

//  task:     	CDF method of describing ACS
//  data: 		ACS, available: https://usa.ipums.org/

//  github:		redi
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

*one-time install:
*ssc install distplot

local conv_year "2017"

***--------------------------***
// # PREP FOR CDF INTERPOLATION IN R
***--------------------------***

use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear
drop repwt*
keep if year == 2016
save $deriv/redi21_ACS_cdf-hinc_shp-2016.dta, replace

use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear
drop repwt*
keep if year == 2017
save $deriv/redi21_ACS_cdf-hinc_shp-2017.dta, replace

	
***--------------------------***
// # GET NUMBERS FOR CDF INTERPOLATION IN R
***--------------------------***

use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear
drop repwt*
keep if year == 2016
duplicates drop acs_hinc_shp, force
keep acs_hinc_shp_2017ub acs_hinc_shp_n

use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear
drop repwt*
keep if year == 2017
duplicates drop acs_hinc_shp, force	
keep acs_hinc_shp_2017ub acs_hinc_shp_n


*The rest of this method is carried out in R -
	* see  binsmooth.Rproj
	* and  cdf_interpolation.R
	* in the binsmooth folder

***--------------------------***

log close redi21_ACS_cdf
exit

