***********************************************************
** CLEAN UP NLSY97 DATA FILE FOR IMPUTATION PRESENTATION **
***********************************************************

** SCREW UP LOOP
	clear *
	cap log close
	
** BEGIN LOG FILE
	cd "G:\My Drive\GitHub Projects\Missing-Data-Imputation\Logs"
	log using 00_mi_tutorial, replace
	
** INFILE DICTIONARY FILE PROVIDED BY NLS EXPLORER	
	cd "G:\My Drive\GitHub Projects\Missing-Data-Imputation\Syntax\Cleanup Do Files"
	infile using default.dct
	
** APPLY LABEL VALUES FROM NLS EXPLORER-PROVIDED DO FILE
	do default-value-labels.do
	
** RENAME VARIABLES
	ren (yhea_100_1997 yhea_2000_1997 yhea_2100_1997 yhea_2200_1997 sex_1997 ///
	bdate_m_1997 bdate_y_1997 cv_hh_size_1997 race_ethnicity_1997 ///
	cv_age_int_date_1997 ysaq_371_1997 ysaq_369_1997) ///
	(health feet inches weight male birth_month birth_year hh_size race age ///
	n_marij ever_marij)
	
** FIX MARIJUANA VARIABLE
	replace n_marij = 0 if ever_marij==0
	
** REPLACE NEGATIVE VALUES WITH MISSINGS
	foreach var of varlist _all {
		replace `var' = . if `var'<0
	}
	
** COMPUTE BMI
	replace inches = inches + (feet*12)
	gen bmi = (weight*703)/(inches^2)
	
** FIX MALE VAR
	tempvar t1
	gen `t1' = male == 1
	drop male
	gen male = `t1'
	
** CREATE WHITE VAR
	gen white = race == 4
	
** LABEL VARS
	lab var bmi "Body mass index"
	lab var male "=1 if respondent is male"
	lab var white "=1 if respondent is white, non-Hispanic"
	lab var age "Age (in discrete years) at first interview"
	lab var hh_size "Household size (1 to 16)"
	lab var health "Self-report rating of health (1 to 5)"
	lab var n_marij "N of days used marijuana in past 30 days"
	
** KEEP ONLY NEEDED VARS
	keep bmi male white age hh_size health n_marij
	
** CLEAN UP
	aorder
	
** SAVE NEW DATA FILE
	cd "G:\My Drive\GitHub Projects\Missing-Data-Imputation\Data"
	save nlsy97_mi_tutorial.dta, replace
	
** CLOSE LOG
	cap log close
	