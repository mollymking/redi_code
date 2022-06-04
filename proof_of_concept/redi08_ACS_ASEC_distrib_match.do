capture log close redi08_ACS_ASEC_distrib_match
log using $redi/redi08_ACS_ASEC_distrib_match.log, name(redi08_ACS_ASEC_distrib_match)replace text

// 	project:	REDI Methods Paper

//  task:     	Diagnostic: Comparing Binned Distributions of ACS and CPS ASEC
//  data: 		CPS ASEC 
//				& ACS

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King

display "$S_DATE  $S_TIME"

***--------------------------***
// # MOTIVATION
***--------------------------***
/*
A diagnostic running the difference in distributions between the two datasets.
If you bin the continuous distribution it should match the binned distribution.
If you took the reference distribution (the one with the continuous values), binned it using the same categories as the binned distribution, and the proportions in the different bins between the two distributions were dissimilar, that would be evidence against the reference distribution being a good source to impute values of the binned distribution.
Show that the reference distribution is of the same scale (i.e. if 30% of people earn below $30k in research dataset, same is true in reference) – 
should be the case because nationally representative
*/
***--------------------------***
// # PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off

set scheme s1color 

local Teal "57 118 104"
local Gold "188 121 18"
local Green "149 158 74"
local Blue "93 164 181"
local LtGrey "233 233 234"
local DkGrey "147 149 152"


local conv_year "2017"

***--------------------------***
// # MERGE ASEC & CPS
***--------------------------***

*ACS dataset comes from here:
use  $deriv/redi03_ACS_convert-hinc_shp.dta, clear 
drop repwt*

*Prepare data for merge
duplicates drop year acs_hinc_shp, force
keep year 	acs_hinc_* 	redi_*
rename acs_hinc_shp  	hinc_shp  // rename for merge with ASEC data from 09_ASEC_bins
// technically,  acs_hinc_shp comes from 02_ACS_bins originally, back before was any merging with 03_ACS_convert
// this is useful for pure comparison between ACS bins and ASEC bins

save $deriv/redi08_ACS_ASEC_distrib_match-hinc_shp.dta, replace

merge 1:1 year hinc_shp using $deriv/redi05_ASEC_bins-hinc_shp-nodups.dta 
	// this is ASEC dataset - asec_hinc_shp is categorical variable


label define  shp_cat		///
	1	"Under $15k"	 	///
	2	"$15k - $25k" 		///
	3	"$25k - $35k" 		///
	4	"$35k - $50k" 		///
	5	"$50k - $75k" 		///
	6	"$75k - $100k" 		///
	7	"$100k - $150k" 	///
	8	"$150k - $200k" 	///
	9	"$200k or more"  	//
	
lab val hinc_shp shp_cat


***--------------------------***
// # GENERATE PROPORTION
***--------------------------***

bysort year: egen asec_hinc_shp_N = total(asec_hinc_shp_n)
bysort year: gen asec_hinc_shp_prop = asec_hinc_shp_n /  asec_hinc_shp_N

bysort year: egen acs_hinc_shp_N = total(acs_hinc_shp_n)
bysort year: gen acs_hinc_shp_prop = acs_hinc_shp_n / acs_hinc_shp_N	

save $deriv/redi08_ACS_ASEC_distrib_match-hinc_shp.dta, replace

***--------------------------***
// HISTOGRAM - SHARP BINS
***--------------------------***

use $deriv/redi08_ACS_ASEC_distrib_match-hinc_shp.dta, clear

graph bar acs_hinc_shp_prop  asec_hinc_shp_prop, ///
	over(hinc_shp, lab(angle(45))) ///
	bargap(-30)  ///
	bar(1, 	fcolor("`Blue'") lcolor("`DkGrey'") fintensity(inten40) ) ///
	bar(2, fcolor("`Gold'") lcolor("`DkGrey'") fintensity(inten40)) ///
	ytitle("Proportion Responses" "by Income Bin") /// 
	by(year, ///2
		b1title("Household Income Range") ///
		note("") ///
		) ///
	legend( ///
		label(1 "ACS Bin Proportion") ///
		label(2 "CPS ASEC Bin Proportion") ///
		size(vsmall) /// size of text
		margin(small) nobox region(fcolor(white) lcolor(white))) //

graph export ///
	$redi/redi08_ACS_ASEC_distrib_match-prop-hinc_shp_byYear.pdf, ///
	replace

***--------------------------***

log close redi08_ACS_ASEC_distrib_match
exit
