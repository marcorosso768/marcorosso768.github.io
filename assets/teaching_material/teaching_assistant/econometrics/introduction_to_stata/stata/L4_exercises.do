* =============================================================================
* LECTURE 4 - LINEAR REGRESSION (OLS)
* Course:   Introduction to Stata (4 lectures)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Handbook: Introduction to Stata, Chapter 8 (and 4.5 factor variables)
* Data:     Banca d'Italia, Indagine sui bilanci delle famiglie italiane (SHIW),
*           historical archive, version 12.2
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: exercises. Write your code below each task; run it block by block.
* =============================================================================

/*
   WHERE WE ARE
   Lecture 3 saved data/clean/shiw_2022.dta (households, 2022, with the
   estimation sample) and Lecture 2 individuals_full.dta (persons). If a file
   is missing, run L2_solutions.do and L3_solutions.do first.

   TODAY: estimate, read and interpret
       ln(income) = b0 + b1 * schooling + b2 * age + b3 * age^2 + ... + u
   then robust standard errors, predictions, tests, diagnostics and a table
   for a paper.
*/


* =============================================================================
* PART 1 - DEMONSTRATION
* =============================================================================

* =============================================================================
* SECTION 0: SETUP
* =============================================================================

clear all
set more off
version 19
* If $root is already set (e.g. by a master do-file) it is kept.
if "$root" == "" global root "C:/path/to/Stata_Lectures_2026"   // <- CHANGE THIS LINE
global raw     "$root/data/raw"
global clean   "$root/data/clean"
global figures "$root/output/figures"
global tables  "$root/output/tables"
global logs    "$root/log"
cd "$root"
capture log close
log using "$logs/L4.log", text replace

foreach f in shiw_2022 individuals_full {
    capture confirm file "$clean/`f'.dta"
    if _rc != 0 {
        display as error "`f'.dta not found: run L2_solutions.do and L3_solutions.do first"
        exit 601
    }
}
set scheme stcolor

use "$clean/shiw_2022.dta", clear
keep if sample == 1


* =============================================================================
* SECTION 1: SIMPLE REGRESSION AND THE OUTPUT (Handbook 8.1, 8.2)
* =============================================================================

* 1.1 regress depvar indepvars

regress ln_y_eq head_educ_years
* Read: Number of obs (compare with the dataset), F and Prob > F, R-squared,
* Root MSE, then for each coefficient: estimate, std. err., t, p-value, CI.

* 1.2 The slope is a rescaled correlation; R2 is the squared correlation

* Stored results: _b[] coefficients, e() estimation results (Handbook 8.8).
scalar b_ols = _b[head_educ_years]
scalar r2_ols = e(r2)
quietly correlate ln_y_eq head_educ_years
display "OLS slope: " b_ols "   rho^2: " r(rho)^2 "   R2: " r2_ols

* 1.3 Interpretation in a log-level model (Handbook 8.3)

* One more year of schooling of the main earner is associated with about
* 100*b percent higher equivalised income.
display "Approximate %: " 100 * _b[head_educ_years] ///
        "   exact %: " 100 * (exp(_b[head_educ_years]) - 1)


* =============================================================================
* SECTION 2: MULTIPLE REGRESSION AND FACTOR VARIABLES (Handbook 4.5, 8.3)
* =============================================================================

* 2.1 More regressors

* c. = continuous, i. = categorical (one dummy per category minus the base),
* ## = all terms of the interaction: c.head_age##c.head_age = age and age^2.
regress ln_y_eq head_educ_years c.head_age##c.head_age hhsize ///
        i.head_female i.area3
* The coefficient of schooling is now "holding age, household size, sex and
* area constant".

* 2.2 Dummies in a log-level model

* Exact percentage difference between households with a female and a male
* main earner, other regressors constant.
display "Female main earner: " 100 * (exp(_b[1.head_female]) - 1) " %"
* The base category of area3 is North (1): each area coefficient is the
* difference with the North.


* =============================================================================
* SECTION 3: ROBUST STANDARD ERRORS (Handbook 8.4)
* =============================================================================

* 3.1 vce(robust)

* Same coefficients, different standard errors.
regress ln_y_eq head_educ_years c.head_age##c.head_age hhsize ///
        i.head_female i.area3, vce(robust)
* vce(cluster ireg) would allow correlation within regions, but with only 20
* clusters these standard errors are unreliable (Handbook 8.4).


* =============================================================================
* SECTION 4: PREDICTIONS, TESTS, TABLES (Handbook 8.5, 8.6, 8.9)
* =============================================================================

