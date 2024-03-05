*To run code, set Central directory to location of datasets*

***Figure 1-Total real net worth of billionaires***
use Billionaires1996-2014.dta, clear

bysort year: egen realbiltotalrnw=sum(realnetworth) if realbillionaires==1
bysort year north: egen realbilnstotalrnw=sum(realnetworth) if realbillionaires==1
bysort year: egen totalrnw=sum(realnetworth)
bysort year north: egen nstotalrnw=sum(realnetworth)


twoway (line totalrnw year)(line nstotalrnw year if north==1)(line nstotalrnw year if north==0)(line realbiltotalrnw year)(line realbilnstotalrnw year if north==1)(line realbilnstotalrnw year if north==0), title(, size(medium) color(black) justification(left)) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Figure 4-Distribution of billionaires by source of wealth*
use "Billionaires-2001and2014detail.dta", clear
graph pie if year==1996, over(selfmade) plabel(_all percent)  legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))
graph pie if year==2001, over(selfmade) plabel(_all percent)  legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))
graph pie if year==2014, over(selfmade) plabel(_all percent)  legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Table 4-Sector contribution to growth in wealth and number of billionaires*
use "Billionaires1996-2014.dta", clear
keep if north==1
drop if region==5
replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7

generate number=1
collapse (sum) realnetworth number, by(region Industry year)
drop if Ind==.
bysort year region: egen totalrnw=sum(realnetworth)

drop if region==0
bysort year region: egen totalbillionaires=sum(number)
keep if year==1996 | year==2015
reshape wide realnetworth totalrnw number totalbillionaires, i(region Industry) j(year)

generate change19962015=(realnetworth2015- realnetworth1996)/(totalrnw2015-totalrnw1996)
generate popchange19962015=(number2015- number1996)/(totalbillionaires2015-totalbillionaires1996)
generate share1996= realnetworth1996/ totalrnw1996
generate share2015= realnetworth2015/ totalrnw2015


*Figure 5-Distribution of billionaires by type*
use "Billionaires-2001and2014detail.dta", clear
replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0


label define newregions 1 "United States" 2 "Europe" 3 "other advanced economies" 4 "emerging markets"
label values region newregions

bysort year region: egen totalnw=count(networth)
bysort year region typeofwealth: egen foundertotal=count(networth)
foreach n of num 0/4{
bysort year region: generate share`n'=(foundertotal/totalnw)*100 if typeofwealth==`n'
}

graph bar share4 share1 share3 share0 share2 if region<4 & region!=0 & year<2015,  over(year) over(region) stack title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Figure 6 Growth in net worth associated with hedge fund billionaires*

use Billionaires1996-2014.dta, clear
tab country if industry==9
tab name if industry==9 & countrycode=="GBR"
keep if industry==9
generate hedgefundgroups=1 if countrycode=="USA"
replace hedgefundgroup=2 if north==1 & countrycode!="USA"

collapse (sum) realnetworth, by(hedgefundgroup year)
twoway (line realnetworth year if hedgefundgroup==1)(line realnetworth year if hedgefundgroup==2), title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Figure 7 Inherited wealth distribution by generation*
use "Billionaires-2001and2014detail.dta", clear
replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0


label define newregions 1 "United States" 2 "Europe" 3 "other advanced economies" 4 "emerging markets"
label values region newregions

bysort generationofinheritance region year: egen generation=count(generationofinheritance)
bysort region year: egen totalinherited=count(generationofinheritance) if selfmade==0
foreach n of num 1/5{
generate inherited`n'=(generation/totalinherited)*100 if generationofinheritance==`n'
}

graph bar inherited5 inherited1 inherited2 inherited3 inherited4  if year==2014 & region<4,  over(year) over(region) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))



*Figure 8-Distribution of firm age by region*
use "Billionaires-2001and2014detail.dta", clear
replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0

label define newregions 1 "United States" 2 "Europe" 3 "other advanced economies" 4 "emerging markets"
label values region newregions
generate companyage=year-foundingdate
twoway (kdensity companyage if region==1)(kdensity companyage if region==2)(kdensity companyage if region==3) if year==2014, xscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

