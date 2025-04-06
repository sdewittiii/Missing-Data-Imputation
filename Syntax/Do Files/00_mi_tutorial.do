***********************************************************
** CLEAN UP NLSY97 DATA FILE FOR IMPUTATION PRESENTATION **
***********************************************************

** SCREW UP LOOP
	clear *
	cap log close
	
** SET DIRECTORIES
	local mydir "G:\My Drive\GitHub Projects" // After downloading folder, change to root directory you store it (easiest is just your Donwloads folder)
	local logdir "\Missing-Data-Imputation\Logs" // Always good practice to keep logs of your Stata programs
	local datadir "\Missing-Data-Imputation\Data" // Where your data goes
	local dictdir "\Missing-Data-Imputation\Syntax\Do Files\From NLS Explorer" // Need to use these to process data from NLS explorer
	
** BEGIN LOG FILE
	cd "`mydir'`logdir'" // Uses local macros defined above to change directory
	log using 00_mi_tutorial, replace // Begins log
	
** INFILE DICTIONARY FILE PROVIDED BY NLS EXPLORER	
	cd "`mydir'`dictdir'" // Uses local macros defined above to change directory
	infile using default.dct // This calls a dictionary file that reads in text data
	
** APPLY LABEL VALUES FROM NLS EXPLORER-PROVIDED DO FILE
	do default-value-labels.do // Processes the label do file NLS Explorer provides
	
** RENAME VARIABLES
	ren (pubid_1997 yhea_100_1997 yhea_2000_1997 yhea_2100_1997 yhea_2200_1997 ///
	sex_1997 bdate_m_1997 bdate_y_1997 cv_hh_size_1997 race_ethnicity_1997 ///
	cv_age_int_date_1997 ysaq_371_1997 ysaq_369_1997) ///
	(id health1 feet inches weight male birth_month birth_year hhsize1 race age1 ///
	nmarij1 ever_marij) // Renaming NLS variable names
	
** FIX MARIJUANA VARIABLE
	replace nmarij = 0 if ever_marij==0 // Filling in valid zeroes for marijuana count variable
	
** REPLACE NEGATIVE VALUES WITH MISSINGS
	foreach var of varlist _all {
		replace `var' = . if `var'<0 
	}
	/* Missing values in the NLSY97 are generally negative, assigning them all 
	to missing here. Wouldn't use this as a general practice with these data
	as "Valid Skips" are assigned values of -4 and they do have true values like
	the marijuana count variable has above (all the 0s I added were for rows
	with -4 values) */
	
** COMPUTE BMI
	replace inches = inches + (feet*12) // They store height in two variables
	gen bmi1 = (weight*703)/(inches^2) // Compute bmi
	
** FIX MALE VAR
	tempvar t1
	gen `t1' = male == 1
	drop male
	gen male = `t1' // Old example just flagged male with dummy variable
	
** CREATE WHITE VAR
	gen white = race == 4 // Shortcut syntax to make a dummy variable
	
** LABEL VARS
	lab var id "Unique NLSY97 ID"
	lab var bmi1 "Body mass index"
	lab var male "=1 if respondent is male"
	lab var white "=1 if respondent is white, non-Hispanic"
	lab var age1 "Age (in discrete years) at first interview"
	lab var hhsize1 "Household size (1 to 16)"
	lab var health1 "Self-report rating of health (1 to 5)"
	lab var nmarij1 "N of days used marijuana in past 30 days"
	
** KEEP ONLY NEEDED VARS
	keep id bmi1 male white age1 hhsize1 health1 nmarij1 // Dropping all other vars to clean up the workspace
	
** CLEAN UP
	aorder // More cleanup
	
** SAVE NEW DATA FILE
	cd "`mydir'`datadir'" // Use locals to change directory
	save nlsy97_mi_tutorial.dta, replace // Save new data
	
** CLOSE LOG
	cap log close // Close log file
	