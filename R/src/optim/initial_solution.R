initial_solution <- function(start_age, max_age, bloc_splits, actifs) {
  base_params_number <- 4
  i <- rendement + dividend_yield

  actuarial_factor <- (i - 1) / (1 - i^-(max_age - start_age + 1)) / i
  theta <- rep(0, base_params_number * (length(bloc_splits) + 1))

  # celi
  celi_idx <- seq(2, by = base_params_number, length.out = length(bloc_splits) + 1)
  theta[celi_idx] <- -actifs$celi$current_value * actuarial_factor

  theta
}
