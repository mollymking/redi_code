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

// REDI Income as IV (redi_dV_lnhinc_shp)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate1 ///
	redi_dV_lnhinc_shp /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	married disability labor ownhouse //
	*, gradient trace difficult

// Original ACS Contnuous Income as IV (hhincome_acs)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate1 ///
	hhincome_acs /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	disability labor ownhouse //
	*, gradient trace difficult

	

***--------------------------***
// #  REGRESSION: Income as IV: Predict Migration on 2019  California  DATA
***--------------------------***

use $deriv/redi14_REDI_Ca2019.dta, clear

// REDI Income as IV (redi_dV_lnhinc_shp)
di in red "CALIFORNIA: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate1 ///
	redi_dV_lnhinc_shp /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	disability labor ownhouse //
	*, gradient trace difficult

// Original ACS Contnuous Income as IV (hhincome_acs)
di in red "WYOMING: " ///
		  "Predict migration as function of ln(REDI-created income), " ///
		  "race/ethnicity, education, gender, disability, labor force, home ownership"
svy: logistic migrate1 ///
	hhincome_acs /// 
	dB_fem /// men comparison
	dB_rblack dB_rasian dB_rhisp dB_rother /// white comparison category
	dB_edu_HS dB_edu_sCol dB_edu_col dB_edu_grad /// lessHS comparison category
	disability labor ownhouse //
	*, gradient trace difficult


***--------------------------***

capture log close redi15_REDI_state_regressions
exit

