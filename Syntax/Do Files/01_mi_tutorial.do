*************************************************************
** ESTIMATE MULTIPLE IMPUTATION EXAMPLE FOR SHORT TUTORIAL **
*************************************************************

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
	log using 01_mi_tutorial, replace // Begins log
	
** CALL IN DATA
	cd "`mydir'`datadir'"
	use nlsy97_mi_tutorial.dta, clear
	
** INSTALL SCHEMEPACK IF NOT INSTALLED
	capture which schemepack
	if _rc {
		ssc install schemepack
	}

	
** SUMMARY OF MISSINGNESS
	summarize bmi1 male white age1 hhsize1 nmarij1 health1, sep(0) 

	egen nmiss=rowmiss(bmi1 male white age1 hhsize1 nmarij1 health1)

	tabulate nmiss

** RUN LITTLE'S MCAR TEST
	mcartest bmi1 male white age1 hhsize1 nmarij1 health1 // Estimate simple version of Little's Test
	
** LOGISTIC REGRESSION MAR TESTS
	** CREATE DUMMY MISSING FLAG
		gen bmi1_miss = bmi1 == .
	** ESTIMATE LOGISTIC REGRESSION PREMDICTING MISSINGNESS IN BMI
		logit bmi1_miss male white age1 hhsize nmarij1 health1
		
** COMPLETE CASE ANALYSIS
	regress bmi1 male white age1 hhsize1 nmarij1 health1
		
** SETTING IMPUTATION PARAMETERS
	mi set flong
	mi register regular male white age1 hhsize1
	mi register imputed bmi1 nmarij1 health1 
	mi describe
	
** USING MISSTABLE TO SUMMARIZE MISSINGNESS
	mi misstable summarize
	mi misstable patterns
	
** RUNNING THE IMPUTATION MODELS
	mi impute chained (regress) bmi1 (ologit) health1 (poisson) nmarij1 = male ///
	white age1 hhsize1, add(5) rseed(04062025)
	
** HOW ARE THE DIFFERENT DATA SETS STORED?
	tabulate _mi_m
	
** INSPECTING THE HEALTH VARIABLE ACROSS IMPUTED DATA
	tabulate health1 _mi_m, col
	
** DISTRIBUTIONS OF IMPUTED BMI VALUES
	twoway (kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==1) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==2) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==3) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==4) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==5, legend(off) ///
	scheme(gg_tableau)), ///
	xtitle("BMI Value") ytitle("Kernal Density")
	
** TAKING A CLOSER LOOK AT THREE YOUTH'S VALUES
	sort id _mi_m
	list id _mi_m bmi1 male white age1 hhsize1 health1 nmarij1 if id==1220 | ///
	id ==3799 | id==4686, sep(6) compress noobs

** ESTIMATE THE MULTIPLY IMPUTED REGRESSION MODELS
	mi estimate: regress bmi1 male white age1 hhsize1 health1 nmarij1 
	
** GET VARIANCE ESTIMATES
	mi estimate, vartable: regress bmi1 male white age1 hhsize1 health1 nmarij1

** ESTIMATE THE MODELS FOR EACH IMPUTED DATA SET
	forval i = 1/5 {
		di ""
		di ""
		di "This is the model using Imputation #`i'"
		regress bmi1 male white age1 hhsize1 health1 nmarij1 if _mi_m==`i'
		di ""
		di ""
	}
	
