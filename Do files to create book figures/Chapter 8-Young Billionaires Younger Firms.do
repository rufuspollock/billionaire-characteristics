**Chapter 8- young billionaires young firms**

**Young Entrerpreneurs, Younger firms**



use Billionaires-2001and2014detail.dta, clear




**FIGURE 8.1 Distribution of billionaires by age and source of wealth***
*A
twoway (kdensity age if selfmade==1)(kdensity age if selfmade==0) if year==2014 & north==1 , title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

*B
twoway (kdensity age if selfmade==1)(kdensity age if selfmade==0) if year==2014 & north==0 , title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

***FIGURE 8.2 Distribtion of self-made billionaires by age and industry**
twoway (kdensity age if north==0)(kdensity age if north==1 & Industry==2)(kdensity age if north==1 & Industry!=2) if selfmade==1 & year==2014, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 


**TABLE 8.1 Average founding date of billionaire realted companies in advanced countries and emerging markets***
bysort year: sum foundingdate, detail
bysort selfmade year: sum foundingdate, detail
bysort year north: sum foundingdate, detail
bysort selfmade year north: sum foundingdate, detail

****FIGURE 8.3 Age of companies associated with billionaire wealth in advanced countries and emerging economies***
generate companyage=year-foundingdate

twoway (kdensity companyage if year==2001)(kdensity companyage if year==2014), by(north)
*****FIGURE 8.4 Age of companies associated with billionaire wealth in emerging economies, excluding China and Russia***
generate notchina=1 if north==0
replace notchina=0 if countrycode=="CHN" | countrycode=="RUS"

twoway (kdensity companyage if year==2001)(kdensity companyage if year==2014) if notchina==1, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 


******FIGURE 8.5 Age of companies associated with billionaire founders***
twoway (kdensity companyage if north==0)(kdensity companyage if north==1 & Industry==2)(kdensity companyage if north==1 & Industry!=2) if typeofwealth==1 & companyage<80 & year>2000, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

**Table 8.2 Movement of billionaires across quintiles in advanced countries and emerging economies*
use "Billionaires-2001and2014detail.dta", clear
keep if year==2001 | year==2014

keep name year networth north
replace name=subinstr(name, " & family", "", .)
replace name=subinstr(name, ", Jr.", "", .)
replace name=subinstr(name, ", III.", "", .)

replace name="David and Simon Reuben" if name=="David & Simon Reuben" 
replace name="James Irving" if name=="James Arthur and John Irving" 
replace name="Hansjorg Wyss" if name=="Hansjoerg Wyss"
replace name="Bernard Sherman" if name=="Bernard (Barry) Sherman" 
replace name="Klaus-Michael Kuhne" if name=="Klaus-Michael Kuehne" 
replace name="S Robson Walton" if name=="S. Robson Walton" 
replace name="A Jerrold Perenchio" if name=="A. Jerrold Perenchio"  
replace name="Billy Joe McCombs" if name=="Billy Joe (Red) McCombs" 
replace name="Clemmie Spangler" if name=="Clemmie Spangler Jr" 
replace name="David Rockefeller" if name=="David Rockefeller, Sr." 
replace name="Forrest Mars" if name=="Forrest Mars Jr" 
replace name="Gunter Herz" if name=="Guenter Herz & Family" 
replace name="H Wayne Huizenga" if name=="H. Wayne Huizenga" 
replace name="H. Ross Perot, Sr." if name=="Henry Ross Perot Sr" 
replace name="Joseph Safra" if name=="Joseph and Moise Safra"
replace name="Rafael del Pino" if name=="Rafael Del Pino y Calvo-Sotelo" 
replace name="Kenneth Troutt" if name=="Kenny Troutt" 
replace name="Martin Bouygues" if name=="Martin & Olivier Bouygues" 
 replace name="Walter Scott" if name=="Walter Scott Jr" 
replace name="William Ford" if name=="William Ford, Sr." 
replace name="Michael and Rainer Schmidt-Ruthenbeck" if name=="Michael & Rainer Schmidt-Ruthenbeck" 
reshape wide networth, i(name north) j(year)
generate quintiles2001=0
gsort north -networthusbillion2001
bysort north: generate rank2001=_n if networthusbillion2001!=.
replace quintiles2001=1 if ((north==0 & rank2001>82) | (north==1 & rank2001>348)) & networthusbillion2001!=.
replace quintiles2001=2 if ((north==0 & rank2001>61 & rank2001<=82) | (north==1 & rank2001>261 & rank<=348))
replace quintiles2001=3 if ((north==0 & rank2001>41 & rank2001<=61) | (north==1 & rank2001>174 & rank<=261))
replace quintiles2001=4 if ((north==0 & rank2001>20 & rank2001<=41) | (north==1 & rank2001>87 & rank<=174))
replace quintiles2001=5 if ((north==0 & rank2001<=20) | (north==1 & rank<=87))

