timer clear 1

timer on 1

	version 16
	
/******************************************************************************/
/* 10-Point Reproducibility Scale */
/******************************************************************************/

/* Note! The 17 Feb 2024 version is slightly different. Double-check your dataset  */
/* Load the dataset in */
*use "./data/Team - Cleaned for I4R - 11 Apr 2024.dta", clear 
use "./data/Team - Cleaned for I4R - 17 Feb 2024.dta", clear 
		
/* Ten-Point Scale for Abel */		
	#delimit ;
	
	histogram ten_point_scale , 
		percent 
		discrete
		width(1)
		start(1)
		color(orange) 
		lcolor(black)
		barwidth(0.8)
		ylabel(0(10)65, grid)  
		ytick(0(10)60) 
		ymtick(5(10)60)
		yscale(titlegap(2.0))
		xlabel( 
			1 "Level 1" 2 "Level 2" 3 "Level 3" 4 "Level 4" 5 "Level 5" 
			6 "Level 6" 7 "Level 7" 8 "Level 8" 9 "Level 9" 10 "Level 10"
			, labsize(small)
		) 
		xscale(titlegap(2.0)) 	
		graphregion(color(white))
		addl
		addlabopts( yvarformat(%9.2f))
		/*
		xline(4.475, lwidth(medthin) lcolor(red))
		xline(4.525, lwidth(medthin) lcolor(navy))
		text( 45 3 "Not Computationally" "Reproducible", color(red))
		text( 45 8 "Computationally" "Reproducible", color(navy))
		*/
	;
	
	/*
	graph export "03 - Figures/ten-point scale - ${date}.png", replace; 	
	graph export "03 - Figures/ten-point scale - ${date}.pdf", replace as(pdf); 	
	*/
	
	#delimit cr

graph export "./figures/figure_5.pdf", replace


	
/******************************************************************************/
// Histogram of Number of Active Days Worked
/******************************************************************************/
/******************************************************************************/

/* Individual Survey - TEAMS */
	use "./data/Individual - One Team - Cleaned - 17 Feb 2024.dta", clear
	
/* Quick Graph for Abel */		
	#delimit ;
	
	histogram team_active_days_censored, 
		percent 
		discrete
		width(5)
		start(0)
		color(orange) 
		lcolor(black)
		ylabel(0(5)40) 	ymtick(0(2.5)40) yscale(titlegap(2.0))
		xlabel(0(10)100 100 "{&ge}100", labsize(small)) xmtick(0(5)100) xscale(titlegap(2.0)) 	xtitle("")
		graphregion(color(white))
		addl
		addlabopts( yvarformat(%9.2f) mlabsize(vsmall))
	;

	/*
	graph export "03 - Figures/team_active_days_fine - ${date}.png", replace; 	
	graph export "03 - Figures/team_active_days_fine - ${date}.pdf", replace as(pdf); 	
	*/
	
	#delimit cr	
	
										graph export  "./figures/figure_7.pdf", replace

	
 
	
/******************************************************************************/
// Why Paper Selected
/******************************************************************************/
	
/* Load the dataset in */
use "./data/Team - Cleaned for I4R - 17 Feb 2024.dta", clear 
	
