* ============================================================================
* MARGINAL EFFECTS & ML TESTS: COMPLETE STATA DO-FILE
* CLABE 2025/2026 - 27 November 2025
* Author: Marco Rosso
* e-mail: marco.rosso4@unibo.it
* ============================================================================

clear all
set more off
capture log close
log using "log_of_Stata_session_27_11_2025.log", replace

* ============================================================================
* EXERCISE 1: LOAD DATA AND BASIC DESCRIPTION
* ============================================================================
display "=========================================="
display "EXERCISE 1: Data Description"
display "=========================================="

webuse lbw, clear

describe low age lwt smoke
summarize low age lwt smoke

* Key observations:
* - low: binary (31% have low birth weight)
* - age: ranges from 14 to 45
* - lwt: mother's weight in lbs
* - smoke: 39% are smokers

* ============================================================================
* EXERCISE 2: ESTIMATE LOGIT AND PROBIT MODELS
* ============================================================================
display "=========================================="
display "EXERCISE 2: Model Estimation"
display "=========================================="

* Estimate PROBIT model
probit low age lwt i.smoke
estimates store probit_full

* Estimate LOGIT model (for comparison)
logit low age lwt i.smoke
estimates store logit_full

* Go back to probit for the rest of analysis
probit low age lwt i.smoke

/*
Interpretation of coefficients:
- age: negative, means older mothers have lower risk
- lwt: negative, means heavier mothers have lower risk
- smoke: positive, means smokers have higher risk

BUT THESE ARE NOT THE MARGINAL EFFECTS!
We need to compute them separately.
*/

* ============================================================================
* EXERCISE 3: AVERAGE MARGINAL EFFECTS (AME)
* ============================================================================
display "=========================================="
display "EXERCISE 3: Average Marginal Effects"
display "=========================================="

probit low age lwt i.smoke
margins, dydx(*)

/*
Output shows:
- age: -0.00897. One more year of age DECREASES probability by 0.9pp
- lwt: -0.00386. One more pound DECREASES probability by 0.4pp
- smoke: +0.153. Being a smoker INCREASES probability by 15.3pp

These are the correct effects!
Compare with coefficients: β_age = -0.0393, but ME = -0.00897
*/

* Store these results for later comparison
margins, dydx(*) post
eststo ame_results

* NOTE: eststo and esttab are from the estout package.
* If you do not have them installed, run:
*   ssc install estout

* ============================================================================
* EXERCISE 3B: MANUAL COMPUTATION OF AME FOR A CONTINUOUS VARIABLE (AGE)
* ============================================================================
display "=========================================="
display "EXERCISE 3B: Manual AME for Age"
display "=========================================="

* Re-estimate the probit model to be sure everything is in memory
probit low age lwt i.smoke

* 1) Get the linear predictor Xβ for each observation
predict xb_hat, xb

* 2) For probit, the density is the standard normal density φ(Xβ)
generate density_age = normalden(xb_hat)

* 3) Individual marginal effect of age:
*    ME_i(age) = φ(Xβ_i) * β_age
generate me_age_manual = density_age * _b[age]

* 4) Average the individual marginal effects (this is the AME by hand)
summarize me_age_manual
scalar ame_age_manual = r(mean)

display "Manual AME for age (using φ(Xβ)*β_age): " ame_age_manual

* 5) Compare with Stata's margins result for age
margins, dydx(age)
matrix M = r(b)
scalar ame_age_margins = M[1,1]

display "AME for age from margins:               " ame_age_margins

/*
Conclusion:
- ame_age_manual should be numerically very close to ame_age_margins.
- The difference (if any) is due only to rounding and finite precision.
*/

* ============================================================================
* EXERCISE 4: MARGINAL EFFECTS AT THE MEAN (MEM)
* ============================================================================
display "=========================================="
display "EXERCISE 4: Marginal Effects at Mean"
display "=========================================="

probit low age lwt i.smoke
margins, dydx(*) atmeans

/*
Output should show similar but slightly different numbers than AME.
Comparison:
- AME vs MEM are often close but conceptually different
- AME: average effect across sample (realistic)
- MEM: effect at "mean person" (artificial)
*/

margins, dydx(*) atmeans post
eststo mem_results

* Create comparison table
esttab ame_results mem_results, ///
    title("Comparison: AME vs MEM") ///
    mtitles("AME" "MEM") ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    legend label

* ============================================================================
* EXERCISE 5: MARGINAL EFFECTS AT DIFFERENT LEVELS
* ============================================================================
display "=========================================="
display "EXERCISE 5: Marginal Effects by Age Level"
display "=========================================="

probit low age lwt i.smoke