generate quintiles2014=0
gsort north -networthusbillion2014
bysort north: generate rank2014=_n if networthusbillion2014!=.
replace quintiles2014=1 if ((north==0 & rank2014>564) | (north==1 & rank2014>758)) & networthusbillion2014!=.
replace quintiles2014=2 if ((north==0 & rank2014>423 & rank2014<=564) | (north==1 & rank2014>568 & rank2014<=758))
replace quintiles2014=3 if ((north==0 & rank2014>282 & rank2014<=423) | (north==1 & rank2014>379 & rank2014<=568))
replace quintiles2014=4 if ((north==0 & rank2014>141 & rank2014<=282) | (north==1 & rank2014>189 & rank2014<=379))
replace quintiles2014=5 if ((north==0 & rank2014<=141) | (north==1 & rank2014<=189))

generate enterone=1 if quintiles2014==1 & quintiles2001==0
generate entertwo=1 if quintiles2014==2 & quintiles2001==0
generate enterthree=1 if quintiles2014==3 & quintiles2001==0
generate enterfour=1 if quintiles2014==4 & quintiles2001==0
generate enterfive=1 if quintiles2014==5 & quintiles2001==0

generate exitone=1 if quintiles2014==0 & quintiles2001==1
generate exittwo=1 if quintiles2014==0 & quintiles2001==2
generate exitthree=1 if quintiles2014==0 & quintiles2001==3
generate exitfour=1 if quintiles2014==0 & quintiles2001==4
generate exitfive=1 if quintiles2014==0 & quintiles2001==5


generate oneone=1 if quintiles2001==1 & quintiles2014==1
generate onetwo=1 if quintiles2001==1 & quintiles2014==2
generate onethree=1 if quintiles2001==1 & quintiles2014==3
generate onefour=1 if quintiles2001==1 & quintiles2014==4
generate onefive=1 if quintiles2001==1 & quintiles2014==5

generate twoone=1 if quintiles2001==2 & quintiles2014==1
generate twotwo=1 if quintiles2001==2 & quintiles2014==2
generate twothree=1 if quintiles2001==2 & quintiles2014==3
generate twofour=1 if quintiles2001==2 & quintiles2014==4
generate twofive=1 if quintiles2001==2 & quintiles2014==5

generate threeone=1 if quintiles2001==3 & quintiles2014==1
generate threetwo=1 if quintiles2001==3 & quintiles2014==2
generate threethree=1 if quintiles2001==3 & quintiles2014==3
generate threefour=1 if quintiles2001==3 & quintiles2014==4
generate threefive=1 if quintiles2001==3 & quintiles2014==5

generate fourone=1 if quintiles2001==4 & quintiles2014==1
generate fourtwo=1 if quintiles2001==4 & quintiles2014==2
generate fourthree=1 if quintiles2001==4 & quintiles2014==3
generate fourfour=1 if quintiles2001==4 & quintiles2014==4
generate fourfive=1 if quintiles2001==4 & quintiles2014==5

generate fiveone=1 if quintiles2001==5 & quintiles2014==1
generate fivetwo=1 if quintiles2001==5 & quintiles2014==2
generate fivethree=1 if quintiles2001==5 & quintiles2014==3
generate fivefour=1 if quintiles2001==5 & quintiles2014==4
generate fivefive=1 if quintiles2001==5 & quintiles2014==5

bysort north: egen total2001=count(quintiles2001) if quintiles2001==5

collapse total2001  (sum) enterone- fivefive, by(north)
generate totalenter= enterone+ entertwo+ enterthree+ enterfour+ enterfive
order enterone entertwo enterthree enterfour enterfive, after(totalenter)


foreach shift of varlist exitone-fivefive {
generate share`shift'=(`shift'/total2001)*100
}

foreach entry of varlist enterone-enterfive {
generate share`entry'=(`entry'/totalenter)*100
}


***Table 8.3 Five-year stability index for top 3, top 5 and top 10 billionaires, by country**
*Top 3 countries*
use Billionaires1996-2014.dta, clear

egen crank2=rank(networthusbillion), by(countrycode year) unique
egen crank=rank(crank2), by(countrycode year) field
keep if crank<4
 keep name year citizenship countrycode networthusbillion crank

