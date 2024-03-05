***Chapter 5-Big Business, Structural Transformation and Development***
**Figure 5.1 Average employment per FT Global 500 firm in the BRIC countries*
use "FTGlobal500.dta", clear
generate numberfirms=1
collapse  (sum) numberfirms employees, by(countrycode year north)
drop if countrycode==""
drop if year<2009
replace employees=. if employees==0
generate employeesperfirm=employees/numberfirms
generate brics=1 if countrycode=="CHN" | countrycode=="RUS" | countrycode=="BRA" | countrycode=="IND"
replace employeesperfirm=employeesperfirm/1000
reshape wide numberfirms employees employeesperfirm, i(countrycode) j(year)
graph bar (sum) employeesperfirm2009 employeesperfirm2010 employeesperfirm2011 employeesperfirm2012 employeesperfirm2013 employeesperfirm2014 if brics==1, over(countrycode) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white))

***Figure 5.2 Correlation between extreme wealth and structural transformation*


use Billionaires1996-2014.dta, clear
egen billno=count(networthusbillion), by(countrycode year)
egen billtot=sum(networthusbillion), by(countrycode year)

keep countrycode year billno billtot north
duplicates drop



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
keep north countrycode year billpermill lnbillno lnbillpermill  Employmentinagriculture gdppcppp2011int gdppccon Employmentinindustry Employmentinservices
gen empind=Employmentinindustry /100
gen empag=Employmentinagriculture /100
gen empsrv=Employmentinservices/100

egen countyid=group(countrycode)
drop if gdppcppp2011int>65000
ren gdppcppp2011int gdppc

*5.2 TOP panel: billionaires per million vs gdppc*
twoway scatter  billpermill gdppc if gdppc>3700 & billpermil>0, xscale(log) yscale(log) || lowess billpermil gdppc if gdppc>3700 & billpermil>0, xscale(log) yscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 


**5.2 BOTTOM panel:employment shares by industry***
twoway (scatter empind empag empsrv gdppc) (lowess empag gdppc) (lowess empsrv gdppc) (lowess empind gdppc)if gdppc>3700, xscale(log) title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 




*Figure 5.3 Correlation between extreme wealth and employment by sector**

generate lngdppc=ln(gdppc)
reg empag lngdppc lnbillno i.countyid, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br excel ctitle("FEag") replace
reg empind lngdppc lnbillno i.countyid, robust
outreg2  lngdppc lnbillno using "Figure5.3.xls", br excel ctitle("FEind")  append
reg empsrv lngdppc lnbillno i.countyid, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br excel ctitle("FEserv")  append

reg empag lngdppc lnbillno i.countyid if north==0, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br excel ctitle("sFEag")  append
reg empind lngdppc lnbillno i.countyid if north==0, robust
outreg2  lngdppc lnbillno using "Figure5.3.xls", br  excel ctitle("sFEind")  append
reg empsrv lngdppc lnbillno i.countyid if north==0, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br excel ctitle("sFEserv")  append

reg empag lngdppc lnbillno i.countyid if north==1, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br  excel ctitle("nFEag")  append
reg empind lngdppc lnbillno i.countyid if north==1, robust
outreg2  lngdppc lnbillno using "Figure5.3.xls", br excel ctitle("nFEind")  append
reg empsrv lngdppc lnbillno i.countyid if north==1, robust
outreg2  lngdppc lnbillno  using "Figure5.3.xls", br excel ctitle("nFEserv")  append




***FIGURE 5.4 Replacement of mega firms from advanced countries by mega firms from emerging markets***
use "ForbesGlobal2000.dta", clear
keep if year==2006 | year==2014

gen firm=1
gen ind=sector

***2006***
replace ind="Aero&Def" if ind=="Aerospace & Defense"
replace ind="BusServ" if ind=="Business Services & Supplies"
replace ind="CapGoods" if ind=="Capital Goods"
replace ind="ConsumerDur" if ind=="Consumer Durables"
replace ind="DivFin" if ind=="Diversified Financials"
replace ind="Drugs" if ind=="Drugs & Biotechnology"
replace ind="FoodMarkets" if ind=="Food Markets"
replace ind="Food&Tobacco" if ind=="Food, Drink & Tobacco"
replace ind="Health" if ind=="Health Care Equipment & Services" | ind=="Health Care Equipment & Svcs"
replace ind="Hotels" if ind=="Hotels, Restaurants & Leisure"
replace ind="HousehldGds" if ind=="Household & Personal Products"
replace ind="Oil" if ind=="Oil & Gas Operations"
replace ind="Software" if ind=="Software & Services"
replace ind="Technology" if ind=="Technology Hardware & Equip" |ind=="Technology Hardware & Equipment"
replace ind="Telecom" if ind=="Telecommunications Services"
replace ind="Trading" if ind=="Trading Companies"


***2014****

