********************************************************************************
****   Project: IRS Cleaning 
****   Date: Mar 2020
****   Producer: Wooserk Park
****   Steps: 1. Append Data (51 States)
****   
****   Note: Download Data from: https://www.irs.gov/statistics/soi-tax-stats-migration-data-2017-2018       
********************************************************************************

ssc install fs
global data = "C:\Users\User\Documents\GitHub\IRS-Migration\02_data"

********************************************************************************
** 1. Appending Data **
********************************************************************************

******************* 1.1. State Outflow ****************************
cd "$data\download"

foreach y in ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma ///
		md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut ///
		va vt wa wi wv wy {

	import excel "1718`y'.xls", sheet("State Outflow") allstring cellrange(A11:G62) clear
	rename (A B C D E F G) (StateCode_origin StateCode_destination State_destination StateName_destination returns_number exemptions_number gross_income)
	gen StateCode_abbr = upper("`y'")
	order StateCode_abbr
save "$data\state_outflow\1718`y'.dta", replace
}

use "$data\state_outflow\1718dc.dta"
drop in 52
save "$data\state_outflow\1718dc.dta", replace
** DC data had 61 rows so I dropped line 52 **

clear
cd "$data\state_outflow\"
fs 1718*.dta
append using `r(files)', force
save "$data\append\1718_state_outflow.dta", replace

tab StateCode_origin

******************* 1.2. State Inflow ****************************
clear
cd "$data\download"

foreach y in ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma ///
md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut ///
va vt wa wi wv wy {

import excel "$data\download\1718`y'.xls", sheet("State Inflow") allstring cellrange(A11:G62) clear
rename (A B C D E F G) (StateCode_destination StateCode_origin State_origin StateName_origin returns_number exemptions_number gross_income)
gen StateCode_abbr = upper("`y'")
order StateCode_abbr
save "$data\state_inflow\1718`y'.dta", replace
}

use "$data\state_inflow\1718dc.dta"
drop in 52
save "$data\state_inflow\1718dc.dta", replace
** DC data had 61 rows so I dropped line 52 **

clear
cd "$data\state_inflow\"
fs 1718*.dta
append using `r(files)', force
save "$data\append\1718_state_inflow.dta", replace

tab StateCode_destination

******************* 1.3. County Outflow *********************************
clear
cd "$data\download"

foreach y in ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma ///
md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut ///
va vt wa wi wv wy {

import excel "$data\download\1718`y'.xls", sheet("County Inflow") allstring cellrange(A7) clear
rename (A B C D E F G H I) (StateCode_origin CountyCode_origin StateCode_destination CountyCode_destination StateName_destination CountyName_destination returns_number exemptions_number gross_income)
save "$data\county_outflow\1718`y'.dta", replace
}

