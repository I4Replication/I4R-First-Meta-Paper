timer clear 1

timer on 1

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

* figure 11

local myvar = "o_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 [fweight = aweight], ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 [fweight = aweight], width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))title(Original)  ///
saving(temp1.gph, replace) 

local myvar = "r_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 [fweight = aweight], ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 [fweight = aweight], width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))title(Re-Analysis)  ///
saving(temp2.gph, replace) 

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_11a.pdf", replace

hist o_p_dbl if o_p_dbl >= 0.0025 & o_p_dbl <= 0.15 [fweight = aweight], width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Original) ///
saving(temp1.gph, replace) 

hist r_p_dbl if r_p_dbl >= 0.0025 & r_p_dbl <= 0.15 [fweight = aweight], width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Re-Analysis) ///
saving(temp2.gph, replace) 

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_11b.pdf", replace

capture erase temp1.gph
capture erase temp2.gph

* figure 12

preserve
keep if economics==1

local myvar = "o_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))title(Original)  ///
saving(temp1.gph, replace)  

local myvar = "r_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))title(Re-Analysis)  ///
saving(temp2.gph, replace)  

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_12a.pdf", replace

restore

preserve
keep if economics==0

local myvar = "o_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero))title(Original)  ///
saving(temp1.gph, replace)  

local myvar = "r_tstat"
capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph
twoway ///
(hist `myvar' if `myvar'<5 , width(0.10) start(0) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(1.65 1.96 2.58, lwidth(thin)) xlabel(0(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero)) title(Re-Analysis) ///
saving(temp2.gph, replace)  

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_12b.pdf", replace

restore

hist o_p_dbl if o_p_dbl >= 0.0025 & o_p_dbl <= 0.15 & economics==1 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Original) ///
saving(temp1.gph, replace)  

hist r_p_dbl if r_p_dbl >= 0.0025 & r_p_dbl <= 0.15 & economics==1 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Re-Analysis) ///
saving(temp2.gph, replace)  

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_12c.pdf", replace

hist o_p_dbl if o_p_dbl >= 0.0025 & o_p_dbl <= 0.15 & economics==0 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Original) ///
saving(temp1.gph, replace) 

