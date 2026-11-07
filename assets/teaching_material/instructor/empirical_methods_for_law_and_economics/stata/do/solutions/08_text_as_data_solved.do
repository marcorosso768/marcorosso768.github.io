* =============================================================================
* LECTURE 8 - SOLUTIONS: legal texts as data
* Data: Constitute Project (Elkins, Ginsburg and Melton, constituteproject.org),
*       25 European constitutions in English, CC BY-NC 3.0; one row per sentence.
* =============================================================================
* How to use this file
*   1. In the cd line below, write the path of YOUR stata/do folder
*      (the folder that contains 00_setup.do, data/, exercises/ and solutions/).
*   2. Part A contains the Guided Stata commands shown on the slides, in the same order.
*   3. Part B solves the laboratory tasks of exercises/08_text_as_data.do.

* Move Stata's working directory to the do folder; all relative paths start from here.
cd "C:/path/to/stata/do"

* Run the setup file. It clears memory, checks that the working directory is right,
* and defines two globals: $course_data (the data folder) and $course_results
* (the folder where logs, figures and tables are saved).
do "00_setup.do"

* Open a text log: everything Stata prints from now on is also written to this file.
* replace overwrites the log of a previous run.
log using "$course_results/logs/08_answer.log", text replace


* =============================================================================
* PART A. GUIDED STATA (the commands on the slides)
* =============================================================================

* ---- Slide "Guided Stata 1: the corpus" ---------------------------------------
* Load the corpus: one row is one sentence (or numbered clause) of one constitution.
use "$course_data/constitutions_text.dta", clear
* Variables, labels and number of rows (18,853 sentences).
describe
* Number of words in each sentence: wordcount() counts the words separated by spaces;
* subinstr(text, char(34), "", .) first removes double quotes (char(34)), which
* wordcount() would otherwise treat as grouping several words into one.
generate words = wordcount(subinstr(text, char(34), "", .))
* For each country: n = number of sentences, sum = number of words of its constitution.
tabstat words, by(country) statistics(n sum)
* Expected: longest Sweden (2,190 sentences, 59,285 words) and Austria (1,795, 49,362);
*           shortest Denmark (246, 6,163) and Latvia (219, 4,962); total 18,853 and 466,841

* ---- Slide "Guided Stata 2: applying the dictionary" -------------------------
* Lower-case copy of the text, so that "Judges" and "judges" are treated alike.
generate text_lc = ustrlower(text)
* 1 if the sentence contains one of the judiciary words, 0 otherwise.
*   ustrregexm(text, pattern) returns 1 when the pattern is found in the text.
*   In the pattern, | means "or" and \b marks the edge of a word, so "court"
*   matches "court" but not "courtesy". /// continues the command on the next line.
generate byte judiciary = ustrregexm(text_lc, ///
    "\b(judge|judges|judicial|judiciary|court|courts|tribunal|tribunals)\b")
* 1 if the sentence contains a word starting with "independen" or "impartial"
* (independent, independence, impartial, impartiality ...): no \b at the end.
generate byte indep = ustrregexm(text_lc, "\b(independen|impartial)")
* 1 if the sentence does both: & means AND.
generate byte jud_indep = judiciary & indep
* Cross-table: how many judiciary sentences, and how many of them are flagged.
tabulate judiciary jud_indep
* Expected: 2,084 judiciary sentences, 77 of them flagged

* ---- Slide "Guided Stata 3: one number per constitution" ---------------------
* Save a copy of the sentence data, because collapse will replace it.
preserve
* One row per constitution: (count) counts the sentences, (sum) adds up words and the
* two 0/1 indicators (the sum of a 0/1 variable is the number of 1s).
collapse (count) sentences=sent_id (sum) words judiciary jud_indep, ///
    by(economy_code country)
* The measure: flagged sentences as a percentage of judiciary sentences.
generate share = 100*jud_indep/judiciary
* Sort from the highest to the lowest share (the minus sign means descending).
gsort -share
* Show the 25 constitutions; noobs hides the row numbers.
list country sentences words judiciary jud_indep share, noobs
* Expected: Spain 9.5 (7 of 74), Poland 7.0, Norway 6.7 ... Italy 5.8 (4 of 69) ...
*           Belgium 1.1, Netherlands 0, Denmark 0
* Horizontal bars, one per country, ordered by the share.
graph hbar share, over(country, sort(1) descending)
* Save the country-level file for Guided Stata 5.
save "$course_results/tables/08_constitutions_country.dta", replace
* Bring back the sentence data.
restore

* ---- Slide "Guided Stata 4: read what you counted" ---------------------------
* Fix the starting point of the random numbers, so everyone gets the same sample.
set seed 20261030
* A random number between 0 and 1 for each sentence; double stores it with more digits.
generate double u = runiform()
* Flagged sentences first (descending jud_indep), and in random order within each group.
gsort -jud_indep u
* The first 20 rows: a random sample of 20 flagged sentences.
list country text in 1/20, noobs

* ---- Slide "Guided Stata 5: compare with other measures" ---------------------
* Load the country-level file saved in Guided Stata 3.
use "$course_results/tables/08_constitutions_country.dta", clear
* Add the European indicators by ISO3 code; keep(match) keeps the countries in both
* files (25); nogenerate does not create the _merge variable.
merge 1:1 economy_code using "$course_data/justice_europe_2019.dta", ///
    keep(match) nogenerate
