*Figure 3.4 Correlation between per capita GDP and share of exports by top 1 percent of exporters**



import excel "Share of the top one percent for figure 4.4.xlsx", sheet("Data") firstrow clear
rename Time year
rename CountryOriginCode countrycode
sort countrycode year
merge 1:1 countrycode year using "WDIdata.dta"
ren Shareoftop1ExportersinT sharetop1
ren gdppcppp2011int gdppc

twoway (scatter  sharetop1 gdppc , xscale(log) )|| (lowess sharetop1 gdppc ) , xscale(log)  title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

***Figure 3.6 Correlation between share of billionaries and share of big firms*** 
use "ForbesGlobal2000.dta", clear
gen nofirm=1
collapse (sum) nofirm salesbil profitsbil assetsbil marketvaluebil, by(countrycode year)

sort countrycode year
save "g2000.dta", replace


use Billionaires1996-2014.dta, clear
gen numbill=1
rename citizenship countryname
rename networthusbillion networth
collapse (sum) numbill networth, by(countrycode year)
sort countrycode year

merge countrycode year using "g2000.dta", 
drop if nofirm==.
drop if numbill==.
egen totnum=sum(nofirm), by(year)
egen totbill=sum(numbill), by(year)
gen billshare=numbill/totbill
gen firmshare=nofirm/totnum
generate countryname="United States" if countrycode=="USA"
replace countryname="Brazil" if countrycode=="BRA"
replace countryname="China" if countrycode=="CHN"
replace countryname="India" if countrycode=="IND"
replace countryname="Russia" if countrycode=="RUS"
replace countryname="Japan" if countrycode=="JPN"
twoway (scatter billshare firmshare,  mlabel(countryname))(line firmshare firmshare) if year==2014, xscale(log) yscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))
