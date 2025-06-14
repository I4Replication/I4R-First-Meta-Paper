* updated 2023-12-11

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


*** original p-values

{
preserve
	
* ptop1
gen ptop1 = o_p_dbl

* ptop2 (leaving both in to change minimally the R code from Elliot et al.)
gen ptop2= o_p_dbl

drop if ptop1 == .
drop if ptop2 == .
drop if ptop1 > 1

capture drop id
egen id = group(paper_title)

keep ptop1 ptop2 id

export delimited using "input_to_elliot_original.csv", replace

restore 
}

*** original p-values, econ only

{
preserve

keep if economics==1
	
* ptop1
gen ptop1 = o_p_dbl

* ptop2 (leaving both in to change minimally the R code from Elliot et al.)
gen ptop2= o_p_dbl

drop if ptop1 == .
drop if ptop2 == .
drop if ptop1 > 1

capture drop id
egen id = group(paper_title)

keep ptop1 ptop2 id

export delimited using "input_to_elliot_original_economics.csv", replace

restore 
}

*** original p-values, political only

{
preserve

keep if economics==0
	
* ptop1
gen ptop1 = o_p_dbl

* ptop2 (leaving both in to change minimally the R code from Elliot et al.)
gen ptop2= o_p_dbl

drop if ptop1 == .
drop if ptop2 == .
drop if ptop1 > 1

capture drop id
egen id = group(paper_title)

keep ptop1 ptop2 id

export delimited using "input_to_elliot_original_political.csv", replace

restore 
}

/*

*** reanalysis p-values

{
preserve
	
* ptop1
gen ptop1 = r_p_dbl

* ptop2 (leaving both in to change minimally the R code from Elliot et al.)
gen ptop2= r_p_dbl

drop if ptop1 == .
drop if ptop2 == .
drop if ptop1 > 1

capture drop id
egen id = group(paper_title)

keep ptop1 ptop2 id

export delimited using "input_to_elliot_reanalysis.csv", replace

restore 
}

*** reanalysis p-values, econ only

{
preserve

keep if economics==1
	
* ptop1
gen ptop1 = r_p_dbl

* ptop2 (leaving both in to change minimally the R code from Elliot et al.)
gen ptop2= r_p_dbl

drop if ptop1 == .
drop if ptop2 == .
drop if ptop1 > 1

capture drop id
egen id = group(paper_title)

keep ptop1 ptop2 id

export delimited using "input_to_elliot_reanalysis_economics.csv", replace

restore 
}
