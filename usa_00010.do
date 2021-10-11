* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix                   ///
  int     year       1-4        ///
  long    sample     5-10       ///
  double  serial     11-18      ///
  double  cbserial   19-31      ///
  double  hhwt       32-41      ///
  byte    repwt      42-42      ///
  double  cluster    43-55      ///
  double  adjust     56-62      ///
  byte    statefip   63-64      ///
  int     countyfip  65-67      ///
  double  strata     68-79      ///
  byte    gq         80-80      ///
  long    hhincome   81-87      ///
  long    repwt1     88-93      ///
  long    repwt2     94-99      ///
  long    repwt3     100-105    ///
  long    repwt4     106-111    ///
  long    repwt5     112-117    ///
  long    repwt6     118-123    ///
  long    repwt7     124-129    ///
  long    repwt8     130-135    ///
  long    repwt9     136-141    ///
  long    repwt10    142-147    ///
  long    repwt11    148-153    ///
  long    repwt12    154-159    ///
  long    repwt13    160-165    ///
  long    repwt14    166-171    ///
  long    repwt15    172-177    ///
  long    repwt16    178-183    ///
  long    repwt17    184-189    ///
  long    repwt18    190-195    ///
  long    repwt19    196-201    ///
  long    repwt20    202-207    ///
  long    repwt21    208-213    ///
  long    repwt22    214-219    ///
  long    repwt23    220-225    ///
  long    repwt24    226-231    ///
  long    repwt25    232-237    ///
  long    repwt26    238-243    ///
  long    repwt27    244-249    ///
  long    repwt28    250-255    ///
  long    repwt29    256-261    ///
  long    repwt30    262-267    ///
  long    repwt31    268-273    ///
  long    repwt32    274-279    ///
  long    repwt33    280-285    ///
  long    repwt34    286-291    ///
  long    repwt35    292-297    ///
  long    repwt36    298-303    ///
  long    repwt37    304-309    ///
  long    repwt38    310-315    ///
  long    repwt39    316-321    ///
  long    repwt40    322-327    ///
  long    repwt41    328-333    ///
  long    repwt42    334-339    ///
  long    repwt43    340-345    ///
  long    repwt44    346-351    ///
  long    repwt45    352-357    ///
  long    repwt46    358-363    ///
  long    repwt47    364-369    ///
  long    repwt48    370-375    ///
  long    repwt49    376-381    ///
  long    repwt50    382-387    ///
  long    repwt51    388-393    ///
  long    repwt52    394-399    ///
  long    repwt53    400-405    ///
  long    repwt54    406-411    ///
  long    repwt55    412-417    ///
  long    repwt56    418-423    ///
  long    repwt57    424-429    ///
  long    repwt58    430-435    ///
  long    repwt59    436-441    ///
  long    repwt60    442-447    ///
  long    repwt61    448-453    ///
  long    repwt62    454-459    ///
  long    repwt63    460-465    ///
  long    repwt64    466-471    ///
  long    repwt65    472-477    ///
  long    repwt66    478-483    ///
  long    repwt67    484-489    ///
  long    repwt68    490-495    ///
  long    repwt69    496-501    ///
  long    repwt70    502-507    ///
  long    repwt71    508-513    ///
  long    repwt72    514-519    ///
  long    repwt73    520-525    ///
  long    repwt74    526-531    ///
  long    repwt75    532-537    ///
  long    repwt76    538-543    ///
  long    repwt77    544-549    ///
  long    repwt78    550-555    ///
  long    repwt79    556-561    ///
  long    repwt80    562-567    ///
  int     pernum     568-571    ///
  double  perwt      572-581    ///
  byte    repwtp     582-582    ///
  long    repwtp1    583-588    ///
  long    repwtp2    589-594    ///
  long    repwtp3    595-600    ///
  long    repwtp4    601-606    ///
  long    repwtp5    607-612    ///
  long    repwtp6    613-618    ///
  long    repwtp7    619-624    ///
  long    repwtp8    625-630    ///
  long    repwtp9    631-636    ///
  long    repwtp10   637-642    ///
  long    repwtp11   643-648    ///
  long    repwtp12   649-654    ///
  long    repwtp13   655-660    ///
  long    repwtp14   661-666    ///
  long    repwtp15   667-672    ///
  long    repwtp16   673-678    ///
  long    repwtp17   679-684    ///
  long    repwtp18   685-690    ///
  long    repwtp19   691-696    ///
  long    repwtp20   697-702    ///
  long    repwtp21   703-708    ///
  long    repwtp22   709-714    ///
  long    repwtp23   715-720    ///
  long    repwtp24   721-726    ///
  long    repwtp25   727-732    ///
  long    repwtp26   733-738    ///
  long    repwtp27   739-744    ///
  long    repwtp28   745-750    ///
  long    repwtp29   751-756    ///
  long    repwtp30   757-762    ///
  long    repwtp31   763-768    ///
  long    repwtp32   769-774    ///
  long    repwtp33   775-780    ///
  long    repwtp34   781-786    ///
  long    repwtp35   787-792    ///
  long    repwtp36   793-798    ///
  long    repwtp37   799-804    ///
  long    repwtp38   805-810    ///
  long    repwtp39   811-816    ///
  long    repwtp40   817-822    ///
  long    repwtp41   823-828    ///
  long    repwtp42   829-834    ///
  long    repwtp43   835-840    ///
  long    repwtp44   841-846    ///
  long    repwtp45   847-852    ///
  long    repwtp46   853-858    ///
  long    repwtp47   859-864    ///
  long    repwtp48   865-870    ///
  long    repwtp49   871-876    ///
  long    repwtp50   877-882    ///
  long    repwtp51   883-888    ///
  long    repwtp52   889-894    ///
  long    repwtp53   895-900    ///
  long    repwtp54   901-906    ///
  long    repwtp55   907-912    ///
  long    repwtp56   913-918    ///
  long    repwtp57   919-924    ///
  long    repwtp58   925-930    ///
  long    repwtp59   931-936    ///
  long    repwtp60   937-942    ///
  long    repwtp61   943-948    ///
  long    repwtp62   949-954    ///
  long    repwtp63   955-960    ///
  long    repwtp64   961-966    ///
  long    repwtp65   967-972    ///
  long    repwtp66   973-978    ///
  long    repwtp67   979-984    ///
  long    repwtp68   985-990    ///
  long    repwtp69   991-996    ///
  long    repwtp70   997-1002   ///
  long    repwtp71   1003-1008  ///
  long    repwtp72   1009-1014  ///
  long    repwtp73   1015-1020  ///
  long    repwtp74   1021-1026  ///
  long    repwtp75   1027-1032  ///
  long    repwtp76   1033-1038  ///
  long    repwtp77   1039-1044  ///
  long    repwtp78   1045-1050  ///
  long    repwtp79   1051-1056  ///
  long    repwtp80   1057-1062  ///
  using `"usa_00010.dat"'

replace hhwt      = hhwt      / 100
replace adjust    = adjust    / 1000000
replace perwt     = perwt     / 100

format serial    %8.0f
format cbserial  %13.0f
format hhwt      %10.2f
format cluster   %13.0f
format adjust    %7.6f
format strata    %12.0f
format perwt     %10.2f

label var year      `"Census year"'
label var sample    `"IPUMS sample identifier"'
label var serial    `"Household serial number"'
label var cbserial  `"Original Census Bureau household serial number"'
label var hhwt      `"Household weight"'
label var repwt     `"Household replicate weights [80 variables]"'
label var cluster   `"Household cluster for variance estimation"'
label var adjust    `"Adjustment factor, ACS/PRCS"'
label var statefip  `"State (FIPS code)"'
label var countyfip `"County (FIPS code)"'
label var strata    `"Household strata for variance estimation"'
label var gq        `"Group quarters status"'
label var hhincome  `"Total household income "'
label var repwt1    `"Household replicate weight 1"'
label var repwt2    `"Household replicate weight 2"'
label var repwt3    `"Household replicate weight 3"'
label var repwt4    `"Household replicate weight 4"'
label var repwt5    `"Household replicate weight 5"'
label var repwt6    `"Household replicate weight 6"'
label var repwt7    `"Household replicate weight 7"'
label var repwt8    `"Household replicate weight 8"'
label var repwt9    `"Household replicate weight 9"'
label var repwt10   `"Household replicate weight 10"'
label var repwt11   `"Household replicate weight 11"'
label var repwt12   `"Household replicate weight 12"'
label var repwt13   `"Household replicate weight 13"'
label var repwt14   `"Household replicate weight 14"'
label var repwt15   `"Household replicate weight 15"'
label var repwt16   `"Household replicate weight 16"'
label var repwt17   `"Household replicate weight 17"'
label var repwt18   `"Household replicate weight 18"'
label var repwt19   `"Household replicate weight 19"'
label var repwt20   `"Household replicate weight 20"'
label var repwt21   `"Household replicate weight 21"'
label var repwt22   `"Household replicate weight 22"'
label var repwt23   `"Household replicate weight 23"'
label var repwt24   `"Household replicate weight 24"'
label var repwt25   `"Household replicate weight 25"'
label var repwt26   `"Household replicate weight 26"'
label var repwt27   `"Household replicate weight 27"'
label var repwt28   `"Household replicate weight 28"'
label var repwt29   `"Household replicate weight 29"'
label var repwt30   `"Household replicate weight 30"'
label var repwt31   `"Household replicate weight 31"'
label var repwt32   `"Household replicate weight 32"'
label var repwt33   `"Household replicate weight 33"'
label var repwt34   `"Household replicate weight 34"'
label var repwt35   `"Household replicate weight 35"'
label var repwt36   `"Household replicate weight 36"'
label var repwt37   `"Household replicate weight 37"'
label var repwt38   `"Household replicate weight 38"'
label var repwt39   `"Household replicate weight 39"'
label var repwt40   `"Household replicate weight 40"'
label var repwt41   `"Household replicate weight 41"'
label var repwt42   `"Household replicate weight 42"'
label var repwt43   `"Household replicate weight 43"'
label var repwt44   `"Household replicate weight 44"'
label var repwt45   `"Household replicate weight 45"'
label var repwt46   `"Household replicate weight 46"'
label var repwt47   `"Household replicate weight 47"'
label var repwt48   `"Household replicate weight 48"'
label var repwt49   `"Household replicate weight 49"'
label var repwt50   `"Household replicate weight 50"'
label var repwt51   `"Household replicate weight 51"'
label var repwt52   `"Household replicate weight 52"'
label var repwt53   `"Household replicate weight 53"'
label var repwt54   `"Household replicate weight 54"'
label var repwt55   `"Household replicate weight 55"'
label var repwt56   `"Household replicate weight 56"'
label var repwt57   `"Household replicate weight 57"'
label var repwt58   `"Household replicate weight 58"'
label var repwt59   `"Household replicate weight 59"'
label var repwt60   `"Household replicate weight 60"'
label var repwt61   `"Household replicate weight 61"'
label var repwt62   `"Household replicate weight 62"'
label var repwt63   `"Household replicate weight 63"'
label var repwt64   `"Household replicate weight 64"'
label var repwt65   `"Household replicate weight 65"'
label var repwt66   `"Household replicate weight 66"'
label var repwt67   `"Household replicate weight 67"'
label var repwt68   `"Household replicate weight 68"'
label var repwt69   `"Household replicate weight 69"'
label var repwt70   `"Household replicate weight 70"'
label var repwt71   `"Household replicate weight 71"'
label var repwt72   `"Household replicate weight 72"'
label var repwt73   `"Household replicate weight 73"'
label var repwt74   `"Household replicate weight 74"'
label var repwt75   `"Household replicate weight 75"'
label var repwt76   `"Household replicate weight 76"'
label var repwt77   `"Household replicate weight 77"'
label var repwt78   `"Household replicate weight 78"'
label var repwt79   `"Household replicate weight 79"'
label var repwt80   `"Household replicate weight 80"'
label var pernum    `"Person number in sample unit"'
label var perwt     `"Person weight"'
label var repwtp    `"Person replicate weights [80 variables]"'
label var repwtp1   `"Person replicate weight 1"'
label var repwtp2   `"Person replicate weight 2"'
label var repwtp3   `"Person replicate weight 3"'
label var repwtp4   `"Person replicate weight 4"'
label var repwtp5   `"Person replicate weight 5"'
label var repwtp6   `"Person replicate weight 6"'
label var repwtp7   `"Person replicate weight 7"'
label var repwtp8   `"Person replicate weight 8"'
label var repwtp9   `"Person replicate weight 9"'
label var repwtp10  `"Person replicate weight 10"'
label var repwtp11  `"Person replicate weight 11"'
label var repwtp12  `"Person replicate weight 12"'
label var repwtp13  `"Person replicate weight 13"'
label var repwtp14  `"Person replicate weight 14"'
label var repwtp15  `"Person replicate weight 15"'
label var repwtp16  `"Person replicate weight 16"'
label var repwtp17  `"Person replicate weight 17"'
label var repwtp18  `"Person replicate weight 18"'
label var repwtp19  `"Person replicate weight 19"'
label var repwtp20  `"Person replicate weight 20"'
label var repwtp21  `"Person replicate weight 21"'
label var repwtp22  `"Person replicate weight 22"'
label var repwtp23  `"Person replicate weight 23"'
label var repwtp24  `"Person replicate weight 24"'
label var repwtp25  `"Person replicate weight 25"'
label var repwtp26  `"Person replicate weight 26"'
label var repwtp27  `"Person replicate weight 27"'
label var repwtp28  `"Person replicate weight 28"'
label var repwtp29  `"Person replicate weight 29"'
label var repwtp30  `"Person replicate weight 30"'
label var repwtp31  `"Person replicate weight 31"'
label var repwtp32  `"Person replicate weight 32"'
label var repwtp33  `"Person replicate weight 33"'
label var repwtp34  `"Person replicate weight 34"'
label var repwtp35  `"Person replicate weight 35"'
label var repwtp36  `"Person replicate weight 36"'
label var repwtp37  `"Person replicate weight 37"'
label var repwtp38  `"Person replicate weight 38"'
label var repwtp39  `"Person replicate weight 39"'
label var repwtp40  `"Person replicate weight 40"'
label var repwtp41  `"Person replicate weight 41"'
label var repwtp42  `"Person replicate weight 42"'
label var repwtp43  `"Person replicate weight 43"'
label var repwtp44  `"Person replicate weight 44"'
label var repwtp45  `"Person replicate weight 45"'
label var repwtp46  `"Person replicate weight 46"'
label var repwtp47  `"Person replicate weight 47"'
label var repwtp48  `"Person replicate weight 48"'
label var repwtp49  `"Person replicate weight 49"'
label var repwtp50  `"Person replicate weight 50"'
label var repwtp51  `"Person replicate weight 51"'
label var repwtp52  `"Person replicate weight 52"'
label var repwtp53  `"Person replicate weight 53"'
label var repwtp54  `"Person replicate weight 54"'
label var repwtp55  `"Person replicate weight 55"'
label var repwtp56  `"Person replicate weight 56"'
label var repwtp57  `"Person replicate weight 57"'
label var repwtp58  `"Person replicate weight 58"'
label var repwtp59  `"Person replicate weight 59"'
label var repwtp60  `"Person replicate weight 60"'
label var repwtp61  `"Person replicate weight 61"'
label var repwtp62  `"Person replicate weight 62"'
label var repwtp63  `"Person replicate weight 63"'
label var repwtp64  `"Person replicate weight 64"'
label var repwtp65  `"Person replicate weight 65"'
label var repwtp66  `"Person replicate weight 66"'
label var repwtp67  `"Person replicate weight 67"'
label var repwtp68  `"Person replicate weight 68"'
label var repwtp69  `"Person replicate weight 69"'
label var repwtp70  `"Person replicate weight 70"'
label var repwtp71  `"Person replicate weight 71"'
label var repwtp72  `"Person replicate weight 72"'
label var repwtp73  `"Person replicate weight 73"'
label var repwtp74  `"Person replicate weight 74"'
label var repwtp75  `"Person replicate weight 75"'
label var repwtp76  `"Person replicate weight 76"'
label var repwtp77  `"Person replicate weight 77"'
label var repwtp78  `"Person replicate weight 78"'
label var repwtp79  `"Person replicate weight 79"'
label var repwtp80  `"Person replicate weight 80"'

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
label define year_lbl 2019 `"2019"', add
label values year year_lbl

