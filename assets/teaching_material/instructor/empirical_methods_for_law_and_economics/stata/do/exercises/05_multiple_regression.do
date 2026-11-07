* =============================================================================
* LECTURE 5 - STUDENT WORKSHEET: multiple regression
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).
* =============================================================================
* How to use this file
*   1. Save a copy under your own name (e.g. 05_yourname.do) and work on the copy.
*   2. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   3. Part A contains the Guided Stata commands shown on the slides, in the same
*      order: run them while we go through the slides.
*   4. Part B is the laboratory: complete the TODO lines and write your answers
*      as comments (lines starting with *).
* To run some lines only: select them and press Ctrl+D (Windows) or Cmd+Shift+D (Mac).

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/05_exercise.log", text replace


* =============================================================================
* PART A. GUIDED STATA (the commands on the slides)
* =============================================================================

* ---- Slide "Guided Stata 1: adding a control" -------------------------------
* Load the European file: one row is one country (37), values per 100,000 inhabitants.
use "$course_data/justice_europe_2019.dta", clear
* Natural log of GDP per capita: the income control.
generate ln_gdppc = ln(gdp_pc_usd)
* Simple regression: recorded thefts on police officers (both per 100,000).
regress theft_100k police_100k
* Keep these results in memory under the name "simple", to compare them later.
estimates store simple
* Multiple regression: the same, adding log income as a second explanatory variable.
* The police coefficient now compares countries with the same income.
regress theft_100k police_100k ln_gdppc
* Keep these results under the name "multiple".
estimates store multiple
* Show the two stored regressions side by side.
*   b(%9.2f): coefficients with two decimals; se(%9.2f): standard errors below them;
*   stats(N r2): number of observations and R-squared at the bottom.
estimates table simple multiple, b(%9.2f) se(%9.2f) stats(N r2)

* ---- Slide "Guided Stata 2: the same coefficient in two steps" ---------------
* Step 1: regress police on income.
regress police_100k ln_gdppc
* New variable police_res: the residual of step 1, the part of police that income
* does not predict.
predict police_res, residuals
* Step 2: regress theft on that part. The slope equals the police coefficient of the
* multiple regression (-2.04); its standard error is not the right one.
regress theft_100k police_res

* ---- Slide "Guided Stata 3: indicators for four groups" ----------------------
* Load the Doing Business file (191 economies); clear replaces the European data.
use "$course_data/contracts_2019.dta", clear
* Build a numeric variable for the four income groups, in their natural order.
* generate creates it for the low-income economies (1); each replace fills one group;
* byte stores small integers.
generate byte income4 = 1 if income_group == "Low income"
replace income4 = 2 if income_group == "Lower middle income"
replace income4 = 3 if income_group == "Upper middle income"
replace income4 = 4 if income_group == "High income"
* Attach names to the four codes: label define creates the list of names,
* label values attaches it to income4, so tables show names instead of numbers.
label define inc4 1 "Low" 2 "Lower middle" 3 "Upper middle" 4 "High"
label values income4 inc4
* Number of economies and mean enforcement time in each income group.
tabstat time_days, by(income4) statistics(n mean)
* Regression on the four groups. i. tells Stata that income4 is a categorical variable:
* it creates one indicator per group and leaves out the first (Low) as the base.
* Constant = mean of the base group; each coefficient = group mean minus base mean.
regress time_days i.income4


* =============================================================================
* PART B. LABORATORY
* =============================================================================

* ============ 37 European countries ==========================================
use "$course_data/justice_europe_2019.dta", clear
generate ln_gdppc = ln(gdp_pc_usd)

* TASK 1. Police and theft, holding income fixed.
* TODO: regress theft_100k police_100k
* TODO: regress theft_100k police_100k ln_gdppc
* WRITE: the police coefficient of each regression as a sentence with units.
*        In the second sentence say what is held fixed.

* TASK 2. Check the omitted variable formula:
*         simple coefficient = multiple coefficient + (income coefficient) x (delta),
*         where delta is the slope of ln_gdppc on police in the same countries.
* TODO: regress ln_gdppc police_100k if !missing(theft_100k)
*       (the if condition keeps the countries used in Task 1)
* TODO: display -2.0413 + 439.0906*(the slope you obtained)
* WRITE: does the result reproduce the simple coefficient of Task 1?
*        Explain the sign of the difference in one sentence.

* TASK 3. Another recorded crime: burglaries.
* TODO: regress burglary_100k police_100k
* TODO: regress burglary_100k police_100k ln_gdppc
* WRITE: what happens to the police coefficient? How many countries are used, and why
*        fewer than in Task 1?

* ============ 191 economies, Doing Business 2020 ==============================
use "$course_data/contracts_2019.dta", clear

* TASK 4. Four income groups.
* TODO: build income4 and its labels as in Part A (copy the six lines)
* TODO: tabstat time_days, by(income4) statistics(n mean)
* TODO: regress time_days i.income4
* TODO: regress time_days ib4.income4
*       (ib4. makes group 4, High, the base group)
* WRITE: the coefficient on High in the first regression and the coefficient on Low in
*        the second, as sentences. Why are they equal with opposite sign?

* TASK 5. Quality of judicial processes, holding the income group fixed.
* TODO: regress time_days judicial_quality
* TODO: regress time_days judicial_quality i.income4
* WRITE: does the judicial_quality coefficient change much? And the coefficient on High:
*        compare it with Task 4. What does "holding judicial quality fixed" do to it?

* TASK 6. Referee comments (write them below as comments).
* Read Table 2, column (1), of Voigt and Wulf (2019) again.
* 1. One main comment: title; issue (with table, column or page); why it matters for a
*    conclusion of the paper; what would resolve it.
* 2. One minor comment.

* EXTENSION. Residualise both variables.
* TODO: regress theft_100k ln_gdppc if !missing(police_100k)
* TODO: predict theft_res, residuals
* TODO: regress police_100k ln_gdppc
* TODO: predict police_res, residuals
* TODO: regress theft_res police_res
* WRITE: compare the slope and its standard error with the multiple regression of Task 1.

* Close the log file.
log close
