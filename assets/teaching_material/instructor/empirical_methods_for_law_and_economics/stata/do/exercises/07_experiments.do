* =============================================================================
* LECTURE 7 - STUDENT WORKSHEET: experiments and difference-in-differences
* Data: Gneezy and Rustichini (2000), "A fine is a price", Journal of Legal Studies
*       29(1): 1-17, Table 1, transcribed by the instructor.
* =============================================================================
* How to use this file
*   1. Save a copy under your own name (e.g. 07_yourname.do) and work on the copy.
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
log using "$course_results/logs/07_exercise.log", text replace


* =============================================================================
* PART A. GUIDED STATA (the commands on the slides)
* =============================================================================

* ---- Slide "Guided Stata 1: before the fine" --------------------------------
* Load the day-care data: one row per centre and week (10 centres x 20 weeks).
use "$course_data/daycare_fines.dta", clear
* Variables, labels and number of rows.
describe
* Before the fine (weeks 1-4): mean number of late-coming parents and of children,
* separately for the fine group and the control group; n counts the rows.
tabstat late children if week <= 4, by(fine_group) statistics(mean n)
* Save a copy of the data in memory, because collapse will replace it.
preserve
* Replace the data with one row per group and week, containing the mean of late.
collapse (mean) late, by(fine_group week)
* Two lines on the same graph, one per group; xline() marks the weeks when the fine
* starts and ends; legend() names the two lines; /// continues the command.
twoway (line late week if fine_group == 1) (line late week if fine_group == 0), ///
    xline(4.5 16.5) legend(order(1 "Fine" 2 "Control"))
* Bring back the original 200 rows.
restore

* ---- Slide "Guided Stata 2: difference-in-differences" -----------------------
* 0/1 variable: 1 in weeks 5-16, when the fine is in force in the fine group.
generate byte during = (period == 2)
* Table of mean late arrivals: rows = group, columns = before/during;
* summarize(late) means asks for the mean of late in each cell. Weeks 17-20 excluded.
tabulate fine_group during if week <= 16, summarize(late) means
* Regression with both indicators and their product: ## adds fine_group, during and
* fine_group#during. The coefficient on the product is the difference-in-differences.
regress late i.fine_group##i.during if week <= 16

* ---- Slide "Guided Stata 3: counting centres" --------------------------------
* The same regression with standard errors clustered by centre: the 16 weeks of a
* centre count as one group of related observations; there are 10 groups.
regress late i.fine_group##i.during if week <= 16, vce(cluster centre)
* Save a copy of the data, because collapse will replace it.
preserve
* Copy late into two variables: one filled only before the fine, one only during it.
generate late_before = late if week <= 4
generate late_fine = late if week >= 5 & week <= 16
* One row per centre: the mean before and the mean during (missing values are ignored).
collapse (mean) late_before late_fine, by(centre fine_group)
* The change of each centre.
generate change = late_fine - late_before
* Show the ten centres.
list centre fine_group late_before late_fine change
* Compare the mean change of the 4 control centres (group 0) and the 6 fined centres
* (group 1): Stata reports mean(0) - mean(1).
ttest change, by(fine_group)
* Bring back the original 200 rows.
restore


* =============================================================================
* PART B. LABORATORY
* =============================================================================

* Reload the data and recreate the indicator of weeks 5-16.
use "$course_data/daycare_fines.dta", clear
generate byte during = (period == 2)

* TASK 1. After the fine was removed (weeks 17-20).
* TODO: generate byte after = (period == 3)
* TODO: tabulate fine_group after if period != 2, summarize(late) means
*       (period != 2 keeps weeks 1-4 and 17-20)
* TODO: regress late i.fine_group##i.after if period != 2, vce(cluster centre)
* WRITE: the difference-in-differences after the removal, as a sentence. Is it larger
*        or smaller than during the fine?

* TASK 2. All three periods in one regression.
* TODO: regress late i.fine_group##i.period, vce(cluster centre)
* WRITE: which two coefficients reproduce the estimates of Part A and Task 1?

* TASK 3. A placebo test: a fake fine before the real one.
* Pretend the fine started in week 3. Only weeks 1-4 are used: nothing happened then.
* TODO: generate byte fake = (week >= 3)
* TODO: regress late i.fine_group##i.fake if week <= 4, vce(cluster centre)
* WRITE: what do you expect the interaction to be, and what do you find? What does this
*        say about the parallel-trends assumption?

* TASK 4. Late arrivals per 100 children.
* Centres have between 28 and 37 children.
* TODO: generate rate = 100*late/children
* TODO: regress rate i.fine_group##i.during if week <= 16, vce(cluster centre)
* WRITE: the difference-in-differences per 100 children. Why might a referee prefer it?

* TASK 5. The randomization test by hand.
* TODO: rerun the preserve ... restore block of Guided Stata 3 and look at the list.
* WRITE: is every change in the fine group larger than every change in the control
*        group? There are 210 ways to choose 6 centres out of 10 (display comb(10,6)).
*        Explain why the probability of this pattern under "no effect" is 1/210.

* TASK 6. Write (as comments below):
* 1. One referee comment on the internal validity of the study, with the four steps.
* 2. A design for the text-message experiment of the slides: unit of randomisation,
*    outcome, number of independent units, one check before looking at the results.

* Close the log file.
log close
