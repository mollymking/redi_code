capture log close rpme
log using $redi/redi20_ACS_rpme.log, name(rpme) replace text

//	project:	REDI Methodology Paper

//  task:     	RPME method of describing ACS
//  data: 		ACS, available: https://usa.ipums.org/

//  github:		redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King

display "$S_DATE  $S_TIME"

***--------------------------***
// # PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 180
clear all
set more off
set seed 1

local conv_year "2017"

use $deriv/redi04_acs_descriptives-hinc_shp.dta, clear

***--------------------------***
// # CLEAN UP DATA SET
***--------------------------***
drop repwtp* perwt hhincome* acs_hinc_shp_2017 redi*

duplicates drop year acs_hinc_shp_n ///
	acs_hinc_shp_`conv_year'lb acs_hinc_shp_`conv_year'ub, force
	

***--------------------------***
// # ROBUST PARETO MIDPOINT ESTIMATOR
***--------------------------***

*implemented the midpoint method in the "rpme" command for Stata. (von Hippel et al 2017)
*can constrain the midpoint method to match a known mean as well.

*one-time install:
*ssc install rpme
*ssc install egen_inequal
*ssc install _gwtmean

*help rpme

//form of program looks like this:
*rpme {acs_hinc_shp_n} {min} {max} [if] [in], [by(id) options]
*cases (number of cases in the bin),   min (lower limit of bin), max (upper limit of bin)

// constrained so mean matches grand mean 
*-  If the grand_mean() option is specified, then the mean of the top bin is calculated so that the mean of the bin midpoints and
	*	top bin mean will equal the grand mean.
di in red "mean constrained" 
rpme   acs_hinc_shp_n      acs_hinc_shp_`conv_year'lb 	acs_hinc_shp_`conv_year'ub,  ///
	by(year) grand_mean(acs_hinc_shp_`conv_year'_mean)  saving($deriv/redi21_ACS_alt_rpme_grandmean-hinc_shp)

	
// no constraints on mean
*-  If the grand_mean() option is not specified, then the mean of the top bin is calculated by fitting a Pareto curve to the top two
 *   populated bins. Because the arithmetic mean of a Pareto distribution can be volatile or undefined, a c mean is used instead.
di in red "Pareto curve"
rpme  acs_hinc_shp_n   acs_hinc_shp_`conv_year'lb 	acs_hinc_shp_`conv_year'ub,  ///
	by(year)  saving($deriv/redi21_ACS_alt_rpme-hinc_shp)

***--------------------------***

log close rpme
exit