* Flagged sentences per 10,000 words of the constitution.
generate per10k = 10000*jud_indep/words
* Natural log of GDP per capita.
generate ln_gdppc = ln(gdp_pc_usd)
* Correlation of the share with the Doing Business index of judicial processes.
pwcorr share judicial_quality, sig obs
* Expected: r = 0.20, p = 0.33, 25 countries
* Correlation of the per-word measure with income.
pwcorr per10k ln_gdppc, sig obs
* Expected: r = -0.51, p = 0.009, 25 countries


* =============================================================================
* PART B. LABORATORY
* =============================================================================

* Reload the corpus and rebuild the indicators of Part A.
use "$course_data/constitutions_text.dta", clear
generate words = wordcount(subinstr(text, char(34), "", .))
generate text_lc = ustrlower(text)
generate byte judiciary = ustrregexm(text_lc, ///
    "\b(judge|judges|judicial|judiciary|court|courts|tribunal|tribunals)\b")
generate byte indep = ustrregexm(text_lc, "\b(independen|impartial)")
generate byte jud_indep = judiciary & indep

* TASK 1. Audit 20 flagged sentences.
set seed 20261030
generate double u = runiform()
gsort -jud_indep u
list country text in 1/20, noobs
* Coding rule: 1 if the sentence establishes or protects the independence or
*   impartiality of courts or judges (including constitutional courts and the right to an
*   independent court); 0 otherwise.
* ANSWER: code each sentence 1/0 and compute the share of 1s. The instructor read all
*   77 flagged sentences: 15 are not about the independence of courts or judges, so
*   precision is 62/77 = 81%. The errors come from: the name of a body ("independent
*   Federal Asylum Tribunal", 7 sentences, and "Independent Administrative Authorities",
*   2 sentences: all Austrian transitional provisions); courts of audit (Germany, Slovenia, Spain); prosecutors
*   (Croatia); the independence of the media (France); an "independent administrative
*   body" (Portugal). Your sample of 20 gives a noisier estimate of the same share.

* TASK 2. What does the dictionary miss?
list text if country == "Denmark" & judiciary == 1, noobs
list text if country == "Netherlands" & judiciary == 1, noobs
* ANSWER: Denmark, section 64: "In the performance of their duties the judges shall be
*   directed solely by the law." and "Judges shall not be dismissed except by judgment,
*   nor shall they be transferred against their will [...]". Netherlands: "Members of
*   the judiciary responsible for the administration of justice and the Procurator
*   General at the Supreme Court shall be appointed for life by Royal Decree." and
*   "[...] such persons may be suspended or dismissed by a court that is part of the
*   judiciary [...]". Tenure and removal only by judges protect independence without
*   using the word.

* TASK 3. A second dictionary.
* Same structure as indep, with irremovab- and three phrases added.
generate byte indep2 = ustrregexm(text_lc, ///
    "\b(independen|impartial|irremovab)|subject only to|bound only by|solely by the law")
generate byte jud_indep2 = judiciary & indep2
count if jud_indep2 == 1
* Expected: 86 (77 + 9)
list country text if jud_indep2 == 1 & jud_indep == 0, noobs
* Expected: 9 new sentences: Bulgaria 3, Czechia, Denmark, France, Greece, Italy, Romania.
* ANSWER: the 9 new sentences are about the tenure or independence of judges (three
*   Bulgarian transitional provisions also cover prosecutors and investigating magistrates;
*   the Czech one concerns Constitutional Court justices).
*   Still missed, for example, Bulgaria: "all judges, court assessors, prosecutors and
*   investigating magistrates shall be subservient only to the law" (the dictionary
*   has "subject only to", not "subservient only to"). Every new phrase must be
*   audited again.

* TASK 4. Prosecutors instead of judges.
generate byte prosecutor = ustrregexm(text_lc, ///
    "\b(prosecut|public ministry|attorney general|procurator)")
generate byte pros_indep = prosecutor & indep
tabulate country if pros_indep == 1
* Expected: 11 sentences in 8 constitutions: Belgium 1, Bulgaria 2, Croatia 2, Hungary 1,
*           Italy 1, Lithuania 1, Romania 1, Spain 2
list country text if pros_indep == 1, noobs
* ANSWER: some sentences are about prosecutors (Belgium: "The public prosecutor is
*   independent in conducting individual investigations and prosecutions [...]"); others
*   mention prosecutors next to the independence of judges (Bulgaria, Spain). Precision
*   must be checked again; a count of words is not the de jure index of Voigt and Wulf.

* TASK 5. Two ways to normalise.
preserve
collapse (sum) words judiciary jud_indep, by(economy_code country)
generate share = 100*jud_indep/judiciary
generate per10k = 10000*jud_indep/words
pwcorr share per10k, sig obs
* Expected: r = 0.85, 25 countries
restore
* ANSWER: they rank countries similarly. They differ when a constitution has many or
*   few sentences about courts relative to its length: per10k divides by all words,
*   share only by the sentences about courts.

* TASK 6. See the slides "A referee's checklist for text-based measures" and
* "Revising a comment: frequent problems".
* Example, for a hypothetical paper: "Section 3 builds the de jure index by counting 'independent' in the English
*   versions of the constitutions. These are translations, and Table A1 mixes versions
*   from different years. Since the main result compares de jure and de facto
*   independence, please report a manual audit of a random sample of matches, by
*   country, and show the results on the subset of official texts."

* Close the log file.
log close
