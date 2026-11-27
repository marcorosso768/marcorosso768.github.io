* =============================================================================
* LECTURE 1 - WORKFLOW AND GETTING DATA INTO STATA
* Course:   Introduction to Stata (4 lectures)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Handbook: Introduction to Stata, Chapters 1-3
* Data:     Banca d'Italia, Indagine sui bilanci delle famiglie italiane (SHIW),
*           historical archive (archivio storico), version 12.2
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: exercises. Write your code below each task; run it block by block.
* =============================================================================

/*
   THE PROJECT FOR THE FOUR LECTURES

   We use real microdata from the Bank of Italy Survey on Household Income and
   Wealth (SHIW), waves 2010-2022. Our question: how are household income and
   wealth related to education, age and geography in Italy?

     Lecture 1: import the raw files, inspect, label and save them
     Lecture 2: create variables and combine the files into one dataset
     Lecture 3: descriptive statistics, tests and graphs
     Lecture 4: OLS regression

   BEFORE YOU START: download from the Bank of Italy website
     - storico_ascii.zip (historical archive, CSV): copy comp.csv, rfam.csv,
       ricf.csv, cons.csv, peso.csv, defl.csv, rper.csv into data/raw/
     - documentazione_storico_versione_12.2.xlsx (the codebook) into data/raw/
   Cite: "Banca d'Italia, Indagine sui bilanci delle famiglie italiane",
   historical archive version 12.2.

   Comments in Stata:   * whole line   // rest of the line
   A block comment, like this one, opens with slash-star and closes with star-slash.
   /// at the end of a line continues the command on the next line.
*/


* =============================================================================
* PART 1 - DEMONSTRATION
* =============================================================================

* =============================================================================
* SECTION 1: SETUP (Handbook 1.2)
* =============================================================================

* 1.1 Clean the environment

* Remove from memory data, labels, macros and stored results.
clear all
* Do not pause the output when the Results window is full.
set more off
* Interpret the code with the syntax of Stata 19, also on newer versions.
version 19

* 1.2 Project folder: the ONLY line you have to change

* A global macro stores text that we recall with $name.
* If $root is already set (e.g. by a master do-file) it is kept.
if "$root" == "" global root "C:/path/to/Stata_Lectures_2026"   // <- CHANGE THIS LINE

* All other paths derive from root: if the project moves, change only root.
global raw     "$root/data/raw"
global clean   "$root/data/clean"
global figures "$root/output/figures"
global tables  "$root/output/tables"
global logs    "$root/log"

* Create the folders if needed; capture ignores the error if they exist.
capture mkdir "$root/data"
capture mkdir "$clean"
capture mkdir "$root/output"
capture mkdir "$figures"
capture mkdir "$tables"
capture mkdir "$logs"
cd "$root"

* 1.3 Log file: a text record of the output

* Close a log left open by a previous run (capture: no error if none).
capture log close
log using "$logs/L1.log", text replace

* 1.4 Get the data (Handbook 3.2)
* Download page (Route A, open it in your browser):
* https://www.bancaditalia.it/statistiche/tematiche/indagini-famiglie-imprese/bilanci-famiglie/distribuzione-microdati/

* Route A (shown in class): download the files by hand from the page above
* and copy them into data/raw/ (see the slides).
* Route B: Stata downloads them itself. copy accepts a web address; unzipfile
* extracts a .zip archive. The block runs only if the files are missing.
* If route B fails (network, proxy), the do-file stops: use route A.
* Conditions of use: on the download page. Research use only, cite the
* source, do not redistribute the files.
local bdi "https://www.bancaditalia.it/statistiche/tematiche/indagini-famiglie-imprese/bilanci-famiglie"
local files "comp rfam ricf cons peso defl rper"
capture mkdir "$raw"
capture confirm file "$raw/comp.csv"
if _rc != 0 {
    display as text "Data not found in data/raw: downloading from the Bank of Italy..."
    capture noisily {
        copy "`bdi'/distribuzione-microdati/documenti/storico/storico_ascii.zip" ///
             "$raw/storico_ascii.zip", replace
        copy "`bdi'/documentazione/documentazione_storico_versione_12.2.xlsx" ///
             "$raw/documentazione_storico_versione_12.2.xlsx", replace
        * unzipfile extracts into the current folder: move there and back.
        cd "$raw"
        unzipfile "storico_ascii.zip", replace
        cd "$root"
        * The archive contains a CSV/ folder: copy the files we need.
        foreach f of local files {
            copy "$raw/CSV/`f'.csv" "$raw/`f'.csv", replace
        }
    }
    cd "$root"
}
* Final check: stop with a clear message if something is still missing.
foreach f in `files' documentazione_storico_versione_12.2 {
    local ext = cond("`f'" == "documentazione_storico_versione_12.2", "xlsx", "csv")
    capture confirm file "$raw/`f'.`ext'"
    if _rc != 0 {
        display as error "`f'.`ext' not found in data/raw/: download the files by hand (route A)"
        exit 601
    }
}

