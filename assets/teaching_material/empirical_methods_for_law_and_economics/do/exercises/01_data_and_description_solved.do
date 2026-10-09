* LECTURE 1 - SOLUTIONS
* Data: World Bank Doing Business 2020 edition (data 1 May 2019), CC BY 4.0.

* Before running: save this solution file under your own name if you want to add notes.

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the one containing the subfolders data/ and do/; replace the placeholder below with its path.
cd "path_to_the_main_folder"

* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
do "do/00_setup.do"
* Start a text log of commands and output; replace overwrites the previous log, and name() identifies a separate named log.
log using "$course_results/logs/01_solutions.log", text replace
* Load this saved .dta file into memory; clear permits replacing the current in-memory data.
use "$course_data/contracts_2019.dta", clear

* Checks on the prepared file (stop here if any fails)
* Check that economy_code uniquely identifies each row and contains no missing identifiers; stop if not.
isid economy_code
* Check that the dataset has exactly 191 rows; _N is the total number of observations.
assert _N == 191
* Check that every row has reference_year equal to 2019; == tests equality.
assert reference_year == 2019
* Require positive, nonmissing time for every row; & means AND and !missing() means known.
assert time_days > 0 & !missing(time_days)
* time_days is the sum of its three components
* Check that the three time components sum to total time within 0.01 day; abs() allows for rounding.
assert abs(filing_days + trial_days + enforcement_days - time_days) < 0.01

* TASK 1. Inspect the data. What does ONE ROW represent? Which edition?
* [slide: Guided Stata 1]
* Show variable names, storage types and labels; does not change the data.
describe
* Inspect coding and distributions of the listed variables; compact requests a shorter overview.
codebook time_days cost_pct_claim region, compact
* Display the specified variables for selected rows; if restricts rows and noobs hides row numbers.
list economy time_days filing_days trial_days enforcement_days cost_pct_claim ///
    /* Restrict the preceding continued list command to Italy (ITA); noobs suppresses row numbers. */ if economy_code=="ITA", noobs
* ANSWER: one row is one economy (191), edition Doing Business 2020 (data as of
*         1 May 2019); time_days is in calendar days; cost_pct_claim is a
*         percentage of the claim value.

* TASK 2. Categories and denominators.
* [slides: Guided Stata 2; Zero, missing, and absent]
* Produce a frequency table of this category; missing includes unknown values when that option is present.
tabulate region, missing
* Produce a frequency table of this category; missing includes unknown values when that option is present.
tabulate income_group, missing
* Count all observations currently in memory; Stata stores the count in r(N).
count
* Count only rows meeting this condition; == tests equality, < means less than, !missing() excludes unknowns; result is stored in r(N).
count if missing(time_days)
* Original output note: 0: no missing values in this extract
* Count only rows meeting this condition; == tests equality, < means less than, !missing() excludes unknowns; result is stored in r(N).
count if court_automation == 0
* Original output note: 73 of 191: observed scores of zero, not missing
* Produce a frequency table of this category; missing includes unknown values when that option is present.
tabulate court_automation, missing
* ANSWER (example): "73 of the 191 economies (38.2%) score 0 on court automation."

* TASK 3. Centre and spread.
* [slide: Guided Stata 3]
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize time_days cost_pct_claim, detail
* Expected: time mean 649.7, median 575, SD 304.2, p25 465, p75 755, max 1785
*           cost mean 32.9, median 27.5, SD 19.5, p25 21.8, p75 38.0, max 163.2
* ANSWER: the mean exceeds the median because of a long right tail
*         (a few very slow or very costly economies pull the mean up).
* Display the specified variables for selected rows; if restricts rows and noobs hides row numbers.
list economy cost_pct_claim if cost_pct_claim > 100, noobs
* Original output note: 3 economies

* Experiment: Timor-Leste's cost mistyped as 1632, then undone
* [slide: Mean versus median: an experiment on real data]
* Temporarily save the current in-memory dataset so restore can recover it.
preserve
* Temporarily introduce a deliberate typing error for Timor-Leste; this is an illustration, not a correction to observed data.
replace cost_pct_claim = 1632 if economy_code == "TLS"
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize cost_pct_claim, detail
* Original output note: mean about 40.6, median still 27.5
* Recover the dataset saved by preserve, undoing intervening in-memory changes.
restore
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize cost_pct_claim
* Original output note: back to mean 32.9
* ANSWER: one outlier moves the mean a lot and the median not at all.

