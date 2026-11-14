*==============================================================================
* EDLE | Empirical Methods for Law and Economics
* Supplementary material: What happens to a coefficient when we add a control?
* Code shown on the STATA slides. No external data needed.
*==============================================================================

clear all
set more off

*------------------------------------------------------------------------------
* PART 1. Simulated data: three worlds
* True model in every world: y = 1*x + 2*z + u
* Only the link between z and x changes (local delta below).
*   World A: delta =  0.5  -> short coefficient about  2 (adding z lowers it)
*   World B: delta = -0.5  -> short coefficient about  0 (adding z raises it)
*   World C: delta = -1    -> short coefficient about -1 (adding z flips the sign)
*------------------------------------------------------------------------------

foreach delta_true in 0.5 -0.5 -1 {

    clear
    set seed 2026
    set obs 10000                       // large sample: estimates close to truth

    generate x = rnormal()              // variable of interest
    generate v = rnormal()              // part of z unrelated to x
    generate u = rnormal()              // error term of y
    generate z = `delta_true'*x + v     // the control
    generate y = 1*x + 2*z + u          // outcome

    quietly regress y x                 // short regression: y on x only
    scalar b_short = _b[x]

    quietly regress y x z               // long regression: add the control z
    scalar b_long  = _b[x]
    scalar gamma   = _b[z]              // effect of z on y, holding x fixed

    quietly regress z x                 // auxiliary regression: z on x
    scalar delta   = _b[x]              // how z moves with x

    display _newline "World with delta = `delta_true'"
    display "  short = " %7.4f b_short "   long = " %7.4f b_long
    * The two numbers below are identical: short - long = gamma*delta
    display "  short - long = " %9.6f b_short - b_long ///
            "   gamma*delta = " %9.6f gamma*delta
}

*------------------------------------------------------------------------------
* PART 2. Real data: nlsw88 (US women, 1988; ships with Stata)
*------------------------------------------------------------------------------

sysuse nlsw88, clear
generate lnwage = ln(wage)              // log hourly wage

* Before running: do college graduates have more or less total experience?
* So in which direction should the collgrad coefficient move?

quietly regress lnwage collgrad                 // short
scalar b_short = _b[collgrad]
quietly regress lnwage collgrad ttl_exp         // long: add total experience
scalar b_long  = _b[collgrad]
scalar gamma   = _b[ttl_exp]
quietly regress ttl_exp collgrad                // auxiliary
scalar delta   = _b[collgrad]

display _newline "nlsw88, control = ttl_exp"
display "  short = " %7.4f b_short "   long = " %7.4f b_long
display "  short - long = " %9.6f b_short - b_long ///
        "   gamma*delta = " %9.6f gamma*delta

* Same exercise with tenure (job tenure). tenure has missing values:
* all three regressions must use the SAME observations, or the identity fails.
quietly regress lnwage collgrad if !missing(tenure)          // short
scalar b_short = _b[collgrad]
quietly regress lnwage collgrad tenure                       // long
scalar b_long  = _b[collgrad]
scalar gamma   = _b[tenure]
quietly regress tenure collgrad                              // auxiliary
scalar delta   = _b[collgrad]

display _newline "nlsw88, control = tenure (same sample in all regressions)"
display "  short = " %7.4f b_short "   long = " %7.4f b_long
display "  short - long = " %9.6f b_short - b_long ///
        "   gamma*delta = " %9.6f gamma*delta

* Try it: remove "if !missing(tenure)" from the short regression and rerun.
* The two numbers no longer coincide: the short regression now uses more
* observations than the long one.
