capture log close redi11_ASEC_regressions
log using $redi/redi11_ASEC_regressions.log, name(redi11_ASEC_regressions) replace text

// 	project:	REDI Methods Paper

//  task:     	Regression of continuous CPS ASEC variables
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

local conv_year = 2017 // this is set in ki11_bidee00_CPI-U-RS.do

do $redi/cps_00015.do // larger data set includes variables for later regression

keep if pernum == 1
svyset [pweight=asecwth]
compress

// RENAME to avoid confusion with ACS
rename hhincome asec_hinc_cont
rename race race_asec
rename hispan hispan_asec
rename educ educ_asec
rename sex sex_asec
rename marst marst_asec
rename migrate1  migrate1_asec
rename diffmob diffmob_asec
rename ownershp ownershp_asec

***--------------------------***
// # CREATE SHARP CATEGORY BOUNDS - HOUSEHOLD
***--------------------------***

label define  cat_inc	 				///
	1	"Less than $15000"	 			///
	2	"15000 to less than 25000" 		///
	3	"25000 to less than 35000" 		///
	4	"35000 to less than 50000" 		///
	5	"50000 to less than 75000" 		///
	6	"75000 to less than 100000" 	///
	7	"100000 to less than 150000" 	///
	8	"150000 to less than 200000" 	///
	9	"200000 or more" 				//

*arbitrary categories invented to demonstrate flexibility of method
gen 	asec_hinc_shp = .
replace asec_hinc_shp = 1 if asec_hinc_cont	<= 15000
replace asec_hinc_shp = 2 if asec_hinc_cont  > 15000 	& asec_hinc_cont <= 25000
replace asec_hinc_shp = 3 if asec_hinc_cont  > 25000 	& asec_hinc_cont <= 35000
replace asec_hinc_shp = 4 if asec_hinc_cont  > 35000 	& asec_hinc_cont <= 50000	
replace asec_hinc_shp = 5 if asec_hinc_cont  > 50000 	& asec_hinc_cont <= 75000	
replace asec_hinc_shp = 6 if asec_hinc_cont  > 75000 	& asec_hinc_cont <= 100000
replace asec_hinc_shp = 7 if asec_hinc_cont  > 100000 	& asec_hinc_cont <= 150000 
replace asec_hinc_shp = 8 if asec_hinc_cont  > 150000 	& asec_hinc_cont <= 200000
replace asec_hinc_shp = 9 if asec_hinc_cont  > 200000 	& asec_hinc_cont != 9999999 
replace asec_hinc_shp = . if asec_hinc_cont == 9999999 
replace asec_hinc_shp = . if asec_hinc_cont == .

label values asec_hinc_shp cat_inc

tab asec_hinc_shp, m
tab asec_hinc_shp, m nolab

* SAVE SHARP INCOME VARIABLE
label var asec_hinc_shp "household Income (ASEC) sharp categories based on asec_hinc_cont"
notes asec_hinc_shp: ASEC household Income Sharp Categories from asec_hinc_cont \  mmk $S_DATE

***--------------------------***
// # COUNT NUMBER OF CASES IN EACH BIN
***--------------------------***

* COUNT BY SHARP BINS
gen id = _n
egen asec_hinc_shp_n = count(id), by(asec_hinc_shp year)
label var asec_hinc_shp_n "Count of cases of household Income (ASEC) sharp within year (count of asec_hinc_shp by year)"

label data "CPS ASEC data - Household Income - 2016, 2017, 2019"
notes: redi01_ASEC-hhincome_all.dta \ CPS ASEC Data - Household Income 2016-2017, 2019 \ redi01_ASEC.do
datasignature set, reset
save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace

***--------------------------***
// INFLATION
***--------------------------***		
	
local y = year

merge m:1 year using $deriv/redi01_CPI-U-RS.dta
keep if _merge == 3 // keep only matches - not matched where different years
drop _merge
svyset [iweight=asecwth]

*original income variable, adjusted for inflation
gen asec_hinc_shp_`conv_year' = asec_hinc_cont / conv_factor
format asec_hinc_shp_`conv_year' %6.0fc
label var asec_hinc_shp_`conv_year' "Inflation-adjusted household income (ASEC), from shp categories, `conv_year' dollars"

***--------------------------***	
// # CREATE NATURAL LOG INCOME VARIABLES
***--------------------------***	

gen asec_lnhinc_shp_`conv_year' = ln(asec_hinc_shp_`conv_year')

label var asec_hinc_shp_`conv_year' "Inflation-adjusted natural log household income (ASEC), from shp categories, `conv_year' dollars"


***--------------------------***	
// SAVE 
***--------------------------***	
		
save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace

***--------------------------***
// DEMOGRAPHICS needed for REGRESSION
***--------------------------***
		
// #1 GENDER
 
local gender_var sex_asec // gender variable in ASEC is "sex"
tab `gender_var', m
tab `gender_var', nolab m

include $redi/redi11a_include_female_from2W_1M.doi

***--------------------------***

// #2 RACE / ETHNICITY - with RACE variable only

local race_var race_asec
tab `race_var'
tab `race_var', m nolab

gen hisp = .
replace hisp = 1 if hispan_asec >=1
replace hisp = 0 if hispan_asec == 0

replace race_asec = 800 if race_asec >=800

local hisp_var hisp

