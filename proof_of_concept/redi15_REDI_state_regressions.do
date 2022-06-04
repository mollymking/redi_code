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
// acs weights
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse

// REDI Income as IV (redi_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "gender, race/ethnicity, education, marriage, disability"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability   // labor ownhouse

// Original ACS Continuous Income as IV (acs_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "gender, race/ethnicity, education, marriage, disability"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability //  labor  ownhouse
	
// Artificial ACS categorical Income as IV (acs_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ACS HH income category, " ///
		  "gender, race/ethnicity, education, marriage, disability"
fvset base 1 acs_hinc
svy: logistic migrate ///
	i.acs_hinc /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability //  labor  ownhouse
	
	
	
***------------
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
	

// Artificial ACS categorical Income as IV (acs_hinc_ln)
di in red "WYOMING: " ///
		  "Predict migration as function of ACS HH income category, " ///
		  "add home ownership"
svy: logistic migrate ///
	i.acs_hinc /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability  ownhouse //  labor  ownhouse

***--------------------------***
// #  REGRESSION: Income as IV: Predict Migration on 2019  California  DATA
***--------------------------***

use $deriv/redi14_REDI_Ca2019.dta, clear
svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse


// REDI Income as IV (redi_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "gender, race/ethnicity, education, marriage, disability"
svy: logistic migrate ///
	redi_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability 
	
// Original ACS Contnuous Income as IV (acs_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(ACS HH income), " ///
		  "gender, race/ethnicity, education, marriage, disability"
svy: logistic migrate ///
	acs_hinc_ln /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability 

// Artificial ACS categorical Income as IV (acs_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ACS HH income category, " ///
		  "gender, race/ethnicity, education, marriage, disability"
fvset base 1 acs_hinc
svy: logistic migrate ///
	i.acs_hinc /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability //  labor  ownhouse
	
	
***------------
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

// Artificial ACS categorical Income as IV (acs_hinc_ln)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ACS HH income category, " ///
		   "add home ownership"
svy: logistic migrate ///
	i.acs_hinc /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability ownhouse	 //  labor  
	
***--------------------------***

capture log close redi15_REDI_state_regressions
exit

