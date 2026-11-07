* =============================================================================
* LECTURE 5 - SOLUTIONS: multiple regression
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).
* =============================================================================
* How to use this file
*   1. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   2. Part A contains the Guided Stata commands shown on the slides, in the same order.
*   3. Part B solves the laboratory tasks of exercises/05_multiple_regression.do.

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/05_answer.log", text replace


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
* Expected: -3.64 (SE 0.96), n 34, R2 0.31
* Keep these results in memory under the name "simple", to compare them later.
estimates store simple
* Multiple regression: the same, adding log income as a second explanatory variable.
* The police coefficient now compares countries with the same income.
regress theft_100k police_100k ln_gdppc
* Expected: police -2.04 (SE 1.03, p 0.057, CI -4.15 to 0.07); ln_gdppc 439.1 (SE 153.3);
*           n 34, R2 0.45
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
* Expected: slope -2.04 (SE 1.33)

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
* Expected: Low 30, 680.4; Lower middle 47, 684.4; Upper middle 55, 633.8; High 59, 621.3
* Regression on the four groups. i. tells Stata that income4 is a categorical variable:
* it creates one indicator per group and leaves out the first (Low) as the base.
* Constant = mean of the base group; each coefficient = group mean minus base mean.
regress time_days i.income4
* Expected: constant 680.4 (55.8); Lower middle 4.0 (71.4); Upper middle -46.7 (69.3);
*           High -59.2 (68.5); R2 0.008


* =============================================================================
* PART B. LABORATORY: SOLUTIONS
* =============================================================================

* ============ 37 European countries ==========================================
* Reload the European file and recreate log income.
use "$course_data/justice_europe_2019.dta", clear
generate ln_gdppc = ln(gdp_pc_usd)

* TASK 1. Police and theft, holding income fixed.
* Simple regression.
regress theft_100k police_100k
* Multiple regression with log income.
regress theft_100k police_100k ln_gdppc
* ANSWER: "Across 34 European countries, one more police officer per 100,000 goes with
*   3.6 fewer recorded thefts per 100,000." "Among countries with the same income, one
*   more police officer per 100,000 goes with 2.0 fewer recorded thefts per 100,000
*   (SE 1.03, p = 0.057)."

* TASK 2. Check the omitted variable formula.
* Run the multiple regression again without printing it (quietly) and keep its two
* coefficients in locals: _b[name] is the coefficient of a variable in the last regression.
quietly regress theft_100k police_100k ln_gdppc
local b_police = _b[police_100k]
local b_income = _b[ln_gdppc]
* delta: slope of log income on police, in the same 34 countries.
* if e(sample) keeps the countries used by the regression just run.
regress ln_gdppc police_100k if e(sample)
* Expected: delta = -0.00364 (more police, lower income)
local delta = _b[police_100k]
* Multiple coefficient + income coefficient x delta.
display `b_police' + `b_income'*`delta'
* Expected: -3.64, the simple coefficient.
* ANSWER: yes. Income is positively related to recorded theft (439.1) and negatively
*   related to police (-0.00364): leaving it out adds 439.1 x (-0.00364) = -1.60 to the
*   police coefficient, which makes it more negative.

* TASK 3. Another recorded crime: burglaries.
regress burglary_100k police_100k
* Expected: -0.65 (SE 0.26, p 0.020), n 30
regress burglary_100k police_100k ln_gdppc
* Expected: police -0.18 (SE 0.29, p 0.54); ln_gdppc 127.4 (SE 45.5), n 30
* ANSWER: once income is held fixed, the police coefficient falls by more than two
*   thirds and is no longer distinguishable from zero. 30 countries: burglaries are
*   missing for Albania, Estonia, Hungary, Italy, North Macedonia and Norway, and police
*   for North Macedonia, Norway and Serbia.

* ============ 191 economies, Doing Business 2020 ==============================
use "$course_data/contracts_2019.dta", clear

* TASK 4. Four income groups.
* Same construction as in Part A.
generate byte income4 = 1 if income_group == "Low income"
replace income4 = 2 if income_group == "Lower middle income"
replace income4 = 3 if income_group == "Upper middle income"
replace income4 = 4 if income_group == "High income"
label define inc4 1 "Low" 2 "Lower middle" 3 "Upper middle" 4 "High"
label values income4 inc4
* Group sizes and means.
tabstat time_days, by(income4) statistics(n mean)
* Base group Low (the default: the smallest code).
regress time_days i.income4
* Base group High: ib4. sets code 4 as the base.
regress time_days ib4.income4
* Expected: constant 621.3; Low 59.2; Lower middle 63.2; Upper middle 12.5
* ANSWER: "High-income economies take on average 59.2 days less than low-income ones";
*   "low-income economies take on average 59.2 days more than high-income ones".
*   Both coefficients are the same difference between two group means, taken in
*   opposite order. Fitted values and R-squared do not change with the base group.

* TASK 5. Quality of judicial processes, holding the income group fixed.
regress time_days judicial_quality
* Expected: -20.73 days per index point (SE 6.61)
regress time_days judicial_quality i.income4
* Expected: judicial_quality -22.78 (SE 7.87); Lower middle 9.4; Upper middle 11.5;
*           High 37.2 (SE 75.0)
* ANSWER: the quality coefficient barely changes. The High coefficient changes sign:
*   -59.2 without the quality index, +37.2 with it. High-income economies score higher
*   on judicial quality (mean 10.8 against 6.5 for low income); once economies with the
*   same quality are compared, high-income ones are not faster. Both coefficients are
*   imprecise, and neither is a causal effect.

* TASK 6. Referee comments: see the slides "Good or weak?" and their answers.
* Example of a main comment: "Section 8, press freedom. The text says that a 10-point
*   increase 'leads to' a 0.10-point rise in de facto independence. Press freedom is
*   not randomly assigned and correlates 0.71 with GDP per capita (footnote 11). Please
*   describe the result as an association, or explain which variation identifies an effect."
* Example of a minor comment: "Table 2, column (1): press freedom is printed as
*   0.01 (0.01) but marked significant at 5%. Please report three decimals."

* EXTENSION. Residualise both variables.
use "$course_data/justice_europe_2019.dta", clear
generate ln_gdppc = ln(gdp_pc_usd)
* Part of theft not predicted by income (in the 34 countries with police data).
regress theft_100k ln_gdppc if !missing(police_100k)
predict theft_res, residuals
* Part of police not predicted by income.
regress police_100k ln_gdppc
predict police_res, residuals
* Slope of one residual on the other.
regress theft_res police_res
* Expected: slope -2.04 (SE 1.02). The slope is identical to Task 1; the standard
*   error is close, but not equal, because this regression does not know that income
*   was already estimated (it uses one degree of freedom too many).

* Close the log file.
log close
