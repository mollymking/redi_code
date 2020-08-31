capture log close CPIURS
log using $redi/redi01_CPI-U-RS.log, name(CPIURS) replace text

//	project:	REDI Methodology Paper

//  task:     	Convert continuous income variables to same year dollar values
//				in this case, using 2017 as conversion year
//  data:		CPI-U-RS, available: https://www.bls.gov/cpi/cpiurs.htm

//  github:   	redi
//  OSF:		https://osf.io/qmhe8/

//  author:   	Molly King


display "$S_DATE  $S_TIME"

***--------------------------***
// PROGRAM SETUP
***--------------------------***

version 16 // keeps program consistent for future replications
set linesize 80
clear all
set more off

***--------------------------***
// IMPORT DATA
***--------------------------***

cd $source/00_CPI-U-RS/
import excel "allitems.xlsx", ///
	sheet("All Items_SA") /// tab for seasonally adjusted
	cellrange(A7:N49) firstrow

cd $deriv
save "redi01_CPI-U-RS.dta", replace


***--------------------------**
// CLEAN DATA
***--------------------------***

drop if YEAR == .
drop N 
drop if YEAR == 1977
keep YEAR AVG

rename YEAR year
rename AVG cpi_avg
label var cpi_avg "CPI-R-US all items average cost price inflator"


***--------------------------**
// CREATE CONVERSION FACTOR
***--------------------------***

local avg_2017 = 361.0
di `avg_2017'	

gen conv_factor_2017 = .
replace conv_factor_2017 = cpi_avg / `avg_2017'

label var conv_factor_2017 "Conversion factor - to convert to $2017, divide by conv_factor"


***--------------------------**
// LABEL AND SAVE DATA
***--------------------------***

label data "CPI-U-RS year and inflation data"
notes: redi_01_CPI-U-RS.dta \ CPI-U-RS Year and Inflation Data, 1978-2018  \ redi_01_CPI-U-RS.do mmk $DATE
compress
datasignature set, reset
save, replace

log close CPIURS
exit
