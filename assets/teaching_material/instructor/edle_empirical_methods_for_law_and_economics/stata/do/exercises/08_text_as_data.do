* =============================================================================
* LECTURE 8 - STUDENT WORKSHEET: legal texts as data
* Data: Constitute Project (Elkins, Ginsburg and Melton, constituteproject.org),
*       25 European constitutions in English, CC BY-NC 3.0; one row per sentence.
* =============================================================================
* How to use this file
*   1. Save a copy under your own name (e.g. 08_yourname.do) and work on the copy.
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
log using "$course_results/logs/08_exercise.log", text replace


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
* Correlation of the per-word measure with income.
pwcorr per10k ln_gdppc, sig obs


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
* TODO: set seed 20261030, generate u = runiform(), gsort -jud_indep u, list 1/20
*       (the commands of Guided Stata 4)
* WRITE: for each of the 20 sentences, 1 if it is about the independence or
*        impartiality of courts or judges, 0 if not. Precision = (number of 1s)/20.
*        Which words misled the dictionary?

* TASK 2. What does the dictionary miss?
* TODO: list text if country == "Denmark" & judiciary == 1, noobs
* TODO: list text if country == "Netherlands" & judiciary == 1, noobs
* WRITE: find the sentences that protect judges without using the words
*        "independent" or "impartial". Quote them.

* TASK 3. A second dictionary.
* TODO: generate byte indep2 = ustrregexm(text_lc, ///
*           "\b(independen|impartial|irremovab)|subject only to|bound only by|solely by the law")
* TODO: generate byte jud_indep2 = judiciary & indep2
* TODO: count if jud_indep2 == 1
* TODO: list country text if jud_indep2 == 1 & jud_indep == 0, noobs
*       (the sentences added by the second dictionary)
* WRITE: how many sentences are added? Are they correct? Which provision is still
*        missed? (Hint: look for "only to the law" in Bulgaria.)

* TASK 4. Prosecutors instead of judges (the topic of Voigt and Wulf).
* TODO: generate byte prosecutor = ustrregexm(text_lc, ///
*           "\b(prosecut|public ministry|attorney general|procurator)")
* TODO: generate byte pros_indep = prosecutor & indep
* TODO: tabulate country if pros_indep == 1
* TODO: list country text if pros_indep == 1, noobs
* WRITE: in how many constitutions does a sentence on prosecutors mention independence?
*        Is every flagged sentence about the independence of prosecutors?

* TASK 5. Two ways to normalise.
* TODO: preserve
* TODO: collapse (sum) words judiciary jud_indep, by(economy_code country)
* TODO: generate share = 100*jud_indep/judiciary
* TODO: generate per10k = 10000*jud_indep/words
* TODO: pwcorr share per10k, sig obs
* TODO: restore
* WRITE: do the two measures rank countries similarly? When would they differ?

* TASK 6. Write (as comments below):
* 1. One referee comment on a paper that uses a dictionary measure of legal texts,
*    with the four steps: where, what, why it matters, what would resolve it.
* 2. Your revised comments on the paper you are reviewing.

* Close the log file.
log close
