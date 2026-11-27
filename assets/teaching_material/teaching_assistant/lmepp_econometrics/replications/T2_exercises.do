* =============================================================================
* REPLICATION TUTORIAL 2 - DORN AND ZWEIMUELLER (2021)
* "Migration and Labor Market Integration in Europe", Journal of Economic
*  Perspectives 35(2): 49-76
* Course:   Replication tutorials (after Introduction to Stata)
* Author:   Marco Rosso (marco.rosso4@unibo.it)
* Data:     the authors' replication archive, FinalDataPackage (May 2021):
*           https://ddorn.net/data.htm, entry P11. Used as it is.
* Stata:    version 19
* =============================================================================
* EXERCISES VERSION. Part 1: the commands shown in class (run them as we go).
* Part 2: four exercises. Write your code below each task.
* =============================================================================

/*
   THE FOLDER (its path must NOT contain spaces: see Section 0)
       Replication_T2/
           Dorn_Zweimueller_2021.pdf   the paper
           FinalDataPackage/           the authors' archive, unzipped as it is
               Readme.pdf
               do/                     master.do, setup.do, 11 do-files
               dta/                    data (their code also writes here)
               pdf/                    the authors' figures and table
           T2_exercises.do             this file
           output/                     created by this file

   TODAY
   1. Run the package: what reproduces, what cannot, what needs fixing.
   2. Read two do-files: Figure 1 (the sample is a coding choice) and
      Figure 4 (append, collapse, merge, reshape on real data).
   3. Exercises: Table 1 from the counts, Figure 1 in numbers, fragile
      labels, a loop that overwrites its own output.
*/


* =============================================================================
* PART 1 - DEMONSTRATION
* =============================================================================

* =============================================================================
* SECTION 0: SETUP
* =============================================================================

clear all
set more off
version 19
global root "C:/path/to/Replication_T2"   // <- CHANGE THIS LINE
global main "$root/FinalDataPackage"   // the name the authors' code expects
global out  "$root/output"

* The authors write ${main}/dta/... WITHOUT quotes: a space in the path
* breaks every file. We stop here if there is one.
if strpos("$main", " ") {
    display as error "The path contains a space: move Replication_T2 to a folder without spaces."
    exit 198
}
cd "$root"
capture mkdir "$out"
capture mkdir "$out/authors_pdf"
capture log close
log using "$out/T2.log", text replace

* Packages used by the authors' code. Their setup.do does not install them
* (see the slides), so we do it: install only what is missing.
capture which labmask
if _rc ssc install labutil           // labmask: value labels from a variable
capture which spmap
if _rc ssc install spmap             // maps (Figure 3)
capture which colorpalette
if _rc ssc install palettes          // colours (Figure 3)
capture findfile colrspace.sthlp
if _rc ssc install colrspace         // required by palettes


* =============================================================================
* SECTION 1: RUN THE PACKAGE
* =============================================================================

* master.do cannot run as it is: its line  global main  is followed only by a
* comment ("enter main file directory here"), i.e. an EMPTY path, and it
* calls setup.do. We do its job here: same files,
* same order, without the four that need EU-SILC microdata (not public:
* Prepare_silc, Fig5, FigA4, Gains_from_migration).

* 1.1 Their code overwrites the figures in pdf/: keep a copy of the originals
local figs : dir "$main/pdf" files "*.pdf"
foreach f of local figs {
    quietly copy "$main/pdf/`f'" "$out/authors_pdf/`f'", replace
}

* 1.2 Run the seven executable do-files (about 2 minutes: Fig2 pauses 2 x 12
* seconds, Fig3 draws 1,095 regions, Fig4 opens the Data Editor: close it)
foreach f in Fig1 Fig2 Fig3 Fig4 FigA2 FigA5 Table1 {
    display as text _newline "==== Running `f'.do"
    do "$main/do/`f'.do"
}
* Now compare FinalDataPackage/pdf (new) with output/authors_pdf (original)
* and with the paper. Table 1 has no do-file output to compare: Table1.do
* only re-orders numbers typed in an Excel file (dta/Mappe3.xlsx).


* =============================================================================
* SECTION 2: FIGURE 1 STEP BY STEP (country-year data)
* =============================================================================

use "$main/dta/mpd2018.dta", clear    // Maddison Project: GDP per capita, population
describe, short
isid countrycode year

