// table 6 7 8 9
timer clear 1

timer on 1

use "./data/many_analysts.dta", clear

datasignature

assert r(datasignature) == "772:9(76396):3478938799:4036207548"

capture drop pos_sig
gen pos_sig = 0
replace pos_sig = 1 if sign=="+" & pv < 0.05

capture drop pos_not_sig
gen pos_not_sig = 0
replace pos_not_sig = 1 if sign=="+" & pv >= 0.05

capture drop neg_sig
gen neg_sig = 0
replace neg_sig = 1 if sign=="-" & pv < 0.05

capture drop neg_not_sig
gen neg_not_sig = 0
replace neg_not_sig = 1 if sign=="-" & pv >= 0.05

capture drop prop_yes
gen prop_yes = 0
replace prop_yes = 1 if opinion=="Yes"

capture drop rowtotal
egen rowtotal = rowtotal(pos_sig pos_not_sig neg_sig neg_not_sig)
sum rowtotal
assert r(mean)==1

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
 
forvalues i = 1(1)4 {
preserve
keep if dep_var==`i'
capture drop team_weight
bysort team research_question dep_var : egen team_weight = count(team)
gen inv_weight = 1/team_weight
tab research_question category [aweight=inv_weight], row nofreq 

tabout research_question category using "./tables/tab_many_analysts_dv_`i'_row.tex" [aweight=inv_weight], cells(row) format(2) nwt() ptotal(none) replace style(tex) ///
botf(latex_table_bottom.tex) topf(latex_table_top.tex) h3(%) 

restore
}

capture erase "./tables/table_6.tex" 
capture erase "./tables/table_7.tex" 
capture erase "./tables/table_8.tex" 
capture erase "./tables/table_9.tex" 

_renamefile "./tables/tab_many_analysts_dv_1_row.tex" "./tables/table_6.tex" 
_renamefile "./tables/tab_many_analysts_dv_2_row.tex" "./tables/table_7.tex" 
_renamefile "./tables/tab_many_analysts_dv_3_row.tex" "./tables/table_8.tex" 
_renamefile "./tables/tab_many_analysts_dv_4_row.tex" "./tables/table_9.tex" 

* table 10

forvalues i = 1(1)4 {
preserve
keep if dep_var==`i'
keep if opinion=="Yes"
capture drop team_weight
bysort team research_question dep_var : egen team_weight = count(team)
gen inv_weight = 1/team_weight
tab research_question category [aweight=inv_weight], row nofreq  

tabout research_question category using "./tables/tab_many_analysts_dv_`i'_row_if_opinion.tex" [aweight=inv_weight], cells(row) format(2) nwt() ptotal(none) replace style(tex) ///
botf(latex_table_bottom.tex) topf(latex_table_top.tex) h3(%) 

restore
}

capture erase "./tables/table_10a.tex" 
capture erase "./tables/table_10b.tex" 
capture erase "./tables/table_10c.tex" 
capture erase "./tables/table_10d.tex" 

_renamefile "./tables/tab_many_analysts_dv_1_row_if_opinion.tex" "./tables/table_10a.tex" 
_renamefile "./tables/tab_many_analysts_dv_2_row_if_opinion.tex" "./tables/table_10b.tex" 
_renamefile "./tables/tab_many_analysts_dv_3_row_if_opinion.tex" "./tables/table_10c.tex" 
_renamefile "./tables/tab_many_analysts_dv_4_row_if_opinion.tex" "./tables/table_10d.tex" 

timer off 1

timer list 1
