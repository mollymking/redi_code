{smcl}
{* *! version 1.0.0 8Sep2020}{...}

{title:Title}

{p2colset 5 15 20 2}{...}
{p2col:{hi:redi} {hline 1}} A Random Empirical Distribution Imputation method for estimating continuous incomes {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd: redi}
{cmd: newvar(long)}
{cmd: inc_var(byte or string)}
{cmd: year(long)}
{cmd: ref_data}
[
{cmd:,}
{opt inflation_year(int)}
{opt inc_type(string)}
]

{p 4 4 2}
where {it:newvar} is

{p 8 17 2}
the new continuous income variable derived from the {cmd:redi} method;

{p 4 4 2}
{it:inc_var} is

{p 8 17 2}
the name of the categorical income variable in the original research dataset, where
{it:inc_var} may be either a string variable (with the categories as text) or a numeric variable
(with the categories storied as value labels);

{p 4 4 2}
{it:year} is

{p 8 17 2}
the name of the year/time variable in the original research dataset;

{p 4 4 2}
and {it:ref_data}

{p 8 17 2}
specifies the reference dataset the researcher wishes to use for income data (see remarks).
Using ref_data = cps (or specifying ref_data without a dataset option) tells the program to use the CPS ASEC as the reference distribution for income.


{title:Description}

{p 8 17 2}
{cmd:redi} is a method for cold-deck imputation of a continuous distribution from binned incomes, using a real-world reference dataset.

{p 4 4 2}
The Random Empirical Distribution Imputation ({cmd:redi}) method imputes
 discrete observations using binned income data, while also enabling the
calculation of summary statistics. {cmd:redi} achieves this through random cold-deck
imputation from a real world reference dataset.
The {cmd:redi} method reconciles bins between datasets or across
years and handles top incomes. {cmd:redi} has other advantages of computing an income
distribution that is nonparametric, bin consistent, area- and variance-preserving, continuous,
and computationally fast.
For a complete discussion of the method's features and limitations, see the "REDI for Binned Data" paper, listed under the references.


{title:Options}

{dlgtab:Main}

{phang}
{opt inflation_year(int)} specifies the year to which the data should be inflated using the R-CPI-U-RS (see remarks).
The year should be specified as a 4-digit number. If no inflation adjustment is desired, do not specify.


{phang}
{opt inc_type(string)} specifies the reference variable to use from the CPS ASEC reference dataset.
 Options are "household", "family", or "respondent"-level income.



{title:Remarks}

{p 4 4 2}
Prior to using this command, you must download and place a reference dataset into your
current working directory.
The default reference dataset (Current Population Survey ASEC) is available for download from
the IPUMS CPS website ({browse "cps.ipums.org":cps.ipums.org}).
Variables needed are: YEAR, ASECWTH, HHINCOME, and PERNUM.
The researcher will need to download this for the year(s) of interest before using
the CPS ASEC as a reference dataset with this command.

{p 4 4 2}
The  Consumer Price Index retroactive series using current methods with all
items (R-CPI-U-RS) is available from the U.S. Bureau of
Labor Statistics website ({browse "http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm":http://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm}).
The Retroactive Series (R-CPI-U-RS) estimates the Consumer Price Index for Urban Consumers from 1978, using current methods that incorporate these improvements over the entire time span.
Using the {opt inflation_year} option for automatically downloads this dataset for use in inflation adjustment. The year specified indicates the year that should be used for inflation-adjusted dollars.


{title:Examples}





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
