* LECTURE 3 - SOLUTIONS
* Data: Eurostat criminal justice statistics 2019 (free reuse, source: Eurostat),
*       World Bank Doing Business 2020 and World Development Indicators (CC BY 4.0).

* Before running: save this solution file under your own name if you want to add notes.

* Set your own course-folder path ONCE in Stata before running this file.
* The course folder is the do/ folder, the one containing data/ and 00_setup.do; replace the placeholder below with its path.
cd "path_to_the_main_folder"

* Run the named do-file from the course working folder; quoted paths can contain spaces. Setup clears memory, so run it before analysis.
do "00_setup.do"
* Start a text log of commands and output; replace overwrites the previous log.
log using "$course_results/logs/03_answer.log", text replace

* ============ PART A: 37 European countries ===========================
* Load this saved .dta file into memory; clear permits replacing the current in-memory data.
use "$course_data/justice_europe_2019.dta", clear

* TASK 1. What is one row? Which variables have missing values, for whom?
* Show variable names, storage types and labels; does not change the data.
describe
* Count missing values for every variable that has at least one; variables with none are not listed.
misstable summarize
* Display the country name only for rows where judges or police are missing; | means OR.
list country if missing(judges_100k) | missing(police_100k)
* ANSWER: one row is one country (37). Missing values (country names as in the data):
*   judges: Germany, Switzerland; police: North Macedonia, Norway, Serbia;
*   burglary: Albania, Estonia, Hungary, Italy, North Macedonia, Norway;
*   theft: North Macedonia; fraud: Netherlands, North Macedonia, Türkiye;
*   corruption: Iceland, Kosovo, Türkiye.

* TASK 2. Judges and enforcement time.
* [slides: Two variables: the scatter plot; Guided Stata 1]
* Plot enforcement time vertically against judges per 100,000 horizontally; mlabel() writes each country's name next to its point.
scatter time_days judges_100k, mlabel(country)
* Save the active graph as a PNG; the _answer suffix keeps it apart from the figure you save in the exercise; width() sets image pixels.
graph export "$course_results/figures/03_judges_time_answer.png", replace width(1600)
* Pearson correlation of the two variables; sig adds the p-value of H0: correlation = 0 and obs the number of pairs used.
pwcorr time_days judges_100k, sig obs
* Expected: r = 0.196, p = 0.260, n = 35 (Germany and Switzerland have no judge count)
* Rank (Spearman) correlation: the same idea computed on ranks, less sensitive to extreme values.
spearman time_days judges_100k
* Original output note: rho = 0.17
* ANSWER: weak positive association: more judges go with slightly slower
*   enforcement. Reverse causality: backlogs lead governments to hire judges.
*   Confounder: legal tradition/procedure (career judiciaries count many
*   professional judges), litigation volume. Measurement: who counts as a
*   "professional judge"; DB time is one standardized case in the largest city.

* TASK 3. Police and recorded theft.
* [slides: More police, less theft?; Answers: more police, less theft?]
* Plot recorded thefts vertically against police per 100,000; mlabel() labels each point with the country.
scatter theft_100k police_100k, mlabel(country)
* Save the active graph as a PNG; the _answer suffix keeps it apart from the figure you save in the exercise; width() sets image pixels.
graph export "$course_results/figures/03_police_theft_answer.png", replace width(1600)
* Create the natural log of GDP per capita; all values are positive, so no row is lost.
generate ln_gdppc = ln(gdp_pc_usd)
* Correlation matrix of the three variables; each pair uses the countries where both values are known.
pwcorr theft_100k police_100k ln_gdppc, sig obs
* Expected: theft-police r = -0.556 (p < 0.001, printed 0.0006, n = 34);
*           theft-ln_gdppc r = 0.644 (n = 36); police-ln_gdppc r = -0.540 (n = 34)
* ANSWER: richer countries record more theft (reporting for insurance, trust in
*   police) and employ fewer police per inhabitant: income is a candidate
*   confounder acting partly through measurement (recorded, not committed, theft).

