* =============================================================================
* LECTURE 6 - STUDENT WORKSHEET: assumptions, standard errors and changing samples
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).
* =============================================================================
* How to use this file
*   1. Save a copy under your own name (e.g. 06_yourname.do) and work on the copy.
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
log using "$course_results/logs/06_exercise.log", text replace


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
* Residuals (vertical axis) against fitted values (horizontal axis) of the last
* regression; yline(0) draws the zero line. Look at whether the spread changes.
rvfplot, yline(0)
* Breusch-Pagan test. H0: the residuals have the same variance for all fitted values.
* A small p-value rejects constant variance.
estat hettest
* The same regression with robust standard errors: vce(robust) changes the standard
* errors, t, p-values and intervals; the coefficients stay the same.
regress theft_100k ln_gdppc, vce(robust)

* ---- Slide "Guided Stata 2: influential observations" ------------------------
* Days to enforce a contract on judges per 100,000 (35 countries with both values).
regress time_days judges_100k
* New variable lev: the leverage of each country, how unusual its number of judges is.
predict lev, leverage
* New variable cook: Cook's distance, how much the coefficients change without that country.
predict cook, cooksd
* List the countries with Cook's distance above 0.1 (& means AND; !missing() skips the
* two countries without judge data).
list country judges_100k time_days lev cook if cook > 0.1 & !missing(cook)
* The same regression without Greece (!= means "not equal to").
regress time_days judges_100k if country != "Greece"
* The same regression without Liechtenstein.
regress time_days judges_100k if country != "Liechtenstein"

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


* =============================================================================
* PART B. LABORATORY
* =============================================================================

* ============ 37 European countries ==========================================
use "$course_data/justice_europe_2019.dta", clear
generate ln_gdppc = ln(gdp_pc_usd)

* TASK 1. Robust standard errors in the police regression.
* TODO: regress theft_100k police_100k ln_gdppc
* TODO: rvfplot, yline(0)
* TODO: estat hettest
* TODO: regress theft_100k police_100k ln_gdppc, vce(robust)
* WRITE: which numbers change and which do not? Does any conclusion change?

* TASK 2. Influential countries in the police regression.
* TODO: regress theft_100k police_100k ln_gdppc
* TODO: predict cook, cooksd
* TODO: list country police_100k theft_100k cook if cook > 4/34 & !missing(cook)
* TODO: rerun the regression without the country with the largest Cook's distance
* WRITE: which country is it, and why might it be unusual? What happens to the
*        police coefficient? Would you drop it? Report both estimates in one sentence.

* TASK 3. Changing samples with a second control.
* TODO: regress theft_100k police_100k ln_gdppc
* TODO: regress theft_100k police_100k ln_gdppc burglary_100k
* TODO: regress theft_100k police_100k ln_gdppc if e(sample)
* WRITE: how many countries are used in each regression? Which countries leave?
*        Split the change in the police coefficient into a sample part and a control
*        part. Lecture 5 called recorded burglaries a "bad control": why?

* TASK 4. How large is the police coefficient?
* TODO: regress theft_100k police_100k ln_gdppc
* TODO: summarize theft_100k police_100k if e(sample)
* TODO: display _b[police_100k]*(mean of police)/(mean of theft)
* WRITE: the coefficient in units, in standard deviations and as an elasticity.

* ============ 191 economies, Doing Business 2020 ==============================
use "$course_data/contracts_2019.dta", clear

* TASK 5. Cost of enforcement and judicial quality.
* TODO: regress cost_pct_claim judicial_quality
* TODO: rvfplot, yline(0)
* TODO: graph export "$course_results/figures/06_rvf_cost.png", replace
*       (graph export saves the graph on screen as a picture file)
* TODO: estat hettest
* TODO: regress cost_pct_claim judicial_quality, vce(robust)
* WRITE: where is the spread of the residuals larger? By how much does the standard
*        error change? Does the conclusion change?

* TASK 6. Referee comments (write them below as comments).
* 1. Rewrite the comment on Voigt and Wulf you wrote in class, with the four steps:
*    where, what, why it matters, what would resolve it.
* 2. Write one comment of the same kind on the paper you are reviewing.

* Close the log file.
log close
