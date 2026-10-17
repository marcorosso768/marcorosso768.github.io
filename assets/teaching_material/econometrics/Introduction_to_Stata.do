* -----------------------------------------------------------------------------
* MASTER DO-FILE: INTRODUCTION TO STATA
* Author: Marco Rosso
* e-mail: marco.rosso4@unibo.it
* Date: 14/11/2025
* Purpose: Contains all code for an introductory Stata demonstration. This file
*          is heavily commented to serve as a reference for students.
* Data: Uses the built-in 'auto.dta' and demonstrates saving/loading data.
* -----------------------------------------------------------------------------

/*
   Types of Comments in Stata:
   
   *   Use an asterisk at the beginning of a line for a single-line comment.
       This is the most common and recommended style for do-files.

   //  Use two forward slashes for a line comment or an inline comment.
       Example:
			command // This comment is at the end of a command line.

   /*  Use a forward slash and an asterisk to start a multi-line comment block,
       and an asterisk and a forward slash to end it. This is useful for
       large blocks of text or for temporarily "commenting out" a section of code.
   */
*/


* =============================================================================
* SECTION I: SETUP & WORKFLOW
* =============================================================================

* 1. PRELIMINARY COMMANDS: Prepare the Stata environment

* Clear Stata's memory of any previously loaded data or variables.
* Using `clear all` also clears globals, macros, and other settings.
clear all

* Tell Stata not to pause when results fill the screen. Essential for long do-files.
set more off

* Set the Stata version. This ensures your script runs correctly on different
* Stata versions by enforcing the syntax and features of version 19.
version 19


* 2. SETTING UP THE PROJECT DIRECTORY: The most crucial step for reproducible research.

* We use 'global macros' (globals) to define file paths. This makes the code
* portable and easy to update. You only need to change the 'root' path.

* To find your current working directory, type `pwd` in the Stata Command window.
* Replace the path below with the path to YOUR main project folder.

* Example for Mac/Linux:
global root "/Users/Marco/Desktop/Introduction to Stata"						// path to the main directory
* Example for Windows (uncomment the line below if you use Windows):
* global root "C:\Users\Marco\Desktop\Introduction to Stata"

* Define sub-folders using the main 'root' global.
global data   "$root/data"
global log_file "$root/log_file"
global output "$root/output"
global figures "$output/figures"
global tables  "$output/tables"

* Create these directories automatically if they don't already exist.
* `capture` suppresses any error message if the folder already exists.
capture mkdir "$data"
capture mkdir "$log_file"
capture mkdir "$output"
capture mkdir "$figures"
capture mkdir "$tables"

* Set the main project folder as the current working directory.
cd "$root"
di "Current working directory set to: $root"


* 3. STARTING A LOG FILE: Record your commands and results.

* A log file is a plain text record of everything that appears in the Results window.
* It is essential for tracking your work and debugging.
* The `replace` option overwrites the log file if it already exists.
log using "$log_file/lecture_log.log", text replace

* Note on multiple logs: You can run multiple logs simultaneously by naming them.
* This is an advanced feature, useful for separating different parts of an analysis.
log using "$log_file/analysis_log.log", name(analysis) text replace
log using "$log_file/tables_log.log", name(tables) text replace


* 4. USING STATA'S HELP SYSTEM: Your most important resource.

* Use `help` for a specific command to open its documentation.
help summarize

* Use `findit` to search for keywords across all of Stata's resources.
* This is great when you don't know the exact command name.
findit robust standard errors


* =============================================================================
* SECTION II: DATA HANDLING & ACCESS
* =============================================================================

* 1. LOADING DATA

* Stata comes with built-in example datasets. `sysuse` loads one of them.
sysuse auto, clear

* To save the current dataset as a Stata file (.dta), use the `save` command.
* We use our predefined global path to save it in the 'data' subfolder.
save "$data/our_auto.dta", replace

/*
  NOTE: Below are examples for importing data from other formats.
  These are commented out because they require external files.

  // Import an Excel file, specifying the sheet and that the first row contains variable names.
  import excel "$data/our_excel_file.xlsx", sheet("Sheet1") firstrow clear

  // Import a comma-separated values (.csv) file.
  import delimited "$data/our_csv_file.csv", clear
*/


* 2. DESCRIBING AND VIEWING DATA

* Get a summary of the dataset: variable names, types, labels, etc.
describe

* List specific variables for the first 5 observations.
list make price mpg in 1/5

* List the same variables for observations 6 through 10.
list make price mpg in 6/10


* 3. WORKING WITH LABELS: Making data human-readable.

* The variable 'foreign' is numeric (0 and 1), which is not very descriptive.
tabulate foreign

* First, define the label. We'll name it `origin_lbl`.
label define origin_lbl 0 "Domestic" 1 "Foreign"

* Then, apply this label to the 'foreign' variable.
label values foreign origin_lbl

* Now the table is much clearer.
tabulate foreign


* 4. GENERATING AND MODIFYING VARIABLES

* Create a new variable using `generate` (or `gen`).
* Example: Log-transforming price. This is often done to handle skewed data or
* to model relationships in percentage terms.
gen log_price = log(price)

* TIP: Use the `after()` option to place the new variable next to an existing one.
drop log_price // Drop the old one first
gen log_price = log(price), after(price)
list price log_price in 1/5

* IMPORTANT: If a variable contains zeros, log(0) is missing.
* A common workaround is to calculate log(variable + 1).
* Example: gen log_var_with_zeros = log(var + 1)

