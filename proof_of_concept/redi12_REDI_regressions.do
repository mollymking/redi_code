capture log close redi12_REDI_regressions
log using $redi/redi12_REDI_regressions.log, name(redi12_REDI_regressions) replace text

// 	project:	REDI Methods Paper

//  task:		Regressions of original ACS Continuous and new continuous REDI-created income
//  data:		ACS & newly created REDI income variables

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

local p   "rediado"
use $deriv/redi04_ACS_descriptives-`p'.dta, clear
save $deriv/redi12_REDI_regressions-`p'.dta, replace	
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do
local y = year


***--------------------------***
// # CREATE NATURAL LOG INCOME VARIABLES
***--------------------------***

gen redi_lnhinc_cont_inf`conv_year' = ln(redi_hinc_cont_inf`conv_year')
label var redi_lnhinc_cont_inf`conv_year' "Inflation-adjusted natural log household income (ACS), from shp categories, `conv_year' dollars"

***--------------------------***
// DEMOGRAPHICS
***--------------------------***	
		
// #1 GENDER
 
local gender_var sex_acs
tab `gender_var', m
tab `gender_var', nolab m

include $redi/redi11a_include_female_from2W_1M.doi

***--------------------------***	

// #2 RACE / ETHNICITY - with RACE and HISP

local race_var race_acs
tab `race_var'
tab `race_var', m nolab

gen hisp = .
replace hisp = 1 if hispan_acs >0
replace hisp = 0 if hispan_acs == 0

local hisp_var hisp

if "`hisp_var'" != "none" {
	tab `hisp_var', m
	tab `hisp_var', m nolab
	tab `race_var' `hisp_var'
}


*don't know/refused code(s) for `race_var'
local race_missing_condition none

local white_race_value = 	1
local black_race_value = 	2
local asian_race_value =	4
local hisp_value =			1
local other_race_value = 	7
local mult_race_value = 	8
local amerInd_race_value  = 3

include $redi/redi11b_racethnicity.doi

// Japanese
replace dB_rasian = 1 if `race_var' == 5 & `hisp_var' != `hisp_value'
replace dG_race = 3   if `race_var' == 5 & `hisp_var' != `hisp_value'
// Other Asian or Pacific Islander 
replace dB_rasian = 1 if `race_var' == 6 & `hisp_var' != `hisp_value'
replace dG_race = 3   if `race_var' == 6 & `hisp_var' != `hisp_value'
// Three or more
replace dB_rother = 1 if `race_var' == 9 & `hisp_var' != `hisp_value'
replace dG_race = 5 if `race_var' == 9 & `hisp_var' != `hisp_value' 

fvset base 1 dG_race		// ref: white_race_value
tab `race_var' dG_race, m

***--------------------------***	

// #3 EDUCATION

local edu_var educ_acs
tab `edu_var'
tab `edu_var', nolab m

*don't know/refused code(s) for `edu_var'
local edu_missing_condition "none"

* Conditions for each category
local lHS_condition 	`"`edu_var' <= 5"'
local HS_condition 		`"`edu_var' == 6"'
local sCol_condition	`"`edu_var' == 7 | `edu_var' == 8"'
local col_condition		`"`edu_var' == 10"'
local grad_condition	`"`edu_var' == 11"'

include $redi/redi11c_education.doi

fvset base 1 dG_edu  		// ref: less than HS
tab `edu_var' dG_edu, m

***--------------------------***

// # INDEPENDENT LIVING DIFFICULTY

/*DIFFMOB indicates whether the respondent has any physical, mental, or 
emotional condition lasting six months or more that makes it difficult or 
impossible to perform basic activities outside the home alone. 
This does not include temporary health problems, such as broken bones.*/

local disab diffmob_acs
tab `disab'
tab `disab', nolab

generate disability = .
replace disability = 1 if `disab' == 2 	// has mobility limitation
replace disability = 0 if `disab' == 1  // no mobility limitation

tab `disab' disability, m

***--------------------------***

// # MARITAL STATUS

/*MARST gives each person's current marital status,
 including whether the spouse was currently living in the same household.*/

local mar_var  marst_acs
tab `mar_var'
tab `mar_var', nolab

generate married = .
replace married = 1 if `mar_var' == 1 | `mar_var' == 2
replace married = 0 if `mar_var' == 3 | `mar_var' == 4 | `mar_var' == 5 | `mar_var' == 6

tab `mar_var' married, m

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

