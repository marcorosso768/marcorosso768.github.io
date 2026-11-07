* =============================================================================
* LECTURE 7 - SOLUTIONS: experiments and difference-in-differences
* Data: Gneezy and Rustichini (2000), "A fine is a price", Journal of Legal Studies
*       29(1): 1-17, Table 1, transcribed by the instructor.
* =============================================================================
* How to use this file
*   1. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   2. Part A contains the Guided Stata commands shown on the slides, in the same order.
*   3. Part B solves the laboratory tasks of exercises/07_experiments.do.

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/07_answer.log", text replace


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
* Expected: control: late 10.0, children 33.8, n 16; fine: late 8.0, children 33.7, n 24
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
* Expected: control 10.00 and 9.23; fine 8.00 and 16.44
* Regression with both indicators and their product: ## adds fine_group, during and
* fine_group#during. The coefficient on the product is the difference-in-differences.
regress late i.fine_group##i.during if week <= 16
* Expected: constant 10.00 (1.41); fine_group -2.00 (1.82); during -0.77 (1.62);
*           fine_group#during 9.22 (2.10, t 4.39), n 160

* ---- Slide "Guided Stata 3: counting centres" --------------------------------
* The same regression with standard errors clustered by centre: the 16 weeks of a
* centre count as one group of related observations; there are 10 groups.
regress late i.fine_group##i.during if week <= 16, vce(cluster centre)
* Expected: fine_group#during 9.22 (clustered SE 1.26, t 7.30, 9 degrees of freedom)
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
* Expected changes: fined centres 5.33, 7.00, 8.33, 10.17, 12.92, 6.92;
*                   control centres -1.50, -2.33, 0.83, -0.08
* Compare the mean change of the 4 control centres (group 0) and the 6 fined centres
* (group 1): Stata reports mean(0) - mean(1).
ttest change, by(fine_group)
* Expected: diff = -0.77 - 8.44 = -9.22, SE 1.50, t -6.15, 8 degrees of freedom, p 0.0003
* Bring back the original 200 rows.
restore


* =============================================================================
* PART B. LABORATORY: SOLUTIONS
* =============================================================================

* Reload the data and recreate the indicator of weeks 5-16.
use "$course_data/daycare_fines.dta", clear
generate byte during = (period == 2)

* TASK 1. After the fine was removed (weeks 17-20).
* 0/1 variable: 1 in weeks 17-20.
generate byte after = (period == 3)
* Mean late arrivals before (weeks 1-4) and after (weeks 17-20); period != 2 drops
* weeks 5-16.
tabulate fine_group after if period != 2, summarize(late) means
* Expected: control 10.00 and 8.25; fine 8.00 and 18.71
regress late i.fine_group##i.after if period != 2, vce(cluster centre)
* Expected: fine_group#after 12.46 (clustered SE 1.93, p 0.0001), n 80
* ANSWER: "After the fine was removed, late arrivals in the fined centres had risen by
*   about 12.5 per week more than in the control centres, compared with the weeks
*   before the fine." Larger than during the fine (9.2): the effect did not disappear.

* TASK 2. All three periods in one regression.
* i.period creates indicators for periods 2 and 3 (period 1 is the base).
regress late i.fine_group##i.period, vce(cluster centre)
* Expected: 1.fine_group#2.period 9.22 (SE 1.27); 1.fine_group#3.period 12.46 (SE 1.92)
* ANSWER: the two interactions reproduce the estimates of Part A (9.22) and of Task 1
*   (12.46). Their standard errors differ slightly because the regression uses all
*   200 rows at once.

* TASK 3. A placebo test: a fake fine before the real one.
generate byte fake = (week >= 3)
regress late i.fine_group##i.fake if week <= 4, vce(cluster centre)
* Expected: fine_group#fake -1.92 (clustered SE 1.79, p 0.31), n 40
* ANSWER: no fine existed in weeks 1-4, so we expect an interaction close to zero; we
*   find -1.9, not distinguishable from zero. The two groups moved in parallel before
*   the fine, which supports (but cannot prove) the parallel-trends assumption.
*   With only four weeks the test has little power.

* TASK 4. Late arrivals per 100 children.
generate rate = 100*late/children
regress rate i.fine_group##i.during if week <= 16, vce(cluster centre)
* Expected: fine_group#during 27.6 per 100 children (clustered SE 3.88)
* ANSWER: the fine increased late arrivals by about 28 per 100 children and week,
*   relative to the control centres. A referee may prefer it because centres differ in
*   size: the rate compares like with like. Here the conclusion is the same.

* TASK 5. The randomization test by hand.
preserve
generate late_before = late if week <= 4
generate late_fine = late if week >= 5 & week <= 16
collapse (mean) late_before late_fine, by(centre fine_group)
generate change = late_fine - late_before
* Sort by the change, so that the ranking is visible.
sort change
list centre fine_group change
restore
* Number of ways to choose 6 centres out of 10.
display comb(10,6)
* Expected: 210
* ANSWER: yes: the smallest change in the fine group (+5.33) is larger than the largest
*   change in the control group (+0.83). If the fine had no effect, each centre's change
*   would be the same whichever group it was in, and each of the 210 choices of 6 centres
*   would be equally likely. Only one choice puts the six largest changes in the fine
*   group, so the probability of a pattern this extreme is 1/210 = 0.005.

* TASK 6. See the slides "Internal and external validity: the referee's view" and
* "Design an experiment" and their answers.
* Example of a comment: "Footnote 7: two of the 12 centres were dropped because their
*   recordings were incomplete. If they were dropped after the assignment, and the fine
*   affected whether recordings were completed, the comparison is no longer between
*   randomly assigned groups. Please report the group of the two centres and the weeks
*   for which their recordings are available."

* Close the log file.
log close
