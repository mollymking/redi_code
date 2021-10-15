capture log close redi11_ASEC_regressions
log using $redi/redi11_ASEC_regressions.log, name(redi11_ASEC_regressions) replace text

// 	project:	REDI Methods Paper

//  task:     	Regression of original continuous CPS ASEC variables
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

use $deriv/redi05_ASEC_bins-hinc_shp.dta, clear
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
gen asec_hinc_shp_`conv_year' = hhincome_asec / conv_factor
format asec_hinc_shp_`conv_year' %6.0fc
label var asec_hinc_shp_`conv_year' "Inflation-adjusted household income (ASEC), from shp categories, `conv_year' dollars"

***--------------------------***	
// # CREATE NATURAL LOG INCOME VARIABLES
***--------------------------***	

gen asec_lnhinc_shp_`conv_year' = ln(asec_hinc_shp_`conv_year')

label var asec_hinc_shp_`conv_year' "Inflation-adjusted natural log household income (ASEC), from shp categories, `conv_year' dollars"


***--------------------------***	
		
save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace

***--------------------------***
// DEMOGRAPHICS needed for REGRESSION
***--------------------------***
		
// #1 GENDER
 
local gender_var sex // gender variable in ASEC is "sex"
tab `gender_var', m
tab `gender_var', nolab m

include $redi/redi11a_include_female_from2W_1M.doi

***--------------------------***

// #2 RACE / ETHNICITY - with RACE variable only

local race_var race
tab `race_var'
tab `race_var', m nolab

gen hisp = .
replace hisp = 1 if hispan >=1
replace hisp = 0 if hispan == 0

replace race = 800 if race >=800

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

local edu_var educ
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

// # INDEPENDENT LIVING DIFFICULTY

/*DIFFMOB indicates whether the respondent has any physical, mental, or 
emotional condition lasting six months or more that makes it difficult or 
impossible to perform basic activities outside the home alone. 
This does not include temporary health problems, such as broken bones.*/

tab diffmob 
tab diffmob, nolab

generate disability = .
replace disability = 1 if diffmob == 2
replace disability = 0 if diffmob == 1

tab diffmob disability, m


***--------------------------***

// # MARITAL STATUS

tab marst
tab marst, nolab

generate married = .
replace married = 1 if marst == 1 | marst == 2
replace married = 0 if marst == 3 | marst == 4 |  marst == 5 | marst == 6

tab marst married, m

***--------------------------***

// # OWNERSHIP OF HOUSING

/*OWNERSHP indicates whether the housing unit was rented or owned by its inhabitants. 
Housing units acquired with a mortgage or other lending arrangement(s) are 
classified as "owned," even if repayment was not yet completed.*/

tab ownershp
tab ownershp, nolab

generate ownhouse = .
replace ownhouse = 1 if ownershp == 10
replace ownhouse = 0 if ownershp == 21 | ownershp == 22

tab ownershp ownhouse, m

***--------------------------***

// # MIGRATION STATUS

/*MIGRATE1 indicates whether the respondent had changed residence in the past year. Those who were living in the same house as one year ago were considered non-movers and were asked no further questions about migration over the past year. Movers were asked about the city, county and state and/or the U.S. territory or foreign country where they resided one year ago.*/

tab migrate1
tab migrate1, nolab

generate migrate = .
replace migrate = 1 if migrate1 == 2 | migrate1 == 3 | migrate1 == 4 | migrate1 == 5 | migrate1 == 6
replace migrate = 0 if migrate1	== 1


***--------------------------***

save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace
use $deriv/redi11_ASEC_regressions-hinc_shp.dta, clear

***--------------------------***
// REGRESSION: CPS ASEC Income as DV
***--------------------------***	

di in red "Predict ASEC income as function of race/ethnicity, education, gender"

svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category


di in red "Predict ASEC income as function of race/ethnicity, education, gender, marital status, disability, labor force"

svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor


***--------------------------***
// REGRESSION: CPS ASEC Income as IV: Predict Home Ownership
***--------------------------***	
di in red "Predict home ownership as function of ASEC ln(income)"
svy: logistic ownhouse ///
	asec_lnhinc_shp_2017 //

di in red "Predict home ownership as function of ASEC ln(income), race/ethnicity, education, gender"
svy: logistic ownhouse ///
	asec_lnhinc_shp_2017 ///	
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category
	*, gradient trace difficult

di in red "Predict home ownership as function of ASEC ln(income), race/ethnicity, education, gender, marital status, disability, labor force"
svy: logistic ownhouse ///
	asec_lnhinc_shp_2017 /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor //
	*, gradient trace difficult
		

***--------------------------***
// REGRESSION: REDI Income as IV: Predict Migration
***--------------------------***	

di in red "Predict migration as function of ASEC ln(income)"
svy: logistic migrate ///
	asec_lnhinc_shp_2017 //

di in red "Predict migration as function of ASEC ln(income), race/ethnicity, education, gender"
svy: logistic migrate ///
	asec_lnhinc_shp_2017 ///	
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category
	*, gradient trace difficult

di in red "Predict migration as function of ASEC ln(income), race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate ///
	asec_lnhinc_shp_2017 /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	disability labor ownhouse //
	*, gradient trace difficult


***--------------------------***


capture log close redi11_ASEC_regressions
exit
