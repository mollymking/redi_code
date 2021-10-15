capture log close redi10_REDI_summary_stats
log using $redi/redi10_REDI_summary_stats.log, name(redi10_REDI_summary_stats) replace text

// 	project:	REDI Methods Paper

//  task:     	Summary Statistics of continuous REDI-created variables, optionally replicated x times
//  data: 		REDI (based on ACS research dataset)

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

*references
*https://www.stata.com/support/faqs/statistics/bootstrapped-samples-guidelines/

local conv_year = 2017 // this is set in redi01_CPI-U-RS.do

***--------------------------***,
// REPETITIONS (OPTIONAL) - DEFAULT = 1
***--------------------------***

global n_replications = 1 // number of applications to run REDI (minimum is 2)
local run = 1 // for keeping track of run number if used on a cluster

forvalues n=1(1)$n_replications{
	do $redi/redi03_ACS_convert.do
		
	save $deriv/redi10_REDI_summary_stats.dta, replace

***--------------------------***		
// Generate MEDIAN x n_replications
***--------------------------***		
	
	//Levels of year variable to loop through years
	
	levelsof year, local(years)
	foreach y of local years { 
	
		epctile redi_dV_hinc_shp_`conv_year', ///
			percentiles(50) svy subpop(if year == `y')
		return list
		matrix list r(table)
		cap matrix M = r(table)
		 
		cap scalar med`y' = M[1,1] // location of median coefficient in matrixm2
		 
	} // end loop through years

	capture drop  redi_dV_hinc_shp_`conv_year'_median
	gen redi_dV_hinc_shp_`conv_year'_median = .
	replace redi_dV_hinc_shp_`conv_year'_median = med2016 if year == 2016
	replace redi_dV_hinc_shp_`conv_year'_median = med2017 if year == 2017

***--------------------------***		
// Generate MEAN  x n_replications
***--------------------------***

	capture drop redi_dV_hinc_shp_`conv_year'_mean
	gen redi_dV_hinc_shp_`conv_year'_mean = .
	label var redi_dV_hinc_shp_`conv_year'_mean /// 
		"REDI hinc shp `conv_year' grand mean"
	
	* convert 2016 values to 2017 dollars
	di in red "Below are the means hinc for both years:"
	svy: mean redi_dV_hinc_shp_`conv_year', over(year)
	cap matrix X = r(table) 

	*inflation-adjusted 2016 REDI mean in 2017 dollars is: 
	*	redi_dV_hinc_shp_`conv_year'_mean 
	*year 2016  REDI 
	cap scalar mn16 = X[1,1]		
	*di in blue "The inflation-adjusted 2016  REDI mean in 2017 dollars is:"
	*di mn16 
	replace redi_dV_hinc_shp_`conv_year'_mean = mn16 if year == 2016

	*inflation-adjusted 2017 REDI mean in 2017 dollars is:  
	*	redi_dV_hinc_shp_`conv_year'_mean 
	*year 2017  REDI
	cap scalar mn17 = X[1,2]
	*di in blue "The inflation-adjusted 2017  REDI mean in 2017 dollars is:"
	*di mn17
	replace redi_dV_hinc_shp_`conv_year'_mean = mn17 if year == 2017
	
	*calculate standard deviation 
	*the -by()- option defines groups within which SD is calculated. 
	*egen redi_dV_hinc_shp_`conv_year'_sd = /// 	
	*	sd(redi_dV_hinc_shp_`conv_year'), by(year)

***--------------------------***
// # GINI COEFFICIENT 
***--------------------------***
	capture drop redi_dV_hinc_shp_`conv_year'_gini 
	gen redi_dV_hinc_shp_`conv_year'_gini = .
	label var redi_dV_hinc_shp_`conv_year'_gini "REDI hinc shp `conv_year' Gini"

	save $deriv/redi10_REDI_summary_stats.dta, replace

	*use -fastgini- because allows pweights
	*https://www.stata.com/statalist/archive/2008-10/msg01179.html
	*fastgini varname [if] [in] [weight] [, bin(#) jk Level(#) nocheck]	


	//Levels of year variable to loop through years

	levelsof year, local(years)
	foreach y of local years { 

		use $deriv/redi10_REDI_summary_stats.dta, clear
		keep if year == `y'	
	
		replace redi_dV_hinc_shp_`conv_year'  = 1 if  redi_dV_hinc_shp_`conv_year'  <= 0
	
		fastgini  redi_dV_hinc_shp_`conv_year' [pweight=perwt] 
		
		local gini`y' = r(gini) 

	} // end loop through years

	replace redi_dV_hinc_shp_`conv_year'_gini = `gini2016' if year == 2016
	replace redi_dV_hinc_shp_`conv_year'_gini = `gini2017' if year == 2017

***--------------------------***
// # CLEAN AND SAVE TEMPFILE 
***--------------------------***

	gen rep_n = `n'
	capture drop repwtp* perwt repwtp pers_inc ftotinc_acs repwt  ///
		asecwth acs_rinc_perc acs_finc_perc acs_rinc_shp acs_finc_shp ///
		acs_hinc_perc acs_hinc_shp acs_hinc_shp_lb acs_hinc_shp_ub hhincome_asec hhincome_acs ///
		acs_hinc_shp_2017lb acs_hinc_shp_2017ub acs_hinc_shp_2017 redi_dV_hinc_shp_2017
	
	gen run_n = `run'		

	*duplicates drop ///
	*	redi_dV_hinc_shp_`conv_year'_mean ///
	*	redi_dV_hinc_shp_`conv_year'_median, force
	
	duplicates drop ///
		redi_dV_hinc_shp_`conv_year'_gini year, force
	
	tempfile temp_hinc_shp_`n'
	save `temp_hinc_shp_`n'', replace


		
***--------------------------***	
// APPEND VALUES GATHERED in REDI
***--------------------------***

} // end loop through number of replications `n'

// now loop through and append each temp file created within income bracket loop
use `temp_hinc_shp_1'
forvalues rep = 2(1)$n_replications {				
	append using `temp_hinc_shp_`rep''
}

***--------------------------***	
// # SAVE DATA 
***--------------------------***	

label data "REDI mean, median, and gini distribution replications"
notes: redi10_REDI_summary_stats.dta \ Distribution of REDI mean, median, and gini values  \ /// 
redi10_REDI_summary_stats.do mmk  $S_DATE
compress
datasignature set, reset  
save $deriv/redi10_REDI_summary_stats_$n_replications_`run'.dta, replace

***--------------------------***	

log close redi10_REDI_summary_stats
exit

