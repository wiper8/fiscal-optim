particle_swarm <- function(theta, f, lower_bounds, upper_bounds,
                           n_particles = 20,
                           max_iter = 100,
                           w = 0.7,
                           c1 = 1.5,
                           c2 = 1.5,
                           ...) {
  
  d <- length(theta)
  stopifnot(length(lower_bounds) == d && length(upper_bounds) == d)

  # Initialize positions (particles x dimensions)
  positions <- matrix(runif(n_particles * d), n_particles, d)
  positions <- sweep(positions, 2, (upper_bounds - lower_bounds), `*`)
  positions <- sweep(positions, 2, lower_bounds, `+`)
  
  # Initialize velocity
  velocity <- matrix(
    runif(n_particles * d, -abs(upper_bounds - lower_bounds), abs(upper_bounds - lower_bounds)),
    n_particles,
    d
  )

  # Evaluate fitness
  fitness <- apply(positions, 1, f, ...)

  # Personal best
  pbest_positions <- positions
  pbest_values <- fitness

  # Global best
  gbest_index <- which.min(fitness)
  gbest_position <- positions[gbest_index, ]
  gbest_value <- fitness[gbest_index]

  for (iter in seq_len(max_iter)) {

    # Random matrices
    r_p <- matrix(runif(n_particles * d), n_particles, d)
    r_g <- matrix(runif(n_particles * d), n_particles, d)

    # Expand gbest to matrix
    gbest_matrix <- matrix(gbest_position, n_particles, d, byrow = TRUE)

    # Velocity update
    velocity <- w * velocity +
      c1 * r_p * (pbest_positions - positions) +
      c2 * r_g * (gbest_matrix - positions)

    # Position update
    positions <- positions + velocity

    # Clamp bounds
    positions <- pmax(positions, matrix(lower_bounds, n_particles, d, byrow = TRUE))
    positions <- pmin(positions, matrix(upper_bounds, n_particles, d, byrow = TRUE))

    # Evaluate fitness
    fitness <- apply(positions, 1, f, ...)

    # Update personal best
    improved <- fitness < pbest_values
    pbest_positions[improved, ] <- positions[improved, , drop = FALSE]
    pbest_values[improved] <- fitness[improved]

    # Update global best
    best_iter_index <- which.min(fitness)
    if (fitness[best_iter_index] < gbest_value) {
      gbest_value <- fitness[best_iter_index]
      gbest_position <- positions[best_iter_index, ]
    }

    cat("Iter:", iter, "Best:", gbest_value, "\n")
  }

  list(par = gbest_position, value = gbest_value)
}

get_bounds <- function(bloc_splits = NULL) {
  fake_i <- rendement_brut + rendement_cash - 1

  fake_n_years <- 90
  actuariat_factor <- (fake_i^fake_n_years - 1) / (fake_i - 1)
  mins <- c(
    0,
    0,
    -(actifs$celi$current_value * fake_i^fake_n_years + actifs$celi$contrib_yearly * actuariat_factor),
    -(actifs$reer$current_value * fake_i^fake_n_years + actifs$reer$plafond * actuariat_factor),
    0
  )
  maxes <- c(
    actifs$cash + salaire,
    (actifs$nonenr_capital + actifs$nonenr_gain) * fake_i^fake_n_years + salaire * actuariat_factor,
    actifs$celi$contrib_yearly * (max_age - start_age + 1) + actifs$celi$contrib_lim,
    actifs$reer$current_value * fake_i^fake_n_years + actifs$reer$plafond * actuariat_factor,
    actifs$reer$current_value * fake_i^fake_n_years + actifs$reer$plafond * actuariat_factor
  )
  list(
    lower = replicate(length(bloc_splits) + 1, mins),
    upper = replicate(length(bloc_splits) + 1, maxes)
  )
}

