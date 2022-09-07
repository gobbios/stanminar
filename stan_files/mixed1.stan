data {
  int<lower=0> N;
  int<lower=0> I;
  vector[N] y;
  int indi_index[N];
}
parameters {
  real intercept;
  real<lower=0> sigma_global;
  real<lower=0> sigma_residual;
  vector[I] indi_means;

}
model {
  vector[N] mu = rep_vector(0, N);
  // for (i in 1:N) {
  //   mu[i] = mu[i] + indi_means[indi_index[i]];
  // }
  mu = intercept + indi_means[indi_index];
  y ~ normal(mu, sigma_residual);
  indi_means ~ normal(0, sigma_global);
}

