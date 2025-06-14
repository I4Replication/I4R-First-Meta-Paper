ssc install tabout

// begin preamble

timer clear 1

timer on 1

use "./data/Cleaned - First Meta Database - For I4R - 10 Jan 2025.dta", clear

datasignature

assert r(datasignature) == "6693:277(60678):2700205674:387348389" 
 
drop if robustness_recode == 1 & !inlist(1, robustness_change_control, robustness_change_depvar, robustness_change_estim, robustness_change_inference, robustness_change_mainvar, robustness_change_sample, robustness_change_weights, robustness_new_data, coding_correction)

drop if not_comparable==1

drop if cannot_compare==1

drop if robustness_new_data==1 

capture drop o_p_dbl
destring o_p_value, gen(o_p_dbl) 

capture drop r_p_dbl
destring r_p_value, gen(r_p_dbl) 

replace o_p_dbl = abs(o_p_dbl)
replace r_p_dbl = abs(r_p_dbl)

capture drop aweight
bysort paper_title: egen aweight = count(paper_title)

di abs(invnormal(0.05/2))
capture drop o_tstat
gen o_tstat = abs(invnormal(abs(o_p_dbl)/2))

di abs(invnormal(0.05/2))
capture drop r_tstat
gen double r_tstat = abs(invnormal(abs(r_p_dbl)/2))

// end preamble

* table 1 

capture drop o_sig_level
gen o_sig_level = .
replace o_sig_level = 3 if o_p_dbl>=0.00 & o_p_dbl<=0.01
replace o_sig_level = 2	if o_p_dbl> 0.01 & o_p_dbl<=0.05
replace o_sig_level = 1 if o_p_dbl> 0.05 & o_p_dbl<=0.10
replace o_sig_level = 0 if o_p_dbl> 0.10 & o_p_dbl<=1.00
label variable o_sig_level "Original Significance Level"

capture label drop o_sig_level_labels
label define o_sig_level_labels 0 "Not Significant" 1 "Significant at 10%" 2 "Significant at 5%" 3 "Significant at 1%"
label values o_sig_level o_sig_level_labels

capture drop r_sig_level
gen r_sig_level = .
replace r_sig_level = 4 if r_p_dbl>=0.00 & r_p_dbl<=0.01
replace r_sig_level = 3	if r_p_dbl> 0.01 & r_p_dbl<=0.05
replace r_sig_level = 2 if r_p_dbl> 0.05 & r_p_dbl<=0.10
replace r_sig_level = 1 if r_p_dbl> 0.10 & r_p_dbl<=1.00 
replace r_sig_level = 0 if (o_coeff_dbl > 0 & r_coeff_dbl<0) | (o_coeff_dbl < 0 & r_coeff_dbl > 0)
label variable r_sig_level "Re-Analysis Significance Level"

capture label drop r_sig_level_labels
label define r_sig_level_labels 0 "Sign Change" 1 "Not Sig." 2 "Sig. at 10%" 3 "Sig. at 5%" 4 "Sig. at 1%"
label values r_sig_level r_sig_level_labels

tab o_sig_level r_sig_level, cell nofreq 

//tabout o_sig_level r_sig_level using "./tables/table_1.tex", cells(row) format(2) replace  style(tex) ///
//botf(latex_table_bottom.tex) topf(latex_table_top.tex) h3(%) 

tabout o_sig_level r_sig_level using "./tables/table_1.tex", cells(cell) format(2) replace  style(tex) ///
botf(latex_table_bottom.tex) topf(latex_table_top.tex) h3(%) 

* table 14 15

preserve

keep paper_title o_p_dbl r_p_dbl aweight journal economics  

rename o_p_dbl o_p_dbl1
rename r_p_dbl o_p_dbl2

gen unique_id = _n

reshape long o_p_dbl, i(unique_id aweight journal economics  ) j(reanalysis)

rename o_p_dbl pvalue

label var reanalysis "Re-Analysis"

replace reanalysis=0 if reanalysis==1
replace reanalysis=1 if reanalysis==2