if "`hisp_var'" != "none" {
	tab `hisp_var', m
	tab `hisp_var', m nolab
	tab `race_var' `hisp_var'
}

*don't know/refused code(s) for `race_var'
local race_missing_condition none

local white_race_value = 	100 
local black_race_value = 	200
local asian_race_value =	651
local hisp_value =			1
local other_race_value = 	652
local mult_race_value = 	800
local amerInd_race_value  = 300

include $redi/redi11b_racethnicity.doi

fvset base 1 dG_race		// ref: white

***--------------------------***

// #3 EDUCATION

local edu_var educ_asec
tab `edu_var'
tab `edu_var', nolab m

*don't know/refused code(s) for `edu_var'
local edu_missing_condition `"`edu_var' == 8 | `edu_var' == 9"'

* Conditions for each category
local lHS_condition 	`"`edu_var' <= 71"'
local HS_condition 		`"`edu_var' == 73"'
local sCol_condition	`"`edu_var' == 81 | `edu_var' == 91 | `edu_var' == 92"'
local col_condition		`"`edu_var' == 111"'
local grad_condition	`"`edu_var' >= 123"'

include $redi/redi11c_education.doi

fvset base 1 dG_edu  		// ref: less than HS


***--------------------------***

// # INDEPENDENT LIVING DIFFICULTY

/*DIFFMOB indicates whether the respondent has any physical, mental, or 
emotional condition lasting six months or more that makes it difficult or 
impossible to perform basic activities outside the home alone. 
This does not include temporary health problems, such as broken bones.*/

tab diffmob_asec
tab diffmob_asec, nolab

generate disability = .
replace disability = 1 if diffmob_asec == 2
replace disability = 0 if diffmob_asec == 1

tab diffmob_asec disability, m


***--------------------------***

// # MARITAL STATUS

tab marst_asec
tab marst_asec, nolab

generate married = .
replace married = 1 if marst_asec == 1 | marst_asec == 2
replace married = 0 if marst_asec == 3 | marst_asec == 4 |  marst_asec == 5 | marst_asec == 6

tab marst_asec married, m

***--------------------------***

// # LABOR FORCE

/*LABFORCE is a dichotomous variable indicating whether a person participated 
in the labor force. See EMPSTAT for a non-dichotomous variable that indicates 
whether the respondent was part of the labor force -- working or seeking work 
-- and, if so, whether the person was currently unemployed.*/

tab labforce
tab labforce, nolab m

generate labor = .
replace labor = 1 if labforce == 2
replace labor = 0 if labforce == 1

tab labforce labor, m


***--------------------------***

// # OWNERSHIP OF HOUSING

/*OWNERSHP indicates whether the housing unit was rented or owned by its inhabitants. 
Housing units acquired with a mortgage or other lending arrangement(s) are 
classified as "owned," even if repayment was not yet completed.*/

tab ownershp_asec
tab ownershp_asec, nolab

generate ownhouse = .
replace ownhouse = 1 if ownershp_asec == 10
replace ownhouse = 0 if ownershp_asec == 21 | ownershp_asec == 22

tab ownershp_asec ownhouse, m

***--------------------------***
/*
// # MIGRATION STATUS

/*MIGRATE1 indicates whether the respondent had changed residence in the past year. Those who were living in the same house as one year ago were considered non-movers and were asked no further questions about migration over the past year. Movers were asked about the city, county and state and/or the U.S. territory or foreign country where they resided one year ago.*/

tab migrate1_asec
tab migrate1_asec, nolab

generate migrate = .
replace migrate = 1 if migrate1_asec == 2 | migrate1_asec == 3 | migrate1_asec == 4 | migrate1_asec == 5 | migrate1_asec == 6
replace migrate = 0 if migrate1_asec	== 1

*/
***--------------------------***

save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace
use $deriv/redi11_ASEC_regressions-hinc_shp.dta, clear

***--------------------------***
// REGRESSION: CPS ASEC Income as DV
***--------------------------***	

di in red "Predict ASEC income as a function of gender of householder, " ///
		  "race/ethnicity, education"	
svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category


di in red "Predict ASEC income as a function of gender of householder, " ///
		  "race/ethnicity, education, married, disability"	
svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability


di in red "Predict ASEC income as a function of gender of householder, " ///
		  "race/ethnicity, education, married, disability, labor force"	

svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor

	
/*
***--------------------------***
// REGRESSION: REDI Income as IV: Predict Migration
***--------------------------***	

di in red "Predict migration as function of ASEC ln(income), " ///
		  "gender, race/ethnicity, education, married, disability"
svy: logistic migrate ///
	asec_lnhinc_shp_`conv_year' ///	
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability  //

di in red "Predict migration as function of ASEC ln(income), add home ownership"
svy: logistic migrate ///
	asec_lnhinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse //
	
*/
***-----
// Check if systematically different values between REDI and ACS Research Dataset
*use $deriv/redi11_ASEC_regressions-hinc_shp.dta, clear


*inflation-adjusted
table dB_fem , 	c(mean asec_hinc_shp_`conv_year')
table dG_race, 	c(mean asec_hinc_shp_`conv_year')
table dG_edu, 	c(mean asec_hinc_shp_`conv_year')


***--------------------------***


capture log close redi11_ASEC_regressions
exit
