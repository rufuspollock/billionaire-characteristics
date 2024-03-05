**Chapter 1: The Self-Made Man**

use Billionaires-2001and2014detail.dta, clear



**FIGURE 1.1 Sheare of self-made billionaires in advanced economies and emerging markets***
graph pie if year>1996 & year<2015, over(selfmade) by(north year) plabel(_all percent)
**FIGURE 1.2 Share of self-made wealth among billionaires in advanced economies and emerging markets***
bysort year: egen totalnetworth=total(networth)
generate inheritedwealth=networth/totalnetworth if selfmade==0
generate selfmadewealth=networth/totalnetworth if selfmade==1
graph pie inheritedwealth selfmadewealth if year>1996 & year<2015, by(north year) plabel(_all percent)

****FIGURE 1.3 Indices of real net worth of billionaires and energy price***

use "Billionaires1996-2014.dta", clear
collapse (sum) realnetworth if realbillionaires==1 & year<2015, by(year Industry)
reshape wide realnetworth, i(Industry) j(year)
generate share1996= realnetworth1996
reshape long realnetworth, i(Industry) j(year)
bysort year: egen totalnetworth=total(realnetworth)
generate index1996= realnetworth/ share1996
bysort year: egen nonfinance=total( realnetworth) if Industry!=4
bysort year: egen nonresource=total( realnetworth) if Industry!=1
generate nonresourceindex= nonresource/990.1999

merge m:1 year using "commoditypriceindex.dta"
twoway (line index1996 year if Industry==1, yaxis(1))(line nonresourceindex year, yaxis(1))(line energyindex year, yaxis(2)), title(, size(medium) color(black) justification(left)) ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

**Table 1.1 Distribution of number and wealth of billionaires, by source of wealth***
use Billionaires-2001and2014detail.dta, clear


merge m:1 name year using Billionaires1996-2014.dta
keep if year==2001 | year==2014

*share of billionaires*
bysort year: tab typeofwealth
bysort year north: tab typeofwealth

generate number=1
collapse (sum) realnetworth number, by(north typeofwealth selfmade year)
drop if selfmade==.
bysort year: egen totalrnw=sum(realnetworth)
bysort year: egen totalbillionaires=sum(number)
bysort year north: egen nstotalrnw=sum(realnetworth)
bysort year north: egen nstotalbillionaires=sum(number)
bysort typeofwealth year: egen billtypetotal=sum(realnetworth)
bysort typeofwealth year: egen billtypenumber=sum(number)

*share of wealth*
generate shareofwealth=billtypetotal/totalrnw
generate nsshare=realnetworth/nstotalrnw

sort typeofwealth north 
bysort year: list typeofwealth shareofwealth if north==1
bysort north year: list typeofwealth nsshare
drop shareofwealth nsshare
reshape wide realnetworth totalrnw number totalbillionaires nstotalrnw nstotalbillionaires billtypetotal billtypenumber , i(north typeofwealth) j(year)

*All Billionaires contribution*
generate wealthchange=(billtypetotal2014- billtypetotal2001)/(totalrnw2014-totalrnw2001)
generate popchange=(billtypenumber2014- billtypenumber2001)/(totalbillionaires2014-totalbillionaires2001)
 list typeofwealth wealthchange
 list typeofwealth popchange

*North and South contribution*
generate nswealthchange=(realnetworth2014- realnetworth2001)/(nstotalrnw2014-nstotalrnw2001)
generate nspopchange=(number2014- number2001)/(nstotalbillionaires2014-nstotalbillionaires2001)
bysort north: list typeofwealth nswealthchange
bysort north: list typeofwealth nspopchange
