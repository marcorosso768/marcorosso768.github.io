*==============================================================================
* EDLE | Empirical Methods for Law and Economics
* Supplementary material: Missing values in a control variable
* Code shown on the STATA slides. No external data needed (nlsw88 ships with Stata).
*==============================================================================

clear all
set more off

sysuse nlsw88, clear                    // US women, 1988
generate lnwage = ln(wage)              // log hourly wage

*------------------------------------------------------------------------------
* 1. How much is missing, and is it MCAR?
*------------------------------------------------------------------------------

misstable summarize                     // union is missing for many women

generate byte union_miss = missing(union)    // 1 if union membership missing
tabulate union_miss

* If observed characteristics predict missingness, MCAR is rejected.
* (MAR can never be tested: it concerns what we do not observe.)
logit union_miss collgrad ttl_exp i.race south smsa married

*------------------------------------------------------------------------------
* 2. Three ways to control for union membership
*------------------------------------------------------------------------------

local ctrl "collgrad ttl_exp i.race south smsa married"

* (1) Complete cases: Stata drops observations with missing union
regress lnwage union `ctrl', vce(robust)
estimates store cc

* (2) Missing-value dummy: set missing union to 0 and add the indicator
generate union0 = cond(union_miss, 0, union)
regress lnwage union0 union_miss `ctrl', vce(robust)
estimates store dummy

* (3) Multiple imputation under MAR
mi set wide                             // storage format for imputed datasets
mi register imputed union               // the variable to fill in
* Imputation model: logit for a 0/1 variable. It includes the outcome lnwage
* and every control of the analysis model.
mi impute logit union = lnwage `ctrl', add(20) rseed(2026)
* Estimate in each of the 20 datasets and combine with Rubin's rules
mi estimate: regress lnwage union `ctrl', vce(robust)

*------------------------------------------------------------------------------
* 3. Compare
*------------------------------------------------------------------------------
* Look at: number of observations, coefficients on union (union0) and collgrad,
* and their standard errors across (1), (2), (3).
estimates table cc dummy, keep(union union0 union_miss collgrad) b se stats(N)

*------------------------------------------------------------------------------
* 4. What if the outcome is left out of the imputation model?
*------------------------------------------------------------------------------
* Start again from the original data, impute union WITHOUT lnwage,
* and compare the coefficient on union with specification (3).
sysuse nlsw88, clear
generate lnwage = ln(wage)
local ctrl "collgrad ttl_exp i.race south smsa married"
mi set wide
mi register imputed union
mi impute logit union = `ctrl', add(20) rseed(2026)
mi estimate: regress lnwage union `ctrl', vce(robust)
