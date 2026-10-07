* LECTURE 2 - READY-TO-RUN SIMULATION (students run it; no programming required)
* ALL DATA IN THIS FILE ARE ARTIFICIAL.
* Artificial population: durations of commercial cases in days, right-skewed
* (lognormal), population mean 300 days and population SD 150 days.
* We draw 2,000 independent random samples of size n = 5, 25 and 100, and for
* each sample compute the mean, the SD, the standard error and a 95% t interval.

if "$course_results" == "" {
    do "do/00_setup.do"
}
capture log close sampling_demo
log using "$course_results/logs/02_sampling_demo.log", text replace name(sampling_demo)

* Population parameters (change these only in a COPY of this file)
global pop_mean = 300
global pop_sd   = 150

* ---- 1. Picture the artificial population (100,000 draws) ---------------
clear
set seed 20261008
quietly set obs 100000
local s2 = ln(1 + ($pop_sd/$pop_mean)^2)
local mu = ln($pop_mean) - `s2'/2
generate double y = exp(rnormal(`mu', sqrt(`s2')))
summarize y, detail
histogram y if y < 1200, percent width(25) xline($pop_mean) ///
    title("Artificial population of case durations") ///
    xtitle("Days (one artificial case)") ytitle("Percent of cases") ///
    note("Simulated: lognormal, mean 300, SD 150. Values above 1,200 days not shown.")
graph export "$course_results/figures/02_population.png", replace width(1600)

* ---- 2. The program that draws ONE sample and returns its statistics -----
capture program drop sample_mean
program define sample_mean, rclass
    version 16.0
    syntax, N(integer)
    drop _all
    quietly set obs `n'
    local s2 = ln(1 + ($pop_sd/$pop_mean)^2)
    local mu = ln($pop_mean) - `s2'/2
    generate double y = exp(rnormal(`mu', sqrt(`s2')))
    quietly summarize y
    local m  = r(mean)
    local s  = r(sd)
    local se = `s'/sqrt(`n')
    local c  = invttail(`n'-1, .025)
    return scalar samplemean = `m'
    return scalar sd   = `s'
    return scalar se   = `se'
    return scalar low  = `m' - `c'*`se'
    return scalar high = `m' + `c'*`se'
end

* ---- 3. Repeat it 2,000 times for each sample size -------------------------
tempfile s5 s25
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    reps(2000) seed(20261009) nodots: sample_mean, n(5)
generate n = 5
generate rep = _n
save `s5'
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    reps(2000) seed(20261010) nodots: sample_mean, n(25)
generate n = 25
generate rep = _n
save `s25'
simulate samplemean=r(samplemean) sd=r(sd) se=r(se) low=r(low) high=r(high), ///
    reps(2000) seed(20261011) nodots: sample_mean, n(100)
generate n = 100
generate rep = _n
append using `s5' `s25'
generate byte covers_truth = (low <= $pop_mean) & (high >= $pop_mean)
label variable samplemean   "Mean of one simulated sample (days)"
label variable sd           "SD within one simulated sample (days)"
label variable se           "Estimated standard error, sd/sqrt(n) (days)"
label variable covers_truth "1 if the 95% interval contains the true mean 300"
sort n rep
order n rep samplemean sd se low high covers_truth

* ---- 4. Results: one row = one simulated sample, NOT one case ------------
tabstat samplemean sd se covers_truth, by(n) statistics(mean sd) format(%9.2f)
* Theory: SD of the sample mean = 150/sqrt(n) = 67.1 (n=5), 30 (n=25), 15 (n=100)

histogram samplemean if n==5,   width(15) start(0) percent xline($pop_mean) name(n5, replace)   title("n = 5")   xtitle("Sample mean (days)")
histogram samplemean if n==25,  width(15) start(0) percent xline($pop_mean) name(n25, replace)  title("n = 25")  xtitle("Sample mean (days)")
histogram samplemean if n==100, width(15) start(0) percent xline($pop_mean) name(n100, replace) title("n = 100") xtitle("Sample mean (days)")
graph combine n5 n25 n100, rows(1) xcommon ycommon ///
    title("2,000 sample means for each sample size (simulated)")
graph export "$course_results/figures/02_sampling_distributions.png", replace width(2000)

* Intervals that miss the true mean are drawn in orange (if there are any among the first 40)
quietly count if n==25 & rep<=40 & covers_truth==0
local misses ""
local leg `"order(1 "Covers 300") rows(1)"'
if r(N) > 0 {
    local misses (rcap low high rep if n==25 & rep<=40 & covers_truth==0, horizontal lcolor(orange))
    local leg `"order(1 "Covers 300" 2 "Misses 300") rows(1)"'
}
twoway (rcap low high rep if n==25 & rep<=40 & covers_truth==1, horizontal lcolor(navy)) ///
       `misses' ///
       (scatter rep samplemean if n==25 & rep<=40, msize(small) mcolor(black)), ///
       xline($pop_mean) legend(`leg') ///
       title("Forty 95% confidence intervals, n = 25") ///
       xtitle("Days") ytitle("Simulated sample")
graph export "$course_results/figures/02_forty_intervals.png", replace width(1600)

save "$course_results/tables/02_sampling_results.dta", replace
export delimited using "$course_results/tables/02_sampling_results.csv", replace
log close sampling_demo
