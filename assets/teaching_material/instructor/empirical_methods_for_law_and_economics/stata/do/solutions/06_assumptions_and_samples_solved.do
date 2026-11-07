* =============================================================================
* LECTURE 6 - SOLUTIONS: assumptions, standard errors and changing samples
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).
* =============================================================================
* How to use this file
*   1. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   2. Part A contains the Guided Stata commands shown on the slides, in the same order.
*   3. Part B solves the laboratory tasks of exercises/06_assumptions_and_samples.do.
*   Graphs are saved with the suffix _answer, so they do not overwrite yours.

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/06_answer.log", text replace


* =============================================================================
* PART A. GUIDED STATA (the commands on the slides)
* =============================================================================

* ---- Slide "Guided Stata 1: unequal variance and robust standard errors" -----
* Load the European file: one row is one country (37), values per 100,000 inhabitants.
use "$course_data/justice_europe_2019.dta", clear
* Natural log of GDP per capita.
generate ln_gdppc = ln(gdp_pc_usd)
* Regression of recorded thefts on log income, with the usual standard errors.
regress theft_100k ln_gdppc
* Expected: 606.4 (SE 123.5, t 4.91, CI 355 to 857), n 36, R2 0.41
* Residuals (vertical axis) against fitted values (horizontal axis) of the last
* regression; yline(0) draws the zero line. Look at whether the spread changes.
rvfplot, yline(0)
* Breusch-Pagan test. H0: the residuals have the same variance for all fitted values.
* A small p-value rejects constant variance.
estat hettest
* Expected: chi2(1) = 12.71, Prob > chi2 = 0.0004
* The same regression with robust standard errors: vce(robust) changes the standard
* errors, t, p-values and intervals; the coefficients stay the same.
regress theft_100k ln_gdppc, vce(robust)
* Expected: 606.4 (robust SE 146.9, t 4.13, CI 308 to 905)

* ---- Slide "Guided Stata 2: influential observations" ------------------------
* Days to enforce a contract on judges per 100,000 (35 countries with both values).
regress time_days judges_100k
* Expected: 3.62 (SE 3.16, p 0.26), n 35
* New variable lev: the leverage of each country, how unusual its number of judges is.
predict lev, leverage
* New variable cook: Cook's distance, how much the coefficients change without that country.
predict cook, cooksd
* List the countries with Cook's distance above 0.1 (& means AND; !missing() skips the
* two countries without judge data).
list country judges_100k time_days lev cook if cook > 0.1 & !missing(cook)
* Expected: Greece (lev 0.07, cook 0.58), Slovenia (0.08, 0.14), Cyprus (0.06, 0.13),
*           Liechtenstein (0.33, 0.11)
* The same regression without Greece (!= means "not equal to").
regress time_days judges_100k if country != "Greece"
* Expected: 0.98 (SE 2.42, p 0.69), n 34
* The same regression without Liechtenstein.
regress time_days judges_100k if country != "Liechtenstein"
* Expected: 5.04 (SE 3.83, p 0.20), n 34

* ---- Slide "Guided Stata 3: same model, same sample" -------------------------
* Theft on police and log income: 34 countries.
regress theft_100k police_100k ln_gdppc
* Keep the results under the name "base".
estimates store base
* Add judges per 100,000: Germany and Switzerland have no judge data, so Stata drops them.
regress theft_100k police_100k ln_gdppc judges_100k
estimates store judges
* The first model again, on the countries used by the last regression only.
* e(sample) is 1 for the rows used by the last regression, 0 otherwise.
regress theft_100k police_100k ln_gdppc if e(sample)
estimates store base_same
* The three models side by side, with N and R-squared.
estimates table base base_same judges, b(%9.2f) se(%9.2f) stats(N r2)
* Expected police: base -2.04 (1.03), N 34; base_same -2.08 (1.07), N 32;
*                  judges -1.67 (1.04), N 32; judges coefficient -14.69 (7.16)


* =============================================================================
* PART B. LABORATORY: SOLUTIONS
* =============================================================================

* ============ 37 European countries ==========================================
* Reload the European file and recreate log income.
use "$course_data/justice_europe_2019.dta", clear
generate ln_gdppc = ln(gdp_pc_usd)

