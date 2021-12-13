*! 1.1 Molly M. King 11 October 2021

***-----------------------------***

/*
redi inc_var year [using], ///
	gen(newvarname) ///
	inflation(integer) CPStype(household|family|respondent) ///
	ref(namelist)
	
*/
version 16

capture program drop redi
program define redi

syntax varlist(min=2 max=2), ///
	Generate(name) [cpstype(string)]
/*
syntax varlist(min=2 max=2) [using/], ///
	Generate(name) [INFlation(integer 0)] [CPStype(string)] ///
	[refvars(namelist min=0 max=2)] 	
*/

tempfile research_data
save `research_data'
***-----------------------------***

*TO DO	
* Output of REDI income value is not accurate
* convert  $temp/`ASECdata'_`ref_year'_inc`inc_level'.dta
* and tempfiles to frames
* add in inflation years
* change reference data to 	local reference_dataset "cps_reference.dta"
* cannot yet specify name of new continuous income variable
	
***-----------------------------***
// #0 Define all locals

// variable list
// categorical income variable from research dataset
	local inc_cat_var : word 1 of `varlist'
// year from research dataset
	local research_year : word 2 of `varlist'
	
	
// new variable	created for continuous income for research dataset
local new_variable "`generate'"


** using filename
if `"`using'"' == "" {
	local reference_dataset $temp/redi13_cps_state_ca.dta
}
else {
	local reference_dataset `"`using'"'
}


** reference variables
if `"`using'"' == "" {  // default to CPS-ASEC, if none specified
	local ref_year "year" // name of variable in CPS-ASEC, default reference    
}
else { // user specified file
	local ref_income_var : word 1 of `refvars'
	local ref_year : word 2 of `refvars'
	if "`ref_year'" == "" { // year variable not specified
		local ref_year "nys" // no year specified
	}
}

** income_type for CPS-ASEC reference
if "`cpstype'" == "family" & `"`using'"' == "" {
	use `reference_dataset', clear  // dataset placed in cwd by researcher			
	keep if pernum == 1 // keeps only one person per household
	svyset [pweight=asecwt]
	compress
	tempfile ref_data
	save `ref_data'
	local ref_income_var "ftotval" // name in reference (CPS-ASEC) dataset
	di "Income type set as `inc_var' income; " ///
	   "Calculating family income using ftotval CPS-ASEC variable."
}
else if "`cpstype'" == "household" & `"`using'"' == ""  {
	use `reference_dataset', clear  // dataset placed in cwd by researcher			
	keep if pernum == 1 // keeps only one person per household
	svyset [pweight=asecwth]
	compress
	tempfile ref_data
	save `ref_data'
	local ref_income_var "hhincome" // name in reference (CPS-ASEC) dataset
	di "Income type set as `inc_var' income; " ///
	   "Calculating household income using hhincome CPS-ASEC variable."
}
else if "`cpstype'" == "respondent" & `"`using'"' == "" {
	use `reference_dataset', clear  // dataset placed in cwd by researcher			
	svyset [pweight=asecwt]
	compress
	tempfile ref_data
	save `ref_data'
	local ref_income_var "inctot" // name in reference (ASEC) dataset
	di "Income type set as `inc_var' income; " ///
	   "Calculating respondent income using inctot ASEC variable."
}	
else if `"`cpstype'"' != "household" & `"`cpstype'"' != "family" & `"`csstype'"' != "respondent" {
	display as err "CPS income type must be either household, family, or respondent."
	error 999
}

	/*
** inflation year
if `inflation' == 0 | `"`inflation'"' == "" {
	local inflate = "no"
}
else if `inflation' < 1978 | `inflation' > 4000 {
	di as error "Inflation using CPI-U-RS data only works for years 1978 and later."
	error 999
}
else {
	local inflate = "yes"
	local inflation_year = `inflation'
	
	// import CPI-U-RS data from 
	import excel "https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx", ///
		clear cellrange(A6:N49) firstrow

	*rename columns
	drop if YEAR == 1977
	keep YEAR AVG
	rename YEAR year
	rename AVG cpi_avg
	label var cpi_avg "CPI-R-US all items average cost price inflator"

	tempfile temp_cpiurs
	save `temp_cpiurs', replace
	*save "r-cpi-u-rs-allitems.dta", replace // save as dta

	* Merge with CPI-U-RS Inflation Data
	merge m:1 year using `temp_cpiurs'

	drop _merge	
}
	
*/
***-----------------------------***

// convert categorical to continuous income values, independent of values of categories

// #1 Create local for levels of income = e.g., levelsof year, local(years)
use `research_data', clear
levelsof `inc_cat_var', local("`inc_cat_var'_levels")