* Create a dummy (or indicator) variable.
* Method 1: The efficient "Stata-native" way using a logical expression.
* The expression (mpg >= 30) evaluates to 1 if true and 0 if false.
gen high_mpg = (mpg >= 30)

* Method 2: The longer, two-step `gen`/`replace` way.
* This is less efficient but can be clearer for complex conditions.
gen high_mpg_alt = 1 if mpg >= 30
replace high_mpg_alt = 0 if high_mpg_alt == . // Replace missing with 0

* Create a categorical variable from a continuous one using `recode` or `gen`/`replace`.
gen weight_cat = 1 if weight < 3000
replace weight_cat = 2 if weight >= 3000 & weight < 4000
replace weight_cat = 3 if weight >= 4000 & weight != . // Good practice to exclude missing

* Apply labels to make the new categorical variable understandable.
label define weight_lbl 1 "Light (<3000)" 2 "Medium (3000-3999)" 3 "Heavy (4000+)"
label values weight_cat weight_lbl
tabulate weight_cat


* =============================================================================
* SECTION III: DATA SUBSETTING & CLEANING
* =============================================================================

* 1. FILTERING OBSERVATIONS WITH `if`

* `if` restricts a command to rows that meet a logical condition.
* Logical operators: == (equals), != (not equals), > (greater), < (less),
*                    & (AND), | (OR).

* Summarize price only for domestic cars.
summarize price if foreign == 0

* Summarize price only for foreign cars with high mileage.
summarize price if foreign == 1 & mpg > 25


* 2. FILTERING OBSERVATIONS WITH `in`

* `in` restricts a command to a specific range of row numbers.
summarize price in 1/10 // First 10 observations
summarize price in -10/l // Last 10 observations ('l' stands for last)


* 3. DROPPING AND KEEPING VARIABLES

* Be careful! These commands permanently alter your dataset in memory.
* `drop` removes variables.
drop displacement

* `keep` removes all variables EXCEPT the ones specified.
keep make price mpg foreign

* Let's reload the full, original dataset we saved earlier.
use "$data/our_auto.dta", clear


* =============================================================================
* SECTION IV: DESCRIPTIVE STATISTICS & EFFICIENCY
* =============================================================================

* 1. UNIVARIATE STATISTICS

* Basic summary statistics (N, mean, std. dev., min, max).
summarize price weight mpg

* Detailed summary statistics, including percentiles, variance, and skewness.
summarize price, detail


* 2. GROUP-LEVEL STATISTICS WITH `bysort`

* `bysort` is a powerful prefix that combines sorting and the `by:` prefix.
* It first sorts the data by the specified variable(s), then runs the command
* for each group.

* Calculate summary statistics for 'price', separately for domestic and foreign cars.
bysort foreign: summarize price


* 3. FLEXIBLE TABLES OF STATISTICS WITH `tabstat`

* `tabstat` is more flexible than `summarize` and creates compact tables.
* It's great for comparing statistics across groups.
tabstat price mpg, by(foreign) statistics(n mean median sd min max)


* 4. EFFICIENT DATA GENERATION WITH `egen` (Extended Generate)

* `egen` is used for commands that require looking across multiple observations.

* Create a new variable containing the overall mean of 'price'.
* Every observation will have the same value for `overall_mean_price`.
egen overall_mean_price = mean(price)

* Create a new variable containing the group-level mean of 'price'.
* This is extremely useful for analysis. It calculates the mean price
* within each 'foreign' group and assigns that group mean to every
* observation in that group.
bysort foreign: egen group_mean_price = mean(price)

* List to show the difference.
list make foreign price group_mean_price in 1/10


* 5. FREQUENCY TABLES WITH `tabulate`

* `tabulate` (or `tab`) shows the frequency, percentage, and cumulative
* percentage of values for a categorical variable.
tabulate rep78

* A two-way table shows the cross-tabulation of two variables.
tabulate rep78 foreign


* =============================================================================
* SECTION V: A GLIMPSE AT NEXT STEPS
* =============================================================================

* 1. VISUALIZATION

* Create a histogram of price with a normal density curve overlaid.
histogram price, normal

* Immediately after creating a graph, you can save it using 'graph export'.
* We use our predefined '$figures' global path to save it in the correct folder.
* The file extension (.png, .pdf, .gph, etc.) determines the format.
* The 'replace' option overwrites the file if it already exists.
graph export "$figures/histogram_price.pdf", replace


* Create a scatter plot of price vs. mpg, with a linear fit line.
twoway (scatter price mpg) (lfit price mpg), title("Price vs. Mileage")

* Save the scatter plot.
graph export "$figures/scatter_price_mpg.pdf", replace

* 2. ESTIMATION (REGRESSION)

* Run a simple linear regression: `regress dep_var indep_var1 indep_var2 ...`
* We model price as a function of mileage and weight.
* The `robust` option requests robust standard errors.
regress price mpg weight, robust

* Perform a post-estimation hypothesis test.
* Example: Test if the coefficients on mpg and weight are equal.
test mpg = weight


* 3. CLOSING LOGS & CLEANING UP

* It's good practice to close logs when you're done.
* Close the main, unnamed log file.
log close

* Close the named logs.
log close analysis
log close tables
* Or close all logs at once: `log close _all`

* Clean the environment before finishing.
clear all

* Display a message indicating the script finished successfully.
display "Master do-file ran successfully."

* -----------------------------------------------------------------------------
* END OF LECTURE DO-FILE
* -----------------------------------------------------------------------------