sort countrycode year crank
egen countb=count(networth), by(countrycode year)
keep if countb==3
keep if year==2014 | year==2009
keep networth year name countrycode
ren networthusbillion networth
replace name=subinstr(name, " & family", "", .)
replace name="Alain Wertheimer" if name=="Alain and Gerard Wertheimer" 
replace name="David and Simon Reuben" if name=="David & Simon Reuben" 
replace name="James Irving" if name=="James Arthur and John Irving" 
replace name="Philip & Cristina Green" if name=="Philip and Cristina Green"
replace name="R Budi Hartono" if name=="R. Budi Hartono" 
replace name="Hansjorg Wyss" if name=="Hansjoerg Wyss"
replace name="John Dorrance" if name=="John Dorrance, III."

reshape wide networth, i(name countrycode) j(year) 
sort countrycode
replace networth2009=0 if networth2009==.
replace networth2014=0 if networth2014==.
egen total09=sum(networth2009), by(countrycode)
egen total14=sum(networth2014), by(countrycode)
keep if total09~=0 & total14~=0
generate number=1
egen totalc=count(number), by(country)

gen stability= (6-totalc)/3
keep countrycode stability
duplicates drop
sort stabilit


*Top 5 country*
use Billionaires1996-2014.dta, clear

egen crank2=rank(networthusbillion), by(countrycode year) unique
egen crank=rank(crank2), by(countrycode year) field
keep if crank<6
 keep name year citizenship countrycode networthusbillion crank

sort countrycode year crank
egen countb=count(networth), by(countrycode year)
keep if countb==5
keep if year==2014 | year==2009

keep networth year name countrycode
ren networthusbillion networth
replace name=subinstr(name, " & family", "", .)
replace name="Alain Wertheimer" if name=="Alain and Gerard Wertheimer" 
replace name="David and Simon Reuben" if name=="David & Simon Reuben" 
replace name="James Irving" if name=="James Arthur and John Irving" 
replace name="Philip & Cristina Green" if name=="Philip and Cristina Green" 
replace name="Walter Thomas and Raymond Kwok" if name=="Thomas & Raymond Kwok" 
replace name="Hansjorg Wyss" if name=="Hansjoerg Wyss"
replace name="Bernard Sherman" if name=="Bernard (Barry) Sherman" 
replace name="Ferit Sahenk" if name=="Ferit Faik Sahenk" 
replace name="Klaus-Michael Kuhne" if name=="Klaus-Michael Kuehne" 
replace name="Philip & Cristina Green" if name=="Philip and Cristina Green" 
replace name="S Robson Walton" if name=="S. Robson Walton" 
replace name="Shashi and Ravi Ruia" if name=="Shashi & Ravi Ruia" 
replace name="A Jerrold Perenchio" if name=="A. Jerrold Perenchio" 



reshape wide networth, i(name countrycode) j(year) 
sort countrycode
replace networth2009=0 if networth2009==.
replace networth2014=0 if networth2014==.
egen total09=sum(networth2009), by(countrycode)
egen total14=sum(networth2014), by(countrycode)
keep if total09~=0 & total14~=0
generate number=1
egen totalc=count(number), by(country)

gen stability= (10-totalc)/5
keep countrycode stability
duplicates drop
sort stability
*Top 10 country*
use Billionaires1996-2014.dta, clear

egen crank2=rank(networthusbillion), by(countrycode year) unique
egen crank=rank(crank2), by(countrycode year) field
keep if crank<11
 keep name year citizenship countrycode networthusbillion crank

sort countrycode year crank
egen countb=count(networth), by(countrycode year)
keep if countb==10
keep if year==2014 | year==2009
keep networth year name countrycode
ren networthusbillion networth
replace name=subinstr(name, " & family", "", .)
replace name="Alain Wertheimer" if name=="Alain and Gerard Wertheimer" 
replace name="Bernard Sherman" if name=="Bernard (Barry) Sherman" 
replace name="David and Simon Reuben" if name=="David & Simon Reuben" 
replace name="Ferit Sahenk" if name=="Ferit Faik Sahenk" 
replace name="James Irving" if name=="James Arthur and John Irving" 
replace name="Klaus-Michael Kuhne" if name=="Klaus-Michael Kuehne" 
replace name="Philip & Cristina Green" if name=="Philip and Cristina Green" 
replace name="S Robson Walton" if name=="S. Robson Walton" 
replace name="Shashi and Ravi Ruia" if name=="Shashi & Ravi Ruia" 
replace name="Walter Thomas and Raymond Kwok" if name=="Thomas & Raymond Kwok" 

reshape wide networth, i(name countrycode) j(year) 
sort countrycode
replace networth2009=0 if networth2009==.
replace networth2014=0 if networth2014==.
egen total09=sum(networth2009), by(countrycode)
egen total14=sum(networth2014), by(countrycode)
keep if total09~=0 & total14~=0
generate number=1
egen totalc=count(number), by(country)

gen stability= (20-totalc)/10
keep countrycode stability
duplicates drop
sort stability

