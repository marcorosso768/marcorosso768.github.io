#=======================================================================
#  Econometrics -- Tutorial 1 (26 November 2026)
#  Chapter 10, Quiz 2, Part B  (panel data)
#  Chapter 11, Quiz 2, Part B  (binary dependent variable)
#  Data: firms.csv (simulated panel, 800 manufacturing firms, 2019-2023)
#
#  SOLUTIONS: complete code, with the results in the comments.
#  Run line by line: Ctrl+Enter (Windows) / Cmd+Enter (Mac) sends the
#  current line, or the selected lines, to the Console.
#  Lines starting with # are comments: R ignores them.
#=======================================================================


#-----------------------------------------------------------------------
# 0. SETUP
#-----------------------------------------------------------------------

# Packages are installed once per computer, loaded once per session.
# Stata analogy: install.packages() ~ ssc install; library() has no
# Stata equivalent (Stata commands are always "loaded").
# install.packages(c("estimatr", "car", "sandwich", "lmtest"))
library(estimatr)   # lm_robust(): OLS with robust / clustered SEs
library(car)        # linearHypothesis(), deltaMethod()
library(sandwich)   # vcovHC(): robust variance matrix for glm
library(lmtest)     # coeftest(): coefficient table with a given vcov

# Load the data. Easiest way in the lab: Environment pane (top right)
# -> Import Dataset -> From Text (base) -> firms.csv. RStudio then
# writes a read.csv() line in the Console: copy it here and change the
# name on the left of <- to d (RStudio calls the object firms).
# setwd("C:/Users/.../Downloads")            # folder with the file
d <- read.csv("firms.csv")
# Stata: import delimited firms.csv, clear

# A first look at the data
dim(d)            # 4000 rows, 15 columns
head(d)           # first 6 rows               (Stata: list in 1/6)
str(d)            # variable names and types   (Stata: describe)
summary(d$va)     # one variable: d$name       (Stata: summarize va)
table(d$year)     # 800 firms in every year: balanced panel (Stata: tab year)


#=======================================================================
# PART 1. CHAPTER 10 -- QUIZ 2, PART B
#=======================================================================

# The model: Cobb-Douglas production function in logs.
#   ln(va) = b1 ln(capital) + b2 ln(employees) + b3 rd + ...
# In R a regression is written as a FORMULA:  y ~ x1 + x2 + x3
# log() is the natural log. Functions can be used inside the formula.
f <- log(va) ~ log(capital) + log(employees) + rd

#--- (1) Pooled OLS, SEs clustered by firm
m1 <- lm_robust(f, data = d, clusters = id, se_type = "stata")
summary(m1)
# Stata: reg lnva lncap lnemp rd, vce(cluster id)
# rd: 0.0874, t = 6.51

#--- (2) Firm fixed effects
m2 <- lm_robust(f, data = d, fixed_effects = ~ id,
                clusters = id, se_type = "stata")
summary(m2)
# Stata: xtset id year ; xtreg lnva lncap lnemp rd, fe vce(cluster id)
# rd: -0.0026  -> the coefficient collapses once alpha_i is in

#--- (3) Firm and year fixed effects
# as.factor(year) turns year into a categorical variable: R creates one
# dummy per year and drops the first (2019).  (Stata: i.year)
m3 <- lm_robust(log(va) ~ log(capital) + log(employees) + rd + as.factor(year),
                data = d, fixed_effects = ~ id,
                clusters = id, se_type = "stata")
summary(m3)
# capital 0.2895 (0.0554), employees 0.7404 (t = 73.63), rd -0.0013 (0.0093)

#--- (4) First differences
# Sort by firm and year, then take the difference with the row above.
# In 2019 the row above belongs to the previous firm: those rows are
# meaningless and are dropped. This works because the panel is balanced.
d <- d[order(d$id, d$year), ]
fd <- function(v) c(NA, diff(v))     # a small function of our own
d$dlva        <- fd(log(d$va))
d$dlcapital   <- fd(log(d$capital))
d$dlemployees <- fd(log(d$employees))
d$drd         <- fd(d$rd)
dd <- subset(d, year != 2019)        # 3200 observations
m4 <- lm_robust(dlva ~ dlcapital + dlemployees + drd + as.factor(year),
                data = dd, clusters = id, se_type = "stata")
summary(m4)
# Stata: reg D.lnva D.lncap D.lnemp D.rd i.year, vce(cluster id)
# dlcapital 0.3110 (0.0587)

#--- DEEP DIVE 1. Perfect multicollinearity  (ready to run)
# What happens with (a) all five year dummies plus an intercept,
# (b) the sector (constant within each firm) in model (3)?
for (y in 2019:2023) d[[paste0("y", y)]] <- as.numeric(d$year == y)
ma <- lm_robust(log(va) ~ log(capital) + log(employees) + rd
                + y2019 + y2020 + y2021 + y2022 + y2023,
                data = d, clusters = id, se_type = "stata")
coef(ma)          # y2023: NA. Dummy variable trap: the 5 dummies sum to 1
mb <- lm_robust(log(va) ~ log(capital) + log(employees) + rd
                + as.factor(year) + as.factor(sector),
                data = d, fixed_effects = ~ id, clusters = id, se_type = "stata")
