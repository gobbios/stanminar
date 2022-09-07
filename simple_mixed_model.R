# a simple mixed model

n_ind <- 25
n_per_id <- 15
indi_sd <- 0.7
global_intercept <- -0.8
global_sd <- 1.3

# individual intercepts
indi_intercepts <- rnorm(n = n_ind, mean = 0, sd = global_sd)

# global data set
xdata <- data.frame(indi = sample(x = letters[1:n_ind], size = n_ind * n_per_id, replace = TRUE), stringsAsFactors = TRUE)
# numeric version of ID
xdata$indi_num <- as.numeric(xdata$indi)
# individual
xdata$y <- rnorm(n = nrow(xdata), mean = global_intercept + indi_intercepts[xdata$indi_num], sd = indi_sd)
plot(xdata$y ~ xdata$indi)
abline(h = global_intercept)


library(lme4)
res <- lmer(y ~ 1 + (1|indi), data = xdata)
summary(res)

# library(brms)
# make_stancode(y ~ 1 + (1|indi), data = xdata, family = gaussian)
# make_standata(y ~ 1 + (1|indi), data = xdata, family = gaussian)

library(rstan)
m <- stan_model(file = "stan_files/mixed1.stan")
r <- sampling(object = m, data = list(N = nrow(xdata), I = n_ind, y = xdata$y, indi_index = xdata$indi_num))
r


plot(indi_intercepts, colMeans(extract(r, pars = "indi_means")$indi_means))
abline(0, 1)
