* =============================================================================
* LECTURE 4 - SOLUTIONS: simple regression
* Data: World Bank Doing Business 2020 and World Development Indicators 2019
*       (CC BY 4.0); Eurostat criminal justice statistics 2019 (source: Eurostat).
* =============================================================================
* How to use this file
*   1. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   2. Part A contains the Guided Stata commands shown on the slides, in the same order.
*   3. Part B solves the laboratory tasks of exercises/04_simple_regression.do.
*   Graphs are saved with the suffix _answer, so they do not overwrite yours.

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/04_answer.log", text replace


* =============================================================================
* PART A. GUIDED STATA (the commands on the slides)
* =============================================================================

* ---- Slide "Guided Stata 1: bring in income" --------------------------------
* Load the Doing Business file (191 economies); clear discards any data in memory.
use "$course_data/contracts_2019.dta", clear
* Add the variables of the income file, matching rows on economy_code.
*   1:1 means each code appears at most once in each file; Stata stops if not.
*   merge creates the variable _merge: 1 = only in Doing Business,
*   2 = only in the income file, 3 = in both files.
merge 1:1 economy_code using "$course_data/gdp_2019.dta"
* How many economies are in each of the three groups.
tabulate _merge
* Expected: matched 186; only in Doing Business 5; only in the income file 24
* Names of the Doing Business economies with no income data.
list economy if _merge == 1
* Expected: Eritrea; South Sudan; Taiwan, China; Venezuela, RB; Yemen, Rep.

* ---- Slide "Guided Stata 2: fit the line" ----------------------------------
* Keep only the economies found in both files (186). The others are dropped from
* memory, not from the files on disk.
keep if _merge == 3
* Natural logs of enforcement time and of GDP per capita.
generate ln_time  = ln(time_days)
generate ln_gdppc = ln(gdp_pc_usd)
* OLS regression: the first variable is the outcome (y), the second the explanatory
* variable (x). Read the coefficient of ln_gdppc (the slope), its standard error,
* t, p-value and 95% interval; R-squared is in the top-right block.
regress ln_time ln_gdppc
* Expected: slope -0.049 (SE 0.022, t -2.27, p 0.025), constant 6.819, n 186, R2 0.027

* ---- Slide "Guided Stata 3: a 0/1 regressor" -------------------------------
* Reload the full Doing Business file, so that all 191 economies are used.
use "$course_data/contracts_2019.dta", clear      // all 191 economies
* Create a 0/1 variable: 1 if the World Bank classifies the economy as high income,
* 0 otherwise. The expression in brackets is 1 when true and 0 when false.
generate byte high_income = (income_group == "High income")
* Regression on the 0/1 variable: the constant is the mean time of group 0;
* the slope is mean of group 1 minus mean of group 0.
regress time_days high_income
* Expected: constant 662.4, slope -41.2 (SE 47.7, p 0.389)
* The t-test of Lecture 3 on the same comparison: same t (opposite sign) and same p,
* because ttest reports mean of group 0 minus mean of group 1.
ttest time_days, by(high_income)
* Expected: diff +41.17, t 0.86, p 0.389


* =============================================================================
* PART B. LABORATORY: SOLUTIONS
* =============================================================================

* TASK 1. Merge income data into the Doing Business file.
* Reload the Doing Business file, so that Part B starts from the original data.
use "$course_data/contracts_2019.dta", clear
* Merge on economy_code, one row per code in each file.
merge 1:1 economy_code using "$course_data/gdp_2019.dta"
* Matched 186; only in Doing Business 5; only in the income file 24.
tabulate _merge
* The five economies without income data.
list economy if _merge == 1
* ANSWER: not random: conflict, crisis or contested status; results on 186
*   economies say nothing about them.
* Keep the matched economies and delete _merge, which is no longer needed.
keep if _merge == 3
drop _merge

* TASK 2. Fit a line: log time on log income.
* Natural logs; all values are positive, so no economy is lost.
generate ln_time  = ln(time_days)
generate ln_gdppc = ln(gdp_pc_usd)
* Two layers on the same axes: the points (scatter) and the OLS line (lfit).
twoway (scatter ln_time ln_gdppc) (lfit ln_time ln_gdppc)
* Save the graph on screen as a picture; width() sets its size in pixels.
graph export "$course_results/figures/04_gdp_time_answer.png", replace width(1600)
* OLS regression of log time on log income.
regress ln_time ln_gdppc
* Expected: slope -0.0493 (SE 0.0218, t -2.27, p 0.025, CI -0.092 to -0.006),
*           constant 6.819 (SE 0.193), n 186, R2 0.027
* _b[ln_gdppc] is the slope stored by the last regression. In a log-log model,
* doubling income multiplies predicted time by 2 to the power of the slope: 0.966,
* that is 3.4% fewer days.
display 2^_b[ln_gdppc]
* ANSWER: "Across 186 economies, 10% higher GDP per capita goes with about 0.5%
*   shorter enforcement time; income accounts for under 3% of the variation."

