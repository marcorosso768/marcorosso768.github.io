* LECTURE 2 - SOLUTIONS
* All data in this lab are ARTIFICIAL (simulated).

* Before running: save this solution file under your own name if you want to add notes.

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the do/ folder, the one containing data/ and 00_setup.do; replace the placeholder below with its path.
cd "path_to_the_main_folder"

* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
do "00_setup.do"

* TASK 1. Run the supplied simulation (saves 3 graphs in results/figures).
* [slide: Guided Stata: the supplied simulation]
* Run the supplied simulation do-file; it creates artificial samples, figures and the saved result dataset.
do "ready_to_run/02_sampling_demo.do"

* Start a text log of commands and output; replace overwrites the previous log, and name() identifies a separate named log.
log using "$course_results/logs/02_answer.log", text replace
* Load this saved .dta file into memory; clear permits replacing the current in-memory data.
use "$course_results/tables/02_sampling_results.dta", clear

* TASK 2. What does one row of this results file represent?
* Show variable names, storage types and labels; does not change the data.
describe
* Produce a frequency table of this category; missing includes unknown values when that option is present.
tabulate n
* The command shown on the Guided Stata slide (all four variables at once):
* Summarize the listed columns by group; statistics() selects summaries and format() sets printed decimal places.
tabstat samplemean sd se covers_truth, by(n) statistics(mean sd)
* ANSWER: one row is one simulated sample (2,000 per sample size), not one case.

* TASK 3. Standard deviation versus standard error.
* Summarize the listed columns by group; statistics() selects summaries and format() sets printed decimal places.
tabstat samplemean sd se, by(n) statistics(mean sd) format(%9.2f)
* Read the exact realised values from this run, not from another software package.
* The population SD is 150; theoretical SEs are 67.1, 30 and 15 for n=5,25,100.
* The sample SD s varies and may be downward biased in small samples; this is
* an optional nuance, not a required beginner outcome. E[s]=sigma is not guaranteed.
* The mean of samplemean should be near 300 for each n.

* TASK 4. Shape of the sampling distribution.
* [slides: What the simulation shows; The central limit theorem, informally]
* ANSWER: for n=5 the sample means are visibly right-skewed (as the population);
*         for n=100 they are close to symmetric around 300 (central limit theorem).
*         See results/figures/02_sampling_distributions_answer.png.

* TASK 5. Coverage.
* [slide: A 95% confidence interval]
* Summarize the listed columns by group; statistics() selects summaries and format() sets printed decimal places.
tabstat covers_truth, by(n) statistics(mean n) format(%9.3f)
* Read the realised coverage from this output; do not assume preprinted values.
* With a skewed population the t interval is only approximate; its coverage
* approaches 95% as n grows. With 2,000 replications the Monte Carlo SE of a
* coverage share is sqrt(.95*.05/2000) = 0.005, so differences of 1 point or
* less between runs are noise. WRITE YOUR OWN RUN'S NUMBERS HERE BEFORE CLASS.
* Calculate Monte Carlo SE of a coverage proportion near .95 using 2000 repetitions; this is uncertainty of the simulation summary.
display sqrt(.95*.05/2000)
* Count only rows meeting this condition; == tests equality, < means less than, !missing() excludes unknowns; result is stored in r(N).
count if n==25 & rep<=40 & covers_truth==0
* Original output note: misses among the 40 plotted intervals

* TASK 6 (extension). SD of the sample mean for n = 400.
* Prediction: 150/sqrt(400) = 7.5 days.
* OPTIONAL: change 0 to 1 below to run this extension after class.
* A false condition skips this block, preserving time for the core tasks.
if 0 {
* Temporarily save the current in-memory dataset so restore can recover it.
preserve
* Repeat sample_mean and collect its r() results into columns; reps(), seed() and n() set repetition count, seed and cases per sample.
simulate samplemean=r(samplemean), reps(2000) seed(20261012) nodots: sample_mean, n(400)
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize samplemean
* Recover the dataset saved by preserve, undoing intervening in-memory changes.
restore

* End the optional block; core interpretation resumes below.
}

* TASK 7. Two paragraphs: SD versus SE with units and numbers; the meaning of
* "95% confidence" (the interval varies across repeated samples, the true mean
* 300 days is fixed; about 95% of such intervals would contain it in the long run,
* not 95% of cases, and not a 95% probability for this one interval).
* Here skewness means the t procedure is only approximately calibrated; the
* claimed long-run coverage requires assumptions and is assessed in the simulation.
* Illustrative interval from the slides (n=25, mean 312, s=150)
* Calculate the t multiplier for the stated degrees of freedom using upper-tail area .025.
display "t critical, 24 df: " invttail(24,.025)
* Calculate lower and upper t-interval endpoints for the illustrative mean 312, SD 150 and n=25.
display "CI: " 312 - invttail(24,.025)*150/sqrt(25) " to " 312 + invttail(24,.025)*150/sqrt(25)
* Calculate the t multiplier for the stated degrees of freedom using upper-tail area .025.
display "t critical, 99 df: " invttail(99,.025)

* PAPER BRIDGE (Gneezy and Rustichini 2000). ANSWER: the 200 centre-week counts come
* from 10 centres observed over 20 weeks; counts from the same centre are dependent
* (same parents, same staff), so the effective number of independent units is
* determined by the dependence structure and analysis, not a simple row count.
* There are 10 independently assigned centres. Positive within-centre dependence
* can make an independent-row calculation overstate precision; no universal
* effective sample size follows from 10 and 200 alone.

* Close the current unnamed text log and finish writing its output.
log close
