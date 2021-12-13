*! 1.0.1 Molly M. King 16 September 2021

***-----------------------------***

capture program drop redi
program define redi
	version 16.0
	syntax newvarname 
	args inc_var year [, inc_type inflation_year ]

***-----------------------------***

// convert categorical to continuous income values, independent of values of categories

// #1 Create local for levels of income = e.g., levelsof year, local(years)
levelsof `inc_var', local("`inc_var'_levels")

// sort for later join & create variable recording the original observation order within the identifier
bysort `year' `inc_var': gen id = _n

// #2 create numeric variables indicating edges of income categories //
// Note: for more detail on if-command and Stata regular expressions used to create this, see:
	*http://www.stata.com/statalist/archive/2013-03/msg00654.html
	*http://www.stata.com/support/faqs/programming/if-command-versus-if-qualifier/
	*http://stats.idre.ucla.edu/stata/faq/how-can-i-extract-a-portion-of-a-string-variable-using-regular-expressions/

// List income levels
di in red "The income levels are: " "``inc_var'_levels'"

		
*If variables are present either as strings OR as labels of numeric categorical variables:
capture confirm string variable `inc_var'
if !_rc {
	gen inc_decoded = `inc_var' // action for string variable
} else 
{
	* Decode converts labels to string variables for Research dataset
	decode `inc_var', gen(inc_decoded)// action for numeric variable
}
				
tempfile working_regex
save `working_regex', replace

//Levels of year variable to loop through years in dataset
levelsof `year', local(years)
di in red  "Create local variable years to loop through within that income bracket - values:" `years'

foreach y of local years { // loop through all years

	// loop through all values of income categories (`inc_level')
	foreach inc_level of local `inc_var'_levels {

		use `working_regex', clear

		// Keep the data if the income variable is equal to the current income level (of the loop)
		keep if `inc_var' == `inc_level'  // do this to make sure not replacing things with wrong level later	
		di "The current inc_level is: " `inc_level'

		// text at beginning of the string:
		if regexm(inc_decoded, "^[a-z/A-Z]+") == 1 {
			di "The inc_level " `inc_level' " is at the lowest end of the original Research dataset income range"
			destring inc_decoded, ignore("Less than LESS THAN Under,$ ") generate(`inc_var'_ub) 
			gen `inc_var'_lb = -100000
			di "Lower bound of -100,000 created for inc_level " `inc_level'
		}

		// text at end of the string:
		else if regexm(inc_decoded, "[a-z/A-Z]+$") == 1 {
			di "The inc_level " `inc_level' " is at the highest end of the original Research dataset income range"
			destring inc_decoded, ignore("and over or over,$ or more OR MORE") generate(`inc_var'_lb) 
			gen `inc_var'_ub = 999999  // my topcode for asec purposes
			di "Upper bound of 999999 created for inc_level " `inc_level'
		}

		// if `inc_var' is missing, keep it missing for lower_bound and upper_bound
		else if regexm(inc_decoded, "[.][a-z]") == 1 {
			di "The inc_level " `inc_level' " is all missing"
			gen `inc_var'_lb = .
			gen `inc_var'_ub = .
			di "Lower and upper bound of . created for inc_level " `inc_level'
		}

		// for labels with 2 numbers in them
		else if regexm(inc_decoded, "[0-9]+$") == 1 {
		// since those at lowest and highest ranges have already been matched (using text), this leaves those with ranges
			di "The inc_level " `inc_level' " has a lower and an upper level"
			split inc_decoded, ///
				parse("-" "to" "-" "to under" "to less than" "UP TO" "but less than") ///
				ignore(" ,$") destring
			gen `inc_var'_lb = inc_decoded1
			gen `inc_var'_ub = inc_decoded2
			di "Lower bound of `inc_var'_lb and upper bound of `inc_var'_ub created for inc_level " `inc_level' "of the original Research dataset income range"
		}
		else { // error - in case doesn't fit any existing category
			display as error "Error: The inc_level " `inc_level' " does not fit any of the existing regular expressions designs. Please email the REDI program creator at mollymkingphd@gmail.com with information about this error and a list of all of your income levels so she can update the program. Thank you for your help!"
		}

		// create locals to use later for selecting appropriate ASEC bounds
		local upper_bound = `inc_var'_ub
		local lower_bound = `inc_var'_lb

		// drop variables used in creating lower and upper bounds
		capture drop inc_decoded1 inc_decoded2

		// #2B Now, still within the single-income-level loop in Research dataset:

		// summarize so can get count of how many individuals in that income level during year
		quietly summarize if `year' == `y' & `inc_var' == `inc_level'
		local sample_size = r(N) // count how many rows there are in survey dataset
		 // count N_B for each bin (# of observations in Research dataset income category between L_bn and U_bn)
				
		// create count within each Research dataset income bin
		gen `inc_var'_n = `sample_size' // contains size of bin in Research dataset
		label variable `inc_var'_n ///
			"Count of respondents in each income bin in original (research) dataset"

		// create temporary file of just this Research dataset income level and year 
		// can merge ASEC incomes back into later
		keep if `year' == `y' & `inc_var' == `inc_level'
		tempfile premerge_`inc_level'_`y'
		save `premerge_`inc_level'_`y'', replace

		// #3A) Selects appropriate CPS ASEC dataset (of a certain type, either fam, hh, or pers) //
		if "`ref_data''" == "cps" {	
			
			*take generic cps input file and generate 3 files below for family, household, and personal as needed
			
			if "`inc_type'" == "family" {
				*use $deriv/ki11_bidee00_ASEC-ftotval.dta, clear // use ASEC family dataset
				*local ref_data "$deriv/ki11_bidee00_ASEC-ftotval"
				use "ref_data", clear  // dataset placed in cwd by researcher			
				keep if pernum == 1 // keeps only one person per household
				svyset [pweight=asecwt]
				compress
				tempfile ref_data
				save `ref_data'
				local inc_var_short "finc"
				local inc_var_name "ftotval" // name in reference (ASEC) dataset
				di "Income type set as `inc_var' income; Calculating family income using ftotval ASEC variable."
			}
			else if "`inc_type'" == "household" {
				use $temp/redi13_cps_state_ca.dta, clear  // dataset placed in cwd by researcher			
				keep if pernum == 1 // keeps only one person per household
				svyset [pweight=asecwth]
				compress
				tempfile ref_data
				save `ref_data'
				local inc_var_short "hinc"
				local inc_var_name "hhincome" // name in reference (ASEC) dataset
				di "Income type set as `inc_var' income; Calculating household income using hhincome ASEC variable."
			}
			else if "`inc_type'" == "respondent" {
				*use $deriv/ki11_bidee00_ASEC-inctot.dta, clear // use ASEC individual-weighted dataset
				*local ref_data "$deriv/ki11_bidee00_ASEC-inctot"
				use "ref_data", clear  // dataset placed in cwd by researcher			
				svyset [pweight=asecwt]
				compress
				tempfile ref_data
				save `ref_data'
				local inc_var_short "rinc"
				local inc_var_name "inctot" // name in reference (ASEC) dataset
				di "Income type set as `inc_var' income; Calculating respondent income using inctot ASEC variable."
			}
			else {
				display as error  ///
				"Error: Income types allowed to use CPS ASEC reference dataset: family, household, or respondent (personal)."
			}
		}
		else if "`ref_data''" != "cps" {
			use `ref_data', clear
		}
		else {
			display as error ///
			"Error: Must specify reference dataset with continuous income distribution using ref_data argument"
		}

		// #3B) Takes a random draw of number of incomes w/in that income boundary and year from the CPS-ASEC
		// Keep ASEC data if within income bounds and for given year

		keep if `year' == `y' & ///
			`inc_var_name' >= `lower_bound' & ///
			`inc_var_name' <= `upper_bound'
		gen obs_no = _n
		tempfile temp_`ref_data'_`year'_inc`inc_level'
		save `temp_`ref_data'_`year'_inc`inc_level'', replace
			*save "`ASECdata'_`year'_inc`inc_level'.dta", replace
		di "Keep income between $`lower_bound' and $`upper_bound' for `y' year."
			
		// #3C) Sample, with replacement, 
		*such that ASEC income has an equal probability assigned to each observation 
		*in this artificial data set (which will later be matched to Research data set)
		// Thanks to Clyde Schechter;  
			*https://www.statalist.org/forums/forum/general-stata-discussion/general/ 	
			* 1475890-is-there-a-command-that-is-equivalent-to-bsample-more-than-_n
		quietly des 
		local N = r(N)
		clear
		set obs `sample_size'
		gen obs_no = runiformint(1, `N')
		merge m:1 obs_no using `temp_`ref_data'_`year'_inc`inc_level'', keep(match) nogenerate 
			*merge m:1 obs_no using "`ASECdata'_`year'_inc`inc_level'.dta", keep(match) nogenerate 
		// here, artificial data set is matched to ASEC data set for that incomebin for that year 								
																	
		// #3D) Add new columns for lower_bound and upper_bound of income bin
		gen `inc_var'_lb = `lower_bound'
		gen `inc_var'_ub = `upper_bound'
		// Label new upper and lower income bound variables
		label variable `inc_var'_lb "`inc_var' Lower Bound"
		label variable `inc_var'_ub "`inc_var' Upper Bound"

		save `temp_`ref_data'_`year'_inc`inc_level'', replace
			*save "`ASECdata'_`year'_inc`inc_level'.dta", replace
			
		di "Merged ASEC values with original Research dataset for inc_level " `inc_level' " ($`lower_bound'-`upper_bound') and year `y'."

		// #4) Merge Research and ASEC data
		// here, ASEC artificial data set (from step 3C) is matched to Research for that incomebin for that year 								
		gen id = _n
		merge 1:1 id using `premerge_`inc_level'_`y''
						
		// #5) create count within each REDI income bin
		generate 	`redi_inc_var'_n = .
		replace 	`redi_inc_var'_n = `N' // r(N) from above
		label var 	`redi_inc_var'_n "`inc_type' (REDI) count of respondents in each income bin in post-merge dataset'"

		// Save these new REDI data (with yearly ASEC continuous data) in a tempfile we can use later for merging, etc.
		tempfile temp_`inc_level'_`y'
		save `temp_`inc_level'_`y'', replace
		di "Saved REDI data (with ASEC continuous data) for inc_level " `inc_level' " ($`lower_bound'-`upper_bound') and year `y' in file"
		
	}  //  close loop through all values of income categories (`inc_level')
				
	*di "Moved outside loop of `year' income bracket " `inc_level' " ($`lower_bound'-`upper_bound')."
		
	// append all income brackets across all years
	tokenize ``inc_var'_levels'
	local first `1'
	use `temp_`1'_`y'', clear
	macro shift
	local rest `*'

	// now loop through and append each temp file created within income bracket loop
	foreach bracket in `*' {
		append using `temp_`bracket'_`y''
	}

	// create new tempfile to save each year's data for all income levels
	tempfile temp_`y'
	save `temp_`y'', replace
	di "Saved new tempfile  for year `y' for all REDI income brackets."
						
} //  end of loop through all years
				
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

// INFLATE based on specified inflation_year

if "`inflation_year''" != "" { // if inflation year is not empty	
	
	local inflation_ref "cpi_u_rs"
	
	if "`inflation_ref'" == "cpi_u_rs" { // provides later option to include other inflation references
	
		*import CPI-U-RS data from https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx
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
			
	* Locals for final variables using inflation-adjustments
	local newvar "redi_`inc_var_short'_`inflation_year'"

	* INFLATION-ADJUSTED INCOME = divide continuous income variable by conversion factor
	*original income variable, adjusted for inflation
	gen `newvar' = `inc_var_name' / conv_factor
	format `newvar' %6.0fc
	label var `newvar' "REDI continuous inflation-adjusted `inc_var' income, `inflation_year' dollars"
	drop `inc_var_name'
} 

else {
	// FINAL VARIABLES if inflation not specified
	local newvar "redi_`inc_var_short'"
	
	*original income variable
	gen `newvar' = `inc_var_name'
	format `newvar' %6.0fc
	label var `newvar' "REDI continuous `inc_var' income"
	drop `inc_var_name'
}
		
***-----------------------------***

end
