initial_solution <- function(ages, actifs) {
  base_params_number <- 4
  i <- rendement + dividend_yield

  actuarial_factor <- (i - 1) / (1 - i^-(tail(ages, 1) - head(ages, 1) + 1)) / i
  theta <- rep(0, base_params_number * (length(ages) - 1))

  # celi
  celi_idx <- seq(2, by = base_params_number, length.out = length(ages) - 1)
  theta[celi_idx] <- -actifs$celi$current_value * actuarial_factor

  theta
}
