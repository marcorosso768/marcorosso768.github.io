* =============================================================================
* LECTURE 2 - CREATING VARIABLES AND COMBINING DATASETS
* Course:   Introduction to Stata (4 lectures)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Handbook: Introduction to Stata, Chapters 4-5 (and 2.6, 12.1-12.2)
* Data:     Banca d'Italia, Indagine sui bilanci delle famiglie italiane (SHIW),
*           historical archive, version 12.2
* Stata:    version 19
* =============================================================================
* SOLUTIONS VERSION: demonstration and solutions, commented line by line.
* =============================================================================

/*
   WHERE WE ARE
   Lecture 1 saved in data/clean/: individuals, deflator, regions, rfam, ricf,
   cons, peso. If some file is missing, run L1_solutions.do first.

   TODAY: from people to households. At the end of the lecture we have
     shiw_hh.dta          one row per household-wave (income, wealth,
                          consumption, weights, main earner's characteristics)
     individuals_full.dta one row per person-wave, with personal income
     region_year.dta      one row per region-wave
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
log using "$logs/L2.log", text replace

* Check that the files of Lecture 1 exist (Handbook 2.7, 12.4)

* A local macro lives only while the do-file runs; foreach repeats the
* commands for each element of the list (Handbook 12.1-12.2).
* confirm file returns an error code in _rc if the file is missing.
foreach f in individuals deflator regions rfam ricf cons peso {
    capture confirm file "$clean/`f'.dta"
    if _rc != 0 {
        display as error "`f'.dta not found: run L1_solutions.do first"
        exit 601
    }
}


* =============================================================================
* SECTION 1: GENERATE, REPLACE, RECODE (Handbook 4.1, 4.3, 4.4)
* =============================================================================

use "$clean/individuals.dta", clear

* 1.1 Dummy variables

* A logical expression is 1 if true, 0 if false.
generate female = (sex == 2)
* With "if", rows that do not satisfy it get missing, not 0. educ is never
* missing in 2010-2022, but the condition protects us (missing > any number).
generate university = (educ >= 5) if !missing(educ)
generate employed = inlist(workstatus, 1, 2)
* One value label for all 0/1 variables.
label define yesno 0 "No" 1 "Yes"
label values female university employed yesno
label variable female     "Female"
label variable university "University degree"
label variable employed   "Employed"
tabulate educ university

* 1.2 generate + replace: approximate years of schooling

* Start from an empty (missing) variable and fill it category by category.
generate educ_years = .
replace educ_years = 0  if educ == 1
replace educ_years = 5  if educ == 2
replace educ_years = 8  if educ == 3
replace educ_years = 13 if educ == 4
replace educ_years = 18 if educ == 5
replace educ_years = 21 if educ == 6
label variable educ_years "Years of schooling (approx.)"
* Always check a recoding with a two-way table.
tabulate educ educ_years

* 1.3 recode: groups of a continuous variable, with labels

recode age (min/17 = 1 "0-17") (18/34 = 2 "18-34") (35/49 = 3 "35-49") ///
           (50/64 = 4 "50-64") (65/max = 5 "65+"), generate(age_group)
label variable age_group "Age group"
tabulate age_group


* =============================================================================
* SECTION 2: BY-GROUPS, _n, _N, egen (Handbook 2.6, 4.2)
* =============================================================================

* 2.1 _n and _N within groups

* _N = number of rows in the group (here: members of a household-wave).
bysort year nquest: generate n_members = _N
* It must equal the household size reported in the data.
assert n_members == hhsize
drop n_members

* 2.2 egen: functions over many rows

* total(): number of children under 14 in the household.
egen n_children = total(age < 14), by(year nquest)
label variable n_children "Children under 14 in the household"
* A household variable from one member: education of the main earner.
generate tmp = educ_years if cfred == 1
bysort year nquest: egen head_educ_hh = max(tmp)
drop tmp
list year nquest nord cfred educ_years head_educ_hh in 1/6

save "$clean/individuals_v2.dta", replace


* =============================================================================
* SECTION 3: FROM PEOPLE TO HOUSEHOLDS (Handbook 3.8)
* =============================================================================

* 3.1 Keep one row per household: the main income earner

keep if cfred == 1
isid nquest year
keep year nquest ireg area3 area5 hhsize nequ n_children ///
     age sex female educ educ_years university marital workstatus
* The person-level variables now describe the main earner: rename them.
rename (age sex female educ educ_years university marital workstatus) ///
       (head_age head_sex head_female head_educ head_educ_years      ///
        head_university head_marital head_workstatus)
label variable head_age        "Age of main earner"
label variable head_female     "Main earner is female"
label variable head_educ       "Education of main earner"
label variable head_educ_years "Years of schooling of main earner"
label variable head_university "Main earner has a degree"


* =============================================================================
* SECTION 4: MERGE (Handbook 5.3)
* =============================================================================

* 4.1 merge 1:1: one household, one income

* The data in memory are the "master", the file on disk the "using".
* keepusing() selects the variables to bring in.
merge 1:1 nquest year using "$clean/rfam.dta", keepusing(y yl yt ym yc)
* _merge: 1 = only in master, 2 = only in using, 3 = matched.
tabulate _merge
drop _merge

* 4.2 merge m:1: many households, one region

* The key (ireg) repeats in the master and is unique in the using file.
* assert(match) stops if something does not match; nogenerate: no _merge.
merge m:1 ireg using "$clean/regions.dta", keepusing(region_name) ///
      assert(match) nogenerate

* 4.3 Checkpoint for the exercises

save "$clean/hh_step1.dta", replace


* =============================================================================
* SECTION 5: APPEND, RESHAPE, COLLAPSE (Handbook 5.1, 5.2, 5.4, 5.5)
* =============================================================================

* 5.1 append: add ROWS (same variables, different observations)

* preserve takes a snapshot of the data, restore brings it back.
* tempfile: a temporary file deleted at the end of the do-file.
preserve
keep if year == 2020
tempfile w2020
save `w2020'
restore
preserve
keep if year == 2022
append using `w2020', generate(source)
tabulate year source
restore

* 5.2 reshape: long (one row per household-wave) <-> wide (one row per household)

preserve
* Households interviewed in all six waves (the panel component).
bysort nquest: keep if _N == 6
keep nquest year y
* i() identifies the new rows, j() becomes the suffix of the variables.
reshape wide y, i(nquest) j(year)
list in 1/3
reshape long
restore

* 5.3 collapse: from households to groups (replaces the data: preserve!)

preserve
collapse (mean) y (median) y_median = y, by(year area3)
list, sepby(year)
restore


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (10 min) - Merge wealth, consumption, weights (Handbook 5.3)
* =============================================================================

* Open data/clean/hh_step1.dta.
*  a) Merge net wealth and its components (w ar af pf) from ricf.dta,
*     consumption (c) from cons.dta and the weight (peso) from peso.dta.
*     Which type of merge do you need? Which result do you expect?
*  b) Use the options assert(match) and nogenerate.
*  c) Save as data/clean/hh_step2.dta

use "$clean/hh_step1.dta", clear
* a-b) one row per household-wave in both files: 1:1 on nquest year.
* We expect a perfect match: every household has income, wealth, weights.
merge 1:1 nquest year using "$clean/ricf.dta", keepusing(w ar af pf) assert(match) nogenerate
merge 1:1 nquest year using "$clean/cons.dta", keepusing(c) assert(match) nogenerate
merge 1:1 nquest year using "$clean/peso.dta", keepusing(peso) assert(match) nogenerate
* c)
save "$clean/hh_step2.dta", replace


* =============================================================================
* EXERCISE 2 (10 min) - Constant prices and log income (Handbook 4.1, 5.3)
* =============================================================================

* Open data/clean/hh_step2.dta.
*  a) Merge rival from deflator.dta. Which type of merge? Tabulate _merge:
*     what are the observations with _merge == 2? Drop them.
*  b) Create y_real, w_real, c_real (= variable * rival): euros of 2022.
*  c) Create equivalised income y_eq = y_real / nequ and its log ln_y_eq.
*     How many missing values does ln() create, and why?
*  d) Label the new variables and save as data/clean/shiw_hh.dta

use "$clean/hh_step2.dta", clear
* a) many households per year, one row per year in the deflator: m:1.
merge m:1 year using "$clean/deflator.dta", keepusing(rival)
* _merge == 2: years in the deflator that are not survey waves (1977-2009,
* 2011, 2013...): they are not households, we drop them.
tabulate _merge
drop if _merge == 2
drop _merge
* b) a loop over variables: `v' takes the values y, w, c in turn.
foreach v of varlist y w c {
    generate `v'_real = `v' * rival
}
* c) ln(x) is missing when x <= 0: 162 households with zero or negative
* income. Stata reports "(162 missing values generated)": always read it.
generate y_eq = y_real / nequ
generate ln_y_eq = ln(y_eq)
count if y_eq <= 0
* d)
label variable y_real  "Disposable income (2022 euros)"
label variable w_real  "Net wealth (2022 euros)"
label variable c_real  "Consumption (2022 euros)"
label variable y_eq    "Equivalised income (2022 euros)"
label variable ln_y_eq "Log equivalised income"
order year nquest ireg region_name area3 peso
sort year nquest
compress
label data "SHIW 2010-2022, households"
save "$clean/shiw_hh.dta", replace


* =============================================================================
* EXERCISE 3 (10 min) - Personal incomes: an imperfect merge (Handbook 3.2, 5.3)
* =============================================================================

* rper.csv has one row per INCOME EARNER (not per person).
*  a) Import it, keep 2010-2022 and the variables nquest nord anno y yl.
*     Rename anno to year, y to y_pers and yl to yl_pers. Which variables
*     identify the rows?
*  b) Merge it with individuals_v2.dta. How many people are not matched?
*     Who are they? (tabulate perc against _merge)
*  c) Set the personal incomes of the unmatched people to zero, keep the
*     merge result in a variable merge_rper and save individuals_full.dta

* a)
import delimited "$raw/rper.csv", clear case(lower)
keep if anno >= 2010
keep nquest nord anno y yl
rename (anno y yl) (year y_pers yl_pers)
isid nquest nord year
tempfile rper
save `rper'
* b) the key is unique in both files: 1:1
use "$clean/individuals_v2.dta", clear
merge 1:1 nquest nord year using `rper'
tabulate perc _merge
* Almost all unmatched people are not income earners (perc == 0): children,
* students, housewives. A few cases do not follow the rule: the definitions
* of the two files differ slightly. Inspect _merge, never drop it blindly.
* c)
replace y_pers  = 0 if _merge == 1
replace yl_pers = 0 if _merge == 1
rename _merge merge_rper
label variable y_pers  "Personal disposable income"
label variable yl_pers "Personal employee income"
save "$clean/individuals_full.dta", replace


* =============================================================================
* EXERCISE 4 (10 min) - The panel and reshape (Handbook 5.1, 5.4)
* =============================================================================

* Open data/clean/shiw_hh.dta.
*  a) Create n_waves = number of waves in which each household is observed.
*     How many households are observed in all six waves?
*  b) Keep these households and the variables nquest year w_real, and
*     reshape to wide format.
*  c) Compute the change in real net wealth between 2010 and 2022. What is
*     the median change?
*  d) Why must you drop the other variables before the reshape?

use "$clean/shiw_hh.dta", clear
* a) _N within nquest = number of rows (waves) of each household
bysort nquest: generate n_waves = _N
tabulate n_waves if year == 2022
* b)
keep if n_waves == 6
keep nquest year w_real
reshape wide w_real, i(nquest) j(year)
* c)
generate dw = w_real2022 - w_real2010
summarize dw, detail
* d) every variable must be in the stub list or constant within i:
* a variable that changes over time (e.g. head_age) cannot fit in one row.


* =============================================================================
* EXERCISE 5 (10 min) - From households to regions: collapse (Handbook 5.5)
* =============================================================================

* Open data/clean/shiw_hh.dta.
*  a) Create a dataset with one row per region and wave containing: the
*     mean of y_eq, the median of y_eq, the mean of w_real and the share of
*     main earners with a degree. Use the survey weights [pw = peso] and
*     keep region_name and area3 in the by() list.
*  b) Check that ireg year identify the rows, label the variables and save
*     as data/clean/region_year.dta
*  c) Which region of the Centre has the highest mean income in 2022?

use "$clean/shiw_hh.dta", clear
* a) the mean of a 0/1 variable is a share
collapse (mean) y_eq w_real head_university (median) y_eq_median = y_eq ///
         [pw = peso], by(year ireg region_name area3)
* b)
isid ireg year
label variable y_eq            "Mean equivalised income"
label variable y_eq_median     "Median equivalised income"
label variable w_real          "Mean net wealth"
label variable head_university "Share of main earners with a degree"
save "$clean/region_year.dta", replace
* c)
list region_name y_eq if year == 2022 & area3 == 2


* =============================================================================
* CLOSE
* =============================================================================

log close
