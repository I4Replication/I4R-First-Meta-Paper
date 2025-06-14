ssc install kdens
ssc install moremata

timer clear 1

timer on 1
* figure 6a
* figure 6c

// begin preamble

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

capture drop ratio_coeff
gen ratio_coeff = r_coeff_dbl / o_coeff_dbl if r_coeff_dbl!=. & o_coeff_dbl!=. & o_coeff_dbl!=0

capture drop diff_p
gen diff_p = r_p_dbl - o_p_dbl if r_p_dbl!=. & o_p_dbl!=.

// end preamble

* figure 6

hist ratio_coeff if ratio_coeff>=-4 & ratio_coeff<=4, width(0.25) start(-4) xlabel(-4(1)4) xtitle("Ratio of replication / original estimate magnitude") percent scheme(s1mono) fcolor(orange) lcolor(black) 
graph export "./figures/figure_6.pdf", replace

count if ratio_coeff>=1 & ratio_coeff!=.
count if ratio_coeff!=.

* figure 9

capture drop mysig
gen mysig = 0 if o_tstat!=.
replace mysig = 1 if o_tstat!=. & o_tstat>=1.65
sum mysig

capture drop mysig
gen mysig = 0 if o_tstat!=.
replace mysig = 1 if o_tstat!=. & o_tstat>=1.96
sum mysig

capture drop mysig
gen mysig = 0 if o_tstat!=.
replace mysig = 1 if o_tstat!=. & o_tstat>=2.58
sum mysig

local myvar = "o_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))  
graph export "./figures/figure_9a.pdf", replace

hist o_p_dbl if o_p_dbl >= 0.0025 & o_p_dbl <= 0.15 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono)
graph export "./figures/figure_9c.pdf", replace

preserve
{
use "./data/MM Data.dta", clear

datasignature

assert r(datasignature) == "21740:160(61238):2901585861:4006186001"

local myvar = "t"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))  ylabel(0(0.1)0.5)
graph export "./figures/figure_9b.pdf", replace

hist pv if pv >= 0.0025 & pv <= 0.15 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) ylabel(0(5)25)
graph export "./figures/figure_9d.pdf", replace
}
restore

* figure 10

local myvar = "o_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ylabel(0(0.1)0.5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))  
graph export "./figures/figure_10a.pdf", replace

local myvar = "r_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ylabel(0(0.1)0.5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))  
graph export "./figures/figure_10b.pdf", replace

hist o_p_dbl if o_p_dbl >= 0.0025 & o_p_dbl <= 0.15 , width(0.01) ylabel(0(5)25) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) 
graph export "./figures/figure_10c.pdf", replace

hist r_p_dbl if r_p_dbl >= 0.0025 & r_p_dbl <= 0.15 , width(0.01) ylabel(0(5)25) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono)  
graph export "./figures/figure_10d.pdf", replace

graph close

timer off 1

timer list 1

