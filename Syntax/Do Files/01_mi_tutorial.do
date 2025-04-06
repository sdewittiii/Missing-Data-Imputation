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
		ssc install schemepack // This installs schemepack if not already installed. Just using it for a figure below
	}

** SUMMARY OF MISSINGNESS
	summarize bmi1 male white age1 hhsize1 nmarij1 health1, sep(0) // Summarize variables in data
	
	egen nmiss=rowmiss(bmi1 male white age1 hhsize1 nmarij1 health1) // Count missing obs across rows

	tabulate nmiss // Tab missing value count

** RUN LITTLE'S MCAR TEST
	mcartest bmi1 male white age1 hhsize1 nmarij1 health1 // Estimate simple version of Little's Test
	
** LOGISTIC REGRESSION MAR TESTS
	** CREATE DUMMY MISSING FLAG
		gen bmi1_miss = bmi1 == . // Shortcut syntax for dummy variable
	** ESTIMATE LOGISTIC REGRESSION PREMDICTING MISSINGNESS IN BMI
		logit bmi1_miss male white age1 hhsize nmarij1 health1 // Estimate logistic regression predicting missingness in bmi1 
		
** COMPLETE CASE ANALYSIS
	regress bmi1 male white age1 hhsize1 nmarij1 health1 // Estimate regression using listwise deletion
		
** SETTING IMPUTATION PARAMETERS
	mi set flong // Sets how to store MI data - long means to append at the end of current data set 
	mi register regular male white age1 hhsize1 // Register variables without missing data 
	mi register imputed bmi1 nmarij1 health1 // Register variables with missing data
	mi describe
	
** USING MISSTABLE TO SUMMARIZE MISSINGNESS
	mi misstable summarize // Use misstable to summarize what variables are missing data 
	mi misstable patterns // Use misstable to show patterns - 1s indicate missing, 0s are nonmissing
	
** RUNNING THE IMPUTATION MODELS
	mi impute chained (regress) bmi1 (ologit) health1 (poisson) nmarij1 = male ///
	white age1 hhsize1, add(5) rseed(04062025) 
	/* This runs the MICE function, specifying OLS to impute missing values in
	bmi1, ordered logistic regression to predict missing values in health1, and 
	a Poisson model to predict missing variables in nmarij1. Note that "chained"
	here means ordering of the conditional models matters - first missing values
	of health are imputed, then the new health1 variable with its imputed values
	is used to impute missing values for nmarij1, and then helath1 and nmarij1 
	with their imputed values are used to impute missing values for bmi1. */
	
** HOW ARE THE DIFFERENT DATA SETS STORED?
	tabulate _mi_m // Just shows that there are now six data sets in storage, 5 with imputed values and the original
	
** INSPECTING THE HEALTH VARIABLE ACROSS IMPUTED DATA
	tabulate health1 _mi_m, col // Another way to look across data sets - see that the original data sets has missing values for health1 whereas the imputed data sets do not
	
** DISTRIBUTIONS OF IMPUTED BMI VALUES
	twoway (kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==1) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==2) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==3) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==4) ///
	(kdensity bmi1 if bmi1>15 & bmi1<35 & _mi_m==5, legend(off) ///
	scheme(gg_tableau)), ///
	xtitle("BMI Value") ytitle("Kernel Density")
	/* Stacking multiple kernel density plots to show that the distributions of 
	BMI are very similar across imputations. */
	
** TAKING A CLOSER LOOK AT THREE YOUTH'S VALUES
	sort id _mi_m
	list id _mi_m bmi1 male white age1 hhsize1 health1 nmarij1 if id==1220 | ///
	id ==3799 | id==4686, sep(6) compress noobs
	/* It's helpful to take a closer look at a few different observations with 
	similar values on non-missing variables. Despite using similar values to 
	impute missing BMI, the random perturbations introduced into the imputation
	procedure result in different imputed values for each of these youth. */

** ESTIMATE THE MULTIPLY IMPUTED REGRESSION MODELS
	mi estimate: regress bmi1 male white age1 hhsize1 health1 nmarij1  // This gives us averaged results across the imputed data sets
	
** GET VARIANCE ESTIMATES
	mi estimate, vartable: regress bmi1 male white age1 hhsize1 health1 nmarij1 
	/* Using the vartable option will get you the within and between imputation 
	variance for each coefficient - note where the option appears! */

** ESTIMATE THE MODELS FOR EACH IMPUTED DATA SET
	forval i = 1/5 {
		di ""
		di ""
		di "This is the model using Imputation #`i'"
		regress bmi1 male white age1 hhsize1 health1 nmarij1 if _mi_m==`i'
		di ""
		di ""
	}
	/* Just used a forvalues loop to get regression out put for each imputation 
	for slide 27. */ 
	
** CLOSE LOG
	cap log close
	
