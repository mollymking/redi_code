//	project:	REDI Methodology Paper

//  task:     	Convert back to continuous incomes
//				and compare original longform code to developed REDI program
//  data: 		ACS, available: https://usa.ipums.org/

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King


***--------------------------***
// # INCOME CONVERSIONS using REDI ADO program
***--------------------------***

local p "rediado"
capture log close redi03_ACS_convert
log using $redi/redi03_ACS_convert.log, name(redi03_ACS_convert) replace text

// # PROGRAM SETUP
version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off
display "$S_DATE  $S_TIME"

// SAVE Correct dataset for redi.ado use
use $deriv/redi01_ASEC-hhincome.dta, clear
save $redi/redi_package/cps_reference.dta, replace

// load ACS "Research" dataset
use $deriv/redi02_ACS_bins.dta, clear	
save $deriv/redi03_ACS_convert-`p'.dta, replace

local year "year"
local conv_year = 2017 // year of conversion factor
set seed 1

cd "~/Documents/SocResearch/redi/redi_code/redi_package/" // location of redi ado file
redi acs_hinc_shp year, ///
	generate(redi_hinc_cont) cpstype(household)  inflationyear(2017)

di in red "End of redi.ado program" 

// ACS INFLATION ADJUSTMENT - after either approach
include $redi/redi03b_inflate_dollars.doi	

// # CLEAN UP
keep if year == 2016 | year == 2017	

// # SAVE DATA 
label data "ACS data converted to continuous REDI-calculated values"
notes: redi03_ACS_convert-`p'.dta \ ///
	ACS hinc_shp Data converted to continuous using `p' approach \ /// 
	redi03_ACS_convert_`p'.do  $S_DATE
compress
datasignature set, reset  

save $deriv/redi03_ACS_convert-`p'.dta, replace

di in red "End of REDI calculations using new REDI ado package" 
log close redi03_ACS_convert


***--------------------------***

exit
