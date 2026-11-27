#=======================================================================
#  Econometrics -- Tutorial 1 (26 November 2026)
#  Chapter 10, Quiz 2, Part B  (panel data)
#  Chapter 11, Quiz 2, Part B  (binary dependent variable)
#  Data: firms.csv (simulated panel, 800 manufacturing firms, 2019-2023)
#
#  We fill in the blanks (___) together. The DEEP DIVE parts are ready to run.
#  Ctrl+Enter (Windows) / Cmd+Enter (Mac) runs the current line.
#  Lines starting with # are comments: R ignores them.
#=======================================================================


#-----------------------------------------------------------------------
# 0. SETUP
#-----------------------------------------------------------------------

# install.packages(c("estimatr", "car", "sandwich", "lmtest"))  # only once
library(estimatr)   # lm_robust(): OLS with robust / clustered SEs
library(car)        # linearHypothesis(), deltaMethod()
library(sandwich)   # vcovHC(): robust variance matrix for probit/logit
library(lmtest)     # coeftest(): coefficient table with robust SEs

# Load the data: Environment pane -> Import Dataset -> From Text (base)
# Then copy here the read.csv() line that appears in the Console,
# and change the name on the left of <- to d, as below:
d <- read.csv("firms.csv")

dim(d)            # rows and columns
head(d)           # first rows
str(d)            # variable names and types
table(d$year)     # is the panel balanced?


#=======================================================================
# PART 1. CHAPTER 10 -- QUIZ 2, PART B
#=======================================================================

# A regression in R is a formula:  y ~ x1 + x2 + x3
f <- log(va) ~ log(capital) + log(employees) + rd

# (1) Pooled OLS, SEs clustered by firm
m1 <- lm_robust(f, data = d, clusters = id, se_type = "stata")
summary(m1)

# (2) Firm fixed effects: which option adds alpha_i?
m2 <- lm_robust(f, data = d, ___ = ~ id,
                clusters = id, se_type = "stata")
summary(m2)

# (3) Firm and year fixed effects: how do we add the year dummies?
m3 <- lm_robust(log(va) ~ log(capital) + log(employees) + rd + ___,
                data = d, fixed_effects = ~ id,
                clusters = id, se_type = "stata")
summary(m3)

# (4) First differences (all consecutive years)
d <- d[order(d$id, d$year), ]          # sort by firm and year
fd <- function(v) c(NA, diff(v))       # difference with the row above
d$dlva        <- fd(log(d$va))
d$dlcapital   <- fd(log(d$capital))
d$dlemployees <- fd(log(d$employees))
d$drd         <- fd(d$rd)
dd <- subset(d, year != 2019)          # why do we drop 2019?
m4 <- lm_robust(dlva ~ dlcapital + dlemployees + drd + as.factor(year),
                data = dd, clusters = id, se_type = "stata")
summary(m4)

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

# B1. Constant returns to scale in (3). H0: ________   q = __
linearHypothesis(m3, "___", test = "Chisq")

# B2. 95% CI for the capital elasticity in (4)
coef(m4)["dlcapital"] + c(___, ___) * m4$std.error["dlcapital"]

# B3. No time effects in (3). q = __
linearHypothesis(m3, matchCoefs(m3, "___"), test = "Chisq")

#--- DEEP DIVE 2. t, F and their distributions  (ready to run)
linearHypothesis(m3, matchCoefs(m3, "year"), test = "F")   # F = 43.63 = 174.52 / 4
qf(0.95, df1 = 4, df2 = Inf)      # 2.37: F critical value in large samples
qchisq(0.95, df = 4)              # 9.49 = 4 x 2.37: chi-squared for q x F
qf(0.95, df1 = 4, df2 = 30)       # 2.69: exact F, small sample, normal homoskedastic errors
qnorm(0.975); qt(0.975, df = 799); qt(0.975, df = 10)   # 1.960 1.963 2.228
# q = 1: F = t^2. The t-statistic of B1, with the covariance of the two estimates:
t_crs <- (sum(coef(m3)[1:2]) - 1) / sqrt(sum(vcov(m3)[1:2, 1:2]))
t_crs; t_crs^2                    # 0.537 and 0.288, the statistic of B1

