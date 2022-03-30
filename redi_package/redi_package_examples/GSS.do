 
#delimit ;

infix

INCOME    1 - 20
RINCOME    21 - 40
YEAR    41 - 60
using GSS.dat;


label variable INCOME   "Total family income";
label variable RINCOME   "Respondents income";
label variable YEAR   "GSS year for this respondent";


label define  GSP001X
1      "Under $1,000"
2      "$1,000 to $2,999"
3      "$3,000 to $3,999"
4      "$4,000 to $4,999"
5      "$5,000 to $5,999"
6      "$6,000 to $6,999"
7      "$7,000 to $7,999"
8      "$8,000 to $9,999"
9      "$10,000 to $14,999"
10      "$15,000 to $19,999"
11      "$20,000 to $24,999"
12      "$25,000 or more"
13      "Refused"
-100      ".i:  Inapplicable"
-97      ".s:  Skipped on Web"
-99      ".n:  No answer"
-98      ".d:  Do not Know/Cannot Choose"
-90      ".r:  Refused"
 ;
label define  GSP002X
98      "DK"
12      "$25000 OR MORE"
11      "$20000 - 24999"
10      "$15000 - 19999"
9      "$10000 - 14999"
8      "$8000 TO 9999"
7      "$7000 TO 7999"
6      "$6000 TO 6999"
5      "$5000 TO 5999"
4      "$4000 TO 4999"
3      "$3000 TO 3999"
2      "$1000 TO 2999"
1      "LT $1000"
-100      ".i:  Inapplicable"
-80      ".x:  Not available in this release"
-99      ".n:  No answer"
-98      ".d:  Do not Know/Cannot Choose"
-90      ".r:  Refused"
 ;


label values INCOME   GSP001X;
label values RINCOME   GSP002X;

