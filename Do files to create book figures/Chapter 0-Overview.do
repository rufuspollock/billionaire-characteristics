**Overview*

*Figure O.1 Correlation between density of billionaires and stage of economic development*

use Billionaires1996-2014.dta, clear
egen billno=count(networthusbillion), by(countrycode year)
egen billtot=sum(networthusbillion), by(countrycode year)

keep countrycode year billno billtot
duplicates drop


replace countrycode="DNK" if countrycode=="DEN"
sort countrycode year

merge countrycode year using "structrans.dta"
ren PopulationtotalSPPOPTOTL pop
ren GDPpercapitaPPPconstant201 gdppcppp2011int
gen billpermill=billno*100000000/pop
gen lnbillno=ln(billno)
drop if countrycode=="MCO"
drop if countrycode=="HKG"
drop if countrycode=="BLZ"
drop if countrycode=="ISL"
keep if billpermill<1000
gen lnbillpermill=ln(billpermill)
ren GDPpercapitaconstant2005US gdppccon
keep countrycode year billpermill lnbillno lnbillpermill  Employmentinagriculture gdppcppp2011int gdppccon Employmentinindustry Employmentinservices
gen empind=Employmentinindustry /100
gen empag=Employmentinagriculture /100
gen empsrv=Employmentinservices/100

egen countyid=group(countrycode)
drop if gdppcppp2011int>65000
ren gdppcppp2011int gdppc


twoway scatter  billpermill gdppc if gdppc>3700 & billpermil>0, xscale(log) yscale(log) || lowess billpermil gdppc if gdppc>3700 & billpermil>0, xscale(log) yscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 