* 4.1 Fitted values and residuals

* if e(sample): only the observations used in the estimation.
predict ln_y_hat if e(sample), xb
predict u_hat if e(sample), residuals
summarize ln_y_eq ln_y_hat u_hat

* 4.2 Tests after the regression

* H0: no difference across macro areas (joint test of the area dummies).
testparm i.area3
* H0: the coefficients of Centre and South are equal.
test 2.area3 = 3.area3
* lincom: size and confidence interval of a combination of coefficients.
lincom 3.area3 - 2.area3

* 4.3 Store the models and build a table

quietly regress ln_y_eq head_educ_years, vce(robust)
estimates store m1
quietly regress ln_y_eq head_educ_years c.head_age##c.head_age hhsize, vce(robust)
estimates store m2
quietly regress ln_y_eq head_educ_years c.head_age##c.head_age hhsize ///
        i.head_female i.area3, vce(robust)
estimates store m3
* etable (Stata 17+): no installation needed.
etable, estimates(m1 m2 m3) column(estimates) mstat(N) mstat(r2) ///
        showstars showstarsnote
* The age-squared coefficient shows as -0.000 with 3 decimals: change the
* format of coefficients and standard errors, then export.
collect style cell result[_r_b _r_se], nformat(%9.4f)
collect preview
collect export "$tables/ols_households.tex", replace


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (10 min) - Levels or logs? (Handbook 8.3)
* =============================================================================

* Open data/clean/shiw_2022.dta and keep sample == 1.
*  a) Regress the winsorized income in euros (y_eq_w) on head_educ_years,
*     with robust standard errors. Interpret the coefficient in euros.
*  b) Regress ln_y_eq_w on head_educ_years. Interpret the coefficient in %.
*  c) Which of the two models fits the data better? Can you compare the R2
*     of the two models? Why?

* >>> write your code here


* =============================================================================
* EXERCISE 2 (10 min) - The age profile (Handbook 4.5, 8.3, 8.6)
* =============================================================================

* Same data. Estimate (robust standard errors):
*   ln_y_eq on head_educ_years, age and age squared (factor-variable
*   notation), hhsize, i.head_female, i.area3
*  a) Is the age profile concave? Test that the coefficient of age squared
*     is zero.
*  b) With lincom, compute the effect of one more year of age at 40 and at
*     70 (derivative: b_age + 2 * b_age2 * age).
*  c) With nlcom, compute the age at which income is highest:
*     -b_age / (2 * b_age2). Is the answer meaningful? Compare with the
*     graph of Lecture 3 (output/figures/cef_age.pdf).

* >>> write your code here


* =============================================================================
* EXERCISE 3 (10 min) - Residuals and diagnostics (Handbook 8.5, 8.7)
* =============================================================================

* Same data. Estimate the model of Exercise 2 WITHOUT robust standard errors.
*  a) Plot the residuals against the fitted values (rvfplot). Do you see a
*     pattern? Export the graph.
*  b) Breusch-Pagan test of heteroskedasticity (estat hettest). What does
*     it imply for the standard errors?
*  c) RESET test of omitted nonlinear terms (estat ovtest).
*  d) Variance inflation factors (estat vif): why are age and age squared
*     so high, and is it a problem?

* >>> write your code here


* =============================================================================
* EXERCISE 4 (10 min) - Sample, population and estimation sample (Handbook 8.8)
* =============================================================================

* Same data.
*  a) Estimate the model of Exercise 2 with robust standard errors and store
*     it as unweighted. Estimate it again with [pweight = peso] and store it
*     as weighted.
*  b) Compare the coefficients of schooling. Why can they differ?
*  c) How many observations does each regression use? Use e(N) and
*     summarize ... if e(sample).

* >>> write your code here


* =============================================================================
* EXERCISE 5 (10 min) - A Mincer equation for employees (Handbook 8.3, 8.9)
* =============================================================================

* Open data/clean/individuals_full.dta. Keep 2022, employees
* (workstatus == 1) aged 25-64 with positive employee income (yl_pers > 0).
*  a) Create ln_yl = ln(yl_pers). Regress it on educ_years, age, age squared
*     and i.female (robust). What is the exact % gender gap? At which age
*     do earnings peak? Compare with the households of Exercise 2.
*  b) Add the interaction between female and educ_years
*     (i.female##c.educ_years). Is the return to schooling different for
*     women?
*  c) Put the two models in one table and export it to
*     output/tables/mincer.tex

* >>> write your code here


* =============================================================================
* CLOSE
* =============================================================================

log close
