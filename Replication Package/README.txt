1. System Requirements

1a. All software dependencies and operating systems (including version numbers)

	StataNow 19.5 (Basic Edition)(will work with older versions)

	ssc install estout
	ssc install coefplot
	ssc install kdens
	ssc install moremata
	ssc install tabout

	R 4.3.1 (will work with older versions)

	install.packages("NlcOptim")
	install.packages("fdrtool")
	install.packages("pracma")
	install.packages("gdata")
	install.packages("spatstat")
	install.packages("rddensity")
	install.packages("ggplot2")
	install.packages("gtools")

	install.packages("shiny")
	install.packages("methods")

1b. Versions the software has been tested on

	macOS Monterey 12.2.1
	StataNow 19.5 (Basic Edition)
	R version 4.3.1 "Beagle Scouts"
1c. Any required non-standard hardware

	There is no non-standard hardware required.
2. Installation guide
2a. Instructions

	Installation of Stata requires a license from StataCorp. 
	Installation of R requires a free download from r-project.org

2b. Typical install time on a "normal" desktop computer

	Installation of Stata and R is nominal for each, < 10 mins.

3. Demo

3a. Instructions to run on data

	For figure 1, run "make figure 1.do"
	For figure 2 and 4, run "make figure 2 and 4.do"
	For figure 3, run "make figure 3.do"
	For figure 5 7 8 and 16 run "make figure 5 7 8 16.do"
	For figure 6 9 and 10 run "make figure 6 9 10.do"
	For figure 11 12 13 and 14 run "make figure 11 12 13 14.do"

	For figure 15 "Applying Elliot et al. (2022)"
	Go to the folder "figure 15"
	Run file "1 prepare input data.do"
	3 .csv fles should be generated.
	Now run "2 run elliot at 5.R"
	3 figures (.pdf format) should now be generated in this folder.
	The "Tests.R" script should not be touched, it is a dependenancy for the above script.
	There will also be writing to a file called "table_elliot.csv" which contains the p values of the tests in the image.	

	For table 1 14 15 and 17, run "make table 1 14 15 17.do"
	Tables 2, 3, 4, 5, are made by hand.
	For table 6 7 8 9, run "make table 6 7 8 9.do"

	For table 16 "Applying Andrews and Kasy (2019)"
	Go to the folder "Table 16"
	Run file "1 prepare input data.do"
	6 .csv files should be generated.
	Now run "app.R"
	This is an R shiny app provided by Andrews and Kasy (2019).
	Using the graphical user interface, with the following options selected (symmetric, 1.65 1.96 2.58, student-t), hit browse and navigate to each of the csv;s just generated. Select one. Wait until the "v" figure is updated. Then press "estimate model." The bottom half of the app will populate after a couple of seconds. These are the numbers transcribed into Table 16 by hand.	
	
3b. Expected Output

	If all do files are executed, 35 .pdf files in the "figures" folder.
	If all do files are executed, 12 .tex files in the "tables" folder.
	If the figure 15 do file and R script are executed, in that folder, there will be 3 figures and 1 csv table.

3c. Expected run time for demo on a "normal" desktop computer

	"make figure 1.do" 6.2 seconds
	"make figure 2 and 4.do" 5.6 seconds
	"make figure 3.do" 1.0 seconds
	"make figure 5 7 8 16.do" 3.3 seconds
	"make figure 6 9 10.do" 4.3 seconds
	"make figure 11 12 13 14.do" 13.2 seconds

	figure 15 in total < 1 min

	"make table 1 14 15 17.do" 0.9 seconds
	"make table 6 7 8 9.do" 0.08 seconds

	table 16 in total < 1 min

	total < 10 minutes

4. Instructions for Use

4a. How to run the software on your data

	The replication folder contains a series of .do files in the top level. Each of these do files are self contained, and will produce the indicated tables in Stata. When using Stata, regardless of MacOS or Windows, double click on the .do file that is named for the figure you wish to generate. Then click "execute". Tables 1, 6-10,14,15,17 are made in Stata. Figures 1-14 & 16 are made in Stata. For Figure 15 and Table 16, Stata is used then R, please see 3a for exact steps.	

4b. (Optional) Reproduction instructions

See 4a. 