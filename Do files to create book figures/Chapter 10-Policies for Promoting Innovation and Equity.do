**Chapter 10-policies for innovation and equity***
 
**10.1 Correlation between per capita GDP and estate tax rate, 2013**
import excel "eyinheritancetaxdata.xlsx", sheet("Sheet1") cellrange(A2:Q37) firstrow clear
drop taxnotes-Q
generate year=2013
rename Country countrycode

merge m:1 countrycode year using "WDIdata.dta"
generate countrylabel="Australia" if countrycode=="AUS"
replace countrylabel="Austria" if countrycode=="AUT"
replace countrylabel="Belgium" if countrycode=="BEL"
replace countrylabel="Canada" if countrycode=="CAN"
replace countrylabel="Switzerland" if countrycode=="CHE"
replace countrylabel="China" if countrycode=="CHN"
replace countrylabel="Cyprus" if countrycode=="CYP"
replace countrylabel="Czech Republic" if countrycode=="CZE"
replace countrylabel="Germany" if countrycode=="DEU"
replace countrylabel="Denmark" if countrycode=="DNK"
replace countrylabel="Spain" if countrycode=="ESP"
replace countrylabel="Finland" if countrycode=="FIN"
replace countrylabel="France" if countrycode=="FRA"
replace countrylabel="United Kingdom" if countrycode=="GBR"
replace countrylabel="Indonesia" if countrycode=="IDN"
replace countrylabel="India" if countrycode=="IND"
replace countrylabel="Ireland" if countrycode=="IRL"
replace countrylabel="Italy" if countrycode=="ITA"
replace countrylabel="Japan" if countrycode=="JPN"
replace countrylabel="South Korea" if countrycode=="KOR"
replace countrylabel="Luxembourg" if countrycode=="LUX"
replace countrylabel="Mexico" if countrycode=="MEX"
replace countrylabel="Netherlands" if countrycode=="NLD"
replace countrylabel="Norway" if countrycode=="NOR"
replace countrylabel="New Zealand" if countrycode=="NZL"
replace countrylabel="Philippines" if countrycode=="PHL"
replace countrylabel="Poland" if countrycode=="POL"
replace countrylabel="Portugal" if countrycode=="PRT"
replace countrylabel="Russia" if countrycode=="RUS"
replace countrylabel="Singapore" if countrycode=="SGP"
replace countrylabel="Sweden" if countrycode=="SWE"
replace countrylabel="Turkey" if countrycode=="TUR"
replace countrylabel="Ukraine" if countrycode=="UKR"
replace countrylabel="United States" if countrycode=="USA"
replace countrylabel="South Africa" if countrycode=="ZAF"


generate loggdppc=log( gdppercapitappp)
twoway (scatter rate loggdppc, mlabel(countrylabel))(lfit rate loggdppc) if loggdppc>8 & year==2013,  title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

**Figure 10.2-Correlation between share of billionaire wealth in advanced countries that is inherited and  share of total tax revenue from legacy taxes*

use Billionaires-2001and2014detail.dta, clear
merge m:1 countrycode year using "estatetax2.dta"
keep countrycode estateshare selfmade year
generate number=1
generate inherited=1 if selfmade==0
keep if year<2015
collapse estateshare (sum) inherited number, by(countrycode year)
reshape wide estateshareoftax inherited number, i(countrycode) j( year)
generate inheritedshare=(inherited2014/number2014)*100
reshape long estateshareoftax inherited number, i(countrycode) j( year)
bysort countrycode: egen avgestateshare=mean(estateshare) if year<1986

generate countrylabel="Australia" if countrycode=="AUS"
replace countrylabel="Austria" if countrycode=="AUT"
replace countrylabel="Belgium" if countrycode=="BEL"
replace countrylabel="Canada" if countrycode=="CAN"
replace countrylabel="Switzerland" if countrycode=="CHE"
replace countrylabel="China" if countrycode=="CHN"
replace countrylabel="Cyprus" if countrycode=="CYP"
replace countrylabel="Czech Republic" if countrycode=="CZE"
replace countrylabel="Germany" if countrycode=="DEU"
replace countrylabel="Denmark" if countrycode=="DNK"
replace countrylabel="Spain" if countrycode=="ESP"
replace countrylabel="Finland" if countrycode=="FIN"
replace countrylabel="France" if countrycode=="FRA"
replace countrylabel="United Kingdom" if countrycode=="GBR"
replace countrylabel="Indonesia" if countrycode=="IDN"
replace countrylabel="India" if countrycode=="IND"
replace countrylabel="Ireland" if countrycode=="IRL"
replace countrylabel="Italy" if countrycode=="ITA"
replace countrylabel="Japan" if countrycode=="JPN"
replace countrylabel="South Korea" if countrycode=="KOR"
replace countrylabel="Luxembourg" if countrycode=="LUX"
replace countrylabel="Mexico" if countrycode=="MEX"
replace countrylabel="Netherlands" if countrycode=="NLD"
replace countrylabel="Norway" if countrycode=="NOR"
replace countrylabel="New Zealand" if countrycode=="NZL"
replace countrylabel="Philippines" if countrycode=="PHL"
replace countrylabel="Poland" if countrycode=="POL"
replace countrylabel="Portugal" if countrycode=="PRT"
replace countrylabel="Russia" if countrycode=="RUS"
replace countrylabel="Singapore" if countrycode=="SGP"
replace countrylabel="Sweden" if countrycode=="SWE"
replace countrylabel="Turkey" if countrycode=="TUR"
replace countrylabel="Ukraine" if countrycode=="UKR"
replace countrylabel="United States" if countrycode=="USA"
replace countrylabel="South Africa" if countrycode=="ZAF"
replace countrylabel="Greece" if countrycode=="GRC"

twoway (scatter inheritedshare avgestateshare, mlabel(countrylabel))(lfit inheritedshare avgestateshare) if year==1985, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Table 10.1 Sources of wealth of self-made financial-sector billionaires in advanced countries and emerging economies*
use Billionaires-2001and2014detail.dta, clear
keep if typeofwealth==3 & year>1996
bysort north year: tab industry
bysort north year: egen totalfinancialwealth=sum(networth)
bysort north year industry: egen industrytotal=sum(networth)
generate shareofwealth=industrytotal/totalfinancialwealth
collapse shareofwealth, by(industry north year)
bysort year north: list industry shareofwealth
