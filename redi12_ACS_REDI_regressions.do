capture log close redi12_ACS_REDI_regressions
log using $redi/redi12_ACS_REDI_regressions.log, name(redi12_ACS_REDI_regressions) replace text

// 	project:	REDI Methods Paper

//  task:		Regressions of original ACS and new continuous REDI-created Variables
//  data: 		ACS original available: https://usa.ipums.org/
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
save $deriv/redi12_ACS_REDI_regressions-hinc_shp.dta, replace

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do
local y = year

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

save $deriv/redi12_ACS_REDI_regressions-hinc_shp.dta, replace


***--------------------------***
// REGRESSIONS
***--------------------------***

di in red "Predict original ACS continuous income as a function of education, race/ethnicity, gender of householder"		
svy: reg acs_hinc_shp_2017 /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category


di in red "Predict REDI-created income as a function of education, race/ethnicity, gender of householder"	
svy: reg redi_dV_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category
 


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

capture log close redi12_ACS_REDI_regressions
exit
