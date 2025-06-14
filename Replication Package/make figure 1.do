
ssc install estout
ssc install coefplot

// begin preamble

timer clear 1

timer on 1

use "./data/Cleaned - First Meta Database - For I4R - 10 Jan 2025.dta", clear

datasignature

assert r(datasignature) == "6693:277(60678):2700205674:387348389" 

drop if robustness_recode == 1 & !inlist(1, robustness_change_control, robustness_change_depvar, robustness_change_estim, robustness_change_inference, robustness_change_mainvar, robustness_change_sample, robustness_change_weights, robustness_new_data, coding_correction)

drop if not_comparable==1

drop if cannot_compare==1

capture drop o_p_dbl
destring o_p_value, gen(o_p_dbl) // make p values for myself, from string, more information than 3 digits in original

capture drop r_p_dbl
destring r_p_value, gen(r_p_dbl) // make p values for myself,  more information than 3 digits in original

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

label var repro_sign_5 "Rep. if Orig. Sig. 5\%"
label var repro_not_sign_5 "Rep. if Orig. Not Sig. 5\%"
label var repro_sign_10 "Rep. if Orig. Sig. 10\%"
label var repro_not_sign_10 "Rep. if Orig. Not Sig. 10\%"

preserve

drop if robustness_new_data==1

