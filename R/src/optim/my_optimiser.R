library(ggplot2)

my_optimiser <- function(theta, f, ...) {
  lapply(seq_along(theta), function(i) {
    tmp <- one_way(theta, f, i, ...)
    print(paste0(i, " / ", length(theta)))
    print(round(tmp$theta, 1))
    print(round(-tmp$objective, 2))
    tmp
  })
}

one_way <- function(theta, f, i) {
  n <- 20
  scaling_factor <- 1.2
  x_theta <- c()
  y_obj <- c()

  # TODO implémenter control
  repeat {
    explo_theta <- t(replicate(n, theta))
    scaling <- (scaling_factor^seq(1, n, length.out = n / 2) - 1)
    explo_theta[, i] <- theta[i] * scaling_factor^seq(-n, n, length.out = n) +
      c(-1 * scaling, scaling) / (scaling_factor - 1)
    objective <- apply(explo_theta, 1, f)
    x_theta <- c(x_theta, explo_theta[, i])
    y_obj <- c(y_obj, objective)
    print(ggplot() +
            geom_point(aes(x = x_theta, y = -y_obj)))
    if (!which.min(objective) %in% c(which.min(explo_theta[, i]), which.max(explo_theta[, i]))) break
    theta <- explo_theta[which.min(objective), ]
  }
  list(theta = theta, objective = min(objective))
}
debugonce(my_optimiser)
my_optimiser(theta, to_optim)
