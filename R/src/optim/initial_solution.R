initial_solution <- function(start_age, max_age, bloc_splits, actifs) {
  base_params_number <- 5
  i <- rendement + dividend_yield

  actuarial_factor <- (i - 1) / (1 - i^-(max_age - start_age + 1)) / i
  theta <- rep(0, base_params_number * (length(bloc_splits) + 1))

  # celi
  celi_idx <- seq(3, by = base_params_number, length.out = length(bloc_splits) + 1)
  theta[celi_idx] <- -actifs$celi$current_value * actuarial_factor

  # reer
  reer_idx <- seq(4, by = base_params_number, length.out = length(bloc_splits) + 1)
  theta[reer_idx] <- -actifs$reer$current_value * actuarial_factor

  # nonenr
  nonenr_idx <- seq(2, by = base_params_number, length.out = length(bloc_splits) + 1)
  theta[nonenr_idx] <- (actifs$nonenr_capital + actifs$nonenr_gain) * actuarial_factor

  theta
}
