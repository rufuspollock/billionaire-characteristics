**Chapter 6 Globalization and Extreme Wealth**


**Figure 6.4 Billionaire real net worth versus company share of international revenue**

use "Billionaires1996-2014.dta", clear


merge m:1 name year using "Billionaires-2001and2014detail.dta"
drop _m
sort company year
merge m:1 company year using "companydata.dta"

replace gdpcurrentusppp=gdpcurrentusppp/1000000000
generate realcountrygdp=(gdpcurrentusppp/deflator1996)*100
collapse  realcountrygdp internationalshare  region north Industry (sum) realnetworth if internationalshare!=., by(company countrycode year)

generate logrnw=log(realnetworth)
generate loggdp=log(realcountrygdp)
regress logrnw loggdp
predict wealthtogdp, resid

regress internationalshare loggdp
predict ishare, resid
replace internationalshare= internationalshare/100

twoway (scatter wealthtogdp ishare )(lfit wealthtogdp ishare ) if ishare>-75, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

**Figure 6.5 Change in billionaire wealth versus change in trade, 1996-2013**
use Billionaires1996-2014.dta, clear

merge m:1 countrycode year using "WDIdata.dta"
replace gdpcurrentusn=gdpcurrentusn/1000000000
replace totalimports=totalimports/1000000000
replace totalexports=totalexports/1000000000
generate realtotalimports=(totalimports/deflator1996)*100
generate realtotalexports=(totalexports/deflator1996)*100
generate realcountrygdp=(gdpcurrentusn/deflator1996)*100
collapse north realcountrygdp realtotalexports realtotalimports (sum) realnetworth if realbillionaires==1, by(countrycode year Industry)

generate lnrealtotaltrade=log( realtotalexports+realtotalimports)
generate lnrealnetworth=log(realnetworth)
sort countrycode Industry year

by countrycode Industry: gen lagnetworth= lnrealnetworth[_n-1]
by countrycode Industry: gen lagtrade= lnrealtotaltrade[_n-1]

bysort countrycode: generate changetrade= lnrealtotaltrade-lagtrade
bysort countrycode: generate changenetworth= lnrealnetworth-lagnetworth
twoway (scatter changenetworth changetrade)(lfit changenetworth changetrade) if changetrade<0.5 & changetrade>-0.5, title(, size(medium) color(black) justification(left)) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Figure 6.6 trade vs. gdp regressions*
use Billionaires1996-2014.dta, clear

merge m:1 countrycode year using "WDIdata.dta"

replace gdpcurrentusn=gdpcurrentusn/1000000000
replace totalimports=totalimports/1000000000
replace totalexports=totalexports/1000000000
generate realtotalimports=(totalimports/deflator1996)*100
generate realtotalexports=(totalexports/deflator1996)*100
generate realcountrygdp=(gdpcurrentusn/deflator1996)*100

gen logtrade=log(realtotalimports+realtotalexports)
generate logrealgdp=log(realcountrygdp)
generate logpopulation=log(population)


replace north=1 if countrycode=="JPN" | countrycode=="KOR" | countrycode=="ISR"

replace north=0 if countrycode=="CZE" | countrycode=="GEO" | countrycode=="POL" |countrycode=="ROM" | countrycode=="RUS" | countrycode=="SRB" | countrycode=="UKR" |countrycode=="CHI" | countrycode=="CYP" | countrycode=="MCD" | countrycode=="LTU"| countrycode=="LIE"


encode countrycode, generate(countrycode2)
drop countrycode
rename countrycode2 countrycode

bysort year countrycode IndustryAggregates: egen countryaggindustrytotals=total(realnetworth) if realbillionaires==1
bysort year countrycode IndustryAggregates: egen countryaggindustrynobillionaires=count(realnetworth) if realbillionaires==1
bysort year countrycode IndustryAggregates: egen countryaggindustryavg=mean(realnetworth) if realbillionaires==1
generate  logcountrytotal=log( countryaggindustrytotals)
drop if year>2014
collapse  logcountrytotal logrealgdp logpopulation logtrade, by(countrycode Industry year north)

egen ind=group(IndustryAggregates)
egen countryid=group(countrycode)
gen ctyind=countryid*100+ind
gen indyear=year*100+ind
gen ctyyear=year*1000+countryid
drop if IndustryAggregates==0 | IndustryAggregates==.
tsset ctyind year
drop countryid
regress logcountrytotal logrealgdp logpopulation logtrade      i.indyear i.country, cluster(countrycode)
outreg2 logtrade  logrealgdp logpopulation using "figure6.7results.txt", br ctitle("All")  replace
regress logcountrytotal logrealgdp logpopulation logtrade      i.indyear i.country if north==1, cluster(countrycode)
outreg2  logtrade logrealgdp logpopulation using "figure6.7results.txt", br ctitle("North")  append
regress logcountrytotal logrealgdp logpopulation logtrade      i.indyear i.country if north==0, cluster(countrycode)
outreg2 logtrade logrealgdp logpopulation  using "figure6.7results.txt", br ctitle("South")  append