# B4. H0: coefficient on rd = 0 in (3). Two-sided p-value
t_rd <- coef(m3)["rd"] / m3$std.error["rd"]
2 * ___(-abs(t_rd))

# B5-B8. Compare the four regressions
round(cbind(pooled = coef(m1)[2:4], fe = coef(m2)[1:3], twfe = coef(m3)[1:3],
            fd = coef(m4)[2:4]), 4)


#=======================================================================
# PART 2. CHAPTER 11 -- QUIZ 2, PART B
#=======================================================================

# Keep only 2023 and create the dummy north
d23 <- subset(d, year == ___)
d23$north <- as.numeric(d23$region == "___")

f2 <- exporter ~ log(employees) + rd + north

# (1) Linear probability model, robust SEs
m1 <- lm_robust(f2, data = d23)
summary(m1)

# (2) Probit and (3) logit
m2 <- glm(f2, family = binomial(link = "___"), data = d23)
m3 <- glm(f2, family = binomial(link = "___"), data = d23)
coeftest(m2, vcov = vcovHC(m2))
coeftest(m3, vcov = vcovHC(m3))

#--- DEEP DIVE 1 again: the dummy variable trap with region  (ready to run)
d23$centre <- as.numeric(d23$region == "Centre")
d23$south  <- as.numeric(d23$region == "South")
coef(lm_robust(exporter ~ log(employees) + rd + north + centre + south, data = d23))
# (Intercept): NA. north + centre + south = 1, the intercept
coef(lm_robust(exporter ~ log(employees) + rd + centre + south, data = d23))
# centre -0.114, south -0.102: relative to the base category, North

# B1. Logit: predicted probability, North, 50 employees, R&D
predict(m3, newdata = data.frame(employees = ___, rd = ___, north = ___),
        type = "response")

# B2. Probit: from 20 to 40 employees, rd = 0, north = 0
pr <- predict(m2, newdata = data.frame(employees = c(40, 20), rd = 0, north = 0),
              type = "response")
pr[1] - pr[2]

# B3. LPM: 90% CI for the effect of doubling employees
d23$lemployees <- log(d23$employees)
m1b <- lm_robust(exporter ~ lemployees + rd + north, data = d23)
deltaMethod(m1b, "___ * lemployees", level = ___)

# B4. Classification table of the logit (cut-off 0.5)
p3 <- fitted(m3)
tab <- table(observed  = factor(d23$exporter, levels = 0:1),
             predicted = factor(as.numeric(p3 > ___), levels = 0:1))
tab
sens <- tab["1", "1"] / sum(tab["1", ])
spec <- tab["0", "0"] / sum(tab["0", ])
c(success = sum(diag(tab)) / sum(tab), sensitivity = sens, specificity = spec,
  FPR = 1 - spec, FNR = 1 - sens)

# B6. Probit, "average" firm: with and without R&D
nd <- data.frame(employees = exp(mean(log(d23$employees))),
                 rd = c(1, 0), north = mean(d23$north))
pr <- predict(m2, newdata = nd, type = "response")
pr[1] - pr[2]

#--- DEEP DIVE 3. Regressions in logs  (ready to run)
# linear-log  (Y on ln X):    X +1%     -> Y changes by 0.01 * b1     (B5: 0.0031)
# log-linear  (ln Y on X):    X +1 unit -> Y changes by about 100*b1 %
# log-log     (ln Y on ln X): X +1%     -> Y changes by b1 %          (elasticity)
100 * (exp(0.0874) - 1)   # rd in Ch. 10 (1): 9.1%, against the approximation 8.7%

# B7. Probit: joint test rd = 0 and north = 0
linearHypothesis(m2, c("rd = 0", "north = 0"), vcov. = vcovHC(m2), test = "Chisq")

# B8. Probit classification table: compare with the logit
p2 <- fitted(m2)
tab2 <- table(observed  = factor(d23$exporter, levels = 0:1),
              predicted = factor(as.numeric(p2 > 0.5), levels = 0:1))
tab2
sum(diag(tab2)) / sum(tab2)
