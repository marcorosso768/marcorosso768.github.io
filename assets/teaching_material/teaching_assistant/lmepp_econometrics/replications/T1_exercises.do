* =============================================================================
* REPLICATION TUTORIAL 1 - AUTOR AND DORN (2009)
* "This Job is 'Getting Old': Measuring Changes in Job Opportunities Using
*  Occupational Age Structure", American Economic Review: Papers and
*  Proceedings 99(2): 45-51
* Course:   Replication tutorials (after Introduction to Stata)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Data:     the authors' replication archive, Public-Release-Data (November
*           2014): https://ddorn.net/data.htm, entry P1. Used as it is.
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: four exercises. Write your code below each task.
* =============================================================================

/*
   THE FOLDER
       Replication_T1/
           Autor_Dorn_2009.pdf    the paper
           Public-Release-Data/   the authors' archive, unzipped as it is
               Readme.pdf
               do/                their two do-files
               dta/               their two datasets (never modify them)
               log/               their do-files write the logs here
               tab-fig/           the tables of the paper (Excel)
           T1_exercises.do        this file
           output/                created by this file (log, figure)

   TODAY
   1. Run the package as the authors released it.
   2. Rebuild Table 1 and one cell of Table 2 step by step: which line of
      code produces which number of the paper?
   3. Exercises: descriptives and an identity, weights and standard errors,
      Table 2 with loops, a panel that does not replicate.
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
if "$root" == "" global root "C:/path/to/Replication_T1"   // <- CHANGE THIS LINE
global pkg "$root/Public-Release-Data"
global out "$root/output"
cd "$root"
capture mkdir "$out"
capture mkdir "$pkg/log"


* =============================================================================
* SECTION 1: RUN THE PACKAGE AS THE AUTHORS DO
* =============================================================================

* Readme.pdf: occ1990dd_ageanalysis_v2.do -> Table 1,
*             czone_ageanalysis_tab2-2009_v2.do -> Table 2.
* Their paths are RELATIVE to Public-Release-Data/do (../dta, ../log): we move into that
* folder, run the two files and come back. Nothing else is changed.
* Their files open and close their own logs, so we open ours only afterwards.
* "set memory" is ignored since Stata 12: Stata prints a note, not an error.

cd "$pkg/do"
do "occ1990dd_ageanalysis_v2.do"
do "czone_ageanalysis_tab2-2009_v2.do"
cd "$root"
* Now open Public-Release-Data/log/occ1990dd_ageanalysis_v2.log and compare it with
* Table 1 of the paper, column by column.

capture log close
log using "$out/T1.log", text replace


* =============================================================================
* SECTION 2: TABLE 1 STEP BY STEP (occupation level)
* =============================================================================

* 2.1 The data: one row per occupation

use "$pkg/dta/occ1990dd_data2012pp.dta", clear
describe, short
isid occ1990dd                        // 330 harmonized occupations, no duplicates
summarize sh_empl1980
display "Sum of the 1980 employment shares: " r(sum)   // = 1

* 2.2 Outcomes and regressors: changes 1980-2005

generate chg_avgage8005 = avg_age2005 - avg_age1980          // years
generate chg_empsh8005  = 100 * (sh_empl2005 - sh_empl1980)  // percentage points
foreach z in 1629 3054 5564 {
    generate chg_shage8005_`z' = sh_age`z'_2005 - sh_age`z'_1980
}

* RTI has no natural unit: standardize it with the 1980 employment weights
* (mean 0, standard deviation 1 across occupations, as in the paper).
summarize RTIb [aw = sh_empl1980]
generate RTIstd = (RTIb - r(mean)) / r(sd)
summarize RTIstd [aw = sh_empl1980]

* 2.3 Table 1, Panels A-C: 3 specifications x 4 outcomes = 12 regressions
* [aw = sh_empl1980]: each occupation counts in proportion to its 1980 size.

local spec1 "chg_empsh8005"
local spec2 "RTIstd"
local spec3 "RTIstd chg_empsh8005"
forvalues p = 1/3 {
    local k = 0
    foreach y in chg_avgage8005 chg_shage8005_1629 chg_shage8005_3054 chg_shage8005_5564 {
        local ++k
        quietly regress `y' `spec`p'' [aw = sh_empl1980]
        estimates store P`p'_`k'
    }
}
* One table per panel. Columns: mean age, share 16-29, 30-54, 55-64.
* estimates table aligns the coefficients by name across the four outcomes
* (etable would put each outcome's coefficients on separate rows).
estimates table P1_1 P1_2 P1_3 P1_4, b(%9.3f) se(%9.3f) stats(N) title("Panel A")
estimates table P2_1 P2_2 P2_3 P2_4, b(%9.3f) se(%9.3f) stats(N) title("Panel B")
estimates table P3_1 P3_2 P3_3 P3_4, b(%9.3f) se(%9.3f) stats(N) title("Panel C")

* 2.4 The "proof of concept" in one picture (not in the paper)

twoway (scatter chg_avgage8005 chg_empsh8005 [aw = sh_empl1980], msymbol(Oh)) ///
       (lfit chg_avgage8005 chg_empsh8005 [aw = sh_empl1980]),             ///
       xtitle("Change in employment share 1980-2005 (p.p.)")                ///
       ytitle("Change in mean age (years)") legend(off)                     ///
       note("Marker size: 1980 employment share. Line: weighted OLS fit.")
graph export "$out/age_vs_size.png", replace


* =============================================================================
* SECTION 3: TABLE 2, ONE CELL (commuting zone level)
* =============================================================================

use "$pkg/dta/workfile2012pp.dta", clear
keep if yr >= 1980                    // the file also contains 1950 and 1970
isid czone yr                         // 722 CZs x 3 periods = 2,166 rows
tabulate yr
* yr is the START of the period: 1980-1990, 1990-2000, 2000-2005.
* t1 t2 t3 are period dummies: we include t2 and t3 (t1 is the base).
* d_ variables: changes, in 10-year equivalents. l_ variables: start of period.
* l_sh_routine33b: share of CZ employment in routine occupations (0-1).
summarize l_sh_routine33b [aw = timepwt48] if yr == 1980

* Panel A, all workers, age 16-29. The authors write cluster(statefip):
* the older syntax of vce(cluster statefip).
regress d_sh_routine_among1629 l_sh_routine33b t2 t3 [aw = timepwt48], ///
        vce(cluster statefip)
* -0.31: a CZ with a 10 p.p. higher routine share at the start of the period
* sees the routine share of its young workers fall by 3.1 p.p. more per decade.


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (6 min + 4 min solution) - Panel D and an identity
* =============================================================================

* Open Public-Release-Data/dta/occ1990dd_data2012pp.dta and rebuild the variables of
* Section 2.2 (or run Section 2 again).
*  a) Reproduce Panel D of Table 1: weighted mean and standard deviation of
*     the four outcomes. Compare with the paper.
*  b) In each year the three age shares of an occupation sum to one. What
*     must the three changes sum to? Check it in the data.
*  c) What does b) imply for the coefficients in columns 2-4 of Panels A-C?
*     Check it with one regression.

* >>> write your code here



* =============================================================================
* EXERCISE 2 (6 min + 4 min solution) - Weights and standard errors
* =============================================================================

* Same data.
*  a) Estimate Panel A, column 1 without weights. Compare with -0.78.
*  b) Why can the two coefficients differ? Which one answers the question of
*     the paper?
*  c) Estimate the weighted model with vce(robust). What happens to the
*     standard error and to the t statistic? Repeat for Panel B, column 1.

* >>> write your code here



* =============================================================================
* EXERCISE 3 (8 min + 4 min solution) - Table 2 with loops
* =============================================================================

* Open Public-Release-Data/dta/workfile2012pp.dta and keep yr >= 1980.
* The authors write 27 regressions by hand. With ONE set of nested loops,
* print Panels A (routine) and C (nroutinel) of Table 2: for each
* occupation group, each education group (all, c, nc) and each age group
* (1629, 3054, 5564), the coefficient of l_sh_routine33b and its standard
* error, one row per education group. Compare with the paper.
* Hint: variable names are d_sh_<occ>_among<age><edu>, with edu = "" for
* all workers; display ... _continue writes on the same line.
* The loops are ready: complete the two lines marked >>> (it runs as it is,
* printing only the headers).

use "$pkg/dta/workfile2012pp.dta", clear
keep if yr >= 1980
foreach occ in routine nroutinel {
    display _newline as text "Occupations: `occ'" _col(27) "16-29" _col(43) "30-54" _col(59) "55-64"
    foreach e in all c nc {
        local s = cond("`e'" == "all", "", "`e'")   // suffix: empty for all workers
        display as text "  `e'" _col(25) _continue
        foreach a in 1629 3054 5564 {
            * >>> 1. quietly regress d_sh_`occ'_among`a'`s' on l_sh_routine33b t2 t3,
            *        with the weights and the clusters of Section 3
            * >>> 2. display the coefficient and the standard error of
            *        l_sh_routine33b: _b[...], _se[...], %6.2f, _continue
        }
        display ""
    }
}



* =============================================================================
* EXERCISE 4 (8 min + 4 min solution) - A panel that does not replicate
* =============================================================================

* Same data.
*  a) Run your loop for Panel B (nroutineh). Compare with the paper.
*  b) For each age group, the shares in routine, nonroutine high-skill and
*     nonroutine low-skill occupations sum to one. What must hold for the
*     three d_sh_ variables? Check it for age 16-29, all workers.
*     Then compare d_sh_nroutineh_among1629 with d_sh_nroutinel_among1629.
*  c) Rebuild the high-skill outcome from the identity and estimate the
*     first cell of Panel B again.
*  d) What do you write in your replication report?

* >>> write your code here



* =============================================================================
* CLOSE
* =============================================================================

log close
