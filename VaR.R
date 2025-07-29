install.packages("quantmod")
library(quantmod)
getSymbols("INFY.NS",from = "2022-01-01", to = Sys.Date())
head(INFY.NS)
Prices <- Ad(INFY.NS)
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
returns <- dailyReturn(Prices, type = "log")
returns <- na.omit(returns)
install.packages("tseries")
library(tseries)
adf.test(returns)
VaR_95_hist <-quantile(returns,probs=0.05)
VaR_99_hist <-quantile(returns,probs=0.01)
print(paste("Historical VaR at 95%:", round(VaR_95_hist * 100, 2),"%"))
print(paste("Historical VaR at 99%:", round(VaR_99_hist * 100, 2), "%"))

returns_vector <- na.omit(as.numeric(returns))
returns_vector <- returns_vector[is.finite(returns_vector)]
hist(returns_vector, breaks = 40, main= "Histogram of Reurns", col="skyblue", xlab = "Returns", ylab = "Frequency")
install.packages("fitdistrplus")
install.packages("MASS")
library(fitdistrplus)
library(MASS)

# Fit normal distribution
fit_norm <- fitdist(returns_vector, "norm")

# Fit Student's t-distribution (need starting values)
fit_t <- fitdistr(returns_vector, "t")

# Fit logistic distribution
fit_logis <- fitdist(returns_vector, "logis")
fit_norm
fit_t
fit_logis

# AIC for Normal (fit using fitdist)
aic_norm <- fit_norm$aic
cat("AIC - Normal Distribution:", aic_norm, "\n")

# AIC for Logistic (fit using fitdist)
aic_logis <- fit_logis$aic
cat("AIC - Logistic Distribution:", aic_logis, "\n")

# AIC for Student's t-distribution (fit using MASS)
# MASS::fitdistr doesn't return AIC directly, so we calculate it manually
loglik_t <- logLik(fit_t)  # log-likelihood
k <- 3                     # Number of parameters: mean, sd, df
aic_t <- -2 * as.numeric(loglik_t) + 2 * k
cat("AIC - Student's t Distribution:", aic_t, "\n")

aic_vector <- c("Normal" = aic_norm, "Logistic" = aic_logis, "Student's t" = aic_t)
best_fit <- names(which.min(aic_vector))
cat("Best-fitting distribution is:", best_fit, "\n")

mu <- fit_t$estimate["m"]        # mean
sigma <- fit_t$estimate["s"]     # standard deviation
df <- fit_t$estimate["df"]       # degrees of freedom
set.seed(248)
sim_returns <- rt(10000,df=df) * sigma + mu

VaR_95_mc <- quantile(sim_returns, 0.05)
VaR_99_mc <- quantile(sim_returns, 0.01)

cat("Monte Carlo VaR at 95%:", round(VaR_95_mc * 100, 2), "%\n")
cat("Monte Carlo VaR at 99%:", round(VaR_99_mc * 100, 2), "%\n")

hist(sim_returns, breaks = 40, probability = TRUE,
     main = "Monte Carlo Simulated Returns (Student's t)",
     col = "skyblue", xlab = "Simulated Returns")
# Add VaR lines
abline(v = VaR_95_hist, col = "blue", lwd = 2, lty = 2)
abline(v = VaR_95_mc, col = "red", lwd = 2, lty = 3)

legend("topright", legend = c("Historical VaR 95%", "Monte Carlo VaR 95%"), col = c("blue", "red"),lty = c(2, 3), lwd = 2)