* TASK 3. Predictions and residuals.
* New variable xb: the predicted ln_time of each economy, from the last regression.
predict xb, xb
* New variable res: the residual, observed minus predicted ln_time.
predict res, residuals
* Prediction in days: exp() undoes ln().
generate pred_days = exp(xb)
* Italy: 1,120 days observed, 547.4 predicted, residual 0.716.
list economy time_days pred_days res if economy_code == "ITA"
* A residual of 0.716 on the log scale means observed time is exp(0.716) = 2.05
* times the predicted time.
display exp(0.716)
* Note: exp(xb) predicts a typical (median-type) value; the mean-type prediction,
* corrected with the smearing factor 1.095, is about 599 days for Italy.
* Sort from the largest to the smallest residual (the minus sign means descending).
gsort -res
* The 15 economies slowest relative to their income: in 1/15 shows the first 15 rows.
list economy time_days pred_days res in 1/15
* Expected: Greece first (1.112); Italy 14th. Most negative: Singapore (-1.172).
* ANSWER: the residual contains procedure, organisation, judges' workload,
*   litigation culture, the specific standardized case and measurement error.

* TASK 4. Another benchmark: the quality of judicial processes index (0-18).
* Reload the full Doing Business file, so that all 191 economies are used.
use "$course_data/contracts_2019.dta", clear
* Time in days on the index in points: the slope is in days per index point.
regress time_days judicial_quality
* Expected: slope -20.73 days per point (SE 6.61, t -3.13, p 0.002, CI -33.8 to -7.7),
*           constant 828.7, n 191, R2 0.049

* TASK 5. A 0/1 regressor is a comparison of means (all 191 economies).
* 0/1 variable: 1 if high income, 0 otherwise.
generate byte high_income = (income_group == "High income")
* Constant = mean of group 0; slope = mean of group 1 minus mean of group 0.
regress time_days high_income
* Expected: constant 662.42 (mean of group 0), slope -41.17 (SE 47.68,
*           t -0.86, p 0.389, CI -135.2 to 52.9), R2 0.004, n 191
* The same comparison as a t-test.
ttest time_days, by(high_income)
* ANSWER: constant = mean of non-high-income; slope = mean(high) - mean(not high).
*   ttest reports mean(0) - mean(1) = +41.17: same t in absolute value, same p.

* TASK 6. Judges and enforcement time in Europe.
* Load the European file; clear replaces the Doing Business data.
use "$course_data/justice_europe_2019.dta", clear
* The slope is in days per additional judge per 100,000 inhabitants.
regress time_days judges_100k
* Expected: slope 3.62 days (SE 3.16, p 0.260, CI -2.8 to 10.0), n 35, R2 0.038
* The same regression without Liechtenstein, an extreme value of judges per 100,000
* (!= means "not equal to").
regress time_days judges_100k if country != "Liechtenstein"
* Expected: slope 5.04 days (SE 3.83, p 0.198), n 34
* ANSWER: imprecise, positive, and a cross-country association: reverse
*   causality (backlogs -> hiring) and confounding (legal tradition) are open.

* TASK 7. Paper bridge (Voigt and Wulf 2019, Table 2, column 1; N = 74, R2 = 0.29)
* ANSWER (example): countries of English legal origin score on average 0.24 points
*   higher on the 0-1 de facto independence index than countries of socialist,
*   German or Scandinavian legal origin (the omitted category). The coefficient
*   compares countries with the same values of the other variables in the column
*   (SE 0.09, significant at 5%). Not causal: legal origin is not randomly assigned
*   and correlates with many other institutions.

* EXTENSION. Police and recorded theft, holding income fixed.
* Natural log of GDP per capita (the European file is in memory).
generate ln_gdppc = ln(gdp_pc_usd)
* Simple regression of recorded thefts per 100,000 on police per 100,000.
regress theft_100k police_100k
* Expected: -3.64 (SE 0.96), n 34, R2 0.309
* Add log income as a second explanatory variable: the police coefficient now
* compares countries with the same income.
regress theft_100k police_100k ln_gdppc
* Expected: police -2.04 (SE 1.03, p 0.057); ln_gdppc 439.1 (SE 153.3); R2 0.454
* ANSWER: holding income fixed, the police coefficient falls by about 44%:
*   part of the simple association reflected income.

* Close the log file.
log close
