* LECTURE 2 - STUDENT WORKSHEET
* All data in this lab are ARTIFICIAL (simulated). Do not describe them as findings.

* Before running: save this file under a new name (e.g. 02_yourname.do) and complete the TODO lines.

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the one containing the subfolders data/ and do/; replace the placeholder below with its path.
cd "path_to_the_main_folder"

* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
do "do/00_setup.do"

* TASK 1. Run the ready-to-run simulation (it takes a few seconds and saves 3 graphs
* in results/figures: population, sampling distributions, forty intervals).
do "do/ready_to_run/02_sampling_demo.do"

log using "$course_results/logs/02_student.log", text replace
use "$course_results/tables/02_sampling_results.dta", clear

* TASK 2. What does one row of this results file represent?
describe
* TODO: tabulate n
* WRITE: one row is ...

* TASK 3. Standard deviation versus standard error.
* TODO: tabstat samplemean sd se, by(n) statistics(mean sd)
* WRITE: (a) Does the average within-sample SD fall as n grows? Why (not)?
*        (b) What happens to the SD of samplemean when n goes from 25 to 100?
*        (c) Compare it with the average of se. What is se estimating?

* TASK 4. Shape of the sampling distribution.
* Look at the graph 02_sampling_distributions.png in results/figures.
* WRITE: the population is skewed. Are the sample means skewed for n=5? For n=100?

* TASK 5. Coverage.
* TODO: tabstat covers_truth, by(n) statistics(mean n)
* WRITE: what fraction of intervals contain 300? Why is it not exactly 0.95?
*        For which n is it furthest from 0.95, and why might that be?

* TASK 6 (extension). Predict the SD of the sample mean for n = 400, then check it.
* The simulation program is still in memory after TASK 1, so you can run:
*   preserve
*   simulate samplemean=r(samplemean), reps(2000) seed(20261012) nodots: sample_mean, n(400)
*   summarize samplemean
*   restore

* TASK 7. Two paragraphs (write them below as comments):
* 1. SD versus SE, with units and the numbers you obtained:
* 2. A correct interpretation of "95% confidence", referring to what varies
*    across repeated samples and what stays fixed:

* PAPER BRIDGE (Gneezy and Rustichini 2000, Table 1 and Figure 1):
* WRITE: why are 200 centre-week counts not 200 independent observations
*        of the effect of the fine?

log close