// sort for later join & create variable recording original observation order within the identifier
bysort `research_year' `inc_cat_var': gen id = _n

// #2 create numeric variables indicating edges of income categories //
// Note: for more detail on if-command and Stata regular expressions used to create this, see:
	*http://www.stata.com/statalist/archive/2013-03/msg00654.html
	*http://www.stata.com/support/faqs/programming/if-command-versus-if-qualifier/
	*http://stats.idre.ucla.edu/stata/faq/how-can-i-extract-a-portion-of-a-string-variable-using-regular-expressions/

// List income levels
di "The income levels are: " "``inc_cat_var'_levels'"
		
// If variables are present either as strings OR as labels of categorical variables:
capture confirm string variable `inc_cat_var'
if !_rc {
	gen inc_decoded = `inc_cat_var' // action for string variable
}
else {
	* Decode converts labels to string variables for Research dataset
	decode `inc_cat_var', gen(inc_decoded) // action for numeric variable
}
				
tempfile working_regex
save `working_regex', replace
*use frames instead


// Levels of research year variable to loop through years in dataset
levelsof `research_year', local(years)
di  "Create local variable years to loop within that income level - values:" `years'

foreach y of local years { // loop through all years

	// loop through all values of income categories (`inc_level')
	foreach inc_level of local `inc_cat_var'_levels {

		use `working_regex', clear

		// Keep data if income variable is equal to current income level (of loop)
		keep if `inc_cat_var' == `inc_level'  
		di "The current inc_level is: " `inc_level'

		// text at beginning of the string:
		if regexm(inc_decoded, "^[a-z/A-Z]+") == 1 {
			di "The inc_level " `inc_level' " is at the lowest end of the " ///
			   "original Research dataset income range"
			destring inc_decoded, ///
				ignore("Less than LESS THAN Under,$ ") generate(`inc_cat_var'_ub) 
			gen `inc_cat_var'_lb = -100000
			di "Lower bound of -100,000 created for inc_level " `inc_level'
		}

		// text at end of the string:
		else if regexm(inc_decoded, "[a-z/A-Z]+$") == 1 {
			di "The inc_level " `inc_level' " is at the highest end of the " ///
			   "original Research dataset income range"
			destring inc_decoded, ///
				ignore("and over or over,$ or more OR MORE") generate(`inc_cat_var'_lb) 
			gen `inc_cat_var'_ub = 999999  // my topcode for asec purposes
			di "Upper bound of 999999 created for inc_level " `inc_level'
		}

		// if `inc_cat_var' is missing, 
		// keep it missing for lower_bound and upper_bound
		else if regexm(inc_decoded, "[.][a-z]") == 1 {
			di "The inc_level " `inc_level' " is all missing"
			gen `inc_cat_var'_lb = .
			gen `inc_cat_var'_ub = .
			di "Lower and upper bound of . created for inc_level " `inc_level'
		}

		// for labels with 2 numbers in them
		else if regexm(inc_decoded, "[0-9]+$") == 1 {
		// since those at lowest and highest ranges have already been matched 
		// (using text), this leaves those with ranges
			di "The inc_level " `inc_level' " has a lower and an upper level"
			split inc_decoded, ///
				parse("-" "to" "-" "to under" "to less than" "UP TO" "but less than") ///
				ignore(" ,$") destring
			gen `inc_cat_var'_lb = inc_decoded1
			gen `inc_cat_var'_ub = inc_decoded2
			di "Lower bound of `inc_cat_var'_lb and upper bound of `inc_cat_var'_ub " ///
			   "created for inc_level " `inc_level' "of the original Research " ///
			   "dataset income range"
		}
		
		else { // error - in case doesn't fit any existing category
			di as error "Error: The inc_level " `inc_level' ///
						" does not fit any of the existing regular expressions " ///
						"designs. Please email the REDI program creator at " ///
						"mollymkingphd@gmail.com with information about this " ///
						"error and a list of all of your income levels so she " ///
						"can update the program. Thank you for your help!"
			error 999
		}

		// locals to use later for selecting appropriate reference data bounds
		local upper_bound = `inc_cat_var'_ub
		local lower_bound = `inc_cat_var'_lb

		// drop variables used in creating lower and upper bounds
		capture drop inc_decoded1 inc_decoded2

		// #2B Now, still within the single-income-level loop in Research dataset:

		// summarize: count of how many individuals in that income level during year
		quietly summarize if `research_year' == `y' & `inc_cat_var' == `inc_level'
		local sample_size = r(N) // count how many rows there are in survey dataset
		 // count N_B for each bin 
		 // (# of observations in Research dataset income category between L_bn and U_bn)
				
		// create count within each Research dataset income level
		gen `inc_cat_var'_n = `sample_size' // size of bin in Research dataset
		label variable `inc_cat_var'_n "N in income level in research dataset"

		// create temporary file of just this Research dataset income level and year 
		// can merge reference/CPS-ASEC incomes back into later
		keep if `research_year' == `y' & `inc_cat_var' == `inc_level'
		tempfile premerge_`inc_level'_`y'
		save `premerge_`inc_level'_`y'', replace
		di "Saved tempfile with upper and lower bounds of research data income levels"
		
		// #3B) Keep reference/CPS-ASEC data if within income bounds and for given year
		use `reference_dataset', clear
		di "Reference data open - Income type set as `inc_cat_var' income" 
		
		keep if `ref_year' == `y' | `"`ref_year'"' == "nys" & ///
			`ref_income_var' >= `lower_bound' & ///
			`ref_income_var' <= `upper_bound'
		gen obs_no = _n
		di "Observation number generated"
	
		**** TO DO: convert  $temp/`ASECdata'_`ref_year'_inc`inc_level'.dta to tempfile - currently not working
		*tempfile ref_`ref_data'_`ref_year'_`inc_level'
		*di "tempfile created"
		*save `ref_`ref_data'_`ref_year'_`inc_level'', replace
		save $temp/`ASECdata'_`ref_year'_inc`inc_level'.dta, replace
		//use frames here
		//or use tempname - for the frames* then drop the tempname at the end
	
		di "Ref to keep income between $`lower_bound' and $`upper_bound' for `y' year."
			
		// #3C) Take random draw of number of incomes w/in income boundary, year
		// Sample, with replacement, such that ASEC income has an equal probability 
		// of being assigned to each observation, creting sample of size equal
		// to research dataset for income level, year
		// Thanks to Clyde Schechter:
			//https://www.statalist.org/forums/forum/general-stata-discussion/general/ 	
			// 1475890-is-there-a-command-that-is-equivalent-to-bsample-more-than-_n
		quietly des 
		local N = r(N)
		clear
		set obs `sample_size'
		gen obs_no = runiformint(1, `N')
		*merge m:1 obs_no using `temp_`ref_data'_`ref_year'_inc`inc_level'', keep(match) nogenerate 
		merge m:1 obs_no using  $temp/`ASECdata'_`ref_year'_inc`inc_level'.dta, ///
		keep(match) nogenerate 

		*save `temp_`ref_data'_`ref_year'_inc`inc_level'', replace
		save $temp/`ASECdata'_`ref_year'_inc`inc_level'.dta, replace
			
		// #4) Merge Research and random sample of reference (ASEC) data
		// within incomebin, year
		
		gen id = _n
		merge 1:1 id using `premerge_`inc_level'_`y'', ///
			update replace keep(match)
		
		di "Merged ASEC values with original Research dataset for inc_level " ///
		   `inc_level' " ($`lower_bound'-`upper_bound') and year `y'."
				
		// #5) create count within each REDI income level
		generate 	category_n = .
		replace 	category_n = `N' // r(N) from above
		label var 	category_n "N respondents in income level in post-merge dataset'"

		// Save these new REDI data (with yearly ASEC continuous data) 
		// in a tempfile we can use later for merging, etc.
		tempfile temp_`inc_level'_`y'
		save `temp_`inc_level'_`y'', replace
		di "Saved REDI data (with continuous data) for inc_level " ///
		   `inc_level' " ($`lower_bound'-`upper_bound') and year `y' in file"
		
	}
	//  close loop through all values of income categories (`inc_level')
				
	*di "Moved outside loop of `research_year' income level " ///
	*   `inc_level' " ($`lower_bound'-`upper_bound')."
		
	// append all income levels across all years
	tokenize ``inc_cat_var'_levels'
	local first `1'
	use `temp_`1'_`y'', clear
	macro shift
	local rest `*'

	// now loop through and append each temp file created within income level loop
	foreach bracket in `*' {
		append using `temp_`bracket'_`y''
	}

	// create new tempfile to save each year's data for all income levels
	tempfile temp_`y'
	save `temp_`y'', replace
	di "Saved new tempfile for year `y' for all REDI  income levels."
						
} 
//  end of loop through all years
				
// append all years 
tokenize `years'
local first `1'
use `temp_`1'', clear
macro shift
local rest `*'

// now loop through and append each yearly temp file created earlier
foreach ytemp in `*' {
	append using `temp_`ytemp''
}

di "Appended all years "

// CLEAN UP
drop obs_no id inc_decoded
drop _merge

***-----------------------------***

// PROGRAM TO RENAME FINAL VARIABLES if inflation not specified
gen `new_variable' = `ref_income_var'
format `new_variable' %6.0fc
label var `new_variable' "REDI continuous `inc_cat_var' income"
	

***-----------------------------***

end
