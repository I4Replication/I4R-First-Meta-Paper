* updated 2024-01-31

// begin preamble

use "../data/Cleaned - First Meta Database - For I4R - 10 Jan 2025.dta", clear

datasignature

assert r(datasignature) == "6693:277(60678):2700205674:387348389" 

drop if robustness_recode == 1 & !inlist(1, robustness_change_control, robustness_change_depvar, robustness_change_estim, robustness_change_inference, robustness_change_mainvar, robustness_change_sample, robustness_change_weights, robustness_new_data, coding_correction)

drop if not_comparable==1

drop if cannot_compare==1

drop if robustness_new_data==1 

replace r_p_dbl = abs(r_p_dbl)

capture drop aweight
bysort paper_title: egen aweight = count(paper_title)

di abs(invnormal(0.05/2))
capture drop o_tstat
gen o_tstat = abs(invnormal(abs(o_p_dbl)/2))
replace o_tstat = abs(o_coeff_dbl / o_std_err_dbl) if o_coeff_dbl!=. & o_std_err_dbl!=. & abs(invnormal(abs(o_p_dbl)/2))>3

di abs(invnormal(0.05/2))
capture drop r_tstat
gen r_tstat = abs(invnormal(abs(r_p_dbl)/2))
replace r_tstat = abs(r_coeff_dbl / r_std_err_dbl) if r_coeff_dbl!=. & r_std_err_dbl!=. & abs(invnormal(abs(r_p_dbl)/2))>3

// end preamble

***

capture drop mycoef
gen mycoef = .
replace mycoef = o_coeff_dbl if o_coeff_dbl!=.

capture drop myse
gen myse = .
replace myse = o_std_err_dbl if o_std_err_dbl!=.

codebook mycoef myse

capture drop id
egen id = group(paper_title)

drop if mycoef==.
drop if myse==.

drop if myse==0

***

export delimited mycoef myse id using "ak_full_sample.csv", novarnames replace

preserve
keep if economics == 1
export delimited mycoef myse id using "ak_economics.csv", novarnames replace
restore

preserve
keep if economics == 0
export delimited mycoef myse id using "ak_political.csv", novarnames replace
restore

*** now the same, but for reanalysis

// begin preamble

use "../data/Cleaned - First Meta Database - For I4R - 10 Jan 2025.dta", clear

datasignature

assert r(datasignature) == "6693:277(60678):2700205674:387348389" 

drop if robustness_recode == 1 & !inlist(1, robustness_change_control, robustness_change_depvar, robustness_change_estim, robustness_change_inference, robustness_change_mainvar, robustness_change_sample, robustness_change_weights, robustness_new_data, coding_correction)

drop if not_comparable==1

drop if cannot_compare==1

drop if robustness_new_data==1 

replace r_p_dbl = abs(r_p_dbl)

capture drop aweight
bysort paper_title: egen aweight = count(paper_title)

di abs(invnormal(0.05/2))
capture drop o_tstat
gen o_tstat = abs(invnormal(abs(o_p_dbl)/2))
replace o_tstat = abs(o_coeff_dbl / o_std_err_dbl) if o_coeff_dbl!=. & o_std_err_dbl!=. & abs(invnormal(abs(o_p_dbl)/2))>3

di abs(invnormal(0.05/2))
capture drop r_tstat
gen r_tstat = abs(invnormal(abs(r_p_dbl)/2))
replace r_tstat = abs(r_coeff_dbl / r_std_err_dbl) if r_coeff_dbl!=. & r_std_err_dbl!=. & abs(invnormal(abs(r_p_dbl)/2))>3

// end preamble

***

capture drop mycoef
gen mycoef = .
replace mycoef = r_coeff_dbl if r_coeff_dbl!=.

capture drop myse
gen myse = .
replace myse = r_std_err_dbl if r_std_err_dbl!=.

codebook mycoef myse

capture drop id
egen id = group(paper_title)

drop if mycoef==.
drop if myse==.

drop if myse==0

***

export delimited mycoef myse id using "ak_r_full_sample.csv", novarnames replace

preserve
keep if economics == 1
export delimited mycoef myse id using "ak_r_economics.csv", novarnames replace
restore

preserve
keep if economics == 0
export delimited mycoef myse id using "ak_r_political.csv", novarnames replace
restore

