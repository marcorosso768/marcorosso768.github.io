* LECTURE 1 - STUDENT WORKSHEET
* Data: World Bank Doing Business 2020 edition (data 1 May 2019), CC BY 4.0.

* Before running: save this file under a new name (e.g. 01_yourname.do) and complete the TODO lines.

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the one containing the subfolders data/ and do/; replace the placeholder below with its path.
cd "path_to_the_main_folder"

* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
do "do/00_setup.do"
* Start a text log of commands and output; replace overwrites the previous log, and name() identifies a separate named log.
log using "$course_results/logs/01_student.log", text replace
* Load this saved .dta file into memory; clear permits replacing the current in-memory data.
use "$course_data/contracts_2019.dta", clear

* TASK 1. Inspect the data. What does ONE ROW represent? Which edition?
describe
* TODO: run codebook on time_days, cost_pct_claim and region (option: compact)
* WRITE: one row is ...; time_days is measured in ...; cost_pct_claim is ...

* TASK 2. Categories and denominators.
* TODO: tabulate region (option: missing), then income_group
* TODO: count the economies with court_automation equal to 0
* WRITE: one sentence with a share AND its denominator.

* TASK 3. Centre and spread.
* TODO: summarize time_days and cost_pct_claim with the option detail
* WRITE: mean, median, SD, 25th and 75th percentiles, with units.
*        Why is the mean larger than the median?
* Experiment: what if Timor-Leste's cost had been mistyped as 1632?
* Predict the new mean and median first, then run these four lines:
*   preserve
*   replace cost_pct_claim = 1632 if economy_code == "TLS"
*   summarize cost_pct_claim, detail
*   restore

* TASK 4. Shape.
* TODO: histogram of time_days with the option percent
* TODO: generate ln_time = ln(time_days) only if time_days > 0 & !missing(time_days)
* TODO: histogram of ln_time; count how many observations it uses
* TODO: graph export "$course_results/figures/01_my_histogram.png", replace

* TASK 5. One economy in the distribution.
* TODO: list economy time_days filing_days trial_days enforcement_days
*       for Italy (economy_code=="ITA") or an economy of your choice
* TODO: count if time_days < (its value)  -> what share of economies is faster?
* WRITE: which phase (filing, trial, enforcement) accounts for most of the time?

* TASK 6. Compare regions (description, not explanation).
* TODO: tabstat time_days cost_pct_claim, by(region) statistics(n mean p50)
* TODO: graph hbox time_days, over(region, sort(1) descending)
* WRITE: which region has the highest median time? How many economies is that based on?

* TASK 7. Five sentences (write them below as comments):
* 1. Source, edition and unit of observation:
* 2. One share with its denominator:
* 3. Centre and spread of time_days, with units:
* 4. One comparison (an economy or a region):
* 5. One limitation of these indicators:

log close