coef(mb)          # sector: all NA, absorbed by the firm fixed effects
# Imperfect multicollinearity: SE of log(capital) 0.040 in (2), 0.055 in (3)
c(m2$std.error["log(capital)"], m3$std.error["log(capital)"])

#--- B1. Constant returns to scale in (3): H0: b1 + b2 = 1  (q = 1)
# The names of the coefficients are exactly as printed by summary(m3).
linearHypothesis(m3, "log(capital) + log(employees) = 1", test = "Chisq")
# Chisq = 0.29  (= q x F, since q = 1), p-value 0.591. Not rejected.
# Stata: test lncap + lnemp = 1

#--- B2. 95% CI for the capital elasticity in (4): upper bound
coef(m4)["dlcapital"] + c(-1.96, 1.96) * m4$std.error["dlcapital"]
# [0.196, 0.426]  -> answer 0.426
# (confint(m4) gives the same, with t rather than normal critical values
#  in the last decimals)

#--- B3. No time effects in (3): H0: all 4 year dummies = 0  (q = 4)
# matchCoefs() collects all coefficients whose name contains "year"
matchCoefs(m3, "year")
linearHypothesis(m3, matchCoefs(m3, "year"), test = "Chisq")
# Chisq = 174.52 > 13.28: rejected at 1%.   Stata: testparm i.year

#--- DEEP DIVE 2. t, F and their distributions  (ready to run)
linearHypothesis(m3, matchCoefs(m3, "year"), test = "F")   # F = 43.63 = 174.52 / 4
qf(0.95, df1 = 4, df2 = Inf)      # 2.37: F critical value in large samples
qchisq(0.95, df = 4)              # 9.49 = 4 x 2.37: chi-squared for q x F
qf(0.95, df1 = 4, df2 = 30)       # 2.69: exact F, small sample, normal homoskedastic errors
qnorm(0.975); qt(0.975, df = 799); qt(0.975, df = 10)   # 1.960 1.963 2.228
# q = 1: F = t^2. The t-statistic of B1, with the covariance of the two estimates:
t_crs <- (sum(coef(m3)[1:2]) - 1) / sqrt(sum(vcov(m3)[1:2, 1:2]))
t_crs; t_crs^2                    # 0.537 and 0.288, the statistic of B1

#--- B4. H0: coefficient on rd = 0 in (3), two-sided p-value
t_rd <- coef(m3)["rd"] / m3$std.error["rd"]
t_rd                                   # -0.14
2 * pnorm(-abs(t_rd))                  # 0.887
# pnorm() is the standard normal c.d.f. (Stata: normal())

#--- B5-B8: read off the four regressions
# Coefficients of the four models side by side:
round(cbind(pooled = coef(m1)[2:4], fe = coef(m2)[1:3], twfe = coef(m3)[1:3],
            fd = coef(m4)[2:4]), 4)
# B5: rd 0.087 -> -0.003: permanent unobserved productivity (OVB)
# B6: with T = 5, FE and FD weight within-firm changes differently
# B7: correct = rd significant at 1% in (1) [t 6.51]; time effects
#     rejected at 1% [174.52]; ln(employees) significant at 1% [t 73.63]
# B8: correct = sector absorbed by firm FE; capital identified by
#     within-firm changes relative to the year average; year FE capture
#     the 2020 recession insofar as common to all firms


#=======================================================================
# PART 2. CHAPTER 11 -- QUIZ 2, PART B
#=======================================================================

# Cross section: keep only 2023 (800 firms)
d23 <- subset(d, year == 2023)
# Create the dummy north. The comparison gives TRUE/FALSE,
# as.numeric() turns it into 1/0.   (Stata: gen north = region=="North")
d23$north <- as.numeric(d23$region == "North")
mean(d23$exporter)        # share of exporters
mean(d23$north)           # 0.501

f2 <- exporter ~ log(employees) + rd + north

#--- (1) Linear probability model, heteroskedasticity-robust SEs
m1 <- lm_robust(f2, data = d23)
summary(m1)
# Stata: reg exporter lnemp rd north, robust
# log(employees) 0.3102, rd 0.163
# lm_robust default is HC2 (Stata ", robust" is HC1: se_type = "stata")

#--- (2) Probit and (3) logit, by maximum likelihood
# glm = generalized linear model; family = binomial(link = ...) chooses
# the c.d.f.: "probit" = Phi, "logit" = logistic.
m2 <- glm(f2, family = binomial(link = "probit"), data = d23)
m3 <- glm(f2, family = binomial(link = "logit"),  data = d23)
# Stata: probit exporter lnemp rd north, robust  (and logit ...)
# Robust SEs: summary(m2) would give the non-robust ones.
coeftest(m2, vcov = vcovHC(m2))     # probit: rd t = 3.98
coeftest(m3, vcov = vcovHC(m3))     # logit: north t = 3.39
# NB: vcovHC() default is HC3; Stata's ", robust" is HC1.
# vcovHC(m2, type = "HC1") reproduces Stata; differences are tiny here.

