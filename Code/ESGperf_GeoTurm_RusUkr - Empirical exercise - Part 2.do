// ***** Stata code for replicating the second part of the paper *****//
// Boccaletti, S., Maranzano, P., Morelli, C. & Ossola, E. (2024+) "ESG Performance and Stock Market Responses to Geopolitical Turmoil: evidence from the Russia-Ukraine War" //

// This file contains commands to replicate the empirical approach to arrive to the estimation of equation (2)

// Please, notice that due to the masking process (see the Excel file "db_v1_masked.xlsx"), the actual resultscannot be exactly replicated. 

* Please, change working directory with the address of the folder in which you saved data files:
* in the next command, change DIRECTORY with the actual directory of the folder

cd "DIRECTORY"

*import the databese from the excel spreadshit
import excel db_v1_masked.xlsx, sheet("Foglio1") firstrow


*winsorize variables at 1st and 99th percentile, except for the Industry Adjusted ESG score

foreach var in TotalAssets PretaxIntCoverag TotalDebtTotalAssets ReturnonAvgTotalAssets {
egen `var'pt1 = pctile(`var') ,p(1) 
egen `var'pt99 = pctile(`var') ,p(99)
replace `var' = `var'pt1  if (`var' < `var'pt1)
replace `var' = `var'pt99 if (`var' > `var'pt99 & `var' <.)
drop `var'pt1 `var'pt99
}

*gen sector and country dummies
egen sector1 = group(naics)
egen countryx= group(country)

*genarte Size as the natural log of Total assets
gen size_ta=ln(TotalAssets)

*the interest coverage ratio is defined as the Pre tax-interest coverage ratio
gen int_cov=PretaxIntCoverag

*we rescale the debt to total asset ratio
gen d_ta=TotalDebtTotalAssets/100

*rename the Return on Assets
gen roa_1=ReturnonAvgTotalAssets


*Rescale CARs

foreach var in car_3_1 car_3_0 car_1_0 car_0 car_0_1 {
sum `var'
gen controllo=`var'*100
replace `var'=controllo 
drop controllo
}


//****** Empirical exercise with Industry Adjusted ESG score (For specification in Table 7)
* (outreg2 to export results in a different file excel)

reg car_3_1 size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE i.sector1 i.countryx i.sector1##i.countryx, vce(robust)

*outreg2 excel using Results_table7_part2.xls, addstat (Prob > F, e(rss)) keep (size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE) label  

reg car_3_0 size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE i.sector1 i.countryx i.sector1##i.countryx, vce(robust)

*outreg2 excel using Results_table7_part2.xls, addstat (Prob > F, e(rss)) keep (size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE) label  

reg car_1_0 size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE i.sector1 i.countryx i.sector1##i.countryx, vce(robust)

*outreg2 excel using Results_table7_part2.xls, addstat (Prob > F, e(rss)) keep (size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE) label  

reg car_0 size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE i.sector1 i.countryx i.sector1##i.countryx, vce(robust)

*outreg2 excel using Results_table7_part2.xls, addstat (Prob > F, e(rss)) keep (size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE) label  

reg car_0_1 size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE i.sector1 i.countryx i.sector1##i.countryx, vce(robust)

*outreg2 excel using Results_table7_part2.xls, addstat (Prob > F, e(rss)) keep (size_ta int_cov d_ta roa_1 INDUSTRY_ADJUSTED_SCORE) label  


