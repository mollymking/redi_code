capture log close redi15_REDI_state_regressions
log using $redi/redi15_REDI_state_regressions.log, name(redi15_REDI_state_regressions) replace text

// 	project:	REDI Methods Paper

//  task:     	Example of REDI regressed on data from a single state in 2019
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
// #  REGRESSION: Income as IV: Predict Migration on 2019  Wyoming  DATA
***--------------------------***

use $deriv/redi14_REDI_Wy2019.dta, clear

// REDI Income as IV (redi_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability   // labor ownhouse

// Original ACS Contnuous Income as IV (acs_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "race/ethnicity, education, gender, disability, labor force"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability //  labor  ownhouse
	

// In both models, significance disappears when add home ownership:
// REDI Income as IV (redi_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "add home ownership"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse //
	

// Original ACS Contnuous Income as IV (acs_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "add home ownership"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse //  
	

***--------------------------***
// #  REGRESSION: Income as IV: Predict Migration on 2019  California  DATA
***--------------------------***

use $deriv/redi14_REDI_Ca2019.dta, clear

// REDI Income as IV (redi_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, marital status, disability"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability 
	
// Original ACS Contnuous Income as IV (acs_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "race/ethnicity, education, gender, marital status, disability"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability 
	

// In both models, significance disappears when add home ownership:
// REDI Income as IV (redi_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "add home ownership"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse  

// Original ACS Contnuous Income as IV (acs_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "add home ownership"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse 

***--------------------------***

capture log close redi15_REDI_state_regressions
exit

