
label define vlR0000100 0 "0"  1 "1 TO 999"  1000 "1000 TO 1999"  2000 "2000 TO 2999"  3000 "3000 TO 3999"  4000 "4000 TO 4999"  5000 "5000 TO 5999"  6000 "6000 TO 6999"  7000 "7000 TO 7999"  8000 "8000 TO 8999"  9000 "9000 TO 9999" 
label values R0000100 vlR0000100

label define vlR0320600 1 "Excellent"  2 "Very good"  3 "Good"  4 "Fair"  5 "Poor" 
label values R0320600 vlR0320600

label define vlR0322500 0 "0"  1 "1"  2 "2"  3 "3"  4 "4"  5 "5"  6 "6"  7 "7"  8 "8"  9 "9" 
label values R0322500 vlR0322500

label define vlR0322600 0 "0"  1 "1"  2 "2"  3 "3"  4 "4"  5 "5"  6 "6"  7 "7"  8 "8"  9 "9"  10 "10"  11 "11"  12 "12" 
label values R0322600 vlR0322600

label define vlR0322700 0 "0"  1 "1 TO 49"  50 "50 TO 99"  100 "100 TO 149"  150 "150 TO 199"  200 "200 TO 249"  250 "250 TO 299"  300 "300 TO 349"  350 "350 TO 399"  400 "400 TO 449"  450 "450 TO 499"  500 "500 TO 999999: 500+" 
label values R0322700 vlR0322700

label define vlR0358900 1 "Yes"  0 "No" 
label values R0358900 vlR0358900

label define vlR0359100 0 "0"  1 "1 TO 4"  5 "5 TO 9"  10 "10 TO 14"  15 "15 TO 19"  20 "20 TO 24"  25 "25 TO 29"  30 "30" 
label values R0359100 vlR0359100

label define vlR0536300 1 "Male"  2 "Female"  0 "No Information" 
label values R0536300 vlR0536300

label define vlR0536401 1 "1: January"  2 "2: February"  3 "3: March"  4 "4: April"  5 "5: May"  6 "6: June"  7 "7: July"  8 "8: August"  9 "9: September"  10 "10: October"  11 "11: November"  12 "12: December" 
label values R0536401 vlR0536401

label define vlR1194100 0 "0 TO 11: LESS THAN 12"  12 "12"  13 "13"  14 "14"  15 "15"  16 "16"  17 "17"  18 "18"  19 "19 TO 999: GREATER THAN 18" 
label values R1194100 vlR1194100

label define vlR1205400 0 "0"  1 "1"  2 "2"  3 "3"  4 "4"  5 "5"  6 "6"  7 "7"  8 "8"  9 "9"  10 "10"  11 "11"  12 "12"  13 "13"  14 "14"  15 "15"  16 "16"  17 "17"  18 "18"  19 "19"  20 "20 TO 99: 20+" 
label values R1205400 vlR1205400

label define vlR1235800 1 "Cross-sectional"  0 "Oversample" 
label values R1235800 vlR1235800

label define vlR1482600 1 "Black"  2 "Hispanic"  3 "Mixed Race (Non-Hispanic)"  4 "Non-Black / Non-Hispanic" 
label values R1482600 vlR1482600
/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */
  /* *start* */

  rename R0000100 PUBID_1997 
  rename R0320600 YHEA_100_1997   // YHEA-100
  rename R0322500 YHEA_2000_1997   // YHEA-2000
  rename R0322600 YHEA_2100_1997   // YHEA-2100
  rename R0322700 YHEA_2200_1997   // YHEA-2200
  rename R0358900 YSAQ_369_1997   // YSAQ-369
  rename R0359100 YSAQ_371_1997   // YSAQ-371
  rename R0536300 SEX_1997EX_1997 
  rename R0536401 BDATE_M_1997 
  rename R0536402 BDATE_Y_1997 
  rename R1194100 CV_AGE_INT_DATE_1997 
  rename R1205400 CV_HH_SIZE_1997 
  rename R1235800 CV_SAMPLE_TYPE_1997 
  rename R1482600 RACE_ETHNICITY_1997 


  /* *end* */  
/* To convert variable names to lower case use the TOLOWER command 
 *      (type findit tolower and follow the links to install).
 * TOLOWER VARLIST will change listed variables to lower case; 
 *  TOLOWER without a specified variable list will convert all variables in the dataset to lower case
 */
tolower