replace ind="Banking" if ind=="Major Banks" | ind=="Regional Banks"
replace ind="BusServ" if ind=="Air Courier" | ind=="Business & Personal Services" | ind=="Business Products & Supplies"  
replace ind="CapGoods" if  ind=="Environmental & Waste Management"| ind=="Heavy Equipment"
replace ind="Chemicals" if ind=="Diversified Chemicals" | ind=="Specialized Chemicals"
replace ind="Construction" if ind=="Construction Materials" | ind=="Construction Services"
replace ind="ConsumerDur" if ind=="Auto & Truck Manufacterers" | ind=="Auto & Truck Parts" | ind=="Electronics" 
replace ind="CapGoods" if ind=="Electrical Equipment" | ind=="Containers & packaging " | ind=="Containers & packageing " | ind=="Other Industrial Equipment" | ind=="Paper & Paper Products" | ind=="Furniture & Fixtures" 
replace ind="DivFin" if ind=="Consumer Financial" | ind=="Real Estate" | ind=="Rental & Leasing" | ind=="Investment Services" | ind=="Thrifts & Mortgage Finance"
replace ind="Drugs" if ind=="Biotechs" | ind=="Pharmaceuticals"
replace ind="Food&Tobacco" if ind=="Beverages" | ind=="Food Processing" | ind=="Food Processing " | ind=="Tobacco"
replace ind="FoodMarkets" if ind=="Food Retail"
replace ind="Health" if ind=="Healthcare Services" | ind=="Managed Health Care" | ind=="Medical Equipment & Supplies" | ind=="Precision Healthcare Equipment"
replace ind="Hotels" if ind=="Casinos & Gaming" | ind=="Hotels & Motels" | ind=="Recreational Products" | ind=="Restaurants"
replace ind="HousehldGds" if ind=="Apparel/Accessories" | ind=="Apparel/Footwear Retailer" | ind=="Consumer Electronics" | ind=="Household Appliances" | ind=="Household/Personal Care" | ind=="Security Systems"
replace ind="Insurance" if ind=="Diversified Insurance" | ind=="Insurance Brokers" | ind=="Life & Health Insurance" | ind=="Property & Casualty Insurance"
replace ind="Materials" if ind=="Aluminum" | ind=="Diversified Metals & Mining" | ind=="Iron & Steel"
replace ind="Media" if ind=="Advertising" | ind=="Broadcasting & Cable" | ind=="Communications Equipment" | ind=="Printing & Publishing"
replace ind="Oil" if ind=="Oil Services & Equipment"
replace ind="Retailing" if ind=="Computer & Electronics Retail" | ind=="Department Stores" | ind=="Discount Stores" | ind=="Drug Retail" | ind=="Home Improvement" | ind=="Internet & Catalog Retail" | ind=="Specialty Stores"
replace ind="Software" if ind=="Software & Programming"
replace ind="Technology" if ind=="Computer Hardware" | ind=="Computer Services" | ind=="Computer Storage Devices" 
replace ind="Telecom" if ind=="Telecommunications"
replace ind="Trading" if ind=="Trading Company"
replace ind="Transportation" if ind=="Airline" | ind=="Other Transportation" | ind=="Railroads" | ind=="Trucking"
replace ind="Utilities" if ind=="Diversified Utilities" | ind=="Electric Utilities" | ind=="Natural Gas Utilities"


drop k
reshape wide ind companyrank salesbil profitsbil assetsbil marketvaluebil sector countrycode country region north , i(company) j(year)
replace ind2014=ind2006 if ind2006!="" & ind2014!=""
reshape long ind companyrank salesbil profitsbil assetsbil marketvaluebil sector countrycode country region north , i(company) j(year)

collapse (sum) firm, by(north ind year)
drop if north==.
reshape wide firm, i(ind year) j(north)
reshape wide firm0 firm1, i(ind) j(year)
gen dnorth=firm12014-firm12006
gen dsouth=firm02014-firm02006
replace dnorth=0 if dnorth==.
replace dsouth=0 if dsouth==.
pwcorr dnorth dsouth
gen total2014=firm12014+firm02014


scatter dnorth dsouth, mlabel(ind) title(, size(medium) color(black) justification(left)) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 


*Figure 5.6 Correlation between Density of UHNW population and stage of development**
use KnightFrankWealthXForbes.dta, clear
generate kfuhnwpermillion= (uhnw *1000000)/pop
generate logkfunhwpermillion=ln(kfuhnwp)
generate lngdppc=ln(gdppcpppint)
generate countrylabel="Iran" if countrycode=="IRN"
replace countrylabel="Saudi Arabia" if countrycode=="SAU"
replace countrylabel="Oman" if countrycode=="OMN"
replace countrylabel="Qatar" if countrycode=="QAT"
replace countrylabel="Algeria" if countrycode=="DZA"
twoway (scatter logkfunhwpermillion lngdppc, mlabel(countrylabel))(lfit logkfunhwpermillion lngdppc) if year==2013, title(, size(medium) color(black) justification(left))  ylabel(, nogrid) subtitle(, size(medium) justification(left)) caption(, size(medsmall)) note(, size(medsmall) justification(left)) legend(lcolor(white)) graphregion(fcolor(white) lcolor(white)) 

