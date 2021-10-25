capture log close redi13_REDI_state_demvars
log using $redi/redi13_REDI_state_demvars.log, name(redi13_REDI_state_demvars) replace text

// 	project:	REDI Methods Paper

//  task:     	Creating variables for regressions for state example
//  data:     	CPS ASEC from IPUMS, available: https://cps.ipums.org/
//				ACS from IPUMS, available: https://usa.ipums.org/

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

***--------------------------***

use $deriv/redi01_ACS_all.dta
save $deriv/redi13_REDI_state_demvars.dta, replace

***--------------------------***
// DEMOGRAPHICS
***--------------------------***	
		
// #1 GENDER
 
local gender_var sex
tab `gender_var', m
tab `gender_var', nolab m

include $redi/redi11a_include_female_from2W_1M.doi

***--------------------------***	

// #2 RACE / ETHNICITY - with RACE and HISP

local race_var race
tab `race_var'
tab `race_var', m nolab

gen hisp = .
replace hisp = 1 if hispan >0
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

local edu_var educ
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
replace ownhouse = 1 if ownershp == 1
replace ownhouse = 0 if ownershp == 2 

tab ownershp ownhouse, m

***--------------------------***

// # MIGRATION STATUS

/*MIGRATE1 indicates whether the respondent had changed residence in the past year. Those who were living in the same house as one year ago were considered non-movers and were asked no further questions about migration over the past year. Movers were asked about the city, county and state and/or the U.S. territory or foreign country where they resided one year ago.*/

tab migrate1
tab migrate1, nolab

generate migrate = .
replace migrate = 1 if migrate1 == 2 | migrate1 == 3 | migrate1 == 4 
replace migrate = 0 if migrate1	== 1

***--------------------------***

// # SAVE DATA

label data "ACS data with DEMOGRAPHIC VARIABLES"
datasignature set, reset 
save $deriv/redi13_REDI_state_demvars.dta, replace

***--------------------------***

capture log close redi13_REDI_state_demvars
exit
