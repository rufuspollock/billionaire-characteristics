
***###CHAPTER 4 Historical Experiences of Development: Large Firms and Extreme Wealth####***



*Table 4.1*
use Billionaires-2001and2014detail.dta, clear

keep if selfmade==1
drop if IndustryAggregates==0
gsort year north -networth 
bysort year north: gen top28=_n

replace Industry=10 if Industry==5 | Industry==2

keep if top28<29
replace Ind=1 if source2=="oil infrastructure"
replace Ind=4 if source2=="insurance"

bysort year: tab Industry if north==0 & top28<29 & year>1996

