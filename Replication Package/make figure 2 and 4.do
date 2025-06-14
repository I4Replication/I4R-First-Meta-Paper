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

capture drop ratio_coeff
gen ratio_coeff = r_coeff_dbl / o_coeff_dbl if r_coeff_dbl!=. & o_coeff_dbl!=. & o_coeff_dbl!=0

capture drop diff_p
gen diff_p = r_p_dbl - o_p_dbl if r_p_dbl!=. & o_p_dbl!=.

// end preamble

capture drop o_sig
gen o_sig = .
replace o_sig = 1 if o_tstat>=1.96
replace o_sig = 0 if o_tstat< 1.96

capture drop hist_intervals
gen hist_intervals = .
replace hist_intervals = round(r_tstat,1)

// fig_scatter_tstat
// the numbers in myshift are assigned to correspond to colors o

capture drop myshift
gen myshift = .
replace myshift = 1 if !((o_coeff_dbl>0 & r_coeff_dbl<0) | (o_coeff_dbl<0 & r_coeff_dbl>0)) & r_tstat>=1.96 & o_tstat>=1.96 // both sig
replace myshift = 2 if !((o_coeff_dbl>0 & r_coeff_dbl<0) | (o_coeff_dbl<0 & r_coeff_dbl>0)) & r_tstat< 1.96 & o_tstat>=1.96 // was sig now isnt
replace myshift = 3 if !((o_coeff_dbl>0 & r_coeff_dbl<0) | (o_coeff_dbl<0 & r_coeff_dbl>0)) & r_tstat< 1.96 & o_tstat< 1.96 // both not sig
replace myshift = 4 if !((o_coeff_dbl>0 & r_coeff_dbl<0) | (o_coeff_dbl<0 & r_coeff_dbl>0)) & r_tstat>=1.96 & o_tstat< 1.96 // was not sig now is
replace myshift = 5 if  ((o_coeff_dbl>0 & r_coeff_dbl<0) | (o_coeff_dbl<0 & r_coeff_dbl>0)) // switchers

label var o_tstat "Publication t-statistic"
label var r_tstat "Replication t-statistic"

twoway ///
(scatter r_tstat o_tstat if r_tstat<=4 & o_tstat<=4 & myshift==1, ylabel(0 1 1.96 3 4, nogrid) xlabel(0 1 1.96 3 4, nogrid) msize(tiny) xline(1.96) yline(1.96) mcolor(blue%30) msymbol(circle)) /// 
(scatter r_tstat o_tstat if r_tstat<=4 & o_tstat<=4 & myshift==2, ylabel(0 1 1.96 3 4, nogrid) xlabel(0 1 1.96 3 4, nogrid) msize(tiny) xline(1.96) yline(1.96) mcolor(red%30) msymbol(triangle)) /// 
(scatter r_tstat o_tstat if r_tstat<=4 & o_tstat<=4 & myshift==3, ylabel(0 1 1.96 3 4, nogrid) xlabel(0 1 1.96 3 4, nogrid) msize(tiny) xline(1.96) yline(1.96) mcolor(green%30) msymbol(square)) /// 
(scatter r_tstat o_tstat if r_tstat<=4 & o_tstat<=4 & myshift==4, ylabel(0 1 1.96 3 4, nogrid) xlabel(0 1 1.96 3 4, nogrid) msize(tiny) xline(1.96) yline(1.96) mcolor(purple%30) msymbol(diamond)) ///
 , saving(scatter.gph, replace) legend(off)
 
graph pie , over(myshift) saving(temp_pie, replace) legend(off) fxsize(25) fysize(25) ///
pie(1, color(blue)) 	plabel(1 percent, format(%9.0fc) gap(0) color(white)) ///
pie(2, color(red))		plabel(2 percent, format(%9.0fc) gap(0) color(white)) ///
pie(3, color(green)) 	plabel(3 percent, format(%9.0fc) gap(0) color(white)) ///
pie(4, color(purple)) 	plabel(4 percent, format(%9.0fc) gap(26)) ///
pie(5, color(yellow))	plabel(5 percent, format(%9.0fc) gap(26))
 
twoway hist o_tstat if o_tstat<=4, start(0) width(0.14) saving(hist_x, replace) xlabel(, nogrid nolabels noticks) xtitle("") xscale(lstyle(none)) xline(1.96) fcolor(gray%30) lcolor(gray%30) ylabel(0 0.1 0.2 0.3 0.4 0.5, nogrid) fysize(25)

twoway hist r_tstat if r_tstat<=4, start(0) width(0.14) saving(hist_y, replace) ylabel(, nogrid nolabels noticks) ytitle("") yscale(lstyle(none)) yline(1.96) fcolor(gray%30) lcolor(gray%30) xlabel(0 0.1 0.2 0.3 0.4 0.5, nogrid) fxsize(25) horiz

graph combine hist_x.gph   scatter.gph hist_y.gph, hole(2) imargin(0 0 0 0) xsize(1) ysize(1) graphregion(margin())
graph export "./figures/figure_2.pdf", replace