*Figure 9- Distribution of firm age over time, United States and Europe*
twoway (kdensity companyage if region==1 & year==2001)(kdensity companyage if region==1 & year==2014), xscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 
drop if companyage==. | companyage==0
twoway (kdensity companyage if region==2 & year==2001)(kdensity companyage if region==2 & year==2014), title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) xscale(log)



*Table 5 Intensive and extensive margins for total real net worth*
use "Billionaires1996-2014.dta", clear

replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0
label values region newregions

bysort year region: egen rtotal=total(realnetworth)
bysort year region: egen rmean=mean(realnetworth) 
bysort year region: egen rnumber=count(realnetworth)
generate lnrtotal=log(rtotal)
generate lnrmean=log(rmean)
generate lnrnumber=log(rnumber)


collapse lnrtotal lnrmean lnrnumber, by(region year)

foreach n of num 1/3 {
regress  lnrmean lnrtotal if region==`n' & (year==1996 | year>2000)
outreg2 using "intexregressions" , dec(3) br
regress lnrnumber lnrtotal if region==`n' & (year==1996 | year>2000)
outreg2 using "intexregressions" , dec(3) br
}

*Table 6-Intensive and extensive margins for total real net worth, various sectors*
use "Billionaires1996-2014.dta", clear

replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0
label values region newregions

bysort year region IndustryAggregates: egen rtotal=total(realnetworth)
bysort year region IndustryAggregates: egen rmean=mean(realnetworth) 
bysort year region IndustryAggregates: egen rnumber=count(realnetworth)
generate lnrtotal=log(rtotal)
generate lnrmean=log(rmean)
generate lnrnumber=log(rnumber)


collapse lnrtotal lnrmean lnrnumber, by(region IndustryAggregates year)

foreach x of num 1/5 {
foreach n of num 1/3 {
regress  lnrmean lnrtotal if region==`n' & IndustryAggregates==`x' & (year==1996 | year>2000)
outreg2 using "intexregressionsb" , dec(3) ct(int_`n'_`x') br
regress lnrnumber lnrtotal if region==`n' & IndustryAggregates==`x' & (year==1996 | year>2000)
outreg2 using "intexregressionsb" , dec(3) ct(ext_`n'_`x') br
}
}
**Table A2**
use "Billionaires-2001and2014detail.dta", clear
keep if year==2014
bysort north: egen totalwealth=total(networth)
bysort north selfmade: egen wealthtype=total(networth)
generate wealthshare=wealthtype/totalwealth
bysort north selfmade: sum wealthshare
bysort north: tab selfmade
bysort north selfmade: sum networth

use "Billionaires-2001and2014detail.dta", clear
keep if year==2014
gsort north -networth
by north: generate nsrank=_n
keep if nsrank<104
drop if nsrank==103 & north==1
bysort north: egen totalwealth=total(networth)
bysort north selfmade: egen wealthtype=total(networth)
generate wealthshare=wealthtype/totalwealth
bysort north selfmade: sum wealthshare
bysort north: tab selfmade
bysort north selfmade: sum networth


**Figure A3 Distribution of wealth by type of billionaire, advanced economies**
use "Billionaires-2001and2014detail.dta", clear
replace region=7 if region==1 & countrycode!="USA"
replace region=2 if region==3
replace region=3 if region==7
replace region=4 if north==0

label define newregions 1 "United States" 2 "Europe" 3 "other advanced economies" 4 "emerging markets"
label values region newregions
bysort year region: egen totalnw=total(networth)
bysort year region typeofwealth: egen foundertotal=total(networth)
foreach n of num 0/4{
bysort year region: generate share`n'=(foundertotal/totalnw)*100 if typeofwealth==`n'
}

graph bar share4 share1 share3 share0 share2 if region<4 & year<2015,  over(year) over(region) stack title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

*Table A3 Distribution of billionaires by country and type* 
use "Billionaires-2001and2014detail.dta", clear
keep if year==2014
bysort countrycode: tab typeofwealth
bysort region: tab typeofwealth
tab countrycode