* 2.1 The sample: who is in the common labour market in each year.
* These are the authors' lines (Fig1.do): read them against the note of
* Figure 1 and footnote 2 of the paper.
keep if year > 1950
generate eu = 0
replace eu = 1 if inlist(countrycode, "FRA", "ITA", "BEL", "LUX", "NLD", "DEU") & year >= 1958
replace eu = 1 if inlist(countrycode, "IRL", "GBR", "DNK") & year >= 1973
replace eu = 1 if countrycode == "GRC" & year >= 1981
replace eu = 1 if inlist(countrycode, "ESP", "PRT") & year >= 1986
replace eu = 1 if inlist(countrycode, "SWE", "FIN", "AUT"/*, "NOR", "ISL"*/) & year >= 1994
replace eu = 1 if inlist(countrycode, "EST", "LVA", "LTU", "MLT", "POL", "SVK", "SVN", "CZE", "HUN") & year >= 2004
replace eu = 1 if countrycode == "CYP" & year >= 2004
replace eu = 1 if inlist(countrycode, "BGR", "ROU") & year >= 2007
replace eu = 1 if countrycode == "HRV" & year >= 2013
* (in Fig1.do Switzerland is a commented line: *replace eu=1 if ... "CHE" ... >=2005)

keep if eu == 1
bysort year: generate n_countries = _N
list year n_countries if countrycode == "FRA" & inlist(year, 1958, 1973, 1986, 1995, 2004, 2007, 2013), noobs

* 2.2 Population-weighted percentiles, one row per year.
* The authors write [weight=pop]: for collapse that means aweights.
collapse (p5) p5 = cgdppc (p50) p50 = cgdppc (p95) p95 = cgdppc [aw = pop], by(year)
list year p5 p50 p95 if inlist(year, 1958, 1986, 2004, 2007, 2016), noobs   // the data end in 2016


* =============================================================================
* SECTION 3: FIGURE 4, THE PIPELINE (country-level shares)
* =============================================================================

* Fig4.do uses the commands of Lecture 2 on real data:
*   append  (loop over 4 censuses) -> collapse (sum by country, year, education)
*   -> merge m:1 (population) -> reshape wide twice -> labmask.
* Then, at line 116, it opens the Data Editor (ed) and gives each row a
* country name BY ROW NUMBER: replace country = "Poland" in 1, ... in 25.

* 3.1 The appended file: one row per country, year, education level
use "$main/dta/IMM_EDU_prep.dta", clear
tabulate year edu_lfs                // 1 low, 2 medium, 3 tertiary, 99 unknown

* 3.2 Run Fig4.do up to the line before "ed": we copy its first lines into
* output/ and run the copy (the authors' file is not touched). Data in memory:
* one row per country (ISO code), sorted by sortvar, with id = row number.
file open fin  using "$main/do/Fig4.do", read text
file open fout using "$out/Fig4_until_labels.do", write text replace
file read fin line
while r(eof) == 0 {
    local clean = strtrim(subinstr(`"`macval(line)'"', char(13), "", .))
    if `"`macval(clean)'"' == "ed" continue, break
    file write fout `"`macval(line)'"' _n
    file read fin line
}
file close fin
file close fout
do "$out/Fig4_until_labels.do"
list id country sortvar in 1/5, noobs
* id 1 is POL: the authors' line  replace country = "Poland" in 1  is right
* today. Exercise 3 asks what happens when the data change.


* =============================================================================
* PART 2 - EXERCISES
* =============================================================================

* =============================================================================
* EXERCISE 1 (6 min + 4 min solution) - Table 1 from the counts
* =============================================================================

* Table 1 of the paper comes from dta/Mappe3.xlsx: shares already computed in
* Excel. The same sheet also contains the counts (total2019, EU_2019, ...).
*  a) Import the sheet and recompute columns 1-6 of Table 1 from the counts
*     (in % of total2019; columns 5-6 are changes 2004-2019 in p.p.).
*     Do they match the shares in the file and the paper?
*  b) In which order are the countries listed? The note of Table 1 says
*     "GDP per capita in 2019"; the text on p. 54 says "2015 GDP per capita".
*     Sort by GDP_2019 and list the first 12. Then merge GDP_2015_nom from
*     dta/GDP_2000_2015.dta, sort by it and list again. Which one is the
*     order of the paper (Luxembourg, Switzerland, Ireland, ...)?

* >>> write your code here