// fig_scatter_effect

capture drop paper_avg_o_coeff
bysort paper_title: egen paper_avg_o_coeff = mean(o_coeff_dbl)

capture drop o_coeff_scaled
gen o_coeff_scaled = o_coeff_dbl / paper_avg_o_coeff
label var o_coeff_scaled "Publication Effect Size"

capture drop r_coeff_scaled
gen r_coeff_scaled = r_coeff_dbl / paper_avg_o_coeff
label var r_coeff_scaled "Replication Effect Size"

capture drop my_ratio
gen my_ratio  = r_coeff_scaled / o_coeff_scaled 
sum my_ratio if abs(r_coeff_scaled)<10 & abs(o_coeff_scaled)<10 , detail 

capture drop myshift
gen myshift = .
replace myshift = 1 if !((r_coeff_scaled>0 & o_coeff_scaled<0) | (r_coeff_scaled<0 & o_coeff_scaled>0)) & abs(r_coeff_scaled/o_coeff_scaled)>0.5 // no switch, keeps at least 50% effect size
replace myshift = 2 if !((r_coeff_scaled>0 & o_coeff_scaled<0) | (r_coeff_scaled<0 & o_coeff_scaled>0)) & abs(r_coeff_scaled/o_coeff_scaled)<0.5 // no switch, loses at least 50% effect size
replace myshift = 3 if !((r_coeff_scaled>0 & o_coeff_scaled<0) | (r_coeff_scaled<0 & o_coeff_scaled>0)) & abs(r_coeff_scaled/o_coeff_scaled)>2 // no switch, replication is doublr
replace myshift = 4 if  ((r_coeff_scaled>0 & o_coeff_scaled<0) | (r_coeff_scaled<0 & o_coeff_scaled>0)) // switchers

graph pie , over(myshift) saving(temp_pie, replace) legend(off) fxsize(25) fysize(25) ///
pie(1, color(blue)) 	plabel(1 percent, format(%9.0fc) gap(0) color(white)) ///
pie(2, color(orange))		plabel(2 percent, format(%9.0fc) gap(0) color(white)) ///
pie(3, color(purple)) 	plabel(3 percent, format(%9.0fc) gap(0) color(white)) ///
pie(4, color(yellow)) 	plabel(4 percent, format(%9.0fc) gap(26) color(black)) 

twoway /// 
(scatter r_coeff_scaled o_coeff_scaled if abs(r_coeff_scaled)<10 & abs(o_coeff_scaled)<10 & myshift==1 , ylabel(, nogrid) xlabel(, nogrid) msize(tiny) mcolor(blue%30) msymbol(circle)) /// regular
(scatter r_coeff_scaled o_coeff_scaled if abs(r_coeff_scaled)<10 & abs(o_coeff_scaled)<10 & myshift==2 , ylabel(, nogrid) xlabel(, nogrid) msize(tiny) msize(tiny)  mcolor(orange%30) msymbol(triangle)) /// reduced effect
(scatter r_coeff_scaled o_coeff_scaled if abs(r_coeff_scaled)<10 & abs(o_coeff_scaled)<10 & myshift==3 , ylabel(, nogrid) xlabel(, nogrid) msize(tiny) msize(tiny)  mcolor(purple%30) msymbol(square)) /// enhanced effect
(scatter r_coeff_scaled o_coeff_scaled if abs(r_coeff_scaled)<10 & abs(o_coeff_scaled)<10 & myshift==4 , ylabel(, nogrid) xlabel(, nogrid) msize(tiny) msize(tiny)  mcolor(red) msymbol(diamond)) /// sign flippers
, saving(scatter.gph, replace) legend(off) xline(0) yline(0) xsize(1) ysize(1) xtitle("Publication Effect Size (Standardized)") ytitle("Replication Effect Size (Standardized)")

twoway hist o_coeff_scaled if abs(o_coeff_scaled)<=10, start(-10) width(1) saving(o, replace) xlabel(, nogrid nolabels noticks) xtitle("") ytitle("Density") xscale(lstyle(none)) xline(0) fcolor(gray%30) lcolor(gray%30) ylabel(, nogrid) fysize(25)

twoway hist r_coeff_scaled if abs(r_coeff_scaled)<=10, start(-10) width(1) saving(r, replace) ylabel(, nogrid nolabels noticks) ytitle("") xtitle("Density") yscale(lstyle(none)) yline(0) fcolor(gray%30) lcolor(gray%30) xlabel(, nogrid) fxsize(25) horiz

graph combine o.gph  scatter.gph r.gph, hole(2) imargin(0 0 0 0) xsize(1) ysize(1) graphregion(margin())
graph export "./figures/figure_4.pdf", replace

capture graph close

capture erase hist_x.gph
capture erase hist_y.gph
capture erase o.gph
capture erase r.gph
capture erase scatter.gph
capture erase temp_pie.gph

timer off 1

timer list 1
