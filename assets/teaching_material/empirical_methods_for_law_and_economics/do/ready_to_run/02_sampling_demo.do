* LECTURE 2 - READY-TO-RUN SIMULATION (students run it; no programming required)
* ALL DATA IN THIS FILE ARE ARTIFICIAL.
* Artificial population: durations of commercial cases in days, right-skewed
* (lognormal), population mean 300 days and population SD 150 days.
* We draw 2,000 independent random samples of size n = 5, 25 and 100, and for
* each sample compute the mean, the SD, the standard error and a 95% t interval.

* Usually launched from exercises/02_sampling_and_inference.do, which has already set the course folder.
* If you run it on its own, Stata's working directory must be the course folder (the one containing data/ and do/).

* Run setup only if the global results-folder path has not yet been defined.
if "$course_results" == "" {
* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
    do "do/00_setup.do"
* End the preceding conditional block; subsequent lines run outside that block.
}
* Close the named simulation log if open; capture suppresses an error if it is not open.
capture log close sampling_demo
* Start a text log of commands and output; replace overwrites the previous log, and name() identifies a separate named log.
log using "$course_results/logs/02_sampling_demo.log", text replace name(sampling_demo)

* Population parameters (change these only in a COPY of this file)
* Set the known artificial population mean to 300 days; this is a chosen teaching parameter.
global pop_mean = 300
* Set the known artificial population SD to 150 days; this is not an estimate from World Bank data.
global pop_sd   = 150

* ---- 1. Picture the artificial population (100,000 draws) ---------------
* Remove the current data from memory; leave saved files on disk unchanged.
clear
* Fix the random-number seed so the same Stata setup can reproduce the artificial draws.
set seed 20261008
* Create this many blank rows for the population picture or current sample; quietly suppresses routine output.
quietly set obs 100000
* Convert the desired mean and SD in days into the variance of the underlying normal log-duration; globals expand with $. 
local s2 = ln(1 + ($pop_sd/$pop_mean)^2)
* Compute the mean of log-duration so exponentiated normal draws have the desired population mean in days.
local mu = ln($pop_mean) - `s2'/2
* Generate positive lognormal durations by exponentiating normal random draws; double preserves numerical precision.
generate double y = exp(rnormal(`mu', sqrt(`s2')))
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize y, detail
* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram y if y < 1200, percent width(25) xline($pop_mean) ///
    /* Set the graph title; text in quotes is a label and not a variable name. */ title("Artificial population of case durations") ///
    /* Label the horizontal axis and, if present, the vertical axis with its units. */ xtitle("Days (one artificial case)") ytitle("Percent of cases") ///
    /* Add a graph footnote identifying the sample, reference lines or the artificial-data scope. */ note("Simulated: lognormal, mean 300, SD 150. Values above 1,200 days not shown.")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/02_population.png", replace width(1600)

* ---- 2. The program that draws ONE sample and returns its statistics -----
* Remove an existing sample_mean program; capture ignores an error if it does not exist.
capture program drop sample_mean
* Start a reusable program that returns numerical results in r() for simulate to collect.
program define sample_mean, rclass
* Interpret commands using Stata 16 syntax for compatibility with later Stata versions.
    version 16.0
* Require the option n() to contain an integer; its value becomes the local macro n.
    syntax, N(integer)
* Remove all variables and observations for this draw, without deleting the running program.
    drop _all
* Create this many blank rows for the population picture or current sample; quietly suppresses routine output.
    quietly set obs `n'
* Convert the desired mean and SD in days into the variance of the underlying normal log-duration; globals expand with $. 
    local s2 = ln(1 + ($pop_sd/$pop_mean)^2)
* Compute the mean of log-duration so exponentiated normal draws have the desired population mean in days.
    local mu = ln($pop_mean) - `s2'/2
