* EDLE - Empirical Methods for Law and Economics - setup

* Interpret commands using Stata 16 syntax for compatibility with later Stata versions.
version 16.0

* Remove data and user-defined programs from memory; saved files on disk are not deleted.
clear all

* Display all output without pausing at a --more-- prompt.
set more off

* Allow 120 characters per line in text output and logs.
set linesize 120

* Close all open logs; capture suppresses an error if no log is open.
capture log close _all

* Check that the prepared dataset exists; capture stores any error code in _rc instead of stopping immediately.
capture confirm file "data/contracts_2019.dta"

* Enter this block only if the preceding captured file check returned a nonzero error code.
if _rc {
* Print a readable error message; this line alone does not stop execution.
    display as error "Working directory is wrong: data/contracts_2019.dta not found."
* Print a readable error message; this line alone does not stop execution.
    display as error "Use cd to move to the course folder, then run this file again."
* Stop this do-file with file-not-found error 601 rather than continuing with the wrong folder.
    exit 601
* End the preceding conditional block; subsequent lines run outside that block.
}

* Store the current working directory c(pwd) in a global macro available to other do-files.
global course_root "`c(pwd)'"

* Build the data-folder path by expanding the course_root global macro.
global course_data "$course_root/data"

* Build the results-folder path by expanding the course_root global macro.
global course_results "$course_root/results"

* Create this output directory; capture allows the folder to exist already without stopping the file.
capture mkdir "$course_results"

* Create this output directory; capture allows the folder to exist already without stopping the file.
capture mkdir "$course_results/logs"

* Create this output directory; capture allows the folder to exist already without stopping the file.
capture mkdir "$course_results/figures"

* Create this output directory; capture allows the folder to exist already without stopping the file.
capture mkdir "$course_results/tables"

* Print a progress message, expanding any $global macro to its stored value.
display as text "Setup complete. Course folder: $course_root"