* TASK 1. Robust standard errors in the police regression.
regress theft_100k police_100k ln_gdppc
* Residuals against fitted values: the spread is larger where predicted theft is high.
rvfplot, yline(0)
graph export "$course_results/figures/06_rvf_police_answer.png", replace width(1600)
* Breusch-Pagan test. Expected: chi2(1) = 9.86, Prob > chi2 = 0.0017
estat hettest
* Robust standard errors.
regress theft_100k police_100k ln_gdppc, vce(robust)
* Expected: police SE 1.03 -> 1.06 (p 0.057 -> 0.062); ln_gdppc SE 153.3 -> 174.6
*           (p 0.007 -> 0.017)
* ANSWER: coefficients, R-squared and N are unchanged; standard errors, t, p-values and
*   intervals change. No conclusion changes: police is borderline either way, income
*   remains significant at 5%.

* TASK 2. Influential countries in the police regression.
regress theft_100k police_100k ln_gdppc
* Cook's distance for each country.
predict cook, cooksd
* 4/34 = 0.118 is the usual flag.
list country police_100k theft_100k cook if cook > 4/34 & !missing(cook)
* Expected: Liechtenstein 0.55, Sweden 0.23, Denmark 0.15
* Without Liechtenstein.
regress theft_100k police_100k ln_gdppc if country != "Liechtenstein"
* Expected: police -1.51 (SE 0.95, p 0.12); ln_gdppc 620.3 (SE 153.2), n 33
* ANSWER: Liechtenstein has by far the highest GDP per capita (about 167,000 US$),
*   so the model predicts many recorded thefts, but it records few (464 per 100,000).
*   Without it the police coefficient moves from -2.04 to -1.51. Do not drop it
*   silently: report "-2.04 on all 34 countries, -1.51 without Liechtenstein, which is
*   the most influential observation".

* TASK 3. Changing samples with a second control.
regress theft_100k police_100k ln_gdppc
* Expected: police -2.04, n 34
regress theft_100k police_100k ln_gdppc burglary_100k
* Expected: police -1.83 (SE 0.77); ln_gdppc 21.7; burglary 2.87 (SE 0.51), n 30
regress theft_100k police_100k ln_gdppc if e(sample)
* Expected: police -2.35 (SE 1.12), n 30
* ANSWER: 34, 30 and 30 countries. Albania, Estonia, Hungary and Italy leave (no
*   burglary data). Sample part: -2.04 -> -2.35; control part: -2.35 -> -1.83. The two
*   go in opposite directions, so comparing -2.04 with -1.83 hides both. Recorded
*   burglaries come from the same reporting and recording process as recorded thefts:
*   holding them fixed removes much of what we want to explain (the income coefficient
*   falls from 439 to 22).

* TASK 4. How large is the police coefficient?
regress theft_100k police_100k ln_gdppc
* Means and standard deviations in the 34 countries used.
summarize theft_100k police_100k if e(sample)
* Expected: theft mean 982.9 (SD 804.1); police mean 359.5 (SD 122.8)
* Elasticity at the means: coefficient x mean of police / mean of theft.
display _b[police_100k]*359.5/982.9
* Expected: -0.75
* ANSWER: units: 100 more police officers per 100,000 go with 204 fewer recorded thefts
*   per 100,000, among countries with the same income. Standard deviations: one SD of
*   police (123) goes with 250 fewer thefts, 0.31 SD of theft. Elasticity: 1% more
*   police, 0.75% fewer recorded thefts. All three describe an association.

* ============ 191 economies, Doing Business 2020 ==============================
use "$course_data/contracts_2019.dta", clear

* TASK 5. Cost of enforcement and judicial quality.
regress cost_pct_claim judicial_quality
* Expected: -1.54 percentage points of the claim per index point (SE 0.42, t -3.67)
rvfplot, yline(0)
graph export "$course_results/figures/06_rvf_cost_answer.png", replace width(1600)
estat hettest
* Expected: chi2(1) = 45.18, Prob > chi2 = 0.0000
regress cost_pct_claim judicial_quality, vce(robust)
* Expected: robust SE 0.51 (t -3.04, p 0.003)
* ANSWER: the residuals spread much more where the predicted cost is high, that is
*   among economies with low judicial quality. The standard error rises by about 20%
*   (0.42 to 0.51); the coefficient remains significant at 1%, so the conclusion does
*   not change, but the robust standard error is the one to report.

* TASK 6. Referee comments: see the slides "Write one comment: two examples".

* Close the log file.
log close
