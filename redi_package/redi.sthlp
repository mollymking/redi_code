{smcl}
{* *! version 1.1 11 October 2021}{...}

{title:Title}

{p2colset 5 15 20 2}{...}
{p2col:{hi:redi} {hline 1}} A Random Empirical Distribution Imputation method for estimating continuous incomes {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd: redi}
{help numlist: inc_var(long)}
{help numlist: year(int)}
using
{help dta: filename}
[
{cmd:,}
{newvar}
{help options: inc_type(string)}
{help options: inflation_year(int)}
]

{p 4 4 2}
where {it:inc_var} is

{p 8 17 2}
the name of the categorical income variable in the original research dataset, where
{it:inc_var} may be either a string variable (with the categories as text) or a numeric variable
(with the categories storied as value labels);

{p 4 4 2}
{it:year} is

{p 8 17 2}
the name of the year variable in the original research dataset;

{p 4 4 2}
and {it:filename}

{p 8 17 2}
specifies the filename of the reference dataset the researcher wishes to use for income data (see remarks).
Using cps (or specifying ref_data without a dataset option) tells the program to
use the CPS ASEC as the reference distribution for income.
If cps is used as the reference distribution, the {opt inc_type} must be specified.


{title:Description}

{p 8 17 2}
{cmd:redi} is a method for cold-deck imputation of a continuous distribution
from binned incomes, using a real-world reference dataset.

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
{it:newvar} specifies a name for the new continuous income variable calculated using the {cmd:redi} method.
If no name is specified, the default variable name is redi_inc.

{phang}
{opt inc_type(string)} specifies the type of income reference variable to use from the CPS ASEC reference dataset.
Options are "household", "family", or "respondent"-level income.

{phang}
{opt inflation_year(int)} specifies the year to which the data should be inflated using the R-CPI-U-RS (see remarks).
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
Alternatively, you may use a local to indicate the location and name of the reference dataset.
These {browse
"https://www.census.gov/topics/population/foreign-born/guidance/cps-guidance/using-cps-asec-microdata.html":details
on using the CPS ASEC Public Use Microdata}, including technical documentation
and details about weights, may also be useful.

{p 4 4 2}
Otherwise, if you do not wish to use the CPS ASEC, you may specify your own .dta file as the reference here,
using the format ref_data = "ReferenceDataName.dta", optionally with directory, i.e. "~/Desktop/ReferenceDataName.dta".


{p 4 4 2}
{it:Program Output}

{p 4 4 2}
Without specifying an inflation year, the {cmd:redi} command produces the continuous income variable {newvar} calculated in the dollar value of the original research dataset.
With the inflation option, the {cmd:redi} command produces the continuous income variable {newvar} calculated using the redi method, adjusted for inflation using the specified inflation dataset and year.


{p 4 4 2}
{it:Inflation}

{p 4 4 2}
The Consumer Price Index retroactive series using current methods with all
items (R-CPI-U-RS) is available from the U.S. Bureau of
Labor Statistics website ({browse "http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm":http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm}).
The Retroactive Series (R-CPI-U-RS) estimates the Consumer Price Index for Urban Consumers from 1978, using current methods that incorporate these improvements over the entire time span.
Using the {opt inflation_year} option for automatically downloads this dataset for use in inflation adjustment. The year specified indicates the year that should be used for inflation-adjusted dollars.



{title:Examples}

{p 4 4 2}
// Calculate a new continuous income variable named ca_redi_inc19 from categorical household income variable hhincome_acs using CPS ASEC reference dataset {p_end}
{p 4 4 2}
{help cmd: redi} {help var: hhincome_acs} {help var: year} {help dta: cps}, {help newvar: ca_redi_inc19} {help options: household}

{p 4 4 2}
// Inflate the resulting continuous household income values to 2020 dollars using the R-CPI-U-RS {p_end}
{p 4 4 2}
{help cmd: redi} {help var: hhincome_acs} {help var: year} {help dta: cps}, {help newvar: ca_redi_inc19} {help options: household} {help options: 2020}


{title:Author}

{p 4 4 2}
     Molly M. King {break}
		 Department of Sociology, Santa Clara University {break}
		 {browse "https://www.mollymking.com/":https://www.mollymking.com/} {break}
		 {browse "mailto:mollymkingphd@gmail.com?subject=redi":mollymkingphd@gmail.com}{p_end}

{title:Acknowledgments}

{p 4 4 2}
I thank Christof Brandtner, Jeremy Freese, and David Grusky for their feedback on the methodological paper underlying this program.
I also thank Nicholas J. Cox for his useful Stata programs and help files, which have served as a model for this help file.

{title:References}

{p 4 8 2}
Baum, C.F. 2020. {browse "http://repec.org/bocode/s/sscsubmit.html":Submitting and retrieving materials from the SSC Archive}.

{p 4 8 2}
King, Molly M. 2020. {browse "https://doi.org/10.31235/osf.io/eswm8":REDI for Binned Data: A Random Empirical Distribution Imputation method for estimating continuous incomes}. SocArXiv Pre-print server.

{break}