* Predicted probabilities at different ages
margins, at(age=(15(5)45))
marginsplot, title("Predicted Probability of Low Birth Weight by Age") ///
    xtitle("Mother's Age (years)") ///
    ytitle("Predicted Probability") ///
    name(pred_prob, replace)

* Marginal effect of age at different ages (THIS SHOWS HETEROGENEITY!)
margins, dydx(age) at(age=(15(5)45))
marginsplot, title("Marginal Effect of Age at Different Age Levels") ///
    xtitle("Mother's Age (years)") ///
    ytitle("Marginal Effect (∂P/∂age)") ///
    name(me_age, replace)

/*
KEY INSIGHT: The marginal effect of age is NOT constant!
- At age 15: ME is small (slope is flat at extreme)
- At age 25-35: ME is largest (slope is steepest in middle)
- At age 45: ME decreases again (approaching other extreme)

This is because f(Xβ) varies with X.
At middle values where P ≈ 0.5, the logit curve is steepest.
*/

* ============================================================================
* EXERCISE 6: MARGINAL EFFECTS FOR DISCRETE VARIABLES
* ============================================================================
display "=========================================="
display "EXERCISE 6: Discrete Variable (Smoking)"
display "=========================================="

probit low age lwt i.smoke

* Marginal effect of smoking variable
margins, dydx(smoke)

/*
This computes: P(low=1|smoke=1) - P(low=1|smoke=0)
for each observation, then averages
*/

* Manual computation to verify
margins, at(smoke=0) at(smoke=1)
marginsplot, title("Predicted Probability: Smokers vs Non-Smokers") ///
    xtitle("Smoking Status") ///
    ytitle("Predicted Probability of Low Birth Weight") ///
    name(smoke_effect, replace)

/*
The difference between these two is the marginal effect of smoke.
Smoking increases the probability of low birth weight by about 15pp.
*/

* ============================================================================
* EXERCISE 6B: MANUAL COMPUTATION OF DISCRETE MARGINAL EFFECT (SMOKING)
* ============================================================================
display "=========================================="
display "EXERCISE 6B: Manual Discrete ME for Smoking"
display "=========================================="

* Re-estimate the probit model to make sure coefficients are in memory
probit low age lwt i.smoke

* Save coefficients in scalars for clarity
scalar b0      = _b[_cons]
scalar bage    = _b[age]
scalar blwt    = _b[lwt]
scalar bsmoke  = _b[1.smoke]

* Compute the linear index Xβ when smoke = 0 for each observation
generate xb_smoke0 = . 
replace xb_smoke0 = b0 + bage*age + blwt*lwt if e(sample)

* Compute the linear index Xβ when smoke = 1 (add the coefficient on smoke)
generate xb_smoke1 = xb_smoke0 + bsmoke if e(sample)

* Convert indices into probabilities using the probit CDF Φ(·)
generate p0 = normal(xb_smoke0)   // P(low=1 | smoke=0, X_-)
generate p1 = normal(xb_smoke1)   // P(low=1 | smoke=1, X_-)

* Individual discrete marginal effect: ME_i = P1_i - P0_i
generate me_smoke_manual = p1 - p0

* Average across all observations: AME for the dummy smoke
summarize me_smoke_manual
scalar ame_smoke_manual = r(mean)

display "Manual discrete ME for smoke (average P1 - P0): " ame_smoke_manual

* Compare with Stata's margins result
margins, dydx(smoke)
matrix B = r(b)
scalar ame_smoke_margins = B[1,2] // B[1,1] corresponds to smoke = 0, B[1,2] to smoke = 1

display "Discrete ME for smoke from margins:             " ame_smoke_margins

/*
Conclusion:
- ame_smoke_manual is the average difference in probabilities
  P(low=1 | smoke=1) - P(low=1 | smoke=0).
- It should match the discrete marginal effect reported by margins, dydx(smoke).
*/

* ============================================================================
* EXERCISE 7: MODEL WITHOUT SMOKING (to show AME changes!)
* ============================================================================
display "=========================================="
display "EXERCISE 7: Model Comparison - Effect of Adding Smoking"
display "=========================================="

probit low age lwt
estimates store model_no_smoke
margins, dydx(*) post
eststo ame_no_smoke

probit low age lwt i.smoke
margins, dydx(*) post
eststo ame_with_smoke

* Compare the two models
esttab ame_no_smoke ame_with_smoke, ///
    title("How AME Changes When We Add Smoking") ///
    mtitles("Without Smoke" "With Smoke") ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    legend label

/*
When we add smoking, the AME of age and lwt might change slightly.
This is because smoking is correlated with age/lwt, and when we add it,
the model captures this information better.
*/

