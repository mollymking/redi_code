cd "~/Documents/SocResearch/redi/redi_code/"

capture log close master
log using "redi00_master.log", name(master) replace text

set more off

** Master REDI Method Do File ***

//	project:	REDI Methodology Paper

//  task:		Master file to rerun sequence of do-files to reproduce all work
//				related to REDI Sociological Metholdology Paper

//  program:	redi00_master.do
//	log:		redi00_master.log

//  github:		dissertation_code
//  OSF:		https://osf.io/qmhe8/

//  author:		Molly King

display "$S_DATE  $S_TIME"
***--------------------------***

// CHANGE DIRECTORIES to local files to run replication code:

global redi  	"~/Documents/SocResearch/redi/redi_code"				// where all replication .do files stored	

*Data
global source	"~/Documents/SocResearch/Dissertation/data/data_sorc"  	// original datasets (ACS, CPS ASEC)
global extr  	"~/Documents/SocResearch/Dissertation/data/data_extr"  	// extracted datasets - a file to extract original data
global temp		"~/Documents/SocResearch/Dissertation/data/data_temp"	// temporary datasets - an empty file to store temporary data
global deriv	"~/Documents/SocResearch/Dissertation/data/data_derv"  	// derived datasets - a file to store final data

* remove comment to run all files, or comment-out one at a time

***--------------------------***
// 01 IMPORT, EXTRACTION, CLEAN 
***--------------------------***

*do $redi/redi01_CPI-U-RS.do				// Import and extract CPI-U-RS inflation index, calculate year adjustment
*do $redi/redi01_ASEC_import.do 			// Import and extract CPS ASEC
											//	uses cps00010.do file with original code from IPUMS CPS ASEC
*do $redi/redi01_ACS_import.do 				// Import and extract ACS
											//	uses usa00011.do file with original code from IPUMS USA

***--------------------------***
// 02-03 REDI METHOD
***--------------------------***

*do $redi/redi02_ACS_bins.do 				// Create ACS artificial data bins
*do $redi/redi03_ACS_convert.do 				// Convert bins back to continuous income, inflate 2016 incomes to 2017 dollar values

***--------------------------***
// 04-07 DESCRIPTIVES (Table 1)
***--------------------------***

*do $redi/redi04_ACS_descriptives.do 		// Descriptive data tables of original continuous ACS Variables
*do $redi/redi05_ASEC_bins.do				// Create ASEC artificial data bins for comparison
*do $redi/redi06_ASEC_descriptives.do		// Descriptive data tables of original CPS ASEC Variables
*do $redi/redi07_REDI_descriptives.do		// Descriptive data tables of continuous REDI-created Variables

***--------------------------***
// 08-10 DISTRIBUTIONS
***--------------------------***
*do $redi/redi08_ACS_ASEC_distrib_match.do	// Compare binned distributions of ACS and CPS ASEC (Appendix Figure B1)
*do $redi/redi09_REDI_ACS_distrib_match.do 	// Compare continuous distributions from original ACS & REDI (Figure 3)
*do $redi/redi10_REDI_summary_stats.do 		// Summary Statistics of continuous REDI-created variables, optionally replicated x times (Table 2)
*do $redi/redi10a_REDI_reps_append.do		// Append x replications of data produced in redi10 - only for proof-of-concept

***--------------------------***
// 11-12 REGRESSIONS (Table 3)
***--------------------------***

*do $redi/redi11_ASEC_regressions.do 		// Regression of original continuous CPS ASEC variables (Table 3 Model 3)
*do $redi/redi12_REDI_regressions.do 		// Regressions of original ACS variables (Table 3 Model 2)
											//	and new continuous REDI-created income (Table 3 Model 1)

***--------------------------***
// 13-15 REGRESSION EXAMPLE USING INDIVIDUAL STATES (Table 4, Appendix C)
***--------------------------***

*do $redi/redi13_REDI_state_demvars.do 		// Create demographic variables for state data
*do $redi/redi14_REDI_state_dataprep.do 	// Create REDI-generated income and artificial ACS bins
*do $redi/redi15_REDI_state_regressions.do 	// Run regressions for another example using 2019 and a single state

***--------------------------***
// 20-22 ALTERNATIVE METHODS (Table 2)
***--------------------------***

*do $redi/redi20_ACS_rpme.do				// RPME method of describing ACS
*do $redi/redi21_ACS_cdf.do					// CDF method of describing ACS
*do $redi/redi22_ACS_mgbe.do				// MGBE method of describing ACS

***--------------------------***

log close master
exit