/* Why Paper Selected */	
	preserve 
	
		foreach x in paper_reason_only paper_reason_sample paper_reason_robust ///
					paper_reason_notrobust paper_reason_read paper_reason_comptime ///
					paper_reason_pkgsize paper_reason_method paper_reason_trust ///
					paper_reason_jrnl paper_reason_confintrst{
						
			replace `x' = `x' * 100		
		}
	
		#delimit ;
	
		graph bar 	paper_reason_only paper_reason_sample paper_reason_robust
					paper_reason_notrobust paper_reason_read paper_reason_comptime
					paper_reason_pkgsize paper_reason_method paper_reason_trust
					paper_reason_jrnl paper_reason_confintrst /*paper_reason_cites*/, 
			/// percent
			ytitle("Percentage of Teams")
			ylabel(0(20)60, grid)
			ytick(0(20)60)
			ymtick(0(10)60)
			legend(
				label(1 "Not given a choice")
				label(2 "Beliefs about statistical power/sample size")
				label(3 "Believe main results are robust")
				label(4 "Believe main results are not robust")
				label(5 "Previously read paper")
				label(6 "Length of time to reproduce results")
				label(7 "Size of replication package")
				label(8 "Methods used")
				label(9 "Trust of original authors")
				label(10 "Journal of publication")
				label(11 "Avoiding conflict of interested")			
				/* label(12 "Number of citations") */
				cols(1)
				size(vsmall)
				position(0)
				bplacement(nwest)
				symysize(small)
				symxsize(small)
			)
			blabel(bar, format(%9.2f))
		;
		
		/*
		graph export "03 - Figures/reasons selected paper - ${date}.png", replace; 	
		graph export "03 - Figures/reasons selected paper - ${date}.pdf", replace as(pdf); 		
		*/	
			
		#delimit cr		
	
	restore 	
graph export "./figures/figure_8.pdf", replace


/******************************************************************************/
// Why Couldn't Do More 
/******************************************************************************/

/* Individual Survey - TEAMS */
use "./data/Team - Cleaned for I4R - 17 Feb 2024.dta", clear 
		
	preserve 
		
		local name_1 "recode vars"
		local name_2 "robustness"
		local name_3 "extensions"
		local name_4 "replications"
		
		local num = 1 
		
		foreach deps in ///
			"recode_no_raw_data recode_no_int_data recode_no_datadict recode_no_docum recode_unclear_pkg recode_unclear_paper" ///
			"robust_no_raw_data robust_no_int_data robust_no_datadict robust_no_docum robust_unclear_pkg robust_unclear_paper" ///
			"exten_no_raw_data exten_no_int_data exten_no_datadict exten_no_docum exten_unclear_pkg exten_unclear_paper" ///
			"rep_data_no_raw_data rep_data_no_int_data rep_data_no_datadict rep_data_no_docum rep_data_unclear_pkg rep_data_unclear_paper" ///
		{
			
				
			foreach x in `deps'{
				replace `x' = 100 * `x'
			}
			
			
			#delimit ;
			
			graph bar `deps'
				, 
				ytitle("Percentage of Teams")
				ylabel(0(5)20, grid)
				ytick(0(5)20)
				ymtick(0(5)20)
				legend(
					label(1 "No raw data")
					label(2 "No intermediate data")
					label(3 "No data dictionary")
					label(4 "Unclear documentation")
					label(5 "Unclear replication package")
					label(6 "Unclear paper")
					cols(1)
					size(small)
					position(0)
					bplacement(neast)
					symysize(small)
					symxsize(small)
				)
				blabel(bar, format(%9.2f))	
			;
			
			/*
			graph export "03 - Figures/Why no more - `name_`num'' - ${date}.png", replace; 	
			graph export "03 - Figures/Why no more - `name_`num'' - ${date}.pdf", replace as(pdf); 		 
			*/	
				
			#delimit cr 		
			
									graph export  "./figures/figure_16_`name_`num''.pdf", replace

			
		// Update the counter for the figure title 	
			local num = `num' + 1 
			
		}	

		gen why_no_more = recode_no_raw_data + recode_no_int_data + recode_no_datadict + recode_no_docum + recode_unclear_pkg + recode_unclear_paper + robust_no_raw_data + robust_no_int_data + robust_no_datadict + robust_no_docum + robust_unclear_pkg + robust_unclear_paper + exten_no_raw_data + exten_no_int_data + exten_no_datadict + exten_no_docum + exten_unclear_pkg + exten_unclear_paper + rep_data_no_raw_data + rep_data_no_int_data + rep_data_no_datadict + rep_data_no_docum + rep_data_unclear_pkg + rep_data_unclear_paper
		
		tab why_no_more 
		
		// 64 out of 110 did not respond 
		di 64 / 110 
	restore 		
		


timer off 1

timer list 1


