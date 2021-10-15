capture log close redi09_REDI_ACS_distrib_match
log using $redi/redi09_REDI_ACS_distrib_match.log, name(redi09_REDI_ACS_distrib_match) replace text

// 	project:	REDI Methods Paper

//  task:     	Compare continuous distributions from original ACS & REDI
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

*one-time install:
*ssc install distplot

local conv_year "2017"

***--------------------------***
// # CDF comparing original and created continuous distributions
***--------------------------***

use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear
save $temp/redi09_REDI_ACS_distrib_match.dta, replace

// CREATE NATURAL LOG INCOME VARIABLES

di in red "Create natural log income variables for acs_hinc_shp_`conv_year'"

gen redi_dV_hinc_shp_`conv_year'_ln = ln(redi_dV_hinc_shp_`conv_year')
gen acs_hinc_shp_`conv_year'_ln = ln(acs_hinc_shp_`conv_year')
gen redi_dV_hinc_shp_`conv_year'_log = log(redi_dV_hinc_shp_`conv_year')
gen acs_hinc_shp_`conv_year'_log = log(acs_hinc_shp_`conv_year')

clonevar redi_inc = acs_hinc_shp_`conv_year'
replace  redi_inc = 1 if acs_hinc_shp_`conv_year' <= 0

save $temp/redi09_REDI_ACS_distrib_match.dta, replace

*distplot varlist [if] [in] [weight] [, by(varname[, sub_options]) { frequency | midpoint } reverse[(ge)]
*                trscale(transformation_syntax) graph_options ]
*log x-scale:  https://www.stata.com/manuals13/g-3axis_scale_options.pdf#g-3axis_scale_options


*Log plot
/*
distplot acs_hinc_shp_`conv_year' redi_dV_hinc_shp_`conv_year', ///
legend( ///
		label(1 "REDI-calculated continuous income") ///
		label(2 "Original household income (ACS)") ///
		size(vsmall) /// size of text
		margin(small) nobox region(fcolor(white) lcolor(white))) ///
	ytitle("Cumulative probability included in distribution") /// 
	xtitle("shp Income (`conv_year' dollars)") ///
	xscale(log) /// 
	xlabel(1 100 1000 10000  100000 1000000) //
	
graph export $redi/redi09_REDI_ACS_distrib_match-log.pdf, replace
*/

*Natural log plot

distplot acs_hinc_shp_`conv_year'_ln redi_dV_hinc_shp_`conv_year'_ln, ///
lp(1 solid 2 dots) /// different line types
legend( ///
		label(1 "REDI-calculated continuous household income") ///
		label(2 "Original household income (ACS)") ///
		size(vsmall) /// size of text
		margin(small) nobox region(fcolor(white) lcolor(white))) ///
	ytitle("Cumulative probability included in distribution") /// 
	xtitle("REDI-calculated Income (`conv_year' dollars)") //
	*xscale(log) ///
	*xlabel(0 200000 500000 1000000 2000000 3000000) //
	
	
graph export $redi/redi09_REDI_ACS_distrib_match-ln.jpg, ///
	replace quality(60) // quality between 0-100 allows for compression

rm  $temp/redi09_REDI_ACS_distrib_match.dta

***--------------------------***
// # MEASURE OF CONFIDENCE - TWO SAMPLE, TWO-SIDED t-TEST REDI vs. ACS
***--------------------------***

use $deriv/redi07_REDI_descriptives-hinc_shp.dta, clear
save $deriv/redi09_REDI_ACS_distrib_match-hinc_shp.dta, replace

keep year perwt redi_dV_hinc_shp_`conv_year' acs_hinc_shp_`conv_year'  repwtp* 
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

// reshape long so can do two sample test with over() variables
rename acs_hinc_shp_`conv_year'  var_hinc1
rename redi_dV_hinc_shp_`conv_year'  var_hinc2
	generate id = _n

reshape long var_hinc, i(id) j(acs_redi)
replace acs_redi = 0 if  acs_redi == 2
label define acs_redi 1 "acs" 0 "redi"
label values acs_redi acs_redi


// now ttest, loop by year
levelsof year, local(years)
foreach y of local years { // loop through all years

	*ttest redi_dV_hinc_shp_`conv_year' == acs_hinc_shp_`conv_year'  [pweight=perwt] , unequal unpaired
	svy: regress var_hinc acs_redi if year == `y'
	test acs_redi // Wald test

} // end loop through years		

***--------------------------***
// # Kolmogorov-Smirnov equality-of-distributions test
***--------------------------***
levelsof year, local(years)
foreach y of local years { // loop through all years

	*A two-sample test tests the equality of the distributions of two samples.
	*  ksmirnov varname [if] [in] , by(groupvar) [exact]
	ksmirnov var_hinc if year == `y', by(acs_redi)

} // end loop through years
	
	
***--------------------------***
// #    Epps-Singleton two-sample empirical characteristic function test
***--------------------------***		
*https://www.stata-journal.com/sjpdf.html?articlenum=st0174
* escftest varname [if] [in], group(groupvar) [t1(#) t2(#)]
levelsof year, local(years)
foreach y of local years { // loop through all years

	escftest var_hinc if year == `y', group(acs_redi)
	
}

***--------------------------***

log close redi09_REDI_ACS_distrib_match
exit