* 1.5 Help

* The help file: syntax diagram, options, examples.
help import delimited
* display is a calculator.
display ln(100)


* =============================================================================
* SECTION 2: IMPORT A CSV FILE AND LOOK AT THE DATA (Handbook 3.2, 3.3)
* =============================================================================

* 2.1 Import the characteristics of household members (one row per person)

* clear replaces the data in memory; case(lower) makes variable names
* lowercase (Stata is case-sensitive: ANNO and anno would be different).
import delimited "$raw/comp.csv", clear case(lower)

* 2.2 First look

* Number of observations, variables, storage types, labels.
describe
* The first rows of some variables.
list nquest nord anno sesso eta studio in 1/5
* Summary statistics and a frequency table.
summarize anno eta
tabulate anno
* Data browser (read-only): look, never edit by hand.


* =============================================================================
* SECTION 3: SYNTAX, OPERATORS, MISSING VALUES (Handbook 2.1-2.3)
* =============================================================================

* 3.1 [by varlist:] command [varlist] [if] [in] [, options]

* if: only observations satisfying a condition.
summarize eta if anno == 2022
* Options after the comma change what the command does.
summarize eta if anno == 2022, detail
* by: repeat the command for each group (data must be sorted: bysort).
bysort anno: summarize eta

* 3.2 Operators: == != > >= < <=   & (and)  | (or)  ! (not)

count if anno == 2022 & eta >= 65
count if anno == 2022 & (sesso == 2 | eta < 18)

* 3.3 Missing values are LARGER than any number

* Education (studio) is missing for children in the early waves.
count if missing(studio)
* WRONG: also counts all the missing values!
count if studio >= 4
* RIGHT:
count if studio >= 4 & !missing(studio)


* =============================================================================
* SECTION 4: KEEP, DROP AND IDENTIFIERS (Handbook 3.4, 3.8, 3.9)
* =============================================================================

* 4.1 Keep the waves 2010-2022 and the variables we need

* keep/drop if: rows; keep/drop varlist: columns.
keep if anno >= 2010
keep nquest nord anno ireg area3 area5 acom5 par sesso eta studio staciv ///
     qualp3 nonoc cfred perc ncomp nequ

* 4.2 What identifies one row?

* isid stops with an error if the variables do not identify the rows.
isid nquest nord anno
* The household id alone is not unique (several members, several waves).
duplicates report nquest anno
* sort orders the rows, order moves the columns.
sort anno nquest nord
order anno nquest nord


* =============================================================================
* SECTION 5: NAMES AND LABELS (Handbook 3.5)
* =============================================================================

* 5.1 English names

rename anno   year
rename sesso  sex
rename eta    age
rename studio educ
rename staciv marital
rename qualp3 workstatus
rename ncomp  hhsize

* 5.2 Variable labels

label variable year       "Survey year"
label variable nquest     "Household id"
label variable nord       "Person id within household"
label variable age        "Age (years)"
label variable educ       "Educational attainment"
label variable hhsize     "Number of household members"
label variable nequ       "Equivalent adults (OECD scale)"
label variable cfred      "Main income earner (1 = yes)"
label variable ireg       "Region of residence (ISTAT code)"
label variable area3      "Macro area of residence"

* 5.3 Value labels: the codes come from the codebook (sheet "Variabili")

* Step 1: label define creates a dictionary code -> text.
label define sex_lbl 1 "Male" 2 "Female"
label values sex sex_lbl
label define educ_lbl 1 "None" 2 "Primary" 3 "Lower secondary" ///
                      4 "Upper secondary" 5 "University degree" 6 "Postgraduate"