* Generate positive lognormal durations by exponentiating normal random draws; double preserves numerical precision.
    generate double y = exp(rnormal(`mu', sqrt(`s2')))
* Calculate summary statistics silently and store results in r(); detail also stores the median r(p50).
    quietly summarize y
* Copy the most recently calculated mean r(mean) into local macro m before another command overwrites r().
    local m  = r(mean)
* Store the sample SD r(sd) in local macro s, before another command changes r().
    local s  = r(sd)
* Estimate uncertainty of this sample mean as sample SD divided by sqrt(n); backticks expand local macros.
    local se = `s'/sqrt(`n')
* Compute the two-sided 95% t critical value: invttail uses upper-tail probability .025 and n-1 degrees of freedom.
    local c  = invttail(`n'-1, .025)
* Return this single numerical result in r() so simulate can collect it once per sample.
    return scalar samplemean = `m'
* Return this single numerical result in r() so simulate can collect it once per sample.
    return scalar sd   = `s'
* Return this single numerical result in r() so simulate can collect it once per sample.
    return scalar se   = `se'
* Return this single numerical result in r() so simulate can collect it once per sample.
    return scalar low  = `m' - `c'*`se'
* Return this single numerical result in r() so simulate can collect it once per sample.
    return scalar high = `m' + `c'*`se'
* Finish the definition of the sample_mean program; the program runs only when called.
end

* ---- 3. Repeat it 2,000 times for each sample size -------------------------
* Allocate temporary file paths in local macros s5 and s25; Stata cleans them up automatically.
tempfile s5 s25
* Repeat sample_mean and collect its r() results into columns; reps(), seed() and n() set repetition count, seed and cases per sample.
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    /* Run 2000 repetitions with this seed; nodots hides progress dots; the colon calls sample_mean with the stated n(). */ reps(2000) seed(20261009) nodots: sample_mean, n(5)
* Label every result row with the number of artificial cases used in that sample (5, 25 or 100).
generate n = 5
* Number result rows from 1 to 2000 within this sample-size block; _n is the current row number.
generate rep = _n
* Save the current result dataset; a backtick path is a temporary file, while replace overwrites an existing named output.
save `s5'
* Repeat sample_mean and collect its r() results into columns; reps(), seed() and n() set repetition count, seed and cases per sample.
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    /* Run 2000 repetitions with this seed; nodots hides progress dots; the colon calls sample_mean with the stated n(). */ reps(2000) seed(20261010) nodots: sample_mean, n(25)
* Label every result row with the number of artificial cases used in that sample (5, 25 or 100).
generate n = 25
* Number result rows from 1 to 2000 within this sample-size block; _n is the current row number.
generate rep = _n
* Save the current result dataset; a backtick path is a temporary file, while replace overwrites an existing named output.
save `s25'
* Repeat sample_mean and collect its r() results into columns; reps(), seed() and n() set repetition count, seed and cases per sample.
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    /* Run 2000 repetitions with this seed; nodots hides progress dots; the colon calls sample_mean with the stated n(). */ reps(2000) seed(20261011) nodots: sample_mean, n(100)
* Label every result row with the number of artificial cases used in that sample (5, 25 or 100).
generate n = 100
* Number result rows from 1 to 2000 within this sample-size block; _n is the current row number.
generate rep = _n
* Add the saved n=5 and n=25 result rows below the current n=100 rows.
append using `s5' `s25'
* Create 1 when both endpoints enclose the known mean, otherwise 0; the mean of this flag is coverage.
generate byte covers_truth = (low <= $pop_mean) & (high >= $pop_mean)
* Attach a readable description to a variable; the values and variable name do not change.
label variable samplemean   "Mean of one simulated sample (days)"
* Attach a readable description to a variable; the values and variable name do not change.
label variable sd           "SD within one simulated sample (days)"
* Attach a readable description to a variable; the values and variable name do not change.
label variable se           "Estimated standard error, sd/sqrt(n) (days)"
* Attach a readable description to a variable; the values and variable name do not change.
label variable covers_truth "1 if the 95% interval contains the true mean 300"
* Sort result rows by sample size, then by repetition number within each size.
sort n rep
* Rearrange the displayed variable order; values and row order are unchanged.
order n rep samplemean sd se low high covers_truth

* ---- 4. Results: one row = one simulated sample, NOT one case ------------
* Summarize the listed columns by group; statistics() selects summaries and format() sets printed decimal places.
tabstat samplemean sd se covers_truth, by(n) statistics(mean sd) format(%9.2f)
* Theory: SD of the sample mean = 150/sqrt(n) = 67.1 (n=5), 30 (n=25), 15 (n=100)

* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram samplemean if n==5,   width(15) start(0) percent xline($pop_mean) name(n5, replace)   title("n = 5")   xtitle("Sample mean (days)")
* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram samplemean if n==25,  width(15) start(0) percent xline($pop_mean) name(n25, replace)  title("n = 25")  xtitle("Sample mean (days)")
* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram samplemean if n==100, width(15) start(0) percent xline($pop_mean) name(n100, replace) title("n = 100") xtitle("Sample mean (days)")
* Combine the three named graphs; rows(1) places them side by side and common axes make their spread comparable.
graph combine n5 n25 n100, rows(1) xcommon ycommon ///
    /* Set the graph title; text in quotes is a label and not a variable name. */ title("2,000 sample means for each sample size (simulated)")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/02_sampling_distributions.png", replace width(2000)

* Intervals that miss the true mean are drawn in orange (if there are any among the first 40)
* Count matching rows without printing output; r(N) records how many intervals missed 300.
quietly count if n==25 & rep<=40 & covers_truth==0
* Initialize an empty local text macro for the optional plot of noncovering intervals.
local misses ""
* Store legend options as text; compound quotes keep nested quoted labels intact.
local leg `"order(1 "Covers 300") rows(1)"'
* Add the next plot layer only if the immediately preceding count found at least one missed interval.
if r(N) > 0 {
* Store an extra interval-plot layer as text: orange segments represent intervals that fail to cover the true mean.
    local misses (rcap low high rep if n==25 & rep<=40 & covers_truth==0, horizontal lcolor(orange))
* Store legend options as text; compound quotes keep nested quoted labels intact.
    local leg `"order(1 "Covers 300" 2 "Misses 300") rows(1)"'
* End the preceding conditional block; subsequent lines run outside that block.
}
* Start a layered graph of covering confidence intervals; rcap draws segments with endpoint caps and horizontal rotates them.
twoway (rcap low high rep if n==25 & rep<=40 & covers_truth==1, horizontal lcolor(navy)) ///
       /* Insert the optional missed-interval layer from the local macro; if it is empty no extra layer is drawn. */ `misses' ///
       /* Add a dot for each sample mean; the y-coordinate is its repetition number and colour/size control appearance. */ (scatter rep samplemean if n==25 & rep<=40, msize(small) mcolor(black)), ///
       /* Add mean/median reference lines; lcolor sets colour and lpattern(dash) gives the median a dashed line. */ xline($pop_mean) legend(`leg') ///
       /* Set the graph title; text in quotes is a label and not a variable name. */ title("Forty 95% confidence intervals, n = 25") ///
       /* Label the horizontal axis and, if present, the vertical axis with its units. */ xtitle("Days") ytitle("Simulated sample")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/02_forty_intervals.png", replace width(1600)

* Save the current result dataset; a backtick path is a temporary file, while replace overwrites an existing named output.
save "$course_results/tables/02_sampling_results.dta", replace
* Write the result rows as a CSV text file; replace overwrites the previous CSV.
export delimited using "$course_results/tables/02_sampling_results.csv", replace
* Close only the named sampling_demo log, leaving other logs unaffected.
log close sampling_demo