label define sample_lbl 201904 `"2015-2019, PRCS 5-year"'
label define sample_lbl 201903 `"2015-2019, ACS 5-year"', add
label define sample_lbl 201902 `"2019 PRCS"', add
label define sample_lbl 201901 `"2019 ACS"', add
label define sample_lbl 201804 `"2014-2018, PRCS 5-year"', add
label define sample_lbl 201803 `"2014-2018, ACS 5-year"', add
label define sample_lbl 201802 `"2018 PRCS"', add
label define sample_lbl 201801 `"2018 ACS"', add
label define sample_lbl 201704 `"2013-2017, PRCS 5-year"', add
label define sample_lbl 201703 `"2013-2017, ACS 5-year"', add
label define sample_lbl 201702 `"2017 PRCS"', add
label define sample_lbl 201701 `"2017 ACS"', add
label define sample_lbl 201604 `"2012-2016, PRCS 5-year"', add
label define sample_lbl 201603 `"2012-2016, ACS 5-year"', add
label define sample_lbl 201602 `"2016 PRCS"', add
label define sample_lbl 201601 `"2016 ACS"', add
label define sample_lbl 201504 `"2011-2015, PRCS 5-year"', add
label define sample_lbl 201503 `"2011-2015, ACS 5-year"', add
label define sample_lbl 201502 `"2015 PRCS"', add
label define sample_lbl 201501 `"2015 ACS"', add
label define sample_lbl 201404 `"2010-2014, PRCS 5-year"', add
label define sample_lbl 201403 `"2010-2014, ACS 5-year"', add
label define sample_lbl 201402 `"2014 PRCS"', add
label define sample_lbl 201401 `"2014 ACS"', add
label define sample_lbl 201306 `"2009-2013, PRCS 5-year"', add
label define sample_lbl 201305 `"2009-2013, ACS 5-year"', add
label define sample_lbl 201304 `"2011-2013, PRCS 3-year"', add
label define sample_lbl 201303 `"2011-2013, ACS 3-year"', add
label define sample_lbl 201302 `"2013 PRCS"', add
label define sample_lbl 201301 `"2013 ACS"', add
label define sample_lbl 201206 `"2008-2012, PRCS 5-year"', add
label define sample_lbl 201205 `"2008-2012, ACS 5-year"', add
label define sample_lbl 201204 `"2010-2012, PRCS 3-year"', add
label define sample_lbl 201203 `"2010-2012, ACS 3-year"', add
label define sample_lbl 201202 `"2012 PRCS"', add
label define sample_lbl 201201 `"2012 ACS"', add
label define sample_lbl 201106 `"2007-2011, PRCS 5-year"', add
label define sample_lbl 201105 `"2007-2011, ACS 5-year"', add
label define sample_lbl 201104 `"2009-2011, PRCS 3-year"', add
label define sample_lbl 201103 `"2009-2011, ACS 3-year"', add
label define sample_lbl 201102 `"2011 PRCS"', add
label define sample_lbl 201101 `"2011 ACS"', add
label define sample_lbl 201008 `"2010 Puerto Rico 10%"', add
label define sample_lbl 201007 `"2010 10%"', add
label define sample_lbl 201006 `"2006-2010, PRCS 5-year"', add
label define sample_lbl 201005 `"2006-2010, ACS 5-year"', add
label define sample_lbl 201004 `"2008-2010, PRCS 3-year"', add
label define sample_lbl 201003 `"2008-2010, ACS 3-year"', add
label define sample_lbl 201002 `"2010 PRCS"', add
label define sample_lbl 201001 `"2010 ACS"', add
label define sample_lbl 200906 `"2005-2009, PRCS 5-year"', add
label define sample_lbl 200905 `"2005-2009, ACS 5-year"', add
label define sample_lbl 200904 `"2007-2009, PRCS 3-year"', add
label define sample_lbl 200903 `"2007-2009, ACS 3-year"', add
label define sample_lbl 200902 `"2009 PRCS"', add
label define sample_lbl 200901 `"2009 ACS"', add
label define sample_lbl 200804 `"2006-2008, PRCS 3-year"', add
label define sample_lbl 200803 `"2006-2008, ACS 3-year"', add
label define sample_lbl 200802 `"2008 PRCS"', add
label define sample_lbl 200801 `"2008 ACS"', add
label define sample_lbl 200704 `"2005-2007, PRCS 3-year"', add
label define sample_lbl 200703 `"2005-2007, ACS 3-year"', add
label define sample_lbl 200702 `"2007 PRCS"', add
label define sample_lbl 200701 `"2007 ACS"', add
label define sample_lbl 200602 `"2006 PRCS"', add
label define sample_lbl 200601 `"2006 ACS"', add
label define sample_lbl 200502 `"2005 PRCS"', add
label define sample_lbl 200501 `"2005 ACS"', add
label define sample_lbl 200401 `"2004 ACS"', add
label define sample_lbl 200301 `"2003 ACS"', add
label define sample_lbl 200201 `"2002 ACS"', add
label define sample_lbl 200101 `"2001 ACS"', add
label define sample_lbl 200008 `"2000 Puerto Rico 1%"', add
label define sample_lbl 200007 `"2000 1%"', add
label define sample_lbl 200006 `"2000 Puerto Rico 1% sample (old version)"', add
label define sample_lbl 200005 `"2000 Puerto Rico 5%"', add
label define sample_lbl 200004 `"2000 ACS"', add
label define sample_lbl 200003 `"2000 Unweighted 1%"', add
label define sample_lbl 200002 `"2000 1% sample (old version)"', add
label define sample_lbl 200001 `"2000 5%"', add
label define sample_lbl 199007 `"1990 Puerto Rico 1%"', add
label define sample_lbl 199006 `"1990 Puerto Rico 5%"', add
label define sample_lbl 199005 `"1990 Labor Market Area"', add
label define sample_lbl 199004 `"1990 Elderly"', add
label define sample_lbl 199003 `"1990 Unweighted 1%"', add
label define sample_lbl 199002 `"1990 1%"', add
label define sample_lbl 199001 `"1990 5%"', add
label define sample_lbl 198007 `"1980 Puerto Rico 1%"', add
label define sample_lbl 198006 `"1980 Puerto Rico 5%"', add
label define sample_lbl 198005 `"1980 Detailed metro/non-metro"', add
label define sample_lbl 198004 `"1980 Labor Market Area"', add
label define sample_lbl 198003 `"1980 Urban/Rural"', add
label define sample_lbl 198002 `"1980 1%"', add
label define sample_lbl 198001 `"1980 5%"', add
label define sample_lbl 197009 `"1970 Puerto Rico Neighborhood"', add
label define sample_lbl 197008 `"1970 Puerto Rico Municipio"', add
label define sample_lbl 197007 `"1970 Puerto Rico State"', add
label define sample_lbl 197006 `"1970 Form 2 Neighborhood"', add
label define sample_lbl 197005 `"1970 Form 1 Neighborhood"', add
label define sample_lbl 197004 `"1970 Form 2 Metro"', add
label define sample_lbl 197003 `"1970 Form 1 Metro"', add
label define sample_lbl 197002 `"1970 Form 2 State"', add
label define sample_lbl 197001 `"1970 Form 1 State"', add
label define sample_lbl 196002 `"1960 5%"', add
label define sample_lbl 196001 `"1960 1%"', add
label define sample_lbl 195001 `"1950 1%"', add
label define sample_lbl 194002 `"1940 100% database"', add
label define sample_lbl 194001 `"1940 1%"', add
label define sample_lbl 193004 `"1930 100% database"', add
label define sample_lbl 193003 `"1930 Puerto Rico"', add
label define sample_lbl 193002 `"1930 5%"', add
label define sample_lbl 193001 `"1930 1%"', add
label define sample_lbl 192003 `"1920 100% database"', add
label define sample_lbl 192002 `"1920 Puerto Rico sample"', add
label define sample_lbl 192001 `"1920 1%"', add
label define sample_lbl 191004 `"1910 100% database"', add
label define sample_lbl 191003 `"1910 1.4% sample with oversamples"', add
label define sample_lbl 191002 `"1910 1%"', add
label define sample_lbl 191001 `"1910 Puerto Rico"', add
label define sample_lbl 190004 `"1900 100% database"', add
label define sample_lbl 190003 `"1900 1% sample with oversamples"', add
label define sample_lbl 190002 `"1900 1%"', add
label define sample_lbl 190001 `"1900 5%"', add
label define sample_lbl 188003 `"1880 100% database"', add
label define sample_lbl 188002 `"1880 10%"', add
label define sample_lbl 188001 `"1880 1%"', add
label define sample_lbl 187003 `"1870 100% database"', add
label define sample_lbl 187002 `"1870 1% sample with black oversample"', add
label define sample_lbl 187001 `"1870 1%"', add
label define sample_lbl 186003 `"1860 100% database"', add
label define sample_lbl 186002 `"1860 1% sample with black oversample"', add
label define sample_lbl 186001 `"1860 1%"', add
label define sample_lbl 185002 `"1850 100% database"', add
label define sample_lbl 185001 `"1850 1%"', add
label values sample sample_lbl