foreach threshold of numlist 0.10 0.05 {
	
eststo clear
	
foreach window of numlist 0.04 0.03 0.02 0.01 {
	
quietly{
	
capture drop sig
gen sig = .
replace sig = 1 if pvalue <= `threshold' & pvalue!=.
replace sig = 0 if pvalue >  `threshold' & pvalue!=. 

probit sig i.reanalysis `controls' if inrange(pvalue,`threshold'-`window',`threshold'+`window'), vce(cluster paper_title)
eststo: margins, dydx(*) post 
estadd scalar threshold = `threshold'	
estadd scalar window = `window'	

}
}

if `threshold'==0.10 {
	local mystring "Significant at 10\% Level"
	local tablabel "./tables/table_15.tex"
}
if `threshold'==0.05 {
	local mystring "Significant at 5\% Level"
	local tablabel "./tables/table_14.tex"
}

esttab ,  keep() ///
mgroups("`mystring'",pattern(1 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span ) ///
stats (N threshold window, label("Observations" "Threshold" "Window") fmt(%11.0gc %11.2f %11.2f)) ///
star(* 0.10 ** 0.05 *** 0.01) noomit nomtitle se(3) b(3) label nogaps se nonotes nobaselevels nocons ///
indicate( ///
, labels("\checkmark" " "))

esttab using "`tablabel'", replace keep() ///
mgroups("`mystring'",pattern(1 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span ) ///
stats (N threshold window, label("Observations" "Threshold" "Window") fmt(%11.0gc %11.2f %11.2f)) ///
star(* 0.10 ** 0.05 *** 0.01) noomit nomtitle se(3) b(3) label nogaps se nonotes nobaselevels nocons ///
indicate( ///
, labels("\checkmark" " "))

}
restore 

// table 17

preserve

keep paper_title o_p_dbl r_p_dbl aweight    

rename o_p_dbl o_p_dbl1
rename r_p_dbl o_p_dbl2

gen unique_id = _n

reshape long o_p_dbl, i(unique_id aweight    ) j(reanalysis)

rename o_p_dbl pvalue

label var reanalysis "Re-Analysis"

replace reanalysis=0 if reanalysis==1
replace reanalysis=1 if reanalysis==2

local first 4 
local last 1 

foreach threshold of numlist 0.05 {
	local threshold2 = `threshold'*100

foreach window of numlist 0.04 0.03 0.02 0.01 {
	local window2 = `window'*100
	 
capture drop prop_sig_`threshold2'_`window2'
gen prop_sig_`threshold2'_`window2' = 0 if inrange(pvalue,`threshold'-`window',`threshold'+`window')
replace prop_sig_`threshold2'_`window2' = 1 if pvalue <= `threshold' & inrange(pvalue,`threshold'-`window',`threshold'+`window')
label var prop_sig_`threshold2'_`window2' "Proportion Significant in `threshold' \pm `window'"

capture drop one_side_`threshold2'_`window2'
gen one_side_`threshold2'_`window2' = .

bitest prop_sig_`threshold2'_`window2' == 0.5 if inrange(pvalue,`threshold'-`window',`threshold'+`window') & reanalysis == 0
replace one_side_`threshold2'_`window2' = r(p_u) if reanalysis == 0

bitest prop_sig_`threshold2'_`window2' == 0.5 if inrange(pvalue,`threshold'-`window',`threshold'+`window') & reanalysis == 1
replace one_side_`threshold2'_`window2' = r(p_u) if reanalysis == 1

label var one_side_`threshold2'_`window2' "One-Sided p-value against 0.50"

capture drop num_`threshold2'_`window2'
gen num_`threshold2'_`window2' = .
count if inrange(pvalue,`threshold'-`window',`threshold'+`window')
replace num_`threshold2'_`window2' = r(N)
format num_`threshold2'_`window2' %4.0f

label var num_`threshold2'_`window2' "Number of Tests in `threshold' \pm `window'"

}

eststo clear

eststo Original : estpost summarize prop_sig_`threshold2'_`first'-num_`threshold2'_`last' if reanalysis==0

esttab , ///
	 main(mean %6.3f) mtitles("Original Analysis" "Re-Analysis")  nogaps compress noobs nonotes  label nonumbers

esttab using "./tables/table_17.tex", tex replace ///
	 main(mean %6.3f) mtitles("Original Analysis" "Re-Analysis")  nogaps compress noobs nonotes  label nonumbers
	 
}

timer off 1

timer list 1
