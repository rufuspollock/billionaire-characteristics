**###Chapter 9-Inequality, growth and redistribution##***

 
 

**9.1-Increase in wealth of the five richest people in each economy and increase in GDP***
local year1=2006
use Billionaires1996-2014, clear

generate nobillionaires=1 if realnetworth!=.
egen numbillion=count(networthusbillion), by(countrycode year)
keep if numbillion>=5
sort countrycode year
by countrycode year: egen crank=rank(networthusbillion), field 
keep if crank<6
collapse (mean) gdpcurrentus north deflator1996 (sum)networthusbillion, by(countrycode year)
keep if year==`year1' | year==2012


ren deflator1996 deflator
generate realcountrygdp=(gdpcurrentus/deflator)*100
gen realnetworth=(networthusbillion/deflator)*100

keep realcountrygdp realnetworth country year north
reshape wide realcountrygdp realnetworth , i(country north) j(year)
keep if realcountrygdp`year1'~=.
keep if realcountrygdp2012~=.
keep if north~=.
keep if realnetworth`year1'~=0
keep if realnetworth2012~=0
keep realcountrygdp`year1' realnetworth`year1' realcountrygdp2012 realnetworth2012 north country

generate cwealthgrowth=((realnetworth2012-realnetworth`year1')/realnetworth`year1')*100
generate cgdpgrowth=((realcountrygdp2012-realcountrygdp`year1')/realcountrygdp`year1')*100

collapse (sum) realcountrygdp`year1' realnetworth`year1' realcountrygdp2012 realnetworth2012 (mean) cwealthgrowth cgdpgrowth, by(north)

generate wealthgrowth=((realnetworth2012-realnetworth`year1')/realnetworth`year1')*100
generate gdpgrowth=((realcountrygdp2012-realcountrygdp`year1')/realcountrygdp`year1')*100

 **FIGURE 9.3 Income shares of richest Americans, 1996-2012***

use "Billionaires1996-2014.dta", clear

merge m:1 year countrycode using "saez.dta"
replace gdpcurrentus=gdpcurrentus/1000000000
generate realcountrygdp=(gdpcurrentus/deflator1996)*100
generate percentcountry= (realnetworth/realcountrygdp)*100
bysort countrycode year: egen totalpercentcountry=total(percentcountry) if realbillionaires==1
twoway (line totalpercentcountry year) (line saez1percent year) (line saez01percent year) (line saez001percent year) if countrycode=="USA" & year<2013, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

**Figure 9.4 Cross-country correlation between billionaire density and share of wealth owned by the top one percent***
use "Billionaires1996-2014.dta", clear

gen billionaire=1 if networthusbillion>0
collapse (sum) networthusbillion billionaire (mean)north gdpcurrentus, by(countrycode year)
generate percentcountry= networth*100000000000/gdpcurrentus
merge m:1 countrycode year using "WDIdata.dta"
generate bpermillion= (billionaire*1000000)/pop
drop _m
merge m:1 countrycode year using "LWS.dta"
replace bpermillion=0 if country=="FIN" & bpermillion==.
replace percentcountry =0 if country=="FIN" & percentcountry ==.
generate countrylabel="United States" if countrycode=="USA"
replace countrylabel="Sweden" if countrycode=="SWE"
replace countrylabel="Germany" if countrycode=="DEU"
replace countrylabel="Canada" if countrycode=="CAN"
replace countrylabel="Finland" if countrycode=="FIN"
replace countrylabel="Italy" if countrycode=="ITA"
replace countrylabel="United Kingdom" if countrycode=="GBR"
scatter bpermillion lws if bpermillion<1, mlabel(countrylabel) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))
pwcorr bpermillion lws , obs sig




***Figure 9.5 and 9.6***
use "Billionaires1996-2014.dta", clear

gen billionaire=1 if networthusbillion>0 & networth!=.
collapse (sum) billionaire (mean)north, by(countrycode year)
merge m:1 year countrycode using "saez1.dta"
drop _m
merge m:1 countrycode year using "WDIdata.dta"
keep if saez1percent!=.
generate bpermillion= (billionaire*1000000)/pop
*9.5 Cross-country correlation between billionaire density and share of income earned by the top one percent
scatter bpermillion saez1percent if bpermillion<3

pwcorr bpermillion saez1percent, sig obs
drop if billionaire==.
egen id=group(countrycode)
tsset id year, yearly
gen saezgrow=saez1percent-l.saez1percent
gen billgrow=bpermillion-l.bpermillion
*9.6 Cross-country correlation between change in beillionaire density and change in the share of income earned byt the top one percent*
scatter billgrow saezgrow if billgrow<2 & billgrow>-2 & saezgrow>-3, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

pwcorr billgrow saezgrow, sig obs




***Figure 9.7 Cross-country correlation between billionaire density and income inequality***
use "Billionaires1996-2014.dta", clear

merge m:1 countrycode year using  "allginis_Oct2014.dta"
drop _m
merge m:1 countrycode year using "WDIdata.dta"
replace gdpcurrentus= gdpcurrentus/1000000000
generate gini=Giniall
generate nobillionaires=1 if networth!=.
collapse gini pop gdpcurrentus (sum) nobillionaires networthus, by(countrycode year)
generate billpermillion= (nobillionaires*1000000)/pop
generate billwealthtogdp=(networth/gdp)*100

generate logbillpermil=log( billpermillion)
twoway (scatter logbillpermil gini if year>1995)(lfit logbillpermil gini if year>1995),  title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))


**Figure 9.9 Average size and number as componentents of total net worth**

use "Billionaires1996-2014.dta", clear
drop if networth==. 
drop if year>2014

bysort year north: egen nstotal=total(realnetworth)
bysort year north: egen nsmean=mean(realnetworth) 
bysort year north: egen nsnumber=count(realnetworth)



generate lntotal=log(nstotal)
generate lnmean=log(nsmean)
generate lnnumber=log(nsnumber)


collapse lntotal lnmean lnnumber, by(north year)



*All billionaires, 1996 USD*
foreach n of num 0/1{
regress  lnmean lntotal if north==`n' & (year==1996 | year>2000)
outreg2 using "Figure9.10.xls" , excel dec(3) br 
regress lnnumber lntotal if north==`n' & (year==1996 | year>2000)
outreg2 using "Figure9.10.xls" , excel dec(3) br
}