eststo clear
eststo: estpost ci repro_sign_5 repro_not_sign_5 repro_sign_10 repro_not_sign_10
foreach var of varlist robustness_change_control-robustness_change_weights {
eststo: estpost ci repro_sign_5 repro_not_sign_5 repro_sign_10 repro_not_sign_10 if `var'==1 & robustness_new_data!=1
}
restore
eststo: estpost ci repro_sign_5 repro_not_sign_5 repro_sign_10 repro_not_sign_10 if robustness_new_data==1 

esttab, ///
cells(b(fmt(2)) ci(fmt(2) par)) collabels(none) mtitles( ///
"\shortstack{Full \\ Sample}" ///
"\shortstack{Change \\ Control}" ///
"\shortstack{Dep. \\ Var.}" ///
"\shortstack{Change \\ Estim.}" ///
"\shortstack{Infer. \\ Method}" ///
"\shortstack{Ind. \\ Var.}" ///
"\shortstack{Change \\ Sample}" ///
"\shortstack{Change \\ Weights}" ///
"\shortstack{New \\ Data}" ///
)  nogaps compress noobs label nonotes

sum repro_sign_5 if robustness_change_control==1

eststo clear
capture drop one
gen one = 1
eststo m0: reg repro_sign_5 one 						if robustness_new_data!=1
eststo m1: reg repro_sign_5 robustness_change_control 	if robustness_change_control==1 & robustness_new_data!=1
eststo m2: reg repro_sign_5 robustness_change_depvar 	if robustness_change_depvar==1 & robustness_new_data!=1
eststo m3: reg repro_sign_5 robustness_change_estim 	if robustness_change_estim==1 & robustness_new_data!=1
eststo m4: reg repro_sign_5 robustness_change_inference if robustness_change_inference==1 & robustness_new_data!=1
eststo m5: reg repro_sign_5 robustness_change_mainvar 	if robustness_change_mainvar==1 & robustness_new_data!=1
eststo m6: reg repro_sign_5 robustness_change_sample 	if robustness_change_sample==1 & robustness_new_data!=1
eststo m7: reg repro_sign_5 robustness_change_weights 	if robustness_change_weights==1 & robustness_new_data!=1
eststo m8: reg repro_sign_5 robustness_new_data 		if robustness_new_data==1 
coefplot m*, keep(_cons) xline(1) mcolor(black)  xlabel(0.4(0.2)1.2) ciopts(recast(rcap) lcol(black)) legend(off) mlabel(@b) mlabpos(2) mlabcolor(black) format(%9.2f) fxsize(100) fysize(100) saving(temp1.gph, replace) ///
xtitle("Original {it:p} {&le} 0.05") ///
 ylabel(0.5 " " ///
 0.60 "Full Sample" ///
 0.70 "Changed Controls" ///
 0.80 "Dependent Variable" ///
 0.90 "Estimation Method" ///
 1.00 "Inference Method" ///
 1.10 "Independent Variable" ///
 1.20 "Changed Sample" ///
 1.30 "Changed Weights" ///
 1.40 "(Replication) New Data" ///
 1.5 " ")

eststo clear
eststo m0: reg repro_not_sign_5 one 						if robustness_new_data!=1
eststo m1: reg repro_not_sign_5 robustness_change_control 	if robustness_change_control==1 & robustness_new_data!=1
eststo m2: reg repro_not_sign_5 robustness_change_depvar 	if robustness_change_depvar==1 & robustness_new_data!=1
eststo m3: reg repro_not_sign_5 robustness_change_estim 	if robustness_change_estim==1 & robustness_new_data!=1
eststo m4: reg repro_not_sign_5 robustness_change_inference if robustness_change_inference==1 & robustness_new_data!=1
eststo m5: reg repro_not_sign_5 robustness_change_mainvar 	if robustness_change_mainvar==1 & robustness_new_data!=1
eststo m6: reg repro_not_sign_5 robustness_change_sample 	if robustness_change_sample==1 & robustness_new_data!=1
eststo m7: reg repro_not_sign_5 robustness_change_weights 	if robustness_change_weights==1 & robustness_new_data!=1
eststo m8: reg repro_not_sign_5 robustness_new_data 		if robustness_new_data==1 
coefplot m*, keep(_cons) xline(1) mcolor(black)  xlabel(0.4(0.2)1.2) ciopts(recast(rcap) lcol(black)) legend(off) mlabel(@b) mlabpos(2) mlabcolor(black) format(%9.2f) fxsize(50) fysize(100) saving(temp2.gph, replace) ///
xtitle("Original {it:p} > 0.05") ///
 yscale(off)
 
eststo clear
eststo m0: reg repro_sign_5 one 						if robustness_new_data!=1 & economics==1
eststo m1: reg repro_sign_5 robustness_change_control 	if robustness_change_control==1 & robustness_new_data!=1 & economics==1
eststo m2: reg repro_sign_5 robustness_change_depvar 	if robustness_change_depvar==1 & robustness_new_data!=1 & economics==1
eststo m3: reg repro_sign_5 robustness_change_estim 	if robustness_change_estim==1 & robustness_new_data!=1 & economics==1
eststo m4: reg repro_sign_5 robustness_change_inference if robustness_change_inference==1 & robustness_new_data!=1 & economics==1
eststo m5: reg repro_sign_5 robustness_change_mainvar 	if robustness_change_mainvar==1 & robustness_new_data!=1 & economics==1
eststo m6: reg repro_sign_5 robustness_change_sample 	if robustness_change_sample==1 & robustness_new_data!=1 & economics==1
eststo m7: reg repro_sign_5 robustness_change_weights 	if robustness_change_weights==1 & robustness_new_data!=1 & economics==1
eststo m8: reg repro_sign_5 robustness_new_data 		if robustness_new_data==1 
coefplot m*, keep(_cons) xline(1) mcolor(black)  xlabel(0.4(0.2)1.2) ciopts(recast(rcap) lcol(black)) legend(off) mlabel(@b) mlabpos(2) mlabcolor(black) format(%9.2f) fxsize(50) fysize(100) saving(temp3.gph, replace) ///
xtitle("Economics {it:p} {&le} 0.05") ///
 yscale(off)

 capture drop zero
 gen zero = 1
 eststo clear
eststo m0: reg repro_sign_5 one 						if robustness_new_data!=1 & economics==0
eststo m1: reg repro_sign_5 robustness_change_control 	if robustness_change_control==1 & robustness_new_data!=1 & economics==0
*eststo m2: reg repro_sign_5 robustness_change_depvar 	if robustness_change_depvar==1 & robustness_new_data!=1 & economics==0
eststo m2: reg zero  	    robustness_change_depvar	if /*robustness_change_depvar==1 &*/ robustness_new_data!=1 & economics==0
eststo m3: reg repro_sign_5 robustness_change_estim 	if robustness_change_estim==1 & robustness_new_data!=1 & economics==0
eststo m4: reg repro_sign_5 robustness_change_inference 		if robustness_change_inference==1 & robustness_new_data!=1 & economics==0
eststo m5: reg repro_sign_5 robustness_change_mainvar 	if robustness_change_mainvar==1 & robustness_new_data!=1 & economics==0
eststo m6: reg repro_sign_5 robustness_change_sample 	if robustness_change_sample==1 & robustness_new_data!=1 & economics==0
eststo m7: reg repro_sign_5 robustness_change_weights 	if robustness_change_weights==1 & robustness_new_data!=1 & economics==0
eststo m8: reg repro_sign_5 robustness_new_data 		if robustness_new_data==1 
coefplot m*, keep(_cons) xline(1) mcolor(black)  xlabel(0.4(0.2)1.2) ciopts(recast(rcap) lcol(black)) legend(off) mlabel(@b) mlabpos(2) mlabcolor(black) format(%9.2f) fxsize(50) fysize(100) saving(temp4.gph, replace) ///
xtitle("Pol. Sci. {it:p} {&le} 0.05") ///
 yscale(off)

graph combine temp1.gph temp3.gph temp4.gph temp2.gph, title("") xcommon ycommon col(4)
graph export "./figures/figure_1.pdf", replace

capture graph close

capture erase temp1.gph
capture erase temp2.gph
capture erase temp3.gph
capture erase temp4.gph

timer off 1

timer list 1