* ============================================================================
* EXERCISE 8: MANUAL COMPUTATION OF HETEROGENEOUS EFFECTS
* ============================================================================
display "=========================================="
display "EXERCISE 8: Understand Heterogeneity - Manual Calculation"
display "=========================================="

probit low age lwt i.smoke

* Predict the linear index Xβ for each person
predict xb_hat1, xb

* Compute the density f(Xβ).
* For probit the density is the standard normal: φ(z) = normalden(z)
generate density = normalden(xb_hat1)

* Manually compute marginal effect of age
generate me_age_manual1 = density * _b[age]

* View first 10 observations
list me_age_manual1 age lwt smoke in 1/10

* Summary statistics
summarize me_age_manual1

/*
You should see that ME varies across observations.
The heterogeneity comes from the density term.
*/

* ============================================================================
* EXERCISE 9: LIKELIHOOD RATIO TEST (Main Test)
* ============================================================================
display "=========================================="
display "EXERCISE 9: Likelihood Ratio (LR) Test"
display "=========================================="

* Hypothesis: H0: β_age = 0 AND β_lwt = 0
*            H1: At least one of these is nonzero

* Estimate FULL model (with age and lwt)
probit low age lwt i.smoke
estimates store full_model

* Estimate RESTRICTED model (without age and lwt)
probit low i.smoke
estimates store restricted_model

* Perform LR test
lrtest full_model restricted_model

/*
Output shows:
- LR chi2(2) = [value]: the test statistic
- Prob > chi2 = [p-value]: probability of getting this value under H0
- If p-value < 0.05, reject H0 (age and lwt matter)
*/

* ============================================================================
* EXERCISE 10: MANUAL LR TEST CALCULATION
* ============================================================================
display "=========================================="
display "EXERCISE 10: Manual Computation of LR Test"
display "=========================================="

* In the Stata output of probit/logit we see at the top:
*   Iteration 0: log likelihood = ...
*   ...
*   Iteration k: log likelihood =  -65.432   (final value at convergence)
* The final "log likelihood = ..." line is what we use as ℓ.

* Store log-likelihoods from the unrestricted and restricted models
probit low age lwt i.smoke
scalar ll_full = e(ll)
probit low i.smoke
scalar ll_restricted = e(ll)

* Manual LR calculation: LR = -2 * (ℓ_restricted - ℓ_full)
display "Log-likelihood (full model, ℓ_U):       " ll_full
display "Log-likelihood (restricted model, ℓ_R): " ll_restricted

display "--------------------------------------------------"
display "Step 1: Compute LR statistic: LR = -2(ℓ_R - ℓ_U)"
scalar LR_stat = -2*(ll_restricted - ll_full)
display "LR statistic = " LR_stat

display "--------------------------------------------------"
display "Step 2: Degrees of freedom"
display "Two restrictions (β_age=0 and β_lwt=0) ⇒ df = 2"
scalar df_LR = 2

display "--------------------------------------------------"
display "Step 3: Critical value at α = 0.05"
scalar crit_5 = invchi2(df_LR, 0.95)
display "Critical value χ2(" df_LR ", 0.95) = " crit_5

display "--------------------------------------------------"
display "Step 4: p-value for the LR statistic"
scalar p_LR = chi2tail(df_LR, LR_stat)
display "p-value = Prob(χ2(" df_LR ") ≥ LR) = " p_LR

display "--------------------------------------------------"
display "Decision rule:"
display "Reject H0 if LR_stat > critical value OR if p-value < 0.05."

display "--------------------------------------------------"
display "Check: compare with lrtest full_model restricted_model"
lrtest full_model restricted_model

/*
The LR statistic and p-value computed manually above
should match the LR χ2 and Prob>χ2 reported by lrtest.
*/

* ============================================================================
* EXERCISE 11: WALD TEST (from standard output)
* ============================================================================
display "=========================================="
display "EXERCISE 11: Wald Test - Single Coefficients"
display "=========================================="

probit low age lwt i.smoke

/*
In the standard output above, you see:
- Coefficient
- Std.Err
- z = Coefficient / Std.Err
- P>|z| = p-value

To get Wald test: W = z^2 (or equivalently, W = (β/SE)^2)

For age: z = [value from output]
        W_age = z^2

The p-value for z-test vs t-test is very similar for this sample size.
*/

* Explicit Wald test for multiple restrictions
test age lwt

/*
Output shows:
- Wald chi2(2) = [value]
- Prob > chi2 = [p-value]

This tests: H0: β_age = 0 AND β_lwt = 0

Compare this with the LR test result. 
They test the same hypothesis but should give slightly different values!
BUT, both the LR test and the Wald test tell you to reject the null hypothesis at the conventional 5% level
*/