* TASK 4. Shape.
* [slide: Shape: the histogram]
* Calculate summary statistics silently and store results in r(); detail also stores the median r(p50).
quietly summarize time_days, detail
* Copy the most recently calculated mean r(mean) into local macro m before another command overwrites r().
local m = r(mean)
* Copy the most recent median r(p50) into local macro p50 for the graph reference line.
local p50 = r(p50)
* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram time_days, percent width(100) start(100) ///
    /* Add mean/median reference lines; lcolor sets colour and lpattern(dash) gives the median a dashed line. */ xline(`m', lcolor(orange)) xline(`p50', lpattern(dash)) ///
    /* Set the graph title; text in quotes is a label and not a variable name. */ title("Contract enforcement time, Doing Business 2020") ///
    /* Label the horizontal axis and, if present, the vertical axis with its units. */ xtitle("Days to enforce the standardized claim") ytitle("Percent of economies") ///
    /* Add a graph footnote identifying the sample, reference lines or the artificial-data scope. */ note("Solid line: mean. Dashed line: median. N = 191 economies.")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/01_hist_time.png", replace width(1600)

* [slide: Logarithms: a change of scale]
* Create natural log of time only for positive known values; double uses high numerical precision.
generate double ln_time = ln(time_days) if time_days > 0 & !missing(time_days)
* Attach a readable description to a variable; the values and variable name do not change.
label variable ln_time "Natural log of time_days"
* Count only rows meeting this condition; == tests equality, < means less than, !missing() excludes unknowns; result is stored in r(N).
count if !missing(ln_time)
* Original output note: 191: no observation lost
* Plot a distribution; if restricts rows, percent scales bars as percentages, width()/start() set bins, xline() marks a reference and name() retains this graph.
histogram ln_time, percent title("Log enforcement time") xtitle("ln(days)") ///
    /* Label the numerical axis and, if present, add a graph title. */ ytitle("Percent of economies")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/01_hist_logtime.png", replace width(1600)
* INSTRUCTOR EXTRA. A log difference is an approximate proportional difference
* Calculate a difference of natural logs; it equals log of a ratio and approximates percentage change only for small changes.
display ln(1120) - ln(575)
* Original output note: 0.67 (Italy versus the median)
* Compute the exact ratio of Italy's time to the median; this is about 1.95, not a causal comparison.
display 1120/575
* Original output note: 1.95: the ratio is the exact comparison

* TASK 5. One economy in the distribution (Italy).
* [slide: Where is Italy, and where does the time go?]
* Calculate summary statistics silently and store results in r(); detail also stores the median r(p50).
quietly summarize time_days if economy_code == "ITA"
* Store Italy's time in a local macro; with one matching row its mean equals its value.
local ita = r(mean)
* Original output note: one row, so the mean is Italy's value
* Count only rows meeting this condition; == tests equality, < means less than, !missing() excludes unknowns; result is stored in r(N).
count if time_days < `ita'
* Original output note: 172 of 191 economies are faster
* Print 100 times the count stored in r(N) divided by all rows _N; %4.1f displays one decimal place.
display "Share of economies faster than Italy: " %4.1f 100*r(N)/_N " percent"
* ANSWER: Italy 1,120 days = 10 filing + 840 trial + 270 enforcement;
*         the trial phase accounts for most of the time.
* INSTRUCTOR EXTRA. Decomposition for a few comparison economies
* Report summary statistics; detail adds percentiles, including p50 (median), and distribution information.
summarize filing_days trial_days enforcement_days, detail
* Draw horizontal stacked bars using the observed component values; asis means do not average them.
graph hbar (asis) filing_days trial_days enforcement_days ///
    /* Keep only the listed economy codes for this graph; commas separate the selected codes. */ if inlist(economy_code,"SGP","USA","FRA","DEU","ESP","PRT","ITA","GRC"), ///
    /* Create one bar per economy and sort the bars by total time; stack combines the three phase lengths. */ over(economy, sort(time_days)) stack ///
    /* Give plot layers human-readable labels and put the legend on one row. */ legend(order(1 "Filing and service" 2 "Trial and judgment" 3 "Enforcement") rows(1)) ///
    /* Label the numerical axis and, if present, add a graph title. */ ytitle("Days") title("Where the time goes")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/01_decomposition.png", replace width(1600)

* TASK 6. Compare regions (description, not explanation).
* [slide: Comparing groups is still description]
* Summarize the listed columns by group; statistics() selects summaries and format() sets printed decimal places.
tabstat time_days cost_pct_claim, by(region) statistics(n mean p50) format(%9.1f)
* Draw a horizontal box plot for each region, ordered by the graph's summary; boxes describe distributions, not causal effects.
graph hbox time_days, over(region, sort(1) descending) ///
    /* Label the numerical axis and, if present, add a graph title. */ ytitle("Days to enforce the standardized claim") title("Enforcement time by region")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/01_box_region.png", replace width(1600)
* ANSWER: read the region with the highest median from the tabstat output and
*         state the number of economies it is based on (column N).

* TASK 7. Five model sentences (replace the region comparison with your output).
* 1. The data are the World Bank's Doing Business 2020 enforcing-contracts
*    indicators (data as of 1 May 2019); one observation is an economy (N = 191).
* 2. 73 of the 191 economies (38.2%) score 0 on court automation.
* 3. Enforcement time has a mean of 649.7 days and a median of 575 days
*    (SD 304.2; quartiles 465 and 755), so the distribution is right-skewed.
* 4. Italy takes 1,120 days, slower than 172 of the 191 economies (90.1%);
*    840 of those days are the trial phase.
* 5. These are experts' estimates for a standardized case in the largest business
*    city, not averages of observed court cases, and the series was discontinued in 2021.

* Extension (preview of lecture 3, describe only)
* Plot trial duration vertically against judicial quality horizontally; each point represents one economy.
scatter trial_days judicial_quality, ///
    /* Set the graph title; text in quotes is a label and not a variable name. */ title("Trial time and judicial-process quality") ///
    /* Label the horizontal axis and, if present, the vertical axis with its units. */ xtitle("Quality of judicial processes index (0-18)") ytitle("Trial and judgment (days)")
* Save the active graph as a PNG; width() specifies image pixels and replace allows overwriting it.
graph export "$course_results/figures/01_scatter_extension.png", replace width(1600)

* Close the current unnamed text log and finish writing its output.
log close
