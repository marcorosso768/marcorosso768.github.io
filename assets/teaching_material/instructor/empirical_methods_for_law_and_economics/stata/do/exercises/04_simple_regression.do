* LECTURE 4 - WORKSHEET: simple regression
* Before running: cd to the course folder (the do/ folder, which contains data/ and 00_setup.do).
* Save this file under a new name (e.g. 04_yourname.do) and complete the TODO lines.
* Data: World Bank Doing Business 2020 and World Development Indicators 2019
*       (CC BY 4.0); Eurostat criminal justice statistics 2019 (source: Eurostat).

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the do/ folder, the one containing data/ and 00_setup.do; replace the placeholder below with its path.
cd "path_to_the_main_folder"

do "00_setup.do"
log using "$course_results/logs/04_exercise.log", text replace

* TASK 1. Merge income data into the Doing Business file.
use "$course_data/contracts_2019.dta", clear
* TODO: merge 1:1 economy_code using "$course_data/gdp_2019.dta"
* TODO: tabulate _merge
* TODO: list economy if _merge == 1
* WRITE: how many economies are matched? Which are lost, and are they a
*        random subset?
* TODO: keep if _merge == 3
* TODO: drop _merge

* TASK 2. Fit a line: log time on log income.
* TODO: generate ln_time  = ln(time_days)
* TODO: generate ln_gdppc = ln(gdp_pc_usd)
* PREDICT: the sign of the slope and the R-squared.
* TODO: scatter ln_time ln_gdppc || lfit ln_time ln_gdppc
* TODO: graph export "$course_results/figures/04_gdp_time.png", replace
* TODO: regress ln_time ln_gdppc
* WRITE: the slope as a sentence with units (10% more income -> ...% time).
*        What does doubling income imply? (Hint: display 2^_b[ln_gdppc])

* TASK 3. Predictions and residuals.
* TODO: predict xb, xb
* TODO: predict res, residuals
* TODO: generate pred_days = exp(xb)
* TODO: list economy time_days pred_days res if economy_code == "ITA"
* TODO: gsort -res
* TODO: list economy time_days pred_days res in 1/15
* WRITE: Italy's predicted and observed days; its residual in words.
*        Name two things the residual contains other than "inefficiency".

* TASK 4. Another benchmark: the quality of judicial processes index (0-18).
use "$course_data/contracts_2019.dta", clear      // all 191 economies
* TODO: regress time_days judicial_quality
* WRITE: the slope in days per index point, its 95% interval, and R-squared.

* TASK 5. A 0/1 regressor is a comparison of means (all 191 economies).
* TODO: generate byte high_income = (income_group == "High income")
* TODO: regress time_days high_income
* TODO: ttest time_days, by(high_income)
* WRITE: which two numbers do the constant and the slope reproduce?
*        Why does the sign of the difference differ between the two outputs?

* TASK 6. Judges and enforcement time in Europe.
use "$course_data/justice_europe_2019.dta", clear
* TODO: regress time_days judges_100k
* TODO: regress time_days judges_100k if country != "Liechtenstein"
* WRITE: the slope in days per additional judge per 100,000 inhabitants.
*        Would you advise a ministry to hire judges on this basis? Why not?

* TASK 7. Paper bridge (Voigt and Wulf 2019, Table 2, column 1).
* WRITE: one coefficient: its sign, the unit of the explanatory variable,
*        its standard error, and one sentence in words. Is it causal?
*        Suggested: English legal origin (0.24, SE 0.09). Compared with whom?

* EXTENSION (preview of Lecture 5). Police and recorded theft, holding income fixed.
* generate ln_gdppc = ln(gdp_pc_usd)
* regress theft_100k police_100k
* regress theft_100k police_100k ln_gdppc
* WRITE: what happens to the police coefficient, and why might that be?

log close
