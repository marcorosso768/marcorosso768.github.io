* =============================================================================
* LECTURE 3 - DESCRIPTIVE STATISTICS, TESTS AND GRAPHS
* Course:   Introduction to Stata (4 lectures)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Handbook: Introduction to Stata, Chapters 6-7 (and 12.2-12.3)
* Data:     Banca d'Italia, Indagine sui bilanci delle famiglie italiane (SHIW),
*           historical archive, version 12.2
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: exercises. Write your code below each task; run it block by block.
* =============================================================================

/*
   WHERE WE ARE
   Lecture 2 saved in data/clean/: shiw_hh.dta (households), individuals_full
   (persons), region_year (regions). If some file is missing, run
   L2_solutions.do first.

   TODAY: describe the data, test simple hypotheses, draw graphs, and prepare
   the analysis file for the regressions of Lecture 4.
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
log using "$logs/L3.log", text replace

foreach f in shiw_hh individuals_full region_year {
    capture confirm file "$clean/`f'.dta"
    if _rc != 0 {
        display as error "`f'.dta not found: run L2_solutions.do first"
        exit 601
    }
}

* Default look of the graphs (Handbook 7.4).
set scheme stcolor

use "$clean/shiw_hh.dta", clear


* =============================================================================
* SECTION 1: SUMMARIZE AND STORED RESULTS (Handbook 6.1, 12.3)
* =============================================================================

* 1.1 Centre, spread, shape

summarize y_eq w_real head_age head_educ_years hhsize
* detail: percentiles, skewness, kurtosis
summarize y_eq if year == 2022, detail

* 1.2 Results stored in r()

* r() is overwritten by the next command: use it immediately.
return list
display "Mean / median = " r(mean) / r(p50)
* Mean > median and skewness > 0: income is right-skewed.
summarize ln_y_eq if year == 2022, detail


* =============================================================================
* SECTION 2: SURVEY WEIGHTS AND MEANS (Handbook 6.4)
* =============================================================================

* 2.1 Sample vs population

* Unweighted statistics describe the SAMPLE; weighted ones the POPULATION.
summarize y_eq if year == 2022
summarize y_eq [aweight = peso] if year == 2022
* pweights (sampling weights) give the population mean with a correct
* standard error and confidence interval.
mean y_eq [pweight = peso] if year == 2022, over(area3)


* =============================================================================
* SECTION 3: TABLES (Handbook 6.2, 6.3)
* =============================================================================

* 3.1 Frequencies: one-way and two-way

tabulate head_educ if year == 2022
* column: percentages within each column (each area sums to 100)
tabulate head_educ area3 if year == 2022, column nofreq

* 3.2 Statistics by group

tabstat y_eq w_real if year == 2022, by(area3) statistics(n mean p50 sd) format(%9.0fc)
* table (rows) (columns): weighted mean income by area and wave
table (area3) (year) [aweight = peso], statistic(mean y_eq) nformat(%9.0fc)


* =============================================================================
* SECTION 4: CORRELATION AND A FIRST TEST (Handbook 6.6, 6.7)
* =============================================================================

* From now on: the most recent wave.
keep if year == 2022

* 4.1 Correlation

* correlate: listwise deletion (one N); pwcorr: pairwise N and p-values.
correlate ln_y_eq head_educ_years head_age hhsize
pwcorr ln_y_eq head_educ_years head_age hhsize, sig star(.05) obs
* Spearman correlates the ranks: robust to skewness and outliers.
spearman y_eq w_real

* 4.2 Difference in means: ttest

* H0: mean log income is equal for households with female and male main
* earner.
ttest ln_y_eq, by(head_female)


* =============================================================================
* SECTION 5: GRAPHS (Handbook 7.1, 7.2, 7.4, 7.6)
* =============================================================================

* 5.1 Distribution: histogram

* A few households with income close to zero have very negative logs: we
* look at the central part of the distribution.
histogram ln_y_eq if inrange(ln_y_eq, 7, 13), normal ///
    title("Log equivalised income, 2022") xtitle("Log equivalised income")
graph export "$figures/hist_log_income.pdf", replace

* 5.2 Relationship: scatter plot with a fitted line (regions)

use "$clean/region_year.dta", clear
twoway (scatter y_eq head_university if year == 2022, mlabel(region_name) mlabsize(vsmall)) ///
       (lfit y_eq head_university if year == 2022), ///
       legend(off) xtitle("Share of main earners with a degree") ///
       ytitle("Mean equivalised income (euros)")
graph export "$figures/scatter_regions.pdf", replace


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (10 min) - A "Table 1" for a paper (Handbook 6.3)
* =============================================================================

* Open data/clean/shiw_hh.dta and keep the 2022 wave.
*  a) Create income and wealth in thousands of euros (y_eq_k, w_real_k).
*  b) With dtable, build a table of descriptive statistics by macro area
*     (area3) with: y_eq_k, w_real_k, head_age, head_educ_years, hhsize,
*     and the categorical variables head_female and head_educ (use i.).
*     Add tests of equality across areas and one decimal for mean and sd.
*  c) Export it to output/tables/table1.tex and to table1.docx
*  d) Is the table weighted? What would change with [pweight = peso]?

* >>> write your code here


* =============================================================================
* EXERCISE 2 (10 min) - Tests on means, proportions, independence (Handbook 6.7)
* =============================================================================

* Same data (2022). Write H0 before running each test.
*  a) Is mean log income different between female and male main earners?
*     Repeat without assuming equal variances (option unequal).
*  b) Is the share of graduates different between female and male main
*     earners? (prtest)
*  c) Is mean log income the same in all education groups? (oneway)
*  d) Is the education of the main earner independent of the macro area?
*     (tabulate ..., chi2)

* >>> write your code here


* =============================================================================
* EXERCISE 3 (10 min) - Weighted means and tests (Handbook 6.4, 6.7)
* =============================================================================

* Same data (2022).
*  a) Estimate the population mean of ln_y_eq by macro area with mean and
*     [pweight = peso]. Add the option coeflegend to see the names of the
*     estimates.
*  b) Test that the mean is equal in the North and in the South (test).
*  c) Compare with the unweighted means: why are they different?

* >>> write your code here


* =============================================================================
* EXERCISE 4 (10 min) - Graphs by group (Handbook 7.1, 7.3, 7.6, 12.2)
* =============================================================================

* Same data (2022).
*  a) Kernel densities of ln_y_eq for the three macro areas in one graph
*     (restrict to values between 7 and 13), with a legend. Export it.
*  b) Box plot of ln_y_eq by education of the main earner. Export it.
*  c) Bar chart of the weighted mean of y_eq by education. Export it.
*  d) Bonus: a loop that draws one histogram per macro area, titled with
*     the name of the area, and combines the three graphs.

* >>> write your code here


* =============================================================================
* EXERCISE 5 (10 min) - Getting ready for the regression (Handbook 6.5, 7.2)
* =============================================================================

* Same data (2022).
*  a) Conditional mean: group the age of the main earner (25-84) in 5-year
*     bins (age_bin = 5 * floor(head_age / 5)), compute the weighted mean
*     of ln_y_eq in each bin (collapse, inside preserve/restore) and plot it
*     with a linear (lfit) and a quadratic (qfit) fit. Is the profile linear?
*  b) Correlations among the future regressors: head_educ_years, head_age,
*     hhsize, n_children. Any very high correlation?
*  c) Winsorize y_eq at the 1st and 99th percentiles (_pctile) into y_eq_w,
*     and create ln_y_eq_w.
*  d) Create sample = 1 if ln_y_eq, head_educ_years, head_age and hhsize
*     are all non-missing. Save as data/clean/shiw_2022.dta

* >>> write your code here


* =============================================================================
* CLOSE
* =============================================================================

log close
