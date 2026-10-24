* LECTURE 3 - WORKSHEET: relationships between variables and hypothesis tests
* Before running: cd to the course folder (the do/ folder, which contains data/ and 00_setup.do).
* Save this file under a new name (e.g. 03_yourname.do) and complete the TODO lines.
* Write your interpretations as comments (lines starting with *).
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the do/ folder, the one containing data/ and 00_setup.do; replace the placeholder below with its path.
cd "path_to_the_main_folder"

do "00_setup.do"
log using "$course_results/logs/03_exercise.log", text replace

* ============ PART A: 37 European countries ===========================
use "$course_data/justice_europe_2019.dta", clear

* TASK 1. What is one row? Which variables have missing values, for whom?
describe
* TODO: misstable summarize
* TODO: list country if missing(judges_100k) | missing(police_100k)
* WRITE: one row is ...; judges are missing for ...; police for ...

* TASK 2. Judges and enforcement time.
* PREDICT first (write the sign you expect):
* TODO: scatter time_days judges_100k, mlabel(country)
* TODO: graph export "$course_results/figures/03_judges_time.png", replace
* TODO: pwcorr time_days judges_100k, sig obs
* WRITE: r = ..., n = ... . One reverse-causality story and one confounder.

* TASK 3. Police and recorded theft.
* TODO: scatter theft_100k police_100k, mlabel(country)
* TODO: graph export "$course_results/figures/03_police_theft.png", replace
* TODO: generate ln_gdppc = ln(gdp_pc_usd)
* TODO: pwcorr theft_100k police_100k ln_gdppc, sig obs
* WRITE: what could explain the negative correlation other than deterrence?
*        Use the correlations of ln_gdppc with the other two variables.

* TASK 4. What does "recorded corruption" measure?
* TODO: gsort -corruption_100k
* TODO: list country corruption_100k if !missing(corruption_100k)
* WRITE: one sentence on why a high value need not mean more corruption.

* ============ PART B: 191 economies, Doing Business 2020 ================
use "$course_data/contracts_2019.dta", clear

* TASK 5. Are high-income economies faster? A difference in means.
* TODO: generate byte high_income = (income_group == "High income")
* TODO: tabstat time_days, by(high_income) statistics(n mean p50 sd)
* PREDICT: will the difference be statistically significant at 5%?
* TODO: ttest time_days, by(high_income)
* TODO: ttest time_days, by(high_income) unequal
* WRITE: the difference with its unit, the p-value and the 95% interval,
*        in one correct sentence. What does the interval allow?

* TASK 6. A difference in proportions: any court automation.
* TODO: generate byte any_automation = (court_automation > 0) if !missing(court_automation)
* TODO: tabulate high_income any_automation, row
* TODO: prtest any_automation, by(high_income)
* WRITE: the two shares with their denominators, z and the p-value.
*        Does this show that automation makes courts faster? Use Task 5.

* TASK 7. Three sentences (write them below as comments):
* 1. One association, with r and n:
* 2. One alternative explanation (reverse causality, confounding or measurement):
* 3. One test result, with difference, p-value and interval, correctly worded:

* EXTENSION. Many tests at once. Correlate police with six crime categories.
* use "$course_data/justice_europe_2019.dta", clear
* pwcorr police_100k homicide_100k robbery_100k burglary_100k theft_100k ///
*     fraud_100k corruption_100k, sig obs
* WRITE: how many have p < 0.05? Are they independent pieces of evidence?

log close