#--- DEEP DIVE 1 again: the dummy variable trap with region  (ready to run)
d23$centre <- as.numeric(d23$region == "Centre")
d23$south  <- as.numeric(d23$region == "South")
coef(lm_robust(exporter ~ log(employees) + rd + north + centre + south, data = d23))
# (Intercept): NA. north + centre + south = 1, the intercept
coef(lm_robust(exporter ~ log(employees) + rd + centre + south, data = d23))
# centre -0.114, south -0.102: relative to the base category, North

#--- B1. Logit: predicted probability, North, 50 employees, R&D
# predict() with newdata: we pass employees in LEVELS, R applies log().
predict(m3, newdata = data.frame(employees = 50, rd = 1, north = 1),
        type = "response")
# 0.563.  type = "response" gives the probability F(z);
# without it predict() returns z (the linear index).
# By hand: z = b0 + b1 ln(50) + b2 + b3, then 1/(1+exp(-z)):
b <- coef(m3); z <- b[1] + b[2] * log(50) + b[3] + b[4]
1 / (1 + exp(-z))                    # same: plogis(z)
# Stata: margins, at(lnemp = `=ln(50)' rd = 1 north = 1)

#--- B2. Probit: change in probability, 20 -> 40 employees, rd = 0, south/centre
pr <- predict(m2, newdata = data.frame(employees = c(40, 20), rd = 0, north = 0),
              type = "response")
pr                       # 0.1674 0.0446
pr[1] - pr[2]            # 0.123
# By hand: pnorm(z40) - pnorm(z20)

#--- B3. LPM: 90% CI for the effect of doubling employees = ln(2) * b1
# deltaMethod needs plain variable names, so precompute the log
d23$lemployees <- log(d23$employees)
m1b <- lm_robust(exporter ~ lemployees + rd + north, data = d23)
deltaMethod(m1b, "log(2)*lemployees", level = 0.90)
# 0.2150 (0.0119), 90% CI [0.195, 0.235] -> answer 0.235
# Here the function is linear, so it is simply ln(2) times the CI of b1:
log(2) * (coef(m1b)["lemployees"] + c(-1.645, 1.645) * m1b$std.error["lemployees"])

#--- B4. Classification table of the logit, cut-off 0.5
p3 <- fitted(m3)                     # predicted probabilities
tab <- table(observed  = factor(d23$exporter, levels = 0:1),
             predicted = factor(as.numeric(p3 > 0.5), levels = 0:1))
tab
#            predicted
# observed    0   1
#        0  402  75
#        1  115 208
sens <- tab["1", "1"] / sum(tab["1", ])   # 208/323 = 64.4%
spec <- tab["0", "0"] / sum(tab["0", ])   # 402/477 = 84.3%
c(success = sum(diag(tab)) / sum(tab), sensitivity = sens, specificity = spec,
  FPR = 1 - spec, FNR = 1 - sens)
# Stata: estat classification

#--- B5. LPM coefficient on ln(employees) = 0.3102:
# 1% more employees -> 0.01 x 0.3102 = 0.0031 higher probability (0.31 pp)

#--- B6. Probit, "average" firm: rd = 1 vs rd = 0
nd <- data.frame(employees = exp(mean(log(d23$employees))),   # so that log() gives the mean
                 rd = c(1, 0), north = mean(d23$north))
pr <- predict(m2, newdata = nd, type = "response")
pr[1] - pr[2]            # 0.204  (LPM: 0.163)

#--- DEEP DIVE 3. Regressions in logs  (ready to run)
# linear-log  (Y on ln X):    X +1%     -> Y changes by 0.01 * b1     (B5: 0.0031)
# log-linear  (ln Y on X):    X +1 unit -> Y changes by about 100*b1 %
# log-log     (ln Y on ln X): X +1%     -> Y changes by b1 %          (elasticity)
100 * (exp(0.0874) - 1)   # rd in Ch. 10 (1): 9.1%, against the approximation 8.7%

#--- B7. Joint test in the probit: rd = 0 and north = 0 (q = 2)
linearHypothesis(m2, c("rd = 0", "north = 0"), vcov. = vcovHC(m2), test = "Chisq")
# Chisq = 25.40 > 9.21: rejected at 1%
# Correct statements: probit rd sig. at 1%; logit north sig. at 1%;
# joint test rejected at 1%; CI = estimate +/- 1.96 robust SE.
# Wrong: comparing logit and probit coefficients directly.

#--- B8. Probit classification, to compare with the logit
p2 <- fitted(m2)
tab2 <- table(observed  = factor(d23$exporter, levels = 0:1),
              predicted = factor(as.numeric(p2 > 0.5), levels = 0:1))
tab2
sum(diag(tab2)) / sum(tab2)          # 76.2%, as the logit
# Correct: MLE because nonlinear in the coefficients; FNR (35.6%) > FPR
# (15.7%); probit and logit classify almost identically.
# Wrong: success rate = simple average of sens. and spec. (it is a
# weighted average); R2 of the LPM a good measure of fit.

# End of script
