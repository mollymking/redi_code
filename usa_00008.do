* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix                ///
  int     year      1-4      ///
  long    hhincome  5-11     ///
  double  perwt     12-21    ///
  byte    repwtp    22-22    ///
  long    repwtp1   23-28    ///
  long    repwtp2   29-34    ///
  long    repwtp3   35-40    ///
  long    repwtp4   41-46    ///
  long    repwtp5   47-52    ///
  long    repwtp6   53-58    ///
  long    repwtp7   59-64    ///
  long    repwtp8   65-70    ///
  long    repwtp9   71-76    ///
  long    repwtp10  77-82    ///
  long    repwtp11  83-88    ///
  long    repwtp12  89-94    ///
  long    repwtp13  95-100   ///
  long    repwtp14  101-106  ///
  long    repwtp15  107-112  ///
  long    repwtp16  113-118  ///
  long    repwtp17  119-124  ///
  long    repwtp18  125-130  ///
  long    repwtp19  131-136  ///
  long    repwtp20  137-142  ///
  long    repwtp21  143-148  ///
  long    repwtp22  149-154  ///
  long    repwtp23  155-160  ///
  long    repwtp24  161-166  ///
  long    repwtp25  167-172  ///
  long    repwtp26  173-178  ///
  long    repwtp27  179-184  ///
  long    repwtp28  185-190  ///
  long    repwtp29  191-196  ///
  long    repwtp30  197-202  ///
  long    repwtp31  203-208  ///
  long    repwtp32  209-214  ///
  long    repwtp33  215-220  ///
  long    repwtp34  221-226  ///
  long    repwtp35  227-232  ///
  long    repwtp36  233-238  ///
  long    repwtp37  239-244  ///
  long    repwtp38  245-250  ///
  long    repwtp39  251-256  ///
  long    repwtp40  257-262  ///
  long    repwtp41  263-268  ///
  long    repwtp42  269-274  ///
  long    repwtp43  275-280  ///
  long    repwtp44  281-286  ///
  long    repwtp45  287-292  ///
  long    repwtp46  293-298  ///
  long    repwtp47  299-304  ///
  long    repwtp48  305-310  ///
  long    repwtp49  311-316  ///
  long    repwtp50  317-322  ///
  long    repwtp51  323-328  ///
  long    repwtp52  329-334  ///
  long    repwtp53  335-340  ///
  long    repwtp54  341-346  ///
  long    repwtp55  347-352  ///
  long    repwtp56  353-358  ///
  long    repwtp57  359-364  ///
  long    repwtp58  365-370  ///
  long    repwtp59  371-376  ///
  long    repwtp60  377-382  ///
  long    repwtp61  383-388  ///
  long    repwtp62  389-394  ///
  long    repwtp63  395-400  ///
  long    repwtp64  401-406  ///
  long    repwtp65  407-412  ///
  long    repwtp66  413-418  ///
  long    repwtp67  419-424  ///
  long    repwtp68  425-430  ///
  long    repwtp69  431-436  ///
  long    repwtp70  437-442  ///
  long    repwtp71  443-448  ///
  long    repwtp72  449-454  ///
  long    repwtp73  455-460  ///
  long    repwtp74  461-466  ///
  long    repwtp75  467-472  ///
  long    repwtp76  473-478  ///
  long    repwtp77  479-484  ///
  long    repwtp78  485-490  ///
  long    repwtp79  491-496  ///
  long    repwtp80  497-502  ///
  using `"usa_00008.dat"'

replace perwt    = perwt    / 100

format perwt    %10.2f

label var year     `"Census year"'
label var hhincome `"Total household income"'
label var perwt    `"Person weight"'
label var repwtp   `"Person replicate weights [80 variables]"'
label var repwtp1  `"Person replicate weight 1"'
label var repwtp2  `"Person replicate weight 2"'
label var repwtp3  `"Person replicate weight 3"'
label var repwtp4  `"Person replicate weight 4"'
label var repwtp5  `"Person replicate weight 5"'
label var repwtp6  `"Person replicate weight 6"'
label var repwtp7  `"Person replicate weight 7"'
label var repwtp8  `"Person replicate weight 8"'
label var repwtp9  `"Person replicate weight 9"'
label var repwtp10 `"Person replicate weight 10"'
label var repwtp11 `"Person replicate weight 11"'
label var repwtp12 `"Person replicate weight 12"'
label var repwtp13 `"Person replicate weight 13"'
label var repwtp14 `"Person replicate weight 14"'
label var repwtp15 `"Person replicate weight 15"'
label var repwtp16 `"Person replicate weight 16"'
label var repwtp17 `"Person replicate weight 17"'
label var repwtp18 `"Person replicate weight 18"'
label var repwtp19 `"Person replicate weight 19"'
label var repwtp20 `"Person replicate weight 20"'
label var repwtp21 `"Person replicate weight 21"'
label var repwtp22 `"Person replicate weight 22"'
label var repwtp23 `"Person replicate weight 23"'
label var repwtp24 `"Person replicate weight 24"'
label var repwtp25 `"Person replicate weight 25"'
label var repwtp26 `"Person replicate weight 26"'
label var repwtp27 `"Person replicate weight 27"'
label var repwtp28 `"Person replicate weight 28"'
label var repwtp29 `"Person replicate weight 29"'
label var repwtp30 `"Person replicate weight 30"'
label var repwtp31 `"Person replicate weight 31"'
label var repwtp32 `"Person replicate weight 32"'
label var repwtp33 `"Person replicate weight 33"'
label var repwtp34 `"Person replicate weight 34"'
label var repwtp35 `"Person replicate weight 35"'
label var repwtp36 `"Person replicate weight 36"'
label var repwtp37 `"Person replicate weight 37"'
label var repwtp38 `"Person replicate weight 38"'
label var repwtp39 `"Person replicate weight 39"'
label var repwtp40 `"Person replicate weight 40"'
label var repwtp41 `"Person replicate weight 41"'
label var repwtp42 `"Person replicate weight 42"'
label var repwtp43 `"Person replicate weight 43"'
label var repwtp44 `"Person replicate weight 44"'
label var repwtp45 `"Person replicate weight 45"'
label var repwtp46 `"Person replicate weight 46"'
label var repwtp47 `"Person replicate weight 47"'
label var repwtp48 `"Person replicate weight 48"'
label var repwtp49 `"Person replicate weight 49"'
label var repwtp50 `"Person replicate weight 50"'
label var repwtp51 `"Person replicate weight 51"'
label var repwtp52 `"Person replicate weight 52"'
label var repwtp53 `"Person replicate weight 53"'
label var repwtp54 `"Person replicate weight 54"'
label var repwtp55 `"Person replicate weight 55"'
label var repwtp56 `"Person replicate weight 56"'
label var repwtp57 `"Person replicate weight 57"'
label var repwtp58 `"Person replicate weight 58"'
label var repwtp59 `"Person replicate weight 59"'
label var repwtp60 `"Person replicate weight 60"'
label var repwtp61 `"Person replicate weight 61"'
label var repwtp62 `"Person replicate weight 62"'
label var repwtp63 `"Person replicate weight 63"'
label var repwtp64 `"Person replicate weight 64"'
label var repwtp65 `"Person replicate weight 65"'
label var repwtp66 `"Person replicate weight 66"'
label var repwtp67 `"Person replicate weight 67"'
label var repwtp68 `"Person replicate weight 68"'
label var repwtp69 `"Person replicate weight 69"'
label var repwtp70 `"Person replicate weight 70"'
label var repwtp71 `"Person replicate weight 71"'
label var repwtp72 `"Person replicate weight 72"'
label var repwtp73 `"Person replicate weight 73"'
label var repwtp74 `"Person replicate weight 74"'
label var repwtp75 `"Person replicate weight 75"'
label var repwtp76 `"Person replicate weight 76"'
label var repwtp77 `"Person replicate weight 77"'
label var repwtp78 `"Person replicate weight 78"'
label var repwtp79 `"Person replicate weight 79"'
label var repwtp80 `"Person replicate weight 80"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2009 `"2009"', add
label define year_lbl 2010 `"2010"', add
label define year_lbl 2011 `"2011"', add
label define year_lbl 2012 `"2012"', add
label define year_lbl 2013 `"2013"', add
label define year_lbl 2014 `"2014"', add
label define year_lbl 2015 `"2015"', add
label define year_lbl 2016 `"2016"', add
label define year_lbl 2017 `"2017"', add
label define year_lbl 2018 `"2018"', add
label values year year_lbl


