capture log close redi11_ASEC_regressions
log using $redi/redi11_ASEC_regressions.log, name(redi11_ASEC_regressions) replace text

// 	project:	REDI Methods Paper

//  task:     	Regression of original continuous CPS ASEC variables - before conversion to REDI
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
gen asec_hinc_shp_`conv_year' = hhincome / conv_factor
format asec_hinc_shp_`conv_year' %6.0fc
label var asec_hinc_shp_`conv_year' "Inflation-adjusted household income (ASEC), from shp categories, `conv_year' dollars"
		
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

save $deriv/redi11_ASEC_regressions-hinc_shp.dta, replace


***--------------------------***
// REGRESSION
***--------------------------***	

* Predict income as a function of education, race/ethnicity, gender of householder

svy: reg asec_hinc_shp_`conv_year' /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad // lessHS comparison category

***--------------------------***

capture log close redi11_ASEC_regressions
exit