label values educ educ_lbl
label define marital_lbl 1 "Married" 2 "Single" 3 "Separated/divorced" 4 "Widowed"
label values marital marital_lbl
label define work_lbl 1 "Employee" 2 "Self-employed" 3 "Not employed"
label values workstatus work_lbl
label define area3_lbl 1 "North" 2 "Centre" 3 "South and Islands"
label values area3 area3_lbl
* Tables now show the text; nolabel shows the codes.
tabulate educ
tabulate educ, nolabel


* =============================================================================
* SECTION 6: CHECK AND SAVE (Handbook 3.1, 3.4, 3.5)
* =============================================================================

* 6.1 Storage types, compress, assert, save

* IDs must be integers (long), never float (only ~7 significant digits).
describe nquest age
* compress: smallest storage type that keeps all values.
compress
* assert stops the do-file if the statement is false for some row.
assert inlist(sex, 1, 2)
assert age >= 0 & age < 120
label data "SHIW 2010-2022, individuals"
save "$clean/individuals.dta", replace


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (10 min) - Explore individuals.dta (Handbook 2.2, 2.3, 3.3)
* =============================================================================

* Open data/clean/individuals.dta and answer:
*  a) How many people were interviewed in 2022?
*  b) What share of them are women?
*  c) How did the mean age change between 2010 and 2022?
*  d) How many HOUSEHOLDS were interviewed in 2022? (hint: one main income
*     earner per household, cfred == 1)
*  e) What is the largest household size, and in how many households?

* >>> write your code here


* =============================================================================
* EXERCISE 2 (10 min) - The price index (Handbook 3.2, 3.4, 3.5)
* =============================================================================

* Import data/raw/defl.csv (one row per year).
*  a) Look at the last five rows.
*  b) The documentation says that RIVAL (revaluation coefficient) equals 1 in
*     the base year. Which year is it in these data?
*  c) Rename anno to year, label defl and rival, check that year identifies
*     the rows, and save the file as data/clean/deflator.dta

* >>> write your code here


* =============================================================================
* EXERCISE 3 (10 min) - Household income (Handbook 3.2, 3.5, 3.8)
* =============================================================================

* Import data/raw/rfam.csv (household income, one row per household-wave).
*  a) Keep the waves 2010-2022 and the variables nquest anno y yl yt ym yc.
*  b) Check which variables identify the rows. Rename anno to year.
*  c) Label the variables (codebook, sheet "RFAM"): y disposable income,
*     yl employee income, yt pensions and transfers, ym self-employment
*     income, yc capital income.
*  d) How many households have zero or negative income in 2022?
*  e) Save as data/clean/rfam.dta

* >>> write your code here


* =============================================================================
* EXERCISE 4 (10 min) - Wealth, consumption and weights (Handbook 3.2, 3.8)
* =============================================================================

* Do the same for three more household files. For each one: import, keep
* 2010-2022, keep the variables listed, check nquest anno, rename anno to
* year, save in data/clean/ with the same name.
*   ricf.csv -> nquest anno w ar af pf   (net wealth, real and financial
*                                         assets, liabilities)
*   cons.csv -> nquest anno c            (consumption)
*   peso.csv -> nquest anno peso         (sampling weight)
* Bonus: write it as a loop (Handbook 12.2), we will see loops in Lecture 2.

* >>> write your code here


* =============================================================================
* EXERCISE 5 (10 min) - An Excel sheet and string variables (Handbook 2.4, 3.2, 3.6)
* =============================================================================

* Import the sheet "Area-Regione" of the codebook
* (data/raw/documentazione_storico_versione_12.2.xlsx), using the first row
* as variable names.
*  a) Make the variable names lowercase and rename regione to region_name.
*  b) Clean region_name: remove blanks at the end (strtrim), replace the
*     typographic apostrophe with the standard one, write "Emilia-Romagna"
*     instead of "Emilia - Romagna" (usubinstr).
*  c) Create region_code with encode. Is region_code equal to ireg? Why
*     should we never use it to match files?
*  d) Drop region_code, check that ireg identifies the rows and save as
*     data/clean/regions.dta

* >>> write your code here


* =============================================================================
* CLOSE
* =============================================================================

log close
