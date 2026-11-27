* =============================================================================
* LECTURE 2 - CREATING VARIABLES AND COMBINING DATASETS
* Course:   Introduction to Stata (4 lectures)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Handbook: Introduction to Stata, Chapters 4-5 (and 2.6, 12.1-12.2)
* Data:     Banca d'Italia, Indagine sui bilanci delle famiglie italiane (SHIW),
*           historical archive, version 12.2
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: exercises. Write your code below each task; run it block by block.
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
* missing in 2010-2022, but the condition protects us (missing > any
* number).
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
merge 1:1 nquest year using "$clean/rfam.dta", keepusing(y yl yt ym yc)
* _merge: 1 = only in master, 2 = only in using, 3 = matched.
tabulate _merge
drop _merge

* 4.2 merge m:1: many households, one region

* The key (ireg) repeats in the master and is unique in the using file.
merge m:1 ireg using "$clean/regions.dta", keepusing(region_name) ///
      assert(match) nogenerate

* 4.3 Checkpoint for the exercises

save "$clean/hh_step1.dta", replace


* =============================================================================
* SECTION 5: APPEND, RESHAPE, COLLAPSE (Handbook 5.1, 5.2, 5.4, 5.5)
* =============================================================================

* 5.1 append: add ROWS (same variables, different observations)

* preserve takes a snapshot of the data, restore brings it back.
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

* >>> write your code here


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

* >>> write your code here


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

* >>> write your code here


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

* >>> write your code here


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

* >>> write your code here


* =============================================================================
* CLOSE
* =============================================================================

log close