* =============================================================================
* EXERCISE 2 (8 min + 4 min solution) - Figure 1 in numbers
* =============================================================================

* p. 51 of the paper: "The 95/5 percentile ratio expanded from 1.19 to 1.85
* with the accession of Spain and Portugal in 1986, and later jumped to 2.82
* and 3.47 following the eastern enlargements of 2004 and 2007".
*  a) The sample of Section 2.1 is rebuilt below. Collapse p5 and p95 by year,
*     compute the ratio p95/p5 and list it for 1985, 1986, 2004, 2007.
*     Which numbers of the text do you reproduce?
*  b) Read the note of Figure 1 and footnote 2: which countries are in the
*     "common European labor market"? Which ones are commented out in Fig1.do?
*  c) Add Norway and Iceland from 1994 and Switzerland from 2005, and compute
*     the ratio again.
*  d) Which sample does the published Figure 1 use?

use "$main/dta/mpd2018.dta", clear
keep if year > 1950
generate eu = 0
replace eu = 1 if inlist(countrycode, "FRA", "ITA", "BEL", "LUX", "NLD", "DEU") & year >= 1958
replace eu = 1 if inlist(countrycode, "IRL", "GBR", "DNK") & year >= 1973
replace eu = 1 if countrycode == "GRC" & year >= 1981
replace eu = 1 if inlist(countrycode, "ESP", "PRT") & year >= 1986
replace eu = 1 if inlist(countrycode, "SWE", "FIN", "AUT") & year >= 1994
replace eu = 1 if inlist(countrycode, "EST", "LVA", "LTU", "MLT", "POL", "SVK", "SVN", "CZE", "HUN") & year >= 2004
replace eu = 1 if countrycode == "CYP" & year >= 2004
replace eu = 1 if inlist(countrycode, "BGR", "ROU") & year >= 2007
replace eu = 1 if countrycode == "HRV" & year >= 2013

* >>> write your code here



* =============================================================================
* EXERCISE 3 (8 min + 4 min solution) - Fragile labels
* =============================================================================

* Start from the data of Section 3.2: do "$out/Fig4_until_labels.do"
* (one row per country, sorted by sortvar, id = row number, country = ISO code).
*  a) The authors name the rows by position (Fig4.do, lines 117-141).
*     Suppose the 2015 data are revised and Slovenia's sortvar rises by 0.2.
*     Re-sort, rebuild id, apply the authors' names by position (the list is
*     given below) and look at rows 1-4. What goes wrong? Does Stata warn you?
*  b) Use the crosswalk below to attach names by country code instead, with
*     merge ... , assert(match). Why is this robust?
*  Run the local below together with your code: a local disappears when the
*  selection you run ends.

local names Poland Slovenia Hungary Latvia Estonia Italy Czechia Portugal Spain Finland Greece Slovakia Netherlands France Denmark UK Sweden Germany Norway Belgium Austria Iceland Ireland Switzerland Luxembourg

preserve
clear
input str3 country str12 name
"POL" "Poland"
"SVN" "Slovenia"
"HUN" "Hungary"
"LVA" "Latvia"
"EST" "Estonia"
"ITA" "Italy"
"CZE" "Czechia"
"PRT" "Portugal"
"ESP" "Spain"
"FIN" "Finland"
"GRC" "Greece"
"SVK" "Slovakia"
"NLD" "Netherlands"
"FRA" "France"
"DNK" "Denmark"
"GBR" "UK"
"SWE" "Sweden"
"DEU" "Germany"
"NOR" "Norway"
"BEL" "Belgium"
"AUT" "Austria"
"ISL" "Iceland"
"IRL" "Ireland"
"CHE" "Switzerland"
"LUX" "Luxembourg"
end
save "$out/crosswalk_iso3.dta", replace
restore

* >>> write your code here



* =============================================================================
* EXERCISE 4 (6 min + 4 min solution) - A loop that overwrites its output
* =============================================================================

*  a) Read the last loop of FigA5.do: how many graphs does it draw, and how
*     many files does it write? Which graph is in pdf/FigA5.pdf?
*  b) Run FigA5.do again (the data stay in memory at the end) and write a
*     loop that exports BOTH graphs to output/, with different file names.
*     (imsm: immigrants of the same race/ethnic group as the majority;
*     imdf: of a different one. pos_share_: % answering "many" or "some".)

* >>> write your code here



* =============================================================================
* CLOSE
* =============================================================================

log close
