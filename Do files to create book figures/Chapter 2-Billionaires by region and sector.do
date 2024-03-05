**Chapter 2-By region and sector***


use Billionaires1996-2014.dta, clear

bysort year: egen totalrnw=sum(realnetworth) if realbillionaires==1
bysort year north: egen nstotalrnw=sum(realnetworth) if realbillionaires==1

*FIGURE 2.1 Total real net worth of billionaires in advanced economies and emerging markets***

twoway (line totalrnw year)(line nstotalrnw year if north==1)(line nstotalrnw year if north==0), title(, size(medium) color(black) justification(left)) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))


**FIGURE 2.2 total real net worth of billionaires by region**

bysort year region north: egen regionrnw=sum(realnetworth) 
twoway (line regionrnw year if region==1)(line regionrnw year if region==3)(line regionrnw year if region==7) if north==1, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 
twoway (line regionrnw year if region==2)(line regionrnw year if region==3)(line regionrnw year if region==7)(line regionrnw year if region==4)(line regionrnw year if region==5)(line regionrnw year if region==6) if north==0, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))


**Figure 2.3 arab founders?***

use Billionaires-2001and2014detail.dta, clear
replace typeofwealth=2 if (selfmade==1 & typeofwealth!=1) | typeofwealth==0
graph pie if year>2000 & year<2015 & region==5 & countrycode!="ISR" & countrycode!="TUR", over(typeofwealth) by( year) plabel(_all percent)


*Table 2.2 Distribution of billionaires by sector and contribution to growth*
use Billionaires1996-2014.dta, clear
generate number=1
keep if year==1996 | year==2014
*share of billionaires*
bysort north year: tab Industry

collapse (sum) realnetworth number, by(north Industry year)
drop if Ind==.
bysort year north: egen totalrnw=sum(realnetworth)


bysort year north: egen totalbillionaires=sum(number)
reshape wide realnetworth totalrnw number totalbillionaires, i(north Industry) j(year)
replace realnetworth1996=0 if realnetworth1996==.
replace totalrnw1996=325.3 if totalrnw1996==.
generate change19962014=(realnetworth2014- realnetworth1996)/(totalrnw2014-totalrnw1996)
replace number1996=0 if number1996==.
replace totalbillionaires1996=129 if totalbillionaires1996==.
generate popchange19962014=(number2014- number1996)/(totalbillionaires2014-totalbillionaires1996)
generate share1996= realnetworth1996/ totalrnw1996
generate share2014= realnetworth2014/ totalrnw2014
*share of wealth*
bysort north: list Industry share1996
bysort north: list Industry share2014


*contribution to growth*
list Industry north popchange
list Industry north change

*Table 2.3 Billionaires by region and type of wealth**
use Billionaires-2001and2014detail.dta, clear
drop if year==1996

bysort year region north: tab founders2 

*Table 2.5  Share of billionaires BRICs countries*
generate brics=1 if countrycode=="CHN" | countrycode=="IND" | countrycode=="BRA" | countrycode=="RUS"
bysort year countrycode: tab founders2 if brics==1

*Table 2.4 Billionaires by Industry, EM and Advanced Economies*
use Billionaires1996-2014.dta, clear
generate number=1
keep if year==1996 | year==2014
*distribution of billionaires*
bysort year north region: tab Industry

collapse (sum) realnetworth number, by(region north Industry year)
drop if Ind==.
bysort year north region: egen totalrnw=sum(realnetworth)

drop if region==0
bysort year north region: egen totalbillionaires=sum(number)
reshape wide realnetworth totalrnw number totalbillionaires, i(north region Industry) j(year)
replace realnetworth1996=0 if realnetworth1996==.

replace realnetworth2014=0 if realnetworth2014==.
bysort region north: replace totalrnw1996= totalrnw1996[_n-1] if totalrnw1996==.
bysort region north: replace totalrnw2014= totalrnw2014[_n+1] if totalrnw2014==.
bysort region north: replace totalrnw1996= totalrnw1996[_n+1] if totalrnw1996==.


replace totalrnw1996= 1.5 if totalrnw1996==.  & region==3


generate change19962014=(realnetworth2014- realnetworth1996)/(totalrnw2014-totalrnw1996)
replace number1996=0 if number1996==.
replace number2014=0 if number2014==.
bysort region north: replace totalbillionaires1996= totalbillionaires1996[_n-1] if totalbillionaires1996==.
bysort region north: replace totalbillionaires2014= totalbillionaires2014[_n+1] if totalbillionaires2014==.
bysort region north: replace totalbillionaires1996= totalbillionaires1996[_n+1] if totalbillionaires1996==.
 replace totalbillionaires1996=1 if totalbillionaires1996==. & region==3
 replace totalbillionaires1996=2 if totalbillionaires1996==. & region==4
 replace totalbillionaires1996=17 if totalbillionaires1996==. & region==5
generate popchange19962014=(number2014- number1996)/(totalbillionaires2014-totalbillionaires1996)

generate share1996= realnetworth1996/ totalrnw1996
generate share2014= realnetworth2014/ totalrnw2014
*distribution of wealth*
sort Ind
bysort  north region: list Industry share1996
bysort north region: list Industry share2014

*contribution to growth*
bysort north region : list Industry popchange
bysort north region: list Industry change