* ============================================================================
* EXERCISE 11B: MANUAL WALD TEST FOR A SINGLE COEFFICIENT (AGE)
* ============================================================================
display "=========================================="
display "EXERCISE 11B: Manual Wald Test (Single Coefficient)"
display "=========================================="

* Re-estimate the unrestricted model to make sure coefficients are in memory
probit low age lwt i.smoke

* Extract coefficient and standard error for 'age'
scalar b_age  = _b[age]
scalar se_age = _se[age]

* Compute the t-statistic and the Wald statistic (t^2)
scalar t_age = b_age / se_age
scalar W_age = t_age^2

* Degrees of freedom = number of restrictions = 1
scalar df_wald = 1

* Compute critical value and p-value
scalar crit_5_wald = invchi2(df_wald, 0.95)
scalar p_wald = chi2tail(df_wald, W_age)

display "Manual Wald Test for β_age:"
display "-------------------------------------------"
display "β_hat (age)  = " b_age
display "SE(age)      = " se_age
display "t-statistic  = " t_age
display "W = t^2      = " W_age
display "Critical χ2(1, 0.95) = " crit_5_wald
display "p-value      = " p_wald

display ""
display "Decision rule:"
display "Reject H0: β_age = 0 if W > χ2_crit or p-value < 0.05"
display ""

display "Check: compare with Stata's standard output t-stat and p-value"

* ============================================================================
* EXERCISE 12: COMPARING THE THREE TESTS
* ============================================================================
display "=========================================="
display "EXERCISE 12: Compare LR and Wald Tests"
display "=========================================="

* Wald test for the joint hypothesis H0: β_age = 0 AND β_lwt = 0
probit low age lwt i.smoke
estimates store full
test age lwt
scalar wald_stat = r(chi2)
scalar wald_pval = r(p)

* LR test for the same hypothesis using restricted model without age and lwt
probit low i.smoke
estimates store restricted
lrtest full restricted
scalar lr_stat = r(chi2)
scalar lr_pval = r(p)

* Display comparison
display "Hypothesis: H0: β_age = 0 AND β_lwt = 0"
display ""
display "Test        | Test Stat | P-value"
display "────────────┼──────────┼─────────"
display "Wald        |   " wald_stat "    |  " wald_pval
display "LR          |   " lr_stat "    |  " lr_pval

/*
In large samples, LR ≈ Wald.
In small samples, they can differ.
Both should lead to same conclusion (reject or don't reject H0).
*/

* ============================================================================
* EXERCISE 13: ACADEMIC EXAMS EXAMPLE FROM LECTURE NOTES
* ============================================================================
display "=========================================="
display "EXERCISE 13: Academic Exams - LR Test"
display "* This example is unrelated to birth weight"
display "* It just shows how to apply tests in different context"
display "=========================================="

* Create the academic exams dataset
clear
input exam n_attend n_pass
1 95 71
2 44 27
3 38 21
4 27 10
5 18 9
6 15 12
end

* Compute pass rate for each exam
generate p_hat = n_pass / n_attend

* Compute overall pass rate
summarize p_hat [w=n_attend]
scalar overall_p = r(mean)

display "Overall pass rate (H0): " overall_p

* For each exam, compute Wald test: H0: p = overall_p
generate se_null = sqrt(overall_p * (1-overall_p) / n_attend)
generate z_stat = (p_hat - overall_p) / se_null
generate wald_test = z_stat^2
generate p_value = 2 * (1 - normal(abs(z_stat)))

* Display results
list exam n_attend p_hat wald_test p_value

/*
Questions:
1. Which exam has the lowest pass rate? (September, 37%)
2. Which exams differ significantly from overall average?
   (Look for p_value < 0.05)
3. Interpretation: Are exams different difficulty, or just random variation?
*/

* ============================================================================
* FINAL SUMMARY
* ============================================================================
display "=========================================="
display "SUMMARY OF KEY COMMANDS"
display "=========================================="

display ""
display "1. MARGINAL EFFECTS:"
display "   margins, dydx(*)              → Average Marginal Effects"
display "   margins, dydx(*) atmeans      → At the Mean"
display "   margins, at(x=(values))       → Predicted prob at specific x"
display ""
display "2. VISUALIZATION:"
display "   marginsplot                   → Plot results from margins"
display ""
display "3. TESTS:"
display "   lrtest model1 model2          → Likelihood Ratio Test"
display "   test var1 var2                → Wald Test"
display ""
display "4. COMPARING MODELS:"
display "   esttab model1 model2, ... → Compare estimates"
display ""

display "=========================================="
display "End of Exercise Session"
display "=========================================="

log close
