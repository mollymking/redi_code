capture log close redi12_REDI_regressions
log using $redi/redi12_REDI_regressions.log, name(redi12_REDI_regressions) replace text

// 	project:	REDI Methods Paper

//  task:		Regressions of original CPS ASEC Variables and new continuous REDI-created income
//  data: 		CPS ASEC original available: https://cps.ipums.org/
//				& newly created REDI income variable

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

use $deriv/redi04_ACS_descriptives-hinc_shp.dta, clear
save $deriv/redi12_REDI_regressions-hinc_shp.dta, replace	

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do
local y = year


***--------------------------***
// # CREATE NATURAL LOG INCOME VARIABLES
***--------------------------***

gen acs_lnhinc_shp_`conv_year' = ln(acs_hinc_shp_`conv_year')
label var acs_hinc_shp_`conv_year' "Inflation-adjusted natural log household income (ACS), from shp categories, `conv_year' dollars"

***--------------------------***
// DEMOGRAPHICS
***--------------------------***	
		
// #1 GENDER
 
local gender_var sex
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

fvset base 1 dG_race		// ref: white_race_value

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
replace labor = 1 if labforce == 2  // yes in labor force
replace labor = 0 if labforce == 1  // not in labor force

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
replace disability = 1 if diffmob == 2 	// has mobility limitation
replace disability = 0 if diffmob == 1  // no mobility limitation

tab diffmob disability, m


***--------------------------***

// # MARITAL STATUS

/*MARST gives each person's current marital status,
 including whether the spouse was currently living in the same household.*/

tab marst
tab marst, nolab

generate married = .
replace married = 1 if marst == 1 | marst == 2
replace married = 0 if marst == 3 | marst == 4 |  marst == 5 | marst == 6

tab marst married, m

***--------------------------***

// # OWNERSHIP OF HOUSING

/*OWNERSHP indicates whether the household rented or owned its housing unit. 
Households that acquired their unit with a mortgage or other lending arrangement
 were understood to "own" their unit even if they had not yet completed repayment.
Two types of renters were identified: those who paid cash rent and those who 
paid no cash rent. The latter category included occupants who paid only for their utilities.*/

tab ownershp
tab ownershp, nolab

generate ownhouse = .
replace ownhouse = 1 if ownershp == 10
replace ownhouse = 0 if ownershp == 21 | ownershp == 22

tab ownershp ownhouse, m


***--------------------------***

save $deriv/redi12_REDI_regressions-hinc_shp.dta, replace

***--------------------------***
// REGRESSION: ACS Income as DV (Original - not included in results)
***--------------------------***	

di in red "Predict original ACS continuous income as a function of education, race/ethnicity, gender of householder"		
svy: reg acs_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category


***--------------------------***
// REGRESSION: REDI Income as DV
***--------------------------***	

di in red "Predict REDI-created income as a function of education, race/ethnicity, gender of householder"	
svy: reg redi_dV_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category
 
***--------------------------***
// REGRESSION: REDI Income as DV - with 5-6 IVs
***--------------------------***	

di in red "Predict REDI-created income as a function of education, race/ethnicity, gender of householder, marital status, disability, and labor force"	
svy: reg redi_dV_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor

***--------------------------***
// REGRESSION: REDI Income as IV: Predict Home Ownership
***--------------------------***	

di in red "Predict home ownership as function of ln(REDI-created income), race/ethnicity, education, gender"
svy: logistic ownhouse ///
	redi_dV_lnhinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category

*est store `v'_modB
	
*svylogitgof
	

***--------------------------***
// REGRESSION: REDI Income as IV: Predict Home Ownership - 5-6 IVs
***--------------------------***	

di in red "Predict home ownership as function of ln(REDI-created income), race/ethnicity, education, gender, marital status, disability, labor force"
svy: logistic ownhouse ///
	redi_dV_lnhinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor //
	

***--------------------------***
// REGRESSION: REDI Income as IV: Predict Disability - 5-6 IVs
***--------------------------***	

di in red "Predict disability as function of ln(REDI-created income), race/ethnicity, education, gender, marital status, labor force"
svy: logistic disability ///
	redi_dV_lnhinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married labor //
	
	
***-----
// Check if systematically different values between REDI and Research Dataset
*use $deriv/redi11_ASEC_regressions-hinc_shp.dta, clear

table sex, c(mean redi_dV_hinc_shp_2017   mean hhincome mean hhincome_acs)
table race, c(mean redi_dV_hinc_shp_2017   mean hhincome mean hhincome_acs)
table hispan, c(mean redi_dV_hinc_shp_2017  mean hhincome mean hhincome_acs)
table educ, c(mean redi_dV_hinc_shp_2017  mean hhincome mean hhincome_acs)
		 
 
***--------------------------***
// CLEAN UP
***--------------------------***

capture log close redi12_REDI_regressions
exit
