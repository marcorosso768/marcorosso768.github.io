*******************************************************
* TEMPLATE DO-FILE: OLS + eststo + estout (LaTeX)
* Author: Marco Rosso
* e-mail: marco.rosso4@unibo.it
* -----------------------------------------------------
* Purpose:
*   - Estimate multiple OLS models
*   - Store them with eststo
*   - Export a publication-style LaTeX table with estout
*
* How to use:
*   1. Set your working directory
*   2. Replace the example data and variables with your own
*   3. Run the do-file
*******************************************************

* 0. BASIC SETUP
clear all
set more off

* (Optional) set working directory
* cd "C:\Your\Folder\Here"

* 1. INSTALL PACKAGES (RUN ONCE)
capture which estout
if _rc {
    ssc install estout, replace
}

*******************************************************
* 2. LOAD DATA
* Replace this example with your own dataset
*******************************************************

* Example: use Stata's auto dataset
sysuse auto, clear

* Example dependent and explanatory variables:
*   Dependent variable: price
*   Main regressors: mpg, weight
*   Controls: foreign (dummy)
*
* In your project, replace:
*   - price   -> your dependent variable
*   - mpg     -> your main regressor 1
*   - weight  -> your main regressor 2
*   - foreign -> your dummy / control
*******************************************************


*******************************************************
* 3. ESTIMATE OLS MODELS AND STORE THEM
*******************************************************
eststo clear

* Model 1: baseline
eststo m1: regress price mpg

* Model 2: add another continuous regressor
eststo m2: regress price mpg weight

* Model 3: add a dummy regressor
eststo m3: regress price mpg weight i.foreign


*******************************************************
* 4. EXPORT RESULTS WITH ESTOUT (FULL LATEX EXAMPLE)
*******************************************************

* Output path (change to your folder)
local outfile "table_ols_example.tex"

estout m1 m2 m3 using "`outfile'", replace ///
    style(tex) collabels(none) /// no automatic column titles
    keep(mpg weight 1.foreign) /// show only selected regressors
    order(mpg weight 1.foreign) /// order of regressors in the table
    varlabels( ///
        mpg        "Miles per gallon" ///
        weight     "Weight (lbs)" ///
        1.foreign  "Foreign car", ///
        end("\addlinespace[0.15cm] ") ///
    ) ///
    cells(b(fmt(3) star) se(fmt(3) par)) /// coefficients + SE in parentheses
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    ///
    /* SUMMARY STATISTICS */
    stats(N r2, ///
        fmt(%9.0g 3) ///
        labels("Observations" "R-squared") ///
        layout(@ "\multicolumn{1}{c}{@}") ///
    ) ///
    ///
    /* FIXED-EFFECTS INDICATORS (EXAMPLE PLACEHOLDER)
       - In this auto example we do NOT have FE
       - In your real project, use indicators like:
       - "Year FE = yearFE" if you added i.year in the model
       - Then estout checks whether those dummies were included
    */
    indicate("Year FE = yearFE" "Region FE = regionFE", ///
        labels("\multicolumn{1}{c}{\checkmark}" ///
               "\multicolumn{1}{c}{ }") ///
    ) ///
    ///
    /* LATEX STRUCTURE: PRE-HEADER, HEADER, FOOTER */
    prehead( ///
        "\begin{tabular}{l c c c}" ///
        "\hline\hline" ///
        "\addlinespace[0.1cm]" ///
        " & \multicolumn{3}{c}{Dependent variable: Price} \\" ///
        "\cmidrule(lr){2-4}" ///
        " & (1) & (2) & (3) \\" ///
    ) ///
    posthead("\addlinespace[0.1cm] \hline \addlinespace[0.05cm]") ///
    prefoot("\addlinespace[0.05cm] \hline \addlinespace[0.05cm]") ///
    postfoot( ///
        "\addlinespace[0.1cm] \hline\hline" ///
        "\end{tabular}" ///
    ) ///
    end("\[-0.10cm]")   // small negative vertical space under table


*******************************************************
* 5. NOTES
*******************************************************
* - The file `table_ols_example.tex` is now in your working directory.
* - Include it in LaTeX with:
*
*   \input{table_ols_example.tex}
*
* - To adapt this template:
*   - Change the regress commands (dependent and independent variables)
*   - Adjust keep(), order(), and varlabels() to your variables
*   - Customize header text inside prehead() and posthead()
*   - Modify stats() to add/remove summary statistics
*   - Update indicate() to match your fixed effects (if any)
*******************************************************