hist r_p_dbl if r_p_dbl >= 0.0025 & r_p_dbl <= 0.15 & economics==0 , width(0.01) start(0) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(0(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) title(Re-Analysis) ///
saving(temp2.gph, replace)

graph combine temp1.gph temp2.gph, xsize(2) ysize(1) ycommon
graph export "./figures/figure_12d.pdf", replace

* figure 13

hist diff_p  , width(0.05) start(-1) xlabel(-1(0.25)1) xtitle("Replication p-value minus original p-value") percent ///
 scheme(s1mono) fcolor(orange) lcolor(black)  
graph export "./figures/figure_13a.pdf", replace

hist diff_p  [fweight = aweight], width(0.05) start(-1) xlabel(-1(0.25)1) xtitle("Replication p-value minus original p-value") percent ///
 scheme(s1mono) fcolor(orange) lcolor(black)  
graph export "./figures/figure_13b.pdf", replace

hist diff_p if economics==1 , width(0.05) start(-1) xlabel(-1(0.25)1) xtitle("Replication p-value minus original p-value") percent ///
 scheme(s1mono) fcolor(orange) lcolor(black)  
graph export "./figures/figure_13c.pdf", replace

hist diff_p if economics==0 , width(0.05) start(-1) xlabel(-1(0.25)1) xtitle("Replication p-value minus original p-value") percent ///
 scheme(s1mono) fcolor(orange) lcolor(black)  
graph export "./figures/figure_13d.pdf", replace

* figure 14

capture drop o_tstat_switch
gen o_tstat_switch = o_tstat
replace o_tstat_switch = -1*o_tstat_switch if (o_coeff_dbl<0 & r_coeff_dbl>0) | (o_coeff_dbl>0 & r_coeff_dbl<0)

local myvar = "o_tstat_switch"

capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 & `myvar'>0 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph

count if o_tstat_switch<=0
local mynum = r(N)

count if o_tstat!=.
local mydenom = r(N)

replace density1 = (1-(`mynum' / `mydenom'))*density1
replace ci1_1 = (1-(`mynum' / `mydenom'))*ci1_1
replace ci1_2 = (1-(`mynum' / `mydenom'))*ci1_2

capture drop density2 xaxis2 ci2_1 ci2_2
kdens `myvar' if `myvar'<0 & `myvar'>-5 , ll(-5) ul(0) gen(density2 xaxis2) ci(ci2_1 ci2_2) nograph

count if o_tstat_switch<=0
local mynum = r(N)

count if o_tstat!=.
local mydenom = r(N)

replace density2 = (`mynum' / `mydenom')*density2
replace ci2_1 = (`mynum' / `mydenom')*ci2_1
replace ci2_2 = (`mynum' / `mydenom')*ci2_2

twoway ///
(hist `myvar' if `myvar'<5 & `myvar'>-5, width(0.10) start(-5) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)) ///
(line density2 xaxis2, lpattern(solid) lcolor(black)) ///
(rarea ci2_1 ci2_2 xaxis2, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(-2.58 -1.96 -1.65 1.65 1.96 2.58, lwidth(thin)) xline(0, lpattern(dash)) xlabel(-5(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero)) xsize(2) ysize(1) 
graph export "./figures/figure_14a.pdf", replace

capture drop r_tstat_switch
gen r_tstat_switch = r_tstat
replace r_tstat_switch = -1*r_tstat_switch if (o_coeff_dbl<0 & r_coeff_dbl>0) | (o_coeff_dbl>0 & r_coeff_dbl<0)

local myvar = "r_tstat_switch"

capture drop density1 xaxis1 ci1_1 ci1_2
kdens `myvar' if `myvar'<5 & `myvar'>0 , ll(0) ul(5) gen(density1 xaxis1) ci(ci1_1 ci1_2) nograph

count if r_tstat_switch<=0
local mynum = r(N)

count if r_tstat!=.
local mydenom = r(N)

replace density1 = (1-(`mynum' / `mydenom'))*density1
replace ci1_1 = (1-(`mynum' / `mydenom'))*ci1_1
replace ci1_2 = (1-(`mynum' / `mydenom'))*ci1_2

capture drop density2 xaxis2 ci2_1 ci2_2
kdens `myvar' if `myvar'<0 & `myvar'>-5 , ll(-5) ul(0) gen(density2 xaxis2) ci(ci2_1 ci2_2) nograph

count if o_tstat_switch<=0
local mynum = r(N)

count if o_tstat!=.
local mydenom = r(N)

replace density2 = (`mynum' / `mydenom')*density2
replace ci2_1 = (`mynum' / `mydenom')*ci2_1
replace ci2_2 = (`mynum' / `mydenom')*ci2_2

twoway ///
(hist `myvar' if `myvar'<5 & `myvar'>-5, width(0.10) start(-5) fcolor(orange) lcolor(orange)) ///
(line density1 xaxis1, lpattern(solid) lcolor(black)) ///
(rarea ci1_1 ci1_2 xaxis1, color(blue%30) lwidth(none none)) ///
(line density2 xaxis2, lpattern(solid) lcolor(black)) ///
(rarea ci2_1 ci2_2 xaxis2, color(blue%30) lwidth(none none)), ///
xtitle("t-statistic") xline(-2.58 -1.96 -1.65 1.65 1.96 2.58, lwidth(thin)) xline(0, lpattern(dash)) xlabel(-5(1)5) ytitle("Density") legend(off) scheme(s1mono) plotregion(margin(zero)) xsize(2) ysize(1) 
graph export "./figures/figure_14b.pdf", replace

capture drop o_p_switch
gen o_p_switch = o_p_dbl
replace o_p_switch = -1*o_p_switch if (o_coeff_dbl<0 & r_coeff_dbl>0) | (o_coeff_dbl>0 & r_coeff_dbl<0)

hist o_p_switch if (o_p_switch >= -0.15 & o_p_switch<= -0.0025) | (o_p_switch >= 0.0025 & o_p_switch <= 0.15) , width(0.01) start(-0.15) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(-0.15(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) xsize(2) ysize(1) 
graph export "./figures/figure_14c.pdf", replace

capture drop r_p_switch
gen r_p_switch = r_p_dbl
replace r_p_switch = -1*r_p_switch if (o_coeff_dbl<0 & r_coeff_dbl>0) | (o_coeff_dbl>0 & r_coeff_dbl<0)

hist r_p_switch if (r_p_switch >= -0.15 & r_p_switch<= -0.0025) | (r_p_switch >= 0.0025 & r_p_switch <= 0.15) , width(0.01) start(-0.15) fcolor(orange) lcolor(black) xtitle("p-value") xlabel(-0.15(0.05)0.15 ,format(%9.2fc)) scheme(s1mono) xsize(2) ysize(1) 
graph export "./figures/figure_14d.pdf", replace

capture erase temp1.gph
capture erase temp2.gph

graph close

timer off 1

timer list 1