/*OWNERSHP indicates whether the household rented or owned its housing unit. 
Households that acquired their unit with a mortgage or other lending arrangement
 were understood to "own" their unit even if they had not yet completed repayment.
Two types of renters were identified: those who paid cash rent and those who 
paid no cash rent. The latter category included occupants who paid only for their utilities.*/

local owner  ownershp_acs
tab `owner'
tab `owner', nolab

generate ownhouse = .
replace ownhouse = 1 if `owner' == 1
replace ownhouse = 0 if `owner' == 2 

tab `owner' ownhouse, m

***--------------------------***
/*
// # MIGRATION STATUS

/*MIGRATE1 indicates whether the respondent had changed residence in the past year. Those who were living in the same house as one year ago were considered non-movers and were asked no further questions about migration over the past year. Movers were asked about the city, county and state and/or the U.S. territory or foreign country where they resided one year ago.*/

local mig_status migrate1_acs
tab `mig_status'
tab `mig_status', nolab

generate migrate = .
replace migrate = 1 if `mig_status' == 2 | `mig_status' == 3 | `mig_status' == 4 
replace migrate = 0 if `mig_status'	== 1

tab `mig_status' migrate, m
*/
***--------------------------***

save $deriv/redi12_REDI_regressions-`p'.dta, replace

***--------------------------***
// REGRESSION: ACS Income as DV (Original Research Continuous Income)
***--------------------------***	

*use $deriv/redi12_REDI_regressions-`p'.dta, clear

di in red "Predict original ACS continuous income as a function of gender of householder, " ///
		  "race/ethnicity, education"		
svy: reg acs_hinc_cont_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category
	

di in red "Predict original ACS continuous income as a function of gender of householder, " ///
		  "race/ethnicity, education, married, disability"		
svy: reg acs_hinc_cont_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability

	
di in red "Predict original ACS continuous income as a function of gender of householder, " ///
		  "race/ethnicity, education, married, disability, labor force"		
svy: reg acs_hinc_cont_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability	labor
	
***--------------------------***
// REGRESSION: REDI Income as DV
***--------------------------***	

di in red "Predict REDI-created income as a function of education, race/ethnicity, gender of householder"	
svy: reg redi_hinc_cont_inf`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category


di in red "Predict REDI-created income as a function of gender of householder, " ///
		  "race/ethnicity, education, marital status, disability"	
svy: reg redi_hinc_cont_inf`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability 
	
di in red "Predict REDI-created income as a function of gender of householder, " ///
		  "race/ethnicity, education, marital status, disability, labor"	
svy: reg redi_hinc_cont_inf`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor


/* currently do the following using state subsets instead
***--------------------------***
// REGRESSION: REDI Income as IV: Predict Migration
***--------------------------***	

di in red "Predict migration as function of ln(REDI-created income), " ///
		  "gender, race/ethnicity, education, married, disability"
svy: logistic migrate ///
	redi_lnhinc_cont_inf`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability // 


di in red "Predict migration as function of ln(REDI-created income), add home ownership"
svy: logistic migrate ///
	redi_lnhinc_cont_inf`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse //



***--------------------------***
// REGRESSION: ACS Income as IV (Artificial Categorical Income): Predict Migration
***--------------------------***	

*use $deriv/redi12_REDI_regressions-`p'.dta, clear

fvset base 1 acs_hinc_shp  	

di in red "Predict migration as function of ACS artificial categorical income, "  ///
		  " gender, race/ethnicity, education, married, disability"		
svy: logistic migrate ///
	i.acs_hinc_shp /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability

di in red "Predict migration as function of ACS artificial categorical income, "  ///
		  " add home ownership"		
svy: logistic migrate ///
	i.acs_hinc_shp /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse //

	
*/
***-----
// Check if systematically different values between REDI and ACS Research Dataset



*inflation-adjusted
table dB_fem, 	c(mean redi_hinc_cont_inf2017   	mean acs_hinc_cont_2017)
table dG_race, 	c(mean redi_hinc_cont_inf2017   	mean acs_hinc_cont_2017)
table dG_edu, 	c(mean redi_hinc_cont_inf2017   	mean acs_hinc_cont_2017)


 
***--------------------------***
// CLEAN UP
***--------------------------***

capture log close redi12_REDI_regressions
exit
