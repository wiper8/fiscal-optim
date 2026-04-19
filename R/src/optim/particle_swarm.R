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
