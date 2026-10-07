* EDLE - Empirical Methods for Law and Economics - setup
* Run every do-file with the COURSE FOLDER as Stata's working directory,
* i.e. the folder that contains the subfolders data/ and do/.
* Example (adapt the path): cd "C:/Users/yourname/Documents/EDLE_week1"
version 16.0
clear all
set more off
set linesize 120
capture log close _all
capture confirm file "data/contracts_2019.dta"
if _rc {
    display as error "Working directory is wrong: data/contracts_2019.dta not found."
    display as error "Use cd to move to the course folder, then run this file again."
    exit 601
}
global course_root "`c(pwd)'"
global course_data "$course_root/data"
global course_results "$course_root/results"
capture mkdir "$course_results"
capture mkdir "$course_results/logs"
capture mkdir "$course_results/figures"
capture mkdir "$course_results/tables"
display as text "Setup complete. Course folder: $course_root"
