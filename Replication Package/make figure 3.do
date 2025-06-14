timer clear 1

timer on 1

use "./data/many_analysts.dta", clear

datasignature

assert r(datasignature) == "772:9(76396):3478938799:4036207548" 

// summary table
// columns are , where columns are variables and rows are research questions

capture drop pos_sig
gen pos_sig = 0
replace pos_sig = 1 if sign=="+" & pv < 0.05

capture drop pos_not_sig
gen pos_not_sig = 0
replace pos_not_sig = 1 if sign=="+" & pv >= 0.05

capture drop neg_sig
gen neg_sig = 0
replace neg_sig = -1 if sign=="-" & pv < 0.05

capture drop neg_not_sig
gen neg_not_sig = 0
replace neg_not_sig = -1 if sign=="-" & pv >= 0.05

capture drop prop_yes
gen prop_yes = 0
replace prop_yes = 2 if opinion=="Yes"

capture drop rowtotal
egen rowtotal = rowtotal(pos_sig pos_not_sig neg_sig neg_not_sig)
sum rowtotal
*assert r(mean)==1

capture drop category
gen category = .
replace category = 4 if pos_sig == 1
replace category = 3 if pos_not_sig == 1
replace category = 1 if neg_sig == 1
replace category = 2 if neg_not_sig == 1

label var research_question "RQ"
label var category "Category"

label define category_value 4 "Pos. & Sig." 3 "Pos. & Not Sig." 1 "Neg. & Sig." 2 "Neg. & Not Sig.", replace
label values category category_value
  
capture drop team_weight
bysort team research_question dep_var : egen team_weight = count(team)
gen inv_weight = 1/team_weight
tab research_question category [aweight=inv_weight], row nofreq 
 
replace research_question = "1 Replicator Experience (Coding)" if research_question=="1"
replace research_question = "2 Replicator Experience (Academic)" if research_question=="2"
replace research_question = "3 Author Experience" if research_question=="3"
replace research_question = "4a Author Exp. > Rep. Exp." if research_question=="4a"
replace research_question = "4b Author Exp. = Rep. Exp." if research_question=="4b"
replace research_question = "4c Author Exp. < Rep. Exp." if research_question=="4c"
replace research_question = "5a Author Prestige > Rep. Prestige" if research_question=="5a"
replace research_question = "5b Author Prestige = Rep. Prestige" if research_question=="5b"
replace research_question = "5c Author Prestige < Rep. Prestige" if research_question=="5c"
replace research_question = "6 Raw Data Provided" if research_question=="6"
replace research_question = "7 Raw or Intermediate Data Prov." if research_question=="7"
replace research_question = "8 Intermediate Code Provided" if research_question=="8"

capture drop irq
encode research_question, gen(irq)

graph bar (mean) pos_not_sig pos_sig  neg_not_sig neg_sig [aweight=inv_weight] if dep_var==1  , over(irq) stack horizontal bar(4, color(blue) lcolor(black) lpattern(dash)) bar(2, color(red) lcolor(black)) bar(1, color(gray)) bar(3, color(gray)) ylabel(-1(0.5)1) yline(0) legend(off) ytitle("Original {it:p} {&le} 0.05") 
graph export "./figures/figure_3_a.pdf", replace

graph bar (mean) pos_not_sig pos_sig  neg_not_sig neg_sig [aweight=inv_weight] if dep_var==3  , over(irq, axis(off)) stack horizontal bar(4, color(blue) lcolor(black) lpattern(dash)) bar(2, color(red) lcolor(black)) bar(1, color(gray)) bar(3, color(gray)) ylabel(-1(0.5)1) yline(0) legend(off) ytitle("Original {it:p} > 0.05")  

graph export "./figures/figure_3_b.pdf", replace

capture graph close

timer off 1

timer list 1