label define repwt_lbl 0 `"Repwt not available"'
label define repwt_lbl 1 `"Repwt available"', add
label values repwt repwt_lbl

label define statefip_lbl 01 `"Alabama"'
label define statefip_lbl 02 `"Alaska"', add
label define statefip_lbl 04 `"Arizona"', add
label define statefip_lbl 05 `"Arkansas"', add
label define statefip_lbl 06 `"California"', add
label define statefip_lbl 08 `"Colorado"', add
label define statefip_lbl 09 `"Connecticut"', add
label define statefip_lbl 10 `"Delaware"', add
label define statefip_lbl 11 `"District of Columbia"', add
label define statefip_lbl 12 `"Florida"', add
label define statefip_lbl 13 `"Georgia"', add
label define statefip_lbl 15 `"Hawaii"', add
label define statefip_lbl 16 `"Idaho"', add
label define statefip_lbl 17 `"Illinois"', add
label define statefip_lbl 18 `"Indiana"', add
label define statefip_lbl 19 `"Iowa"', add
label define statefip_lbl 20 `"Kansas"', add
label define statefip_lbl 21 `"Kentucky"', add
label define statefip_lbl 22 `"Louisiana"', add
label define statefip_lbl 23 `"Maine"', add
label define statefip_lbl 24 `"Maryland"', add
label define statefip_lbl 25 `"Massachusetts"', add
label define statefip_lbl 26 `"Michigan"', add
label define statefip_lbl 27 `"Minnesota"', add
label define statefip_lbl 28 `"Mississippi"', add
label define statefip_lbl 29 `"Missouri"', add
label define statefip_lbl 30 `"Montana"', add
label define statefip_lbl 31 `"Nebraska"', add
label define statefip_lbl 32 `"Nevada"', add
label define statefip_lbl 33 `"New Hampshire"', add
label define statefip_lbl 34 `"New Jersey"', add
label define statefip_lbl 35 `"New Mexico"', add
label define statefip_lbl 36 `"New York"', add
label define statefip_lbl 37 `"North Carolina"', add
label define statefip_lbl 38 `"North Dakota"', add
label define statefip_lbl 39 `"Ohio"', add
label define statefip_lbl 40 `"Oklahoma"', add
label define statefip_lbl 41 `"Oregon"', add
label define statefip_lbl 42 `"Pennsylvania"', add
label define statefip_lbl 44 `"Rhode Island"', add
label define statefip_lbl 45 `"South Carolina"', add
label define statefip_lbl 46 `"South Dakota"', add
label define statefip_lbl 47 `"Tennessee"', add
label define statefip_lbl 48 `"Texas"', add
label define statefip_lbl 49 `"Utah"', add
label define statefip_lbl 50 `"Vermont"', add
label define statefip_lbl 51 `"Virginia"', add
label define statefip_lbl 53 `"Washington"', add
label define statefip_lbl 54 `"West Virginia"', add
label define statefip_lbl 55 `"Wisconsin"', add
label define statefip_lbl 56 `"Wyoming"', add
label define statefip_lbl 61 `"Maine-New Hampshire-Vermont"', add
label define statefip_lbl 62 `"Massachusetts-Rhode Island"', add
label define statefip_lbl 63 `"Minnesota-Iowa-Missouri-Kansas-Nebraska-S.Dakota-N.Dakota"', add
label define statefip_lbl 64 `"Maryland-Delaware"', add
label define statefip_lbl 65 `"Montana-Idaho-Wyoming"', add
label define statefip_lbl 66 `"Utah-Nevada"', add
label define statefip_lbl 67 `"Arizona-New Mexico"', add
label define statefip_lbl 68 `"Alaska-Hawaii"', add
label define statefip_lbl 72 `"Puerto Rico"', add
label define statefip_lbl 97 `"Military/Mil. Reservation"', add
label define statefip_lbl 99 `"State not identified"', add
label values statefip statefip_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define repwtp_lbl 0 `"Repwtp not available"'
label define repwtp_lbl 1 `"Repwtp available"', add
label values repwtp repwtp_lbl


