{smcl}
{* *! version 1.1 11 October 2021}{...}

{title:Title}

{p2colset 5 15 20 2}{...}
{p2col:{hi:redi} {hline 1}} A Random Empirical Distribution Imputation method for estimating continuous incomes {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd: redi}
{help varlist: inc_var(string)}
{help varlist: year(string)}
{cmd:,}
Generate({newvar})
[
{help options: CPStype(string)}
{help options: INFlationyear(int)}
]

{p 4 4 2}
where {it:inc_var(string)} is

{p 8 17 2}
the name of the categorical income variable in the original research dataset, and
{it:inc_var} may be either a string variable (with the categories as text) or a numeric variable
(with the categories storied as value labels);

{p 4 4 2}
{it:year(string)} is

{p 8 17 2}
the name of the year variable in the original research dataset; and

{p 4 4 2}
{it:Generate(string)} specifies

{p 8 17 2}
a name for the new continuous income variable calculated using the {cmd:redi} method.


{title:Description}

{p 8 17 2}
{cmd:redi} is a method for cold-deck imputation of a continuous distribution
from binned incomes, using a real-world reference dataset (in this case, the CPS ASEC).

{p 4 4 2}
The Random Empirical Distribution Imputation ({cmd:redi}) method imputes
discrete observations using binned income data, while also enabling the
calculation of summary statistics. {cmd:redi} achieves this through random
cold-deck imputation from a real world reference dataset. The {cmd:redi} method
reconciles bins between datasets or across years and handles top incomes.
{cmd:redi} has other advantages of computing an income distribution that is
nonparametric, bin consistent, area- and variance-preserving, continuous, and
computationally fast. For a complete discussion of the method's features and
limitations, see the "REDI for Binned Data" paper, listed under the references.


{title:Options}

{dlgtab:Main}

{phang}
{opt CPStype(string)} specifies the type of income reference variable to use from the CPS ASEC reference dataset.
Options are "household", "family", or "respondent"-level income.

{phang}
{opt INFlationyear(int)} specifies the year to which the data should be inflated using the R-CPI-U-RS (see remarks).
The year should be specified as a 4-digit number. If no inflation adjustment is desired, do not specify.



{title:Remarks}

{p 4 4 2}
{it:Reference Data}

{p 4 4 2}
Prior to using this command, you must download and place a reference dataset into your
current working directory.
The default reference dataset (the Current Population Survey ASEC) is available for download from
the IPUMS CPS website ({browse "cps.ipums.org":cps.ipums.org}).
To use the CPS ASEC as the reference dataset, the researcher must download this
dataset for the year(s) of interest before using the CPS ASEC as a reference
dataset with this command. The variables needed are: YEAR, ASECWTH, HHINCOME,
and PERNUM. Place this dataset in your current working directory and name the file "cps_reference.dta".
Additional
{browse "https://www.census.gov/topics/population/foreign-born/guidance/cps-guidance/using-cps-asec-microdata.html":details on using the CPS ASEC Public Use Microdata},
including technical documentation and details about analysis using survey weights, may also be useful.

{p 4 4 2}
{it:Program Output}

{p 4 4 2}
Without specifying an inflation year, the {cmd:redi} command produces the
continuous income variable {newvar} calculated in the dollar value corresponding to the year of the
original research dataset. With the inflation option, the {cmd:redi} command
produces both this same continuous income variable {newvar} calculated using the {cmd:redi}
method, and another new variable adjusted for inflation using the specified inflation dataset and year.

In the process of producing the continuous value, the {cmd:redi} command will also
generate a lower-bound variable ({it:inc_var}_lb) and an upper-bound variable
({it:inc_var}_ub) for the continuous income variable drawn from the reference dataset.
These can be used to verify the new continuous variable or dropped at the researcher's
convenience.

{p 4 4 2}
{it:Inflation}

{p 4 4 2}
The Consumer Price Index retroactive series using current methods with all items
(R-CPI-U-RS) is available from the U.S. Bureau of Labor Statistics website
({browse "http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm":http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm}).
The Retroactive Series (R-CPI-U-RS) estimates the Consumer Price Index for Urban
Consumers from 1978, using current methods that incorporate these improvements
over the entire time span. Using the {opt inflation_year} option for
automatically downloads this dataset for use in inflation adjustment. The year
specified indicates the year that should be used for inflation-adjusted dollars.
Using this option produces a variable named ({newvar})_inf({it:inflationyear})



{title:Examples}

{p 4 4 2}
// Calculate a new continuous income variable named household_cont from categorical
household income variable inchousehold and year variable yr.
The household income type needs to be specified as an option.{p_end}
{p 8 17 2}
{help cmd: redi} {help var: inchousehold} {help var: yr}, gen(household_cont) cps(household)

{p 4 4 2}
// Inflate the resulting continuous household income values to 2020 dollars using the R-CPI-U-RS. This example will produce not only household_cont but also household_cont_inf2020,
a version of the continuous variable inflated to 2020 dollars. {p_end}
{p 8 17 2}
{help cmd: redi} {help var: inchousehold} {help var: yr}, g(household_cont) cps(household) {help options: inf(2020)}


{title:Author}

{p 4 4 2}
     Molly M. King {break}
		 Department of Sociology, Santa Clara University {break}
		 {browse "https://www.mollymking.com/":https://www.mollymking.com/} {break}
		 {browse "mailto:mollymkingphd@gmail.com?subject=redi":mollymkingphd@gmail.com}{p_end}

{title:Acknowledgments}

{p 4 4 2}
I am grateful to Jeremy Freese for his significant help with the syntax and implementation of this program.
I thank Christof Brandtner, Jeremy Freese, and David Grusky for their feedback on the methodological paper underlying this program.
I also thank Nicholas J. Cox for his useful Stata programs and help files, which have served as a model for this help file.

{title:References}

{p 4 8 2}
Baum, C.F. 2020. {browse "http://repec.org/bocode/s/sscsubmit.html":Submitting and retrieving materials from the SSC Archive}.

{p 4 8 2}
King, Molly M. 2022. "REDI for Binned Data: A Random Empirical Distribution Imputation method for estimating continuous incomes."
Forthcoming in {it:Sociological Methodology.} {browse "https://doi.org/10.31235/osf.io/eswm8":Available on the SocArXiv Pre-print server.}

{break}