* TASK 4. What does "recorded corruption" measure?
* [slide: Is Sweden the most corrupt country in Europe?]
* Sort rows from the highest to the lowest value; the minus sign means descending order.
gsort -corruption_100k
* Display country and recorded corruption, skipping countries with a missing value.
list country corruption_100k if !missing(corruption_100k)
* Expected: Sweden 201.5, Denmark 87.2, Finland 71.8 ... Italy 5.8, Greece 5.7
* ANSWER: recorded offences = offences committed x share detected and recorded,
*   under national legal definitions; active enforcement raises the count.

* ============ PART B: 191 economies, Doing Business 2020 ================
* Load the week-1 Doing Business file; clear replaces the European data in memory.
use "$course_data/contracts_2019.dta", clear

* TASK 5. Are high-income economies faster? A difference in means.
* [slides: After the break: are richer economies faster?; Guided Stata 2; "p = 0.39" discussion]
* Create a 0/1 indicator: 1 if the World Bank classifies the economy as high income, 0 otherwise; byte saves memory.
generate byte high_income = (income_group == "High income")
* Summarize time separately for the two groups; n, mean, p50 (median) and sd are requested, with one decimal.
tabstat time_days, by(high_income) statistics(n mean p50 sd) format(%9.1f)
* Expected: 0: n 132, mean 662.4, median 590.5, sd 312.5
*           1: n  59, mean 621.3, median 545.0, sd 285.5
* Two-sample t-test of equal means across the two groups; Stata reports mean(0) - mean(1), assuming equal variances.
ttest time_days, by(high_income)
* Expected: diff = mean(0) - mean(1) = 41.17, SE 47.68, t = 0.8634, df 189,
*           p = 0.389, 95% CI -52.88 to 135.21
* Same test without assuming equal variances in the two groups (Satterthwaite degrees of freedom).
ttest time_days, by(high_income) unequal
* Expected: t = 0.894, Satterthwaite df 121.3, p = 0.373
* ANSWER: "Non-high-income economies take on average 41 days longer (662 vs 621);
*   the difference is not statistically significant (p = 0.39), and the 95%
*   interval, from 53 days shorter to 135 days longer, is compatible both with
*   no difference and with a large one."

* TASK 6. A difference in proportions: any court automation.
* [slide: Guided Stata 3]
* Create a 0/1 indicator for any automation feature; the if condition keeps unknown scores missing instead of coding them 0.
generate byte any_automation = (court_automation > 0) if !missing(court_automation)
* Cross-tabulate income group and automation; row shows the percentage with automation within each income group.
tabulate high_income any_automation, row
* Two-sample test of equal proportions; Stata reports prop(0) - prop(1) and a z statistic.
prtest any_automation, by(high_income)
* Expected: 63/132 = 47.7% vs 55/59 = 93.2%; diff = -0.455, z = -5.98,
*           p < 0.001, 95% CI -0.562 to -0.348
* ANSWER: automation is far more common in high-income economies, but Task 5
*   shows that these are not clearly faster: the test says nothing about
*   automation causing speed.

* TASK 7. Model sentences
* 1. Across 34 European countries, police per 100,000 and recorded thefts per
*    100,000 are negatively correlated (r = -0.56).
* 2. Richer countries record more theft and employ fewer police per inhabitant,
*    so income (and reporting behaviour) can produce the correlation.
* 3. Non-high-income economies take 41 days longer on average (p = 0.39, 95% CI
*    -53 to 135 days): the data cannot distinguish no difference from a large one.

* EXTENSION. Many tests at once.
* [slide: Two kinds of error, and many tests]
* Reload the European data; clear replaces the Doing Business data in memory.
use "$course_data/justice_europe_2019.dta", clear
* Correlate police with six crime categories at once; sig and obs add p-values and the number of pairs.
pwcorr police_100k homicide_100k robbery_100k burglary_100k theft_100k ///
    /* Continue the variable list of the same pwcorr command; options follow the comma. */ fraud_100k corruption_100k, sig obs
* Expected (with police): homicide 0.303 (p 0.081), robbery -0.109 (0.538),
*   burglary -0.424 (0.020, n 30), theft -0.556 (<0.001, printed 0.0006), fraud -0.420 (0.017, n 32),
*   corruption -0.407 (0.023, n 31). Four of six p < 0.05, all negative:
*   a common cause (income, reporting) rather than four independent findings.

* Close the current text log and finish writing its output.
log close
