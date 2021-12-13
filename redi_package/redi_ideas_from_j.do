
//
redi inc_research_dataset year [using], ///
	gen(newvarname) inflation year(household|family|respondent) ///
	ref(namelist)
	
//

clear all
program drop _all

version 16

program define rediparms

syntax varlist(min=2 max=2) [using/], ///
	Generate(name) [INFlation(integer 0)] [type(string)] ///
	[refvars(namelist min=1 max=2)] 

** variable list
local income_cat_variable : word 1 of `varlist'
local year : word 2 of `varlist'
	
** new variable	
local new_variable "`generate'"

** using filename
if `"`using'"' == "" {
	local reference_dataset "WHATEVER YOU WANT DEFAULT TO BE"
}
else {
	local reference_dataset `"`using'"'
}

** reference variables
if `"`using'"' == "" {
	local ref_income_var "WHATEVER"
	local ref_year "year"
}
else { // user specified file
	local ref_income_var : word 1 of `refvars'
	local ref_year_var : word 2 of `refvars'
	if "`ref_year_var'" == "" { // year variable not specified
		local ref_year_var "WHATEVER"
	}
}

** income_type
if `"`type'"' != "household" & `"`type'"' != "family" & `"`type'"' != "respondent" {
	display as err "type must be either household, family, or respondent"
	error 999
}
local income_type "`type'"

** inflation year
if `inflation' == 0 {
	local inflate = "no"
}
else if `inflation' < 1000 | `inflation' > 10000 {
	di as error "inflation must be between XX and XX"
	error 999
}
else {
	local inflate = "yes"
	local inflation_year = `inflation'
}

display "income_type is `income_type'"
display "new_variable is `new_variable'"
display `"reference_dataset is `reference_dataset'"' // use `" "' quotes because might contain quotes
display "inflation year is " `inflation'
display "reference set income variable is `ref_income_var'"
display "reference set year variable is `ref_year_var'"

end

rediparms using "hello/filehere.dta", gen(whatever)

