capture log close redi22_ACS_mgbe
log using $redi/redi22_ACS_mgbe.log, name(redi22_ACS_mgbe) replace text

//  project:	REDI Methodology Paper

//  task:     	MGBE method of describing ACS
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
*ssc install mgbe

local conv_year "2017" // year used for inflation

use $deriv/redi03_ACS_convert-hinc_shp.dta, clear

***--------------------------***
// # MULTIMODEL GENERALIZED BETA ESTIMATOR
***--------------------------***

drop repwt*
duplicates drop year acs_hinc_shp_n ///
	acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, force
keep year acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub

replace acs_hinc_shp_`conv_year'lb = 0 ///
	if acs_hinc_shp_`conv_year'lb < 0 // previously replaced values, switch back
compress
save $deriv/redi22_ACS_mgbe-hinc_shp.dta, replace

*mgbe command for Stata  (von Hippel et al 2017)
*mgbe accepts three arguments, in order:  acs_hinc_shp_n (number of  acs_hinc_shp_n per bin), 
	*min (lower limit of bin) and max (upper limit of bin).
* mgbe  acs_hinc_shp_n min max {if} [, DISTribution(string) AIC BIC AVERAGE SAVing(string) BY(id)]


/*
use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(PARETO2) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_pareto2-hinc_shp)

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(LN) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_ln-hinc_shp)

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(LOGLOG) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_loglog-hinc_shp)

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(GB2) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_GB2-hinc_shp)

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(DAGUM) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_DAGUM-hinc_shp)

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear	
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(SM) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_SM-hinc_shp)	

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(BETA2) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_BETA2-hinc_shp)	

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(GG) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_GG-hinc_shp)	

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear	
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(GA) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_GA-hinc_shp)	

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear	
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, distribution(WEI) ///
	by(year)  saving($deriv/redi22_ACS_mgbe_WEI-hinc_shp)	
*/
	
* Estimates will be averaged across distributions, with the average weighted according to the AIC (by default) or BIC.:

use  $deriv/redi22_ACS_mgbe-hinc_shp.dta, clear
mgbe  acs_hinc_shp_n acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, ///
	by(year) average saving($deriv/redi22_ACS_mgbe_average-hinc_shp)  


***--------------------------***
		
log close redi22_ACS_mgbe
exit