clear
cd "$data\county_outflow\"
fs 1718*.dta
append using `r(files)', force
save "$data\append\1718_county_outflow.dta", replace

tab StateCode_origin
drop J K
drop if StateCode_origin != "1" & StateCode_origin != "10" & StateCode_origin != "11" ///
& StateCode_origin != "12" & StateCode_origin != "13" & StateCode_origin != "15" ///
& StateCode_origin != "16" & StateCode_origin != "17" & StateCode_origin != "18" ///
& StateCode_origin != "19" & StateCode_origin != "2" & StateCode_origin != "20" ///
& StateCode_origin != "21" & StateCode_origin != "22" & StateCode_origin != "23" ///
& StateCode_origin != "24" & StateCode_origin != "25" & StateCode_origin != "26" ///
& StateCode_origin != "27" & StateCode_origin != "28" & StateCode_origin != "29" ///
& StateCode_origin != "30" & StateCode_origin != "31" & StateCode_origin != "32" ///
& StateCode_origin != "33" & StateCode_origin != "34" & StateCode_origin != "35" ///
& StateCode_origin != "36" & StateCode_origin != "37" & StateCode_origin != "38" ///
& StateCode_origin != "39" & StateCode_origin != "4" & StateCode_origin != "40" ///
& StateCode_origin != "41" & StateCode_origin != "42" & StateCode_origin != "44" ///
& StateCode_origin != "45" & StateCode_origin != "46" & StateCode_origin != "47" ///
& StateCode_origin != "48" & StateCode_origin != "49" & StateCode_origin != "5" ///
& StateCode_origin != "50" & StateCode_origin != "51" & StateCode_origin != "53" ///
& StateCode_origin != "54" & StateCode_origin != "55" & StateCode_origin != "56" ///
& StateCode_origin != "6" & StateCode_origin != "8" & StateCode_origin != "9"
tab StateCode_origin

save "$data\append\1718_county_outflow.dta", replace

******************* 1.4. County Inflow *********************************
clear
cd "$data\download"

foreach y in ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma ///
md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut ///
va vt wa wi wv wy {

import excel "$data\download\1718`y'.xls", sheet("County Inflow") allstring cellrange(A7) clear
rename (A B C D E F G H I) (StateCode_destination CountyCode_destination StateCode_origin CountyCode_origin StateName_origin CountyName_origin returns_number exemptions_number gross_income)
save "$data\county_inflow\1718`y'.dta", replace
}

clear
cd "$data\county_inflow\"
fs 1718*.dta
append using `r(files)', force
save "$data\append\1718_county_inflow.dta", replace

tab StateCode_destination
drop J K
drop if StateCode_destination != "1" & StateCode_destination != "10" & StateCode_destination != "11" ///
& StateCode_destination != "12" & StateCode_destination != "13" & StateCode_destination != "15" ///
& StateCode_destination != "16" & StateCode_destination != "17" & StateCode_destination != "18" ///
& StateCode_destination != "19" & StateCode_destination != "2" & StateCode_destination != "20" ///
& StateCode_destination != "21" & StateCode_destination != "22" & StateCode_destination != "23" ///
& StateCode_destination != "24" & StateCode_destination != "25" & StateCode_destination != "26" ///
& StateCode_destination != "27" & StateCode_destination != "28" & StateCode_destination != "29" ///
& StateCode_destination != "30" & StateCode_destination != "31" & StateCode_destination != "32" ///
& StateCode_destination != "33" & StateCode_destination != "34" & StateCode_destination != "35" ///
& StateCode_destination != "36" & StateCode_destination != "37" & StateCode_destination != "38" ///
& StateCode_destination != "39" & StateCode_destination != "4" & StateCode_destination != "40" ///
& StateCode_destination != "41" & StateCode_destination != "42" & StateCode_destination != "44" ///
& StateCode_destination != "45" & StateCode_destination != "46" & StateCode_destination != "47" ///
& StateCode_destination != "48" & StateCode_destination != "49" & StateCode_destination != "5" ///
& StateCode_destination != "50" & StateCode_destination != "51" & StateCode_destination != "53" ///
& StateCode_destination != "54" & StateCode_destination != "55" & StateCode_destination != "56" ///
& StateCode_destination != "6" & StateCode_destination != "8" & StateCode_destination != "9"
tab StateCode_destination

save "$data\append\1718_county_inflow.dta", replace

********************************************************************************
****    2. Exporting Cleaned Data to Excel
******************************************************************************** 
** State Outflow **
use "$data\append\1718_state_outflow.dta", clear
 
tab StateName_destination 
drop StateCode_origin StateCode_destination exemptions_number gross_income StateName_destination
sort StateCode_abbr State_destination
export excel using "$data\append\State_outflow.xlsx", firstrow(variables) replace

** State Inflow **
use "$data\append\1718_state_inflow.dta", clear
 
tab StateName_origin
drop StateCode_destination StateCode_origin exemptions_number gross_income StateName_origin
sort StateCode_abbr State_origin
export excel using "$data\append\State_inflow.xlsx", firstrow(variables) replace


*********
** END **
*********
